/// <summary>
/// 来自：
/// Unity3D 在Game窗口下查看Overdraw视图 - ComplicatedCc的博客 - CSDN博客
/// http://blog.csdn.net/complicatedcc/article/details/70214681
/// add by cy 20170924
/// </summary>

Shader "Custom/Overdraw"
{
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
        LOD 100
        Fog { Mode Off }
        ZWrite Off
        ZTest Always
        Blend One One
 
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
         
            #include "UnityCG.cginc"
 
            struct appdata
            {
                float4 vertex : POSITION;
            };
 
            struct v2f
            {
                float4 vertex : SV_POSITION;
            };
 
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }
         
            fixed4 frag (v2f i) : SV_Target
            {
                //return fixed4(0.1, 0.2, 0.05, 0); //原始Overdraw
                //return fixed4(0.2, 0.24, 0.42, 0); //白蓝
                //return fixed4(0.1, 0.14, 0.42, 0); //蓝
                //return fixed4(0.2, 0.2, 0.2, 0); //0.2白
                //return fixed4(0.1, 0.1, 0.1, 0); //0.1白
                //return fixed4(0.1, 0.2, 0.4, 0); //天蓝
                //return fixed4(0.01, 0.04, 0.09, 0); //暗蓝

                //return fixed4(0.01, 0.12, 0.05, 0); //夜视仪
                return fixed4(0.04, 0.1, 0.14, 0); //浅蓝
                //return fixed4(0.2, 0.1, 0.04, 0); //浅蓝
                
                
            }
            ENDCG
        }
    }
}