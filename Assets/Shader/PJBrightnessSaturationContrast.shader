// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Unlit/PJBrightnessSaturationContrast"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Brightness("Brightness",Float) = 1
		_Saturation("Saturation",Float) = 1
		_Contrast("Contrast",Float) = 1
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
					float4 vertex : POSITION;
					float2 texcoord : TEXCOORD0;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;

					float4 pos : SV_POSITION;
				};

				sampler2D _MainTex;
				half4 _MainTex_ST;
				half  _Brightness;
				half _Saturation;
				half _Contrast;

				v2f vert(appdata v)
				{
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv = v.texcoord;
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 color = tex2D(_MainTex, i.uv);
					fixed3 brightColor = color.rgb*_Brightness;
					fixed lumiance = 0.2125*color.r + 0.7154*color.g + 0.0721*color.b;
					fixed3 lumianceColor = fixed3(lumiance, lumiance, lumiance);
					brightColor = lerp(lumiance, brightColor, _Saturation);
					fixed3 avgColor = fixed3(0.5, 0.5, 0.5);
					brightColor = lerp(avgColor, brightColor, _Contrast);

					return fixed4(brightColor,color.a);
				}
			ENDCG
		}
		}
			Fallback "Transparent/VertexLit"
}
