// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// CANDELA-SSRR V2 SCREEN SPACE RAYTRACED REFLECTIONS
// Copyright 2015 Livenda

Shader "Hidden/GausFast" {
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
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraNormalsTexture;
uniform float _IsInForwardRender;
uniform float _IsInLegacyDeffered;
uniform float _FlipReflectionsMSAA;
uniform sampler2D _toksvigRT;
uniform float _ContactBlurPower;
uniform float _fadePower;
uniform float _radius;


inline half4 hblur (float2 uv, float stride ) 
{

	half2 texel = (_MainTex_TexelSize.xy+pow(stride,0.9))*_radius;

	half2 h_blurTexCoords[14];
	
	h_blurTexCoords[ 0] = uv + texel*float2(-0.028, 0.0);
    h_blurTexCoords[ 1] = uv + texel*float2(-0.024, 0.0);
    h_blurTexCoords[ 2] = uv + texel*float2(-0.020, 0.0);
    h_blurTexCoords[ 3] = uv + texel*float2(-0.016, 0.0);
    h_blurTexCoords[ 4] = uv + texel*float2(-0.012, 0.0);
    h_blurTexCoords[ 5] = uv + texel*float2(-0.008, 0.0);
    h_blurTexCoords[ 6] = uv + texel*float2(-0.004, 0.0);
    h_blurTexCoords[ 7] = uv + texel*float2( 0.004, 0.0);
    h_blurTexCoords[ 8] = uv + texel*float2( 0.008, 0.0);
    h_blurTexCoords[ 9] = uv + texel*float2( 0.012, 0.0);
    h_blurTexCoords[10] = uv + texel*float2( 0.016, 0.0);
    h_blurTexCoords[11] = uv + texel*float2( 0.020, 0.0);
    h_blurTexCoords[12] = uv + texel*float2( 0.024, 0.0);
    h_blurTexCoords[13] = uv + texel*float2( 0.028, 0.0);
    
	half4 gl_FragColor = half4(0,0,0,0);
    
    stride =0.0;
     
    gl_FragColor += tex2Dlod(_MainTex, float4(h_blurTexCoords[ 0],0,stride))*0.0044299121055113265;
    gl_FragColor += tex2Dlod(_MainTex, float4(h_blurTexCoords[ 1],0,stride))*0.00895781211794;
    gl_FragColor += tex2Dlod(_MainTex, float4(h_blurTexCoords[ 2],0,stride))*0.0215963866053;
    gl_FragColor += tex2Dlod(_MainTex, float4(h_blurTexCoords[ 3],0,stride))*0.0443683338718;
    gl_FragColor += tex2Dlod(_MainTex, float4(h_blurTexCoords[ 4],0,stride))*0.0776744219933;
    gl_FragColor += tex2Dlod(_MainTex, float4(h_blurTexCoords[ 5],0,stride))*0.115876621105;
    gl_FragColor += tex2Dlod(_MainTex, float4(h_blurTexCoords[ 6],0,stride))*0.147308056121;
    gl_FragColor += tex2Dlod(_MainTex, float4(uv,0,stride))*0.159576912161;
    gl_FragColor += tex2Dlod(_MainTex, float4(h_blurTexCoords[ 7],0,stride))*0.147308056121;
    gl_FragColor += tex2Dlod(_MainTex, float4(h_blurTexCoords[ 8],0,stride))*0.115876621105;
    gl_FragColor += tex2Dlod(_MainTex, float4(h_blurTexCoords[ 9],0,stride))*0.0776744219933;
    gl_FragColor += tex2Dlod(_MainTex, float4(h_blurTexCoords[ 10],0,stride))*0.0443683338718;
    gl_FragColor += tex2Dlod(_MainTex, float4(h_blurTexCoords[ 11],0,stride))*0.0215963866053;
    gl_FragColor += tex2Dlod(_MainTex, float4(h_blurTexCoords[ 12],0,stride))*0.00895781211794;
    gl_FragColor += tex2Dlod(_MainTex, float4(h_blurTexCoords[ 13],0,stride))*0.0044299121055113265;
							
							
	return gl_FragColor;

}

inline half RC (float2 uv ) 
{
					
if(_FlipReflectionsMSAA >0) uv.y = 1-uv.y; 

float spec = 1-tex2D(_CameraNormalsTexture, uv).a;
float spec2 = 1-tex2D(_CameraGBufferTexture1, uv).a;

if (_IsInForwardRender || _IsInLegacyDeffered  > 0)
spec = spec;
else
spec = spec2;

//spec = clamp(spec,0.0, 1.0);

return spec;
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
  
    half mask = saturate(1-tex2D(_MainTex, i.uv).a);

	float maskadd = lerp(1, mask,_ContactBlurPower-0.005);

	mask = pow(maskadd,1/1.99)+0.001;

 	float roughness = pow(RC(i.uv),0.7)*mask;
 	
 	half tok = tex2D(_toksvigRT, i.uv).x;
 
 	roughness = saturate(roughness*2);
 		
    return hblur(i.uv,roughness*tok);
}
ENDCG
	}
	//==========================================================================================================
	//pass 2
	//==========================================================================================================
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
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraNormalsTexture;
uniform float _IsInForwardRender;
uniform float _IsInLegacyDeffered;
uniform float _FlipReflectionsMSAA;
uniform sampler2D _toksvigRT;
uniform float _ContactBlurPower;
uniform float _fadePower;
uniform float _radius;


inline half4 vblur (float2 uv, float stride ) 
{

	half2 texel = (_MainTex_TexelSize.xy+pow(stride,0.9))*_radius;

	half2 v_blurTexCoords[14];
	
	v_blurTexCoords[ 0] = uv + texel*float2(0.0, -0.028);
    v_blurTexCoords[ 1] = uv + texel*float2(0.0,-0.024);
    v_blurTexCoords[ 2] = uv + texel*float2(0.0,-0.020);
    v_blurTexCoords[ 3] = uv + texel*float2(0.0,-0.016);
    v_blurTexCoords[ 4] = uv + texel*float2(0.0,-0.012);
    v_blurTexCoords[ 5] = uv + texel*float2(0.0,-0.008);
    v_blurTexCoords[ 6] = uv + texel*float2(0.0,-0.004);
    v_blurTexCoords[ 7] = uv + texel*float2(0.0, 0.004);
    v_blurTexCoords[ 8] = uv + texel*float2(0.0, 0.008);
    v_blurTexCoords[ 9] = uv + texel*float2(0.0, 0.012);
    v_blurTexCoords[10] = uv + texel*float2(0.0, 0.016);
    v_blurTexCoords[11] = uv + texel*float2(0.0, 0.020);
    v_blurTexCoords[12] = uv + texel*float2(0.0, 0.024);
    v_blurTexCoords[13] = uv + texel*float2(0.0, 0.028);
    
	half4 gl_FragColor = half4(0,0,0,0);
	
	stride =0.0;
    
    gl_FragColor += tex2Dlod(_MainTex, float4(v_blurTexCoords[ 0],0,stride))*0.0044299121055113265;
    gl_FragColor += tex2Dlod(_MainTex, float4(v_blurTexCoords[ 1],0,stride))*0.00895781211794;
    gl_FragColor += tex2Dlod(_MainTex, float4(v_blurTexCoords[ 2],0,stride))*0.0215963866053;
    gl_FragColor += tex2Dlod(_MainTex, float4(v_blurTexCoords[ 3],0,stride))*0.0443683338718;
    gl_FragColor += tex2Dlod(_MainTex, float4(v_blurTexCoords[ 4],0,stride))*0.0776744219933;
    gl_FragColor += tex2Dlod(_MainTex, float4(v_blurTexCoords[ 5],0,stride))*0.115876621105;
    gl_FragColor += tex2Dlod(_MainTex, float4(v_blurTexCoords[ 6],0,stride))*0.147308056121;
    gl_FragColor += tex2Dlod(_MainTex, float4(uv,0,stride))*0.159576912161;
    gl_FragColor += tex2Dlod(_MainTex, float4(v_blurTexCoords[ 7],0,stride))*0.147308056121;
    gl_FragColor += tex2Dlod(_MainTex, float4(v_blurTexCoords[ 8],0,stride))*0.115876621105;
    gl_FragColor += tex2Dlod(_MainTex, float4(v_blurTexCoords[ 9],0,stride))*0.0776744219933;
    gl_FragColor += tex2Dlod(_MainTex, float4(v_blurTexCoords[ 10],0,stride))*0.0443683338718;
    gl_FragColor += tex2Dlod(_MainTex, float4(v_blurTexCoords[ 11],0,stride))*0.0215963866053;
    gl_FragColor += tex2Dlod(_MainTex, float4(v_blurTexCoords[ 12],0,stride))*0.00895781211794;
    gl_FragColor += tex2Dlod(_MainTex, float4(v_blurTexCoords[ 13],0,stride))*0.0044299121055113265;
							
							
	return gl_FragColor;

}

inline half RC (float2 uv ) 
{
					
if(_FlipReflectionsMSAA >0) uv.y = 1-uv.y; 

float spec = 1-tex2D(_CameraNormalsTexture, uv).a;
float spec2 = 1-tex2D(_CameraGBufferTexture1, uv).a;

if (_IsInForwardRender || _IsInLegacyDeffered  > 0)
spec = spec;
else
spec = spec2;

//spec = clamp(spec,0.0, 1.0);

return spec;
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
  
    half mask = saturate(1-tex2D(_MainTex, i.uv).a);
	
	float maskadd = lerp(1, mask,_ContactBlurPower-0.005);

	mask = pow(maskadd,1/1.99)+0.001;
		
	float roughness = pow(RC(i.uv),0.7)*mask;
	
	half tok = tex2D(_toksvigRT, i.uv).x;
	
	roughness = saturate(roughness*2);

 
    return vblur(i.uv,roughness*tok);
}
ENDCG
	}
}

Fallback off

}