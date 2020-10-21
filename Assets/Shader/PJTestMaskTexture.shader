// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*
切线空间中计算
在顶点着色器中，把光照转换到切线空间，矩阵乘法在顶点中
*/
Shader "PJLight/PJTestMaskTexture"
{
    Properties
    {
		_Color("Color",Color)=(1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_Mask("Mask",2D) = "bump"{}
		_MaskScale("Mask Scale", Float) = 1.0
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
				//half4 tangent:TANGENT;//tangent是四维的，tangent.w用来决定副切线的方向
				half4 texcoord:TEXCOORD0;             
            };

            struct v2f
            {
				half4 vertex : SV_POSITION;
				half2 uv:TEXCOORD0;
				half3 worldPos:TEXCOORD1;		
				half3 worldNormal:TEXCOORD2;
            };

			half4 _Color;
            sampler2D _MainTex;
            half4 _MainTex_ST;
			sampler2D _Mask;
			half4 _Mask_ST;
			float _MaskScale;


            v2f vert (a2v v)
            {
                v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);  
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.worldPos =  (mul(unity_ObjectToWorld, v.vertex));
				o.worldNormal =normalize( mul(v.normal, unity_WorldToObject));
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {        
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 albedo = tex2D(_MainTex,i.uv).rgb*_Color;
				fixed3 ambient = albedo * UNITY_LIGHTMODEL_AMBIENT;
				fixed diffMask = tex2D(_Mask, i.uv).r*_MaskScale ;
				fixed3 diffuse = _LightColor0.rgb*albedo*(0.5*dot(i.worldNormal, worldLightDir) + 0.5)*diffMask;

				return half4(ambient + diffuse,1.0);
            }
            ENDCG
        }
    }
	Fallback "Diffuse"
}
