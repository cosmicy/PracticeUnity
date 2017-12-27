// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// CANDELA-SSRR V2 SCREEN SPACE RAYTRACED REFLECTIONS
// Copyright 2015 Livenda

Shader "Hidden/CandelaCompose" {
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
uniform sampler2D _SSRtexture;
uniform float4 _ScreenFadeControls;
uniform float _UseEdgeTexture;
uniform float _IsInForwardRender;
uniform float _IsInLegacyDeffered;
//uniform float _FullDeferred;
uniform sampler2D _EdgeFadeTexture;
//uniform sampler2D _depthTexCustom;
uniform float _SSRRcomposeMode;
uniform float _reflectionMultiply;
uniform sampler2D _CameraDepthTexture;
uniform float _FlipReflectionsMSAA;
uniform float _fadePower;
uniform float _fresfade;
uniform float _fresrange;
		float4 _MainTex_TexelSize;
uniform sampler2D _CameraNormalsTexture;
		sampler2D _CameraDepthNormalsTexture;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
uniform sampler2D _CameraGBufferTexture0; 
uniform float4x4	_ViewProjectInverse;
uniform float _convolutionSamples;
uniform float _swidth;
		float4x4 _CameraMV;
		
uniform sampler2D _toksvigRT;


	
//////////////  Hammersley point set fast and practical generation of hemisphere directions////
////////////////////////////////////////////////////////////////////////////////////////////


	inline float3 SchlickFres(float3 SpecCol,float ndotv, float roughness)
	{
	    return SpecCol + ( 1.0f - SpecCol)* exp2( (-5.554731 * ndotv - 6.983162) * ndotv*saturate(1.0-roughness*2.0)); //PBS FRESNEL ATT BASED ON ROUGNESS
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
	
//--------------------------------
float2 uvtmp = i.uv;

if(_FlipReflectionsMSAA >0) uvtmp.y = 1-uvtmp.y; 

float2 uvflipped = uvtmp;
//--------------------------------
	
	float4 original    = tex2D(_MainTex, i.uv);
	half tok = tex2D(_toksvigRT, i.uv).x;
	
	//half4 tok = tex2D(_toksvigRT, i.uv);
	
	float4 dn = tex2D(_CameraDepthNormalsTexture, uvflipped);
	float3 n = DecodeViewNormalStereo(dn);
	float3 worldN = mul((float3x3)_CameraMV, n);
	
	
	float4 	Mainworldnormal = tex2D (_CameraNormalsTexture, uvflipped)*2.0-1.0; 

			Mainworldnormal =normalize(Mainworldnormal);
		
		////////////////////////NDOTV reconstruct View from VPI and Depth
		
		float 	ZD = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));      	
		float3 	scrPos = float3(uvflipped*2-1, ZD); 							//Flip Pos for MSAA support      
		float4 	WPos = mul(_ViewProjectInverse, float4(scrPos,1)); 
				WPos = WPos / WPos.w;
		float3 	viewDir = normalize(WPos.rgb - _WorldSpaceCameraPos);
		float 	NdotV = saturate(dot(Mainworldnormal ,-viewDir )); 
		
		if (_IsInLegacyDeffered  > 0)
			NdotV = saturate(dot(worldN ,-viewDir )); 
		
		///////////////////////////////////////////////////////////////////////
	
	float4 worldnorm = (tex2D(_CameraNormalsTexture, uvflipped));
	float4 worldnorm2 = (tex2D(_CameraGBufferTexture1, i.uv));
	float4 specular = worldnorm2;
	
	if (_IsInForwardRender || _IsInLegacyDeffered  > 0)
	specular = worldnorm.a;
	
	else
	worldnorm = worldnorm2;
	
	specular.a = pow(specular.a,1/2.2);
	
	worldnorm.a = pow(worldnorm.a,1.4);
	
	half4 gbuffer0 = tex2D (_CameraGBufferTexture0, i.uv); 
	float occlusion = gbuffer0.a;
	
	float screenFade  = 1.0f;
	
	if(_UseEdgeTexture > 0)
	screenFade = (tex2D(_EdgeFadeTexture, i.uv).x);
	else
	
	screenFade = 1-pow(saturate((pow(length(((i.uv * 2.0) - 1.0)),_ScreenFadeControls.y)-_ScreenFadeControls.z)*_ScreenFadeControls.w),0.9);
	screenFade = pow(screenFade,4.2);
	
	float4 col = float4(0,0,0,0);
	
	float2 inUV = i.uv;
	float4 SSRColor = float4(0,0,0,0);
			SSRColor.a =tex2D(_SSRtexture, i.uv).a;
			

	float roughness = max(specular.a*tok,0.05); //fetch remap UT5 PBS smoothness!
	
	SSRColor.rgb = tex2Dlod(_SSRtexture, float4(inUV.xy,0,0)).rgb*tok;
	
	
		// Attenuate Reflections to fix SchlickFres modulation for Mirror reflections at high rougness values
	float dirAtten = pow(1-pow(NdotV,(10-_fresfade)),exp(_fresrange*8*(1-roughness*0.2))); ///<------DO NOT CHANGE PHYSICALLY CORRECT FOR SSR
	
			dirAtten *=clamp(SSRColor.a*SSRColor.a*SSRColor.a,0,1);

	
	//////////////////////////////////////////////////FINAL COMPOSE /////////////////////////////////////////////////////////////
	
	if(_SSRRcomposeMode > 0)//Physically Accurate Mode
	{
	
	if (_IsInForwardRender || _IsInLegacyDeffered > 0)
	col = float4(SSRColor.rgb * SchlickFres(specular.rgb,NdotV,roughness),1)*dirAtten*worldnorm.a*_reflectionMultiply+original*(1-dirAtten*_reflectionMultiply*worldnorm.a);
	else	
	col = float4(SSRColor.rgb * SchlickFres(specular.rgb,NdotV,roughness),1)*dirAtten*clamp(pow(float4(worldnorm.rgb+0.03,0),1/6.2),0.5,1)*worldnorm.a*_reflectionMultiply+original*(1-dirAtten*_reflectionMultiply*worldnorm.a);
	
	}
	else
	{						//Additive Mode

	if (_IsInForwardRender || _IsInLegacyDeffered > 0)
	col = float4(SSRColor.rgb * SchlickFres(specular.rgb,NdotV,roughness),1)*dirAtten*worldnorm.a*_reflectionMultiply+original;
	else
	col = float4(SSRColor.rgb * SchlickFres(specular.rgb,NdotV,roughness),1)*dirAtten*clamp(pow(float4(worldnorm.rgb+0.03,0),1/6.2),0.5,1)*worldnorm.a*_reflectionMultiply+original;
	
	}
	
	//Debug Display Screen Fade
	if(_ScreenFadeControls.x > 0)
	col = screenFade;
	
	 
	float4 rf = tex2Dlod(_SSRtexture, float4(uvflipped.xy,0,0));
	
	float3 sh = SchlickFres(specular.rgb,NdotV,worldnorm.a);
	return lerp(original,col, screenFade);//float4(tex2Dlod(_SSRtexture, float4(inUV.xy,0,0)).rgb,1);//;// lerp(original,col, screenFade);
	
}
ENDCG
	}
}

Fallback off

}