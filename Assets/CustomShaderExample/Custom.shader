Shader "Custom/Custom"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("Normal", 2D) = "Bump"{}
        _Range("range", Range(10,200)) =10
        _Range1("range1", Range(1,100)) = 10
        _SpecColor1("Spec", COlor) = (1,1,1,1)
        _GlossTex("Gloss", 2D)="white"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Custom noambient

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        float4 _SpecColor1;
        float _Range;
        float _Range1;
        sampler2D _GlossTex;
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_GlossTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            float4 m = tex2D (_GlossTex, IN.uv_GlossTex);
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));            
            o.Gloss = m.a;
            // Metallic and smoothness come from slider variables
            o.Alpha = c.a;
        }

        float4 LightingCustom (SurfaceOutput surface, float3 lightDir, float3 viewDir, float atten)
        {
            float4 final;
            float3 DiffColor;
            float ndot1 = saturate(dot(surface.Normal, lightDir));
            DiffColor = ndot1 + surface.Albedo * _LightColor0.rgb * atten;
            final.rgb = DiffColor.rgb;
            final.a = surface.Alpha;
            float3 H = normalize(lightDir + viewDir);
            float3 ndotH = saturate(dot(H, surface.Normal));
            float3 SpecColor = _SpecColor1 * pow(ndotH,_Range) * surface.Gloss;
            
            float3 rimColor;
            float rim = abs(dot(viewDir,surface.Normal));
            float invrim = 1-rim;
            rimColor = pow(invrim, _Range) * float3(0.5,0.5,0.5);
            float3 rimColor2 = pow(rim,_Range1);

            final.rgb = DiffColor.rgb + SpecColor.rgb  + rimColor.rgb + rimColor2.rgb;
            final.a = surface.Alpha;

            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
