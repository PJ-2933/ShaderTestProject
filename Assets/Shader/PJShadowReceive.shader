// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'



Shader "PJLight/PJShadowReceive"//环境光+漫反射+镜面反射
{
	Properties
	{
		_Diffuse("Diffuse",Color) = (1,1,1,1)
		_Specular("Specular", Color) = (1, 1, 1, 1)

		_Gloss("Gloss", Range(8.0, 256)) = 20
	}
		SubShader
	{


		Pass
		{
		Tags {"LightMode" = "ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
	#pragma multi_compile_fwdbase

		 
			#include "Lighting.cginc"

			#include "AutoLight.cginc" 
			 struct a2v
			{
				half4 vertex : POSITION;
				half3 normal:NORMAL;

			};

			struct v2f
			{
				half4 pos : SV_POSITION;
				
				half3 worldNormal:TEXCOORD0;
		 
				SHADOW_COORDS(1)//声明一个用于对阴影纹理采集的坐标,
			};


			half4 _Diffuse;

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);  //UnityObjectToClipPos(v.vertex);

				o.worldNormal = normalize(mul(v.normal, (half3x3)unity_WorldToObject));

				TRANSFER_SHADOW(o);//计算阴影的纹理坐标,这个宏里的o.pos写死，所以必须用pos

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				
				half3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				half3 diffuse = _LightColor0.rgb*_Diffuse.rgb*saturate(dot(i.worldNormal, worldLight));
				half3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
				half3 color = diffuse + ambient;
				fixed shadow = SHADOW_ATTENUATION(i);
				fixed4 col = fixed4(color*shadow,1);

				return col;
			}
			ENDCG
		}
		Pass
				{

				// Pass for other pixel lights

				Tags { "LightMode" = "ForwardAdd" }



				Blend One One



				CGPROGRAM



				// Apparently need to add this declaration

				#pragma multi_compile_fwdadd



				#pragma vertex vert

				#pragma fragment frag



				#include "Lighting.cginc"

				#include "AutoLight.cginc"



				fixed4 _Diffuse;

				fixed4 _Specular;

				float _Gloss;



				struct a2v {

					float4 vertex : POSITION;

					float3 normal : NORMAL;

				};



				struct v2f {

					float4 pos : SV_POSITION;

					float3 worldNormal : TEXCOORD0;

					float3 worldPos : TEXCOORD1;

				};



				v2f vert(a2v v) {

					v2f o;

					o.pos = UnityObjectToClipPos(v.vertex);



					o.worldNormal = UnityObjectToWorldNormal(v.normal);



					o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;



					return o;

				}



				fixed4 frag(v2f i) : SV_Target {

					fixed3 worldNormal = normalize(i.worldNormal);

					#ifdef USING_DIRECTIONAL_LIGHT

						fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

					#else

						fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos.xyz);

					#endif



					fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0, dot(worldNormal, worldLightDir));



				/*	fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

					fixed3 halfDir = normalize(worldLightDir + viewDir);

					fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);*/



					#ifdef USING_DIRECTIONAL_LIGHT

						fixed atten = 1.0;

					#else

						#if defined (POINT)

							float3 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1)).xyz;

							fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;

						#elif defined (SPOT)

							float4 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1));

							fixed atten = (lightCoord.z > 0) * tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;

						#else

							fixed atten = 1.0;

						#endif

					#endif



					return fixed4((diffuse ) * atten, 1.0);

				}



				ENDCG

			}



 
	}



		Fallback "Specular"
}
