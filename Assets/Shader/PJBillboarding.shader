// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Unlit/PJBillboarding"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_TintColor("Tint Color",Color)=(1,1,1,1)
		_VerticalBillboarding("Vertical Billboarding",Range(0,1)) = 1
	}
		SubShader
		{
			Tags {"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"DisaableBatching" = "True"}


			Pass
			{
			Tags{"LightMode" = "ForwardBase"}
				ZWrite Off
				Blend SrcAlpha OneMinusSrcAlpha
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
				float4 _MainTex_ST;
				fixed4 _TintColor;
				half  _VerticalBillboarding;

				v2f vert(appdata v)
				{
					v2f o;
					half3 center = half3(0, 0, 0);
					half3 viewer = mul(unity_WorldToObject, half4(_WorldSpaceCameraPos, 1));
					half3 normalDir = viewer - center;
					normalDir.y = normalDir.y*_VerticalBillboarding;//_VerticalBillboarding为1时法线固定为视角方向，为0时up方向固定为(0,1,0)
					normalDir = normalize(normalDir);

					half3 upDir = abs(normalDir.y) > 0.999 ? half3(0, 0, 1) : half3(0, 1, 0);
					half3 rightDir = normalize(cross(upDir, normalDir));
					upDir = normalize(cross(normalDir, rightDir));

					half3 centerPos = v.vertex.xyz - center;
					half3 localPos = center + rightDir * centerPos.x + upDir * centerPos.y + normalDir * centerPos.z;//旋转
					o.pos = UnityObjectToClipPos(half4(localPos, 1));

					o.uv=TRANSFORM_TEX (v.texcoord, _MainTex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 color = tex2D(_MainTex, i.uv);
					color *= _TintColor;
					return color;
				}
			ENDCG
		}
		}
			Fallback "Transparent/VertexLit"
}
