	// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Unlit/PJGuassianBlur"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_BlurSize("Blur Size",float) = 1

	}
		SubShader
		{
			ZTest Always
			ZWrite Off
			Cull Off
			CGINCLUDE


			sampler2D _MainTex;
			half4 _MainTex_TexelSize;//一个像素的uv大小
			half  _BlurSize;
			struct appdata
			{
				half4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
			};

			ENDCG
				Pass
			{

				NAME"GAUSSIAN_BLUR_VERTICAL"

				CGPROGRAM
				#pragma vertex vertVertical
				#pragma fragment frag


				#include "UnityCG.cginc"

			/*		struct appdata
			{
				half4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
			};*/

			struct v2f
			{
				half2 uv[5] : TEXCOORD0;

				half4 pos : SV_POSITION;
			};



				v2f vertVertical(appdata v)
				{
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv[0] = v.texcoord;
					o.uv[1] = v.texcoord + half2(0, _MainTex_TexelSize.y * 1)*_BlurSize;
					o.uv[2] = v.texcoord + half2(0, _MainTex_TexelSize.y * -1)*_BlurSize;
					o.uv[3] = v.texcoord + half2(0, _MainTex_TexelSize.y * 2)*_BlurSize;
					o.uv[4] = v.texcoord + half2(0, _MainTex_TexelSize.y * -2)*_BlurSize;

					return o;
				}


				fixed4 frag(v2f i) : SV_Target
				{
					half weight[3] = {0.4026,0.2442,0.0545};
					fixed3 sum = tex2D(_MainTex, i.uv[0]).rgb*weight[0];

					for (int index = 1; index < 3; index++) {
						sum += tex2D(_MainTex, i.uv[index * 2 - 1]).rgb*weight[index];
						sum += tex2D(_MainTex, i.uv[index * 2]).rgb*weight[index];
					}
					return fixed4(sum,1.0);
				}
			ENDCG
			}
					Pass
					{
							NAME"GAUSSIAN_BLUR_HORIZANTOL"

							CGPROGRAM
							#pragma vertex vertHorizontal
							#pragma fragment frag
									#include "UnityCG.cginc"

					/*		struct appdata
					{
						half4 vertex : POSITION;
						half2 texcoord : TEXCOORD0;
					};*/

					struct v2f
					{
						half2 uv[5] : TEXCOORD0;

						half4 pos : SV_POSITION;
					};
							v2f vertHorizontal(appdata v)
							{
								v2f o;
								o.pos = UnityObjectToClipPos(v.vertex);
								o.uv[0] = v.texcoord;
								o.uv[1] = v.texcoord + half2( _MainTex_TexelSize.y * 1,0)*_BlurSize;
								o.uv[2] = v.texcoord + half2(_MainTex_TexelSize.y * -1,0)*_BlurSize;
								o.uv[3] = v.texcoord + half2(_MainTex_TexelSize.y * 2, 0)*_BlurSize;
								o.uv[4] = v.texcoord + half2(_MainTex_TexelSize.y * -2, 0)*_BlurSize;

								return o;
							}


							fixed4 frag(v2f i) : SV_Target
							{
								half weight[3] = {0.4026,0.2442,0.0545};
								fixed3 sum = tex2D(_MainTex, i.uv[0]).rgb*weight[0];

								for (int index = 1; index < 3; index++) {
									sum += tex2D(_MainTex, i.uv[index * 2 - 1]).rgb*weight[index];
									sum += tex2D(_MainTex, i.uv[index * 2]).rgb*weight[index];
								}
								return fixed4(sum,1.0);
							}
								ENDCG
						}
		}
		Fallback Off
}
		/*	Pass
			{

				NAME"GAUSSIAN_BLUR_VERTICAL"

				CGPROGRAM
				#pragma vertex vertVertical
				#pragma fragment frag


				#include "UnityCG.cginc"

					struct appdata
			{
				half4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				half2 uv[5] : TEXCOORD0;

				half4 pos : SV_POSITION;
			};



				v2f vertVertical(appdata v)
				{
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv[0] = v.texcoord;
					o.uv[1] = v.texcoord + half2(0, _MainTex_TexelSize.y * 1)*_BlurSize;
					o.uv[2] = v.texcoord + half2(0, _MainTex_TexelSize.y * -1)*_BlurSize;
					o.uv[3] = v.texcoord + half2(0, _MainTex_TexelSize.y * 2)*_BlurSize;
					o.uv[4] = v.texcoord + half2(0, _MainTex_TexelSize.y * -2)*_BlurSize;

					return o;
				}


				fixed4 frag(v2f i) : SV_Target
				{
					half weight[3] = {0.4026,0.2442,0.0545};
					fixed3 sum = tex2D(_MainTex, i.uv[0]).rgb*weight[0];

					for (int index = 1; index < 3; index++) {
						sum += tex2D(_MainTex, i.uv[index * 2 - 1]).rgb*weight[index];
						sum += tex2D(_MainTex, i.uv[index * 2]).rgb*weight[index];
					}
					return fixed4(sum,1.0);
				}
			ENDCG
			}*/

				/*	Pass
					{
							NAME"GAUSSIAN_BLUR_HORIZANTOL"

							CGPROGRAM
							#pragma vertex vertHorizontal
							#pragma fragment frag
									#include "UnityCG.cginc"

							struct appdata
					{
						half4 vertex : POSITION;
						half2 texcoord : TEXCOORD0;
					};

					struct v2f
					{
						half2 uv[5] : TEXCOORD0;

						half4 pos : SV_POSITION;
					};
							v2f vertHorizontal(appdata v)
							{
								v2f o;
								o.pos = UnityObjectToClipPos(v.vertex);
								o.uv[0] = v.texcoord;
								o.uv[1] = v.texcoord + half2( _MainTex_TexelSize.y * 1,0)*_BlurSize;
								o.uv[2] = v.texcoord + half2(_MainTex_TexelSize.y * -1,0)*_BlurSize;
								o.uv[3] = v.texcoord + half2(_MainTex_TexelSize.y * 2, 0)*_BlurSize;
								o.uv[4] = v.texcoord + half2(_MainTex_TexelSize.y * -2, 0)*_BlurSize;

								return o;
							}


							fixed4 frag(v2f i) : SV_Target
							{
								half weight[3] = {0.4026,0.2442,0.0545};
								fixed3 sum = tex2D(_MainTex, i.uv[0]).rgb*weight[0];

								for (int index = 1; index < 3; index++) {
									sum += tex2D(_MainTex, i.uv[index * 2 - 1]).rgb*weight[index];
									sum += tex2D(_MainTex, i.uv[index * 2]).rgb*weight[index];
								}
								return fixed4(sum,1.0);
							}
								ENDCG
						};*/


