Shader "Custom/Rim"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("Normal", 2D) = "white"{}
        _RimColor("RimColor",Color) = (1,1,1,1)
        _RimStrength("RimStrength", Range(0,10)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Transparent" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert alpha:fade

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        float4 _RimColor;
        float _RimStrength;
        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldPos;
        };


        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Emission = c + pow(frac(IN.worldPos.y - _Time.x),10);
            float ndot1 = abs(dot(o.Normal, IN.viewDir));
            // Metallic and smoothness come from slider variables
            o.Alpha = pow(1-ndot1,_RimStrength);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
