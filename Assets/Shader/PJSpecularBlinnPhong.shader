// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "PJLight/PJSpecularBlinnPhong"//环境光+漫反射+镜面反射
{
    Properties
    {
		_Diffuse("Diffuse",Color)=(1,1,1,1)
		_Specular("Specular",Color)=(1,1,1,1)
		_Gloss("Gloss",Range(1,128))=20
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
				half3 color:COLOR;
			 
            };

            half _Gloss;
            half4 _Specular;
			half4 _Diffuse;

            v2f vert (a2v v)
            {
                v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);  //UnityObjectToClipPos(v.vertex);
				
				half3 worldNormal = normalize(mul(v.normal, (half3x3)unity_WorldToObject));
				half3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				//diffuse
				half3 diffuse = _LightColor0.rgb*_Diffuse.rgb*saturate(dot(worldNormal, worldLight));
				//ambient
				half3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
				
			 
				//get view Direction
				half3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
				half3 halfDir = normalize(viewDir+worldLight);
				//Specular
				fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(saturate(dot(worldNormal, halfDir)), _Gloss);

				o.color = diffuse + ambient+specular;

              
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
             
                fixed4 col = fixed4(i.color,1);
                
                return col;
            }
            ENDCG
        }
    }

		Fallback "Specular"
}
