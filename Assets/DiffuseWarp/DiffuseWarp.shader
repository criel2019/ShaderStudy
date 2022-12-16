Shader "Custom/wrap"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RampTex ("RampTex", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
    
        CGPROGRAM
        #pragma surface surf warp noambient

        sampler2D _MainTex;
        sampler2D _RampTex;
        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 Lightingwarp(SurfaceOutput s, float3 lightDir, float atten)
        {
            float ndotl = dot(s.Normal,lightDir) * 0.5 + 0.5;
            float4 ramp = tex2D(_RampTex, float2(ndotl, 0.5));

            float4 final;
            final.rgb = s.Albedo.rgb * ramp.rgb;
            final.a = s.Alpha;
            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}