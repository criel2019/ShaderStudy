Shader "Custom/DiffuseWarp"
{
    Properties
    {
        _CameraDepthTexture("cameradepth", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        sampler2D _CameraDepthTexture;
        struct Input
        {
            float4 screenPos;
        };

        
        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 spos = float2(IN.screenPos.xy)/IN.screenPos.w;
            float4 depth = tex2D(_CameraDepthTexture, spos);
            
            o.Emission = depth;
            o.Alpha = 1;

        }

        ENDCG
    }
    FallBack "Diffuse"
}
