Shader "Custom/MaskingPrac"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Masking("masking", 2D) = "white" {}
        _Metallic ("Metallic", Range(10,200)) = 0
        _RimColor ("RimColor", Color) = (1,1,1,1)
        _RimRange ("RimRange", Range(1,10)) = 10
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        #pragma surface surf Custom

        sampler2D _MainTex;
        sampler2D _Masking;
        float _Metallic;
        float4 _RimColor;
        float _RimRange;
        struct Input
        {
            float2 uv_MainTex;
        };
        
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 masking = tex2D (_Masking, IN.uv_MainTex);
            o.Albedo = c.rgb + masking.rgb * float3(0.5,0.3,0.3);
            o.Alpha = c.a;
        }

        float4 LightingCustom (inout SurfaceOutput s, float3 lightDir, float3 viewDir, float3 atten)
        {
            float4 final;
            final.a = 1;
            float NormalDotLight = dot(s.Normal, lightDir) * 0.5 + 0.5;
            float3 H = normalize(lightDir + viewDir);
            float3 Spec = pow(dot(s.Normal, H),_Metallic);
            float ViewDirDotNormal = saturate(dot(viewDir, s.Normal));
            float OneMinusViewDirDotNormal = 1-ViewDirDotNormal;
            
            final.rgb = NormalDotLight * s.Albedo + Spec + pow(OneMinusViewDirDotNormal, _RimRange) *_RimColor;
            return final;

        }   

        ENDCG
    }
    FallBack "Diffuse"
}
