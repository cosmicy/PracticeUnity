// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// CANDELA-SSRR V2 SCREEN SPACE RAYTRACED REFLECTIONS
// Copyright 2015 Livenda

Shader "Hidden/LumaComp" {
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


inline half lumaTap(float2 uv ) 
{
					
					half2 texel = _MainTex_TexelSize.xy*1.5;
					
					
					half4 lumcoeff = float4(0.299,0.587,0.114,0.0);
					
					half2 offset0 = uv.xy;
					half2 offset1 = uv.xy - texel;
					half2 offset2 = uv.xy + float2(  texel.x, -texel.y );
					half2 offset3 = uv.xy + float2( -texel.x,  texel.y );
					half2 offset4 = uv.xy + texel;
					
					half2 offset5 = uv.xy + float2(  -texel.x, 0 );
					half2 offset6 = uv.xy + float2(   texel.x, 0 );
					half2 offset7 = uv.xy + float2(  0, -texel.y );
					half2 offset8 = uv.xy + float2(  0,  texel.y );
					
						
					float	luma1    =  dot(tex2D(_MainTex, offset1),lumcoeff);
							luma1    += dot(tex2D(_MainTex, offset2),lumcoeff);
							luma1    += dot(tex2D(_MainTex, offset3),lumcoeff);
							luma1    += dot(tex2D(_MainTex, offset4),lumcoeff);
							luma1    += dot(tex2D(_MainTex, offset5),lumcoeff);
							luma1    += dot(tex2D(_MainTex, offset6),lumcoeff);
							luma1    += dot(tex2D(_MainTex, offset7),lumcoeff);
							luma1    += dot(tex2D(_MainTex, offset8),lumcoeff);
					
							//_Accum
							float averageLuma= luma1/8;
														
							float centretap = dot(tex2D(_MainTex, offset0),lumcoeff)/1.5;
														
							float lumadiff = saturate(centretap-averageLuma);
						
							if (lumadiff > 1) lumadiff = 0;
								
	return lumadiff;

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
  half lumacomp = 1-lumaTap(i.uv);
  half4 final = tex2D(_MainTex, i.uv);
  half lmfinal = pow(lumacomp,12);
  final.xyz *=lmfinal*lmfinal*lmfinal;
return final;
	
}
ENDCG
	}
}

Fallback off

}