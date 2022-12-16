Shader "Custom/vertex"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SubTex1 ("Tex1", 2D) = "white"{}
        _SubTex2 ("Tex2", 2D) = "white"{}
        _SubTex3 ("Tex3", 2D) = "white"{}
        _Metallic ("Metal", Range(0,1)) = 1
        _Smoothness ("Smoothness", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard noambient

        sampler2D _MainTex;
        sampler2D _SubTex1;
        sampler2D _SubTex2;
        sampler2D _SubTex3;
        float _Metallic;
        float _Smoothness;
        struct Input
        {
            float2 uv_MainTex;
            float4 color:COLOR;
        };

        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 d = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 a = tex2D (_SubTex1, IN.uv_MainTex);
            fixed4 b = tex2D (_SubTex2, IN.uv_MainTex);
            fixed4 c = tex2D (_SubTex3, IN.uv_MainTex);
            o.Metallic = _Metallic;
            o.Smoothness = IN.color.g * _Smoothness + 0.3;
            o.Albedo = b.rgb * IN.color.r + c.rgb * IN.color.g + a.rgb * IN.color.b + d.rgb * (1-(IN.color.r + IN.color.g + IN.color.b ));
            
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
