﻿// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "PJLight/PJDiffuseReflect"
{
    Properties
    {
		_Diffuse("Diffuse",Color)=(1,1,1,1)
		_ReflectColor("reflect Color",Color)=(1,1,1,1)
		_ReflectAmount("Reflect Amount",Range(0,1))=0.5
		_Cubemap("Reflect Cubemap",Cube) = "_Skybox"{}
       // _MainTex ("Texture", 2D) = "white" {}
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

			};

			struct v2f
			{
				half4 vertex : SV_POSITION;

				half3 worldNormal:NORMAL;
				half3 worldPos:TEXCOORD0;
				half3 worldViewDir:TEXCOORD1;
				half3 worldRefl:TEXCOORD2;
			};

			sampler2D _MainTex;
			half4 _MainTex_ST;
			half4 _Diffuse;
			half4 _ReflectColor;
			half _ReflectAmount;
			samplerCUBE _Cubemap;

			v2f vert(a2v v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);  //UnityObjectToClipPos(v.vertex);

				o.worldNormal = normalize(mul(v.normal, (half3x3)unity_WorldToObject));
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);
				o.worldRefl = reflect(-o.worldViewDir, o.worldNormal);


				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				half3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				half3 diffuse = _LightColor0.rgb*_Diffuse.rgb*saturate(dot(i.worldNormal, worldLight));
				half3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
				half3 reflection = texCUBE(_Cubemap, i.worldRefl).rgb*_ReflectColor;

				half3 color =lerp( diffuse,reflection,_ReflectAmount) + ambient;
				fixed4 col = fixed4(color,1);

				return col;
			}
            ENDCG
        }
    }
}
