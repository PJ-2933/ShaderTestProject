	// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Unlit/PJBloom"
{
	Properties
	{
		_MainTex("Texture(RGB)", 2D) = "white" {}
		_BlurSize("Blur Size",float) = 1
		_Bloom("Bloom(RGB)",2D) = "black"{}
		_LumianceThreshold("Lumiance Threshold",float)=0.6
	}
		SubShader
		{
			ZTest Always
			ZWrite Off
			Cull Off
			CGINCLUDE


			sampler2D _MainTex;
			half4 _MainTex_TexelSize;//一个像素的uv大小
			sampler2D _Bloom;
			half  _BlurSize;
			half _LumianceThreshold;

			struct appdata
			{
				half4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
			};
			ENDCG

			Pass{
				CGPROGRAM
				#pragma vertex vertExtractBright
				#pragma fragment fragExtractBright
				#include "UnityCG.cginc"
				struct v2f {
					half4 pos:SV_POSITION;
					half2 uv:TEXCOORD0;
				};
				v2f vertExtractBright(appdata v) {
					v2f o; 
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv = v.texcoord;
					return o;
				}
				fixed LumianceFunc(fixed4 color) {
					return 0.2125*color.r + 0.7154*color.g + 0.0721*color.b;
				}
				fixed4 fragExtractBright(v2f i) : SV_Target{
					fixed4 c = tex2D(_MainTex, i.uv);
					fixed val = clamp(LumianceFunc(c) - _LumianceThreshold, 0, 1);
					return val * c;
				}
				
				ENDCG
			}

		UsePass"Unlit/PJGuassianBlur/GAUSSIAN_BLUR_VERTICAL"
		UsePass"Unlit/PJGuassianBlur/GAUSSIAN_BLUR_HORIZANTOL"
					Pass
					{
							NAME"GAUSSIAN_BLUR_HORIZANTOL"

							CGPROGRAM
							#pragma vertex vertBloom
							#pragma fragment fragBloom
									#include "UnityCG.cginc"

					 

					struct v2fBloom
					{
						half4 uv  : TEXCOORD0;

						half4 pos : SV_POSITION;
					};
					v2fBloom vertBloom(appdata v)
							{
						v2fBloom o;
								o.pos = UnityObjectToClipPos(v.vertex);
								o.uv.xy = v.texcoord;
								o.uv.zw = v.texcoord;

#if UNITY_UV_STARTS_AT_TOP
								if (_MainTex_TexelSize.y < 0.0) {
									o.uv.w = 1 - o.uv.w;
								}
#endif
								return o;
							}


							fixed4 fragBloom(v2fBloom i) : SV_Target
							{
								 return tex2D(_MainTex,i.uv.xy) + tex2D(_Bloom,i.uv.zw);
							}
								ENDCG
						}
		}
		Fallback Off
}



