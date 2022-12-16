Shader "Custom/1PassOutLine"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Range("range", range(0.1,1)) = 0.3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;
        float _Range;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            float3 vari = pow(1-abs(dot(o.Normal, IN.viewDir)),_Range); 
            float var = (vari.r + vari.g + vari.b)/3;
            if(var > 0.5){
                var = 1;
            }
            else{
                var = 0;
            }
            o.Emission =(1-var) * c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
