Shader "CandelaSSRR/Cubemap Specular SSR" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
	_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
	_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	_SpecTex ("Specular(RGB) Roughness(A)", 2D) = "white" {}
	_Cube ("Reflection Cubemap", Cube) = "_Skybox" 
}
SubShader {
	LOD 300
	Tags { "RenderType"="Opaque" }

CGPROGRAM
#pragma surface surf BlinnPhong

sampler2D _MainTex;
sampler2D _SpecTex;
samplerCUBE _Cube;

fixed4 _Color;
fixed4 _ReflectColor;
half _Shininess;

struct Input {
	float2 uv_MainTex;
	float3 worldRefl;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	half4 SPG = tex2D(_SpecTex, IN.uv_MainTex);
	
	
	///ALL
	fixed4 reflcol = texCUBE (_Cube, IN.worldRefl);
	
	
	
	_SpecColor = _SpecColor*SPG;
	
	fixed4 c = tex * _Color;
	
	o.Albedo = c.rgb;
	o.Gloss = tex.a;
	o.Specular = clamp(_Shininess*SPG.a,0.01,1.0);
	
	
	reflcol *= tex.a;
	o.Emission = reflcol.rgb *_ReflectColor.rgb;
	o.Alpha =  _Color.a*tex.a;
}
ENDCG
}

FallBack "Reflective/VertexLit"
}