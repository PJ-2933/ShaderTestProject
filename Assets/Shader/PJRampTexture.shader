// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*
切线空间中计算
在顶点着色器中，把光照转换到切线空间，矩阵乘法在顶点中
*/
Shader "PJLight/PJRampTexture"
{
    Properties
    {
		_Color("Color",Color)=(1,1,1,1)
		//_MainTex ("Texture", 2D) = "white" {}
		_RampTex("Ramp Tex",2D) = "white"{}
		//_BumpScale("Bump Scale", Float) = 1.0
    }
    SubShader
    {
            

        Pass
        {
		Tags {"LightMode" = "ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
    
            #include "UnityCG.cginc"
			#include "Lighting.cginc"

            struct a2v
            {
                half4 vertex : POSITION;
				half3 normal:NORMAL;
				//half4 tangent:TANGENT;//tangent是四维的，tangent.w用来决定副切线的方向
				half4 texcoord:TEXCOORD0;             
            };

            struct v2f
            {
				half4 pos : SV_POSITION;
				half3 worldNormal:TEXCOORD0;
				half3 worldPos:TEXCOORD1;
				half2 uv:TEXCOORD2;				
            };

			half4 _Color;
           /* sampler2D _MainTex;
            half4 _MainTex_ST;*/
			sampler2D _RampTex;
			half4 _RampTex_ST;
			 


            v2f vert (a2v v)
            {
                v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);  
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.uv = TRANSFORM_TEX(v.texcoord, _RampTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
             
				  half3 worldNormal = normalize(i.worldNormal);
				  half3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));				 				 
				  fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				  fixed halfLambert = 0.5* dot(worldNormal, worldLightDir) + 0.5;
				  fixed3 diffuse = _LightColor0.rgb*tex2D(_RampTex, fixed2(halfLambert, 0.5f)).rgb*_Color.rgb;

				  return half4(ambient + diffuse,1.0);
            }
            ENDCG
        }
    }
	Fallback "Diffuse"
}
