Shader "Unlit/PJSequenceAnimation"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_HAmount("Horizontal Amount",Float) = 1
		_VAmount("Vertical Amount",Float) = 1
		_Speed("Speed",Range(0.1,30)) = 1
	}
		SubShader
		{
			Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType" = "Transparent" }
			 

			Pass
			{
			Tags{"LightMode"="ForwardBase"}
				ZWrite Off
				Blend SrcAlpha OneMinusSrcAlpha

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
				half _HAmount;
				half _VAmount;
				half _Speed;

				v2f vert(appdata v)
				{
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
			
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					half time = floor(_Time.y*_Speed);
				half row = floor(time / _HAmount);
				half col = time - row * _HAmount;

				half2 uv = float2(i.uv.x / _HAmount, i.uv.y / _VAmount);
				uv.x += col / _HAmount;
				uv.y -= row / _VAmount;

				/*half2 uv = i.uv + half2(col, -row);
				uv.x /= _HAmount;
				uv.y /= _VAmount;*/
				// sample the texture
				fixed4 color = tex2D(_MainTex, uv);
				// apply fog
				
				return color;
			}
			ENDCG
		}
		}
			Fallback "Transparent/VertexLit"
}
