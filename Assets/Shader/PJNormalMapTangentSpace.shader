// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*
切线空间中计算
在顶点着色器中，把光照转换到切线空间，矩阵乘法在顶点中
*/
Shader "PJLight/PJNormalMapTangentSpace"
{
    Properties
    {
		_Color("Color",Color)=(1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap("Noraml Map",2D) = "bump"{}
		_BumpScale("Bump Scale", Float) = 1.0
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
				half4 tangent:TANGENT;//tangent是四维的，tangent.w用来决定副切线的方向
				half4 texcoord:TEXCOORD0;             
            };

            struct v2f
            {
				half4 vertex : SV_POSITION;
				half4 uv:TEXCOORD0;
				half3 lightTangentDir:TEXCOORD1;				
            };

			half4 _Color;
            sampler2D _MainTex;
            half4 _MainTex_ST;
			sampler2D _BumpMap;
			half4 _BumpMap_ST;
			float _BumpScale;


            v2f vert (a2v v)
            {
                v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);  
				o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.texcoord, _BumpMap);

				float3 binormal = cross(normalize(v.normal), normalize(v.tangent.xyz));

				float3x3 rotation = float3x3(v.tangent.xyz, binormal, v.normal);

				//TANGENT_SPACE_ROTATION;
			
				o.lightTangentDir =normalize( mul(rotation, ObjSpaceLightDir(v.vertex)).xyz);
              
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
             
				  half4 packedNormal = tex2D(_BumpMap,i.uv.zw);
				  half3 tangentNormal = UnpackNormal(packedNormal);
				  tangentNormal.xy *= _BumpScale;
				  tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy,tangentNormal.xy)));

				  half3 albedo = tex2D(_MainTex, i.uv.xy).rgb*_Color.rgb;
				  fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT * albedo;
				  fixed3 diffuse=_LightColor0.rgb*albedo*saturate(dot(tangentNormal, i.lightTangentDir));
				  return half4(ambient + diffuse,1.0);
            }
            ENDCG
        }
    }
	Fallback "Diffuse"
}
