Shader "Custom/surfaceShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SubTex ("SubText", 2D) = "blue"{}
        _SubTex1 ("noise", 2D) = "white"{}
    } 
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Transparent" }

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;
        sampler2D _SubTex;
        sampler2D _SubTex1;
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SubTex;
            float2 uv_SubTex1;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 e = tex2D (_SubTex1 , float2(IN.uv_SubTex1.x + _Time.x, IN.uv_SubTex1.y)) + 0.6;
            e = (e.r + e.g + e.b) / 3;
            fixed4 c = tex2D (_MainTex, float2(IN.uv_MainTex.y + _Time.x , IN.uv_MainTex.x+_Time.x + e.r));
            fixed4 d = tex2D (_SubTex , IN.uv_SubTex - _Time.x + e.g);
            
            o.Albedo = c.rgb * d.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
