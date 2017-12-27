// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// CANDELA-SSRR V2 SCREEN SPACE RAYTRACED REFLECTIONS
// Copyright 2015 Livenda
   
      
    Shader "Hidden/CandelaWorldNormal"
    {
      Properties
      {
      	_MainTex ("Base (RGB)", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _Shininess ("Shininess", Range (0.03, 1)) = 1
        _Glossiness("Smoothness", Range(0.0, 1.0)) = 0.0
        _MetallicGlossMap("Metallic", 2D) = "white" {}
        _SpecTex ("Specular(RGB) Roughness(A)", 2D) = "white" {}
        _SpecGlossMap ("Specular(RGB) Roughness(A)", 2D) = "white" {}
       
      }
      SubShader
      {
        Tags { "RenderType"="Opaque" }
        Pass {
         
          CGPROGRAM
          #pragma vertex vert
          #pragma fragment frag
          #include "UnityCG.cginc"
     
     
          sampler2D _BumpMap;
          float4 _BumpMap_ST;
     	  float _Shininess;
     	  float _Glossiness;
     
     	  sampler2D _MetallicGlossMap;
     	  sampler2D _SpecTex;
     	  sampler2D _SpecGlossMap;
     	  sampler2D _MainTex;
     	  float4 _MainTex_ST;
		  float _alphaBiasControlSSRR;
     	  
          struct v2f
          {
            float4 pos : SV_POSITION;
            float2 uv : TEXCOORD0;
            float3 TtoW0 : TEXCOORD1;
            float3 TtoW1 : TEXCOORD2;
            float3 TtoW2 : TEXCOORD3;
            float2 uvs   : TEXCOORD4;
            fixed3 col	:	COLOR;
          
          };
     
          v2f vert (appdata_tan v)
          {
            v2f o;
            
             TANGENT_SPACE_ROTATION;
              o.TtoW0 = (mul(rotation, unity_ObjectToWorld[0].xyz ));
              o.TtoW1 = (mul(rotation, unity_ObjectToWorld[1].xyz ));
              o.TtoW2 = (mul(rotation, unity_ObjectToWorld[2].xyz ));
                       
            o.pos = UnityObjectToClipPos (v.vertex);
            o.uv = TRANSFORM_TEX (v.texcoord, _BumpMap);
     		o.uvs = TRANSFORM_TEX (v.texcoord, _MainTex);
     		o.col = mul( unity_ObjectToWorld, float4( v.normal, 0.0 ) ).xyz*0.5+0.5;
     		
			return o;
          }
     
          float4 frag (v2f i) : COLOR0
          {
            float3 normal2 = (UnpackNormal(tex2D(_BumpMap, i.uv)));
                               
            float3 normalWS;
            normalWS.x = dot(i.TtoW0, normal2);
            normalWS.y = dot(i.TtoW1, normal2);
            normalWS.z = dot(i.TtoW2, normal2);
            
            float ln = dot(normalWS, float3(0.0,0.0,1.0));
           
            fixed4 color; 
            
            color.xyz = normalize(normalWS) * 0.5 + 0.5;
            
           if (ln > 1.0)
           {
           color.xyz = i.col.xyz;
           }
                  
            float spe = tex2D(_SpecTex, i.uvs).a;
            float SpecGlossMap = tex2D(_SpecGlossMap, i.uvs).a;
            float spemetal = tex2D(_MetallicGlossMap, i.uvs).a;
                       
            color.a = (_Shininess*spe);
                 
            if (_Shininess == 0) color.a= spemetal*_Glossiness;
            
            return color;
          }
          ENDCG
        }
      }
    }
    
    