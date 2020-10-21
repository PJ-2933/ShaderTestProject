	// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Unlit/PJEdgeDetection"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_EdgeOnly("EdgeOnly",float) = 1
		_EdgeColor("Edge Color",Color) = (0,0,1,1)
		_BGColor("Background Color",Color) = (1,1,1,1)
	}
		SubShader
		{



			Pass
			{

				ZTest Always
				ZWrite Off
				Cull Off

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag


				#include "UnityCG.cginc"

				struct appdata
				{
					half4 vertex : POSITION;
					half2 texcoord : TEXCOORD0;
				};

				struct v2f
				{
					half2 uv[9] : TEXCOORD0;

					half4 pos : SV_POSITION;
				};

				sampler2D _MainTex;
				half4 _MainTex_ST;
				half4 _MainTex_TexelSize;//一个像素的uv大小
				half  _EdgeOnly;
				half4 _EdgeColor;
				half4 _BGColor;

				v2f vert(appdata v)
				{
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);

					o.uv[0] = v.texcoord + _MainTex_TexelSize.xy*half2(-1, -1);
					o.uv[1] = v.texcoord + _MainTex_TexelSize.xy*half2(0, -1);
					o.uv[2] = v.texcoord + _MainTex_TexelSize.xy*half2(1, -1);
					o.uv[3] = v.texcoord + _MainTex_TexelSize.xy*half2(-1, 0);
					o.uv[4] = v.texcoord + _MainTex_TexelSize.xy*half2(0, 0);
					o.uv[5] = v.texcoord + _MainTex_TexelSize.xy*half2(1, 0);
					o.uv[6] = v.texcoord + _MainTex_TexelSize.xy*half2(-1, 1);
					o.uv[7] = v.texcoord + _MainTex_TexelSize.xy*half2(0, 1);
					o.uv[8] = v.texcoord + _MainTex_TexelSize.xy*half2(1, 1);
					return o;
				}

				

				half Sobel(v2f i) {
					const half Gx[9] = { -1,-2,-1,
										0,0,0,
										1,2,1 };
					const half Gy[9] = { -1,0,1,
										-2,0,2,
										-1,0,1 };
					
					half texColor;
					half edgeX = 0;
					half edgeY = 0;
					
					for (int it = 0; it < 9; it++) {
						texColor = Luminance(tex2D(_MainTex, i.uv[it]));
						edgeX += texColor * Gx[it];
						edgeY += texColor * Gy[it];
					}
					return 1 - abs(edgeX) - abs(edgeY);
				}

				fixed4 frag(v2f i) : SV_Target
				{
					 half edge = Sobel(i);
					fixed4 withEdgeColor = lerp(_EdgeColor, tex2D(_MainTex, i.uv[4]), edge);
					fixed4 onlyEdgeColor = lerp(_EdgeColor, _BGColor, edge);
					return lerp(withEdgeColor, onlyEdgeColor, _EdgeOnly);
				}
			ENDCG
		}
		}
			Fallback Off
}
