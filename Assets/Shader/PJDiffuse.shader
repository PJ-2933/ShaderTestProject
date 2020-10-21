// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "PJLight/PJDiffuse"
{
    Properties
    {
		_Diffuse("Diffuse",Color)=(1,1,1,1)
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
				half3 color:COLOR;
			 
            };

            sampler2D _MainTex;
            half4 _MainTex_ST;
			half4 _Diffuse;

            v2f vert (a2v v)
            {
                v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);  //mul(UNITY_MATRIX_MVP,v.vertex);
				
				half3 worldNormal = normalize(mul(v.normal, (half3x3)unity_WorldToObject));
				half3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				half3 diffuse = _LightColor0.rgb*_Diffuse.rgb*saturate(dot(worldNormal, worldLight));
				half3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
				o.color = diffuse + ambient;

              
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
}
