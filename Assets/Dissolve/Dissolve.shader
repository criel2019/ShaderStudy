Shader "Custom/Dissolve"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Noise ("Noise", 2D) = "white"{}
        _Cut("Cut", Range(0,1)) = 0
        _outThickness("outThickness", Range(0,3)) = 0

    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert alpha:fade

        sampler2D _MainTex;
        sampler2D _Noise;
        fixed4 _Color;
        float _Cut;
        float _outThickness;
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_Noise;
        };




        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 noise = tex2D (_Noise, IN.uv_Noise);
            o.Albedo = c.rgb;

            float alpha;
            if(noise.g >= _Cut)
            {
                alpha = 1;
            }
            else
            {
                alpha = 0;
            }
            o.Alpha = alpha;

            float outLine;
            if(noise.r >= _Cut * _outThickness)
            {
                outLine = 0;
            }
            else
            {
                outLine = 1;
            }
            o.Emission = outLine * _Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
