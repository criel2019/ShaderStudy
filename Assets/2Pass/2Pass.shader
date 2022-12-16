Shader "Custom/2Pass"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _LineThickeness("Thickeness", Range(0,1)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        cull back

        CGPROGRAM
        #pragma surface surf Nolight

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = 0;
        }

        float4 LightingNolight(SurfaceOutput s, float3 lightDir, float atten)
        {
            float4 final;
            final.rgb = s.Albedo;
            final.a = s.Alpha;
            float shadow = dot(s.Normal, lightDir) * 0.5 + 0.5;
            shadow = ceil(shadow*3)/3;
            return float4(final.rgb * shadow,1);
        }
        ENDCG

        cull front
        CGPROGRAM
        #pragma surface surf Nolight vertex:vert noshadow noambient

        float _LineThickeness;
        void vert (inout appdata_full v)
        {
            v.vertex.xyz = v.vertex.xyz + v.normal.xyz * _LineThickeness;
        }
        struct Input
        {
            float4 color:COLOR;
        };


        void surf (Input IN, inout SurfaceOutput o)
        {
        }

        float4 LightingNolight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return float4(0,0,0,1);
        }

        ENDCG
    }
    FallBack "Diffuse"
}
