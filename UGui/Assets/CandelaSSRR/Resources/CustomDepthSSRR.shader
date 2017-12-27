// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// CANDELA-SSRR V2 SCREEN SPACE RAYTRACED REFLECTIONS
// Copyright 2015 Livenda

Shader "Hidden/CustomDepthSSRR" {


SubShader {

    Tags {"Queue" = "Transparent"  "RenderType"="Transparent"}
    Pass {
  
        Fog { Mode Off }
       
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

float _ExcludeFromSSRR;

struct v2f {
    float4 pos : SV_POSITION;
    float2 mypos : TEXCOORD1;
};

v2f vert (appdata_base v) {
    v2f o;
    o.pos = UnityObjectToClipPos (v.vertex);
    o.mypos = o.pos.zw;
    return o;
}

half4 frag(v2f i) : COLOR {
	
	float castref =_ExcludeFromSSRR;
	
	float4 d = float4(i.mypos.x/i.mypos.y, 1-castref, 0, 0);
	
    return  d;
}
ENDCG
    }
}
}