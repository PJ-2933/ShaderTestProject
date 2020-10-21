Shader "Unlit/PJWave"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Magnitude("Wave Magnitude",Float) = 1
		_Frequency("Wave Frequency",Float) = 1
		_InvWaveLenth("Inverse Wave Lenth",Float)=10
		_Speed("Speed",Range(0.1,30)) = 1
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
			//Cull Off

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
				half _Magnitude;
				half _Frequency;
				half _Speed;
				half _InvWaveLenth;

				v2f vert(appdata v)
				{
					v2f o;
					half4 offset;
					offset  = float4(0,0, 0, 0);
					 
					offset.x = sin(_Frequency*_Time.y +( v.vertex.x + v.vertex.y + v.vertex.z)*_InvWaveLenth)*_Magnitude;
					offset.z = offset.x ;
					offset.y = offset.x / 2;
					o.pos = UnityObjectToClipPos(v.vertex + offset);
					o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.uv += half2(0, _Time.y*_Speed);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 color = tex2D(_MainTex, i.uv);
					return color;
				}
			ENDCG
		}
		}
			Fallback "Transparent/VertexLit"
}
