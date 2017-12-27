// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// CANDELA-SSRR V2 SCREEN SPACE RAYTRACED REFLECTIONS
// Copyright 2015 Livenda

Shader "Hidden/Toksvig" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	
}

SubShader {
	ZTest Always Cull Off ZWrite Off Fog { Mode Off }
	Pass {

CGPROGRAM
#pragma target 3.0
#pragma vertex vert
#pragma fragment frag
#pragma fragmentoption ARB_precision_hint_fastest
#pragma glsl
#include "UnityCG.cginc"
                
uniform sampler2D _MainTex;
float4 _MainTex_TexelSize;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraNormalsTexture2;

		sampler2D _CameraDepthNormalsTexture;
uniform sampler2D _CameraGBufferTexture2;
uniform float _ToksvigPower;

uniform float _IsInForwardRender;
uniform float _IsInLegacyDeffered;
uniform float _FullDeferred;

float4x4 _CameraMV;


float3 GetWorldNormal(float2 screenspaceUV)
{
float4 dn = tex2Dlod(_CameraDepthNormalsTexture, float4(screenspaceUV,0,0));
float3 n = DecodeViewNormalStereo(dn);
float3 worldN = mul((float3x3)_CameraMV, n);

return worldN;
}


	
struct v2f {
	float4 pos : POSITION;
	float2 uv : TEXCOORD0;
};


v2f vert( appdata_img v )
{
	v2f o;
	o.pos = UnityObjectToClipPos (v.vertex);
	o.uv = MultiplyUV( UNITY_MATRIX_TEXTURE0, v.texcoord );

	return o;
}


half4 frag (v2f i) : COLOR
{

	////////////////////////////Toksvig ///////////////////////////////////
	
	float2 texel = _MainTex_TexelSize.xy*0.75;
					
					half2 offset5 = i.uv.xy + float2(  -texel.x, 0 );
					half2 offset6 = i.uv.xy + float2(   texel.x, 0 );
					half2 offset7 = i.uv.xy + float2(  0, -texel.y );
					half2 offset8 = i.uv.xy + float2(  0,  texel.y );
					

		   		   
	 half3  Normaln = (tex2Dlod(_CameraNormalsTexture, float4(offset5,0,0)).rgb)*2.0-1.0;
		   Normaln += (tex2Dlod(_CameraNormalsTexture, float4(offset6,0,0)).rgb)*2.0-1.0;
		   Normaln += (tex2Dlod(_CameraNormalsTexture, float4(offset7,0,0)).rgb)*2.0-1.0;
		   Normaln += (tex2Dlod(_CameraNormalsTexture, float4(offset8,0,0)).rgb)*2.0-1.0;

		   
		   Normaln *=0.25;
		  		  
		   half len = length(Normaln.xyz);
						   
		   if(len < 0.825 )  len =1;
	
		   	   
		   // Toksvig Factor
    	   half ft = len/lerp(256*_ToksvigPower, 1.0, len);
    	   
float3 nm = normalize(tex2D(_CameraNormalsTexture, float2(offset5)).rgb)*2.0-1.0;
return clamp(pow(ft,0.99),0,1);
	
}
ENDCG
	}
}

Fallback off

}