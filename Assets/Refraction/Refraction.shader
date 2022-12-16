Shader "Custom/Refraction"
{
    Properties
    {
        _MainTex("MainTex", 2D) = "white"{}
        _Strength("strength", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"}
        zwrite off
        GrabPass{}
        CGPROGRAM
        #pragma surface surf nolight noambient
        
        sampler2D _GrabTexture;
        sampler2D _MainTex;
        float _Strength;
        struct Input
        {
            float2 color:COLOR;
            float4 screenPos;
            float2 uv_MainTex;
        };


        void surf (Input IN, inout SurfaceOutput o)
        {
            float3 screenUV = IN.screenPos.rgb / IN.screenPos.a;
            float3 waterPulse = tex2D(_MainTex, IN.uv_MainTex);
            o.Emission = tex2D(_GrabTexture, float2((screenUV.xy + _Strength * waterPulse)));

        }
            
        float4 Lightingnolight(SurfaceOutput input, float3 lightDir, float atten)
        {
            return float4(0,0,0,1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
