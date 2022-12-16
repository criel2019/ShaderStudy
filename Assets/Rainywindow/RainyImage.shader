Shader "Custom/RainyImage"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Noise("Noise", 2D) = "white"{}
        _RainRange("RainRange", Range(0,100)) = 10
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Range ("Range", Range(0,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0
        float _RainRange;
        sampler2D _MainTex;
        sampler2D _Noise;
        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldPos;
        };
        float _Range;
        half _Glossiness;
        half _Metallic;
        float3 Random13(float seed)
        {   
            return float3(
                frac(sin(dot(float2(seed, 0.1235), float2(0.4733, seed))) * 12),
                frac(sin(dot(float2(seed, 0.4733), float2(0.6293, seed))) * 12),
                frac(sin(dot(float2(seed, 0.6293), float2(0.1235, seed))) * 12)
            );
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float4 col;
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 Noise = tex2D(_Noise, IN.uv_MainTex);
            float noise = (Noise.x + Noise.y + Noise.z + Noise.w)*0.25; 
            float time = fmod( _Time.y ,7200);
            float x, y;
            //choose how many windows would be 
            float2 uv = IN.uv_MainTex * _RainRange * float2(2,1);
           
            float2 id = floor(IN.uv_MainTex*_RainRange * float2(2,1))/5;
            
            
            uv.y += time*0.2;
            
            //make multiple windows
            float2 gv = frac(uv) - 0.5;
            id = Random13(id);
            time += id * 6.28123;
            col.rg = gv.rg*0;
            float w = IN.uv_MainTex.y * 10;
            float rainFunctionX = sin(w) * sin(w) * cos(w)*0.2;
            float rainFunctionY = sin(time) *0.2;
            
            
            rainFunctionY += gv.x * gv.x;
            float2 rainDropPos = float2(gv.x*0.5,gv.y) + float2(rainFunctionX, rainFunctionY);
            
            float TempRainDrop = smoothstep(0.04, 0.05, length(float2(rainDropPos)));
            float rainDrop = 1-TempRainDrop;
            float2 trailPos = float2(gv.x*0.5, gv.y) + float2(rainFunctionX, time*0.025);
            trailPos.y = (frac(trailPos.y *8)-0.5)*0.125;
            float TempTrail = smoothstep(0.005, 0.006, length(trailPos));
            float trail = 1-TempTrail;
            float fogTrail = smoothstep(-0.05,0.05, rainDropPos.y);
            fogTrail *= smoothstep(0.5,rainFunctionY,gv.y);
            trail *= fogTrail;
            fogTrail *= smoothstep(0.02,0.01, abs(rainDropPos.x));
            
            
            float2 offs = rainDrop * rainDropPos + trail *trailPos;
            trail += fogTrail*0.5;
            if(gv.x > 0.49 || gv.y > 0.49){ 
            col = float4(1,0,0,1);
            }
           
            float4 final = tex2D(_MainTex, IN.uv_MainTex+ offs);
            o.Albedo.rgb =c.rgb + final;
            o.Emission = 0;
            o.Alpha = 1;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
           
        }
        ENDCG
    }
    FallBack "Diffuse"
}