Shader "CandelaSSRR/Specular SSR" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
	_MainTex ("Base (RGB) Reflectivity (A)", 2D) = "white" {}
	_SpecTex ("Specular(RGB) Roughness(A)", 2D) = "white" {}

}
SubShader { 
	Tags { "RenderType"="Opaque" }
	LOD 400
	
CGPROGRAM
#pragma surface surf BlinnPhong



sampler2D _MainTex;
sampler2D _SpecTex;


fixed4 _Color;
half _Shininess;


struct Input {
	float2 uv_MainTex;
	float2 uv_BumpMap;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	float4 SPG = tex2D(_SpecTex, IN.uv_MainTex);
	
	
	
	_SpecColor = _SpecColor*SPG;
	
	o.Albedo = tex.rgb * _Color.rgb;
	o.Gloss = SPG.a;
	o.Alpha = tex.a * _Color.a;
	o.Specular = clamp(_Shininess*SPG.a,0.01,1.0);
	

}
ENDCG
}

FallBack "Specular"
}

