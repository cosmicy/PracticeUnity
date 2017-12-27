// CANDELA-SSRR V2 SCREEN SPACE RAYTRACED REFLECTIONS
// Copyright 2015 Livenda

Shader "Hidden/CandelaSSRRv2" {
Properties {
 _MainTex ("Base (RGB)", 2D) = "white" { }
}
SubShader { 


 // Stats for Vertex shader:
 //       d3d11 : 4 math
 //        d3d9 : 5 math
 //        gles : 145 math, 12 texture, 30 branch
 //       metal : 1 math
 //      opengl : 145 math, 12 texture, 30 branch
 // Stats for Fragment shader:
 //       d3d11 : 114 math, 1 texture, 41 branch
 //        d3d9 : 157 math, 23 texture, 44 branch
 //       metal : 145 math, 12 texture, 30 branch
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
  GpuProgramID 19398
Program "vp" {
SubProgram "opengl " {
// Stats: 145 math, 12 textures, 30 branches
"!!GLSL#version 120

#ifdef VERTEX

varying vec2 xlv_TEXCOORD0;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
uniform vec4 _ScreenParams;
uniform vec4 _ZBufferParams;
uniform sampler2D _depthTexCustom;
uniform sampler2D _MainTex;
uniform float _fadePower;
uniform float _maxDepthCull;
uniform float _maxFineStep;
uniform float _maxStep;
uniform float _stepGlobalScale;
uniform float _bias;
uniform mat4 _ProjMatrix;
uniform mat4 _ProjectionInv;
uniform mat4 _ViewMatrix;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
uniform float _SSRRcomposeMode;
uniform float _FlipReflectionsMSAA;
uniform float _skyEnabled;
uniform sampler2D _CameraDepthNormalsTexture;
uniform sampler2D _CameraGBufferTexture2;
uniform float _IsInForwardRender;
uniform float _IsInLegacyDeffered;
uniform float _FullDeferred;
uniform mat4 _CameraMV;
varying vec2 xlv_TEXCOORD0;
void main ()
{
  vec2 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  float kklng4_2;
  float ejzah4_3;
  int mftrqw_4;
  vec3 otrre5_5;
  vec4 rehj5_6;
  float utrhfd_7;
  vec4 fincxse_8;
  vec4 tmpvar_9;
  tmpvar_9 = texture2DLod (_MainTex, xlv_TEXCOORD0, 0.0);
  float tmpvar_10;
  if ((_skyEnabled > 0.5)) {
    tmpvar_10 = -24.0;
  } else {
    tmpvar_10 = _ZBufferParams.x;
  };
  ejzah4_3 = tmpvar_10;
  float tmpvar_11;
  if ((_skyEnabled > 0.5)) {
    tmpvar_11 = 25.0;
  } else {
    tmpvar_11 = _ZBufferParams.y;
  };
  kklng4_2 = tmpvar_11;
  if ((tmpvar_9.w == 0.0)) {
    fincxse_8 = vec4(0.0, 0.0, 0.0, 0.0);
  } else {
    float tmuiq2_12;
    tmuiq2_12 = 0.0;
    if ((_IsInForwardRender > 0.0)) {
      tmuiq2_12 = texture2DLod (_depthTexCustom, xlv_TEXCOORD0, 0.0).x;
    } else {
      tmuiq2_12 = texture2DLod (_CameraDepthTexture, xlv_TEXCOORD0, 0.0).x;
    };
    float tmpvar_13;
    tmpvar_13 = (1.0/(((tmpvar_10 * tmuiq2_12) + tmpvar_11)));
    if ((tmpvar_13 > _maxDepthCull)) {
      fincxse_8 = vec4(0.0, 0.0, 0.0, 0.0);
    } else {
      vec4 paAccurateColor_14;
      vec4 origtmp_15;
      int s_16;
      vec4 uytrfb4_17;
      float vcfggr4_18;
      float fghdtge4_19;
      int i_33_20;
      bool dlkfeoi_21;
      vec4 odpoeir6_22;
      float fduer6_23;
      int maxCount_29_24;
      vec3 mvjidu6_25;
      vec3 iydjer_26;
      vec3 ofpeod_27;
      vec4 nfkjie2_28;
      vec4 fjhdrit_29;
      vec3 vredju_30;
      vec4 qwmjd7_31;
      mftrqw_4 = int(_maxStep);
      qwmjd7_31.w = 1.0;
      qwmjd7_31.xy = ((xlv_TEXCOORD0 * 2.0) - 1.0);
      qwmjd7_31.z = tmuiq2_12;
      vec4 tmpvar_32;
      tmpvar_32 = (_ProjectionInv * qwmjd7_31);
      vec4 tmpvar_33;
      tmpvar_33 = (tmpvar_32 / tmpvar_32.w);
      vredju_30.xy = qwmjd7_31.xy;
      vredju_30.z = tmuiq2_12;
      fjhdrit_29.w = 0.0;
      fjhdrit_29.xyz = vec3(0.0, 0.0, 0.0);
      if ((_IsInForwardRender > 0.0)) {
        fjhdrit_29.xyz = ((texture2DLod (_CameraNormalsTexture, xlv_TEXCOORD0, 0.0).xyz * 2.0) - 1.0);
      } else {
        if ((_IsInLegacyDeffered > 0.0)) {
          vec3 n_34;
          vec3 tmpvar_35;
          tmpvar_35 = ((texture2DLod (_CameraDepthNormalsTexture, xlv_TEXCOORD0, 0.0).xyz * vec3(3.5554, 3.5554, 0.0)) + vec3(-1.7777, -1.7777, 1.0));
          float tmpvar_36;
          tmpvar_36 = (2.0 / dot (tmpvar_35, tmpvar_35));
          n_34.xy = (tmpvar_36 * tmpvar_35.xy);
          n_34.z = (tmpvar_36 - 1.0);
          mat3 tmpvar_37;
          tmpvar_37[0] = _CameraMV[0].xyz;
          tmpvar_37[1] = _CameraMV[1].xyz;
          tmpvar_37[2] = _CameraMV[2].xyz;
          fjhdrit_29.xyz = (tmpvar_37 * n_34);
        } else {
          if ((_FullDeferred > 0.0)) {
            fjhdrit_29.xyz = ((texture2D (_CameraGBufferTexture2, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
          };
        };
      };
      vec3 tmpvar_38;
      tmpvar_38 = normalize(tmpvar_33.xyz);
      vec3 tmpvar_39;
      tmpvar_39 = normalize((_ViewMatrix * fjhdrit_29).xyz);
      nfkjie2_28.w = 1.0;
      nfkjie2_28.xyz = (tmpvar_33.xyz + normalize((tmpvar_38 - 
        (2.0 * (dot (tmpvar_39, tmpvar_38) * tmpvar_39))
      )));
      vec4 tmpvar_40;
      tmpvar_40 = (_ProjMatrix * nfkjie2_28);
      vec3 tmpvar_41;
      tmpvar_41 = normalize(((tmpvar_40.xyz / tmpvar_40.w) - vredju_30));
      otrre5_5.z = tmpvar_41.z;
      otrre5_5.xy = (tmpvar_41.xy * 0.5);
      ofpeod_27.xy = tmpvar_1;
      ofpeod_27.z = tmuiq2_12;
      utrhfd_7 = 0.0;
      float tmpvar_42;
      tmpvar_42 = (2.0 / _ScreenParams.x);
      float tmpvar_43;
      tmpvar_43 = sqrt(dot (otrre5_5.xy, otrre5_5.xy));
      vec3 tmpvar_44;
      tmpvar_44 = (otrre5_5 * ((tmpvar_42 * _stepGlobalScale) / tmpvar_43));
      iydjer_26 = tmpvar_44;
      maxCount_29_24 = int(_maxStep);
      fduer6_23 = utrhfd_7;
      dlkfeoi_21 = bool(0);
      mvjidu6_25 = (ofpeod_27 + tmpvar_44);
      i_33_20 = 0;
      s_16 = 0;
      while (true) {
        if ((s_16 >= 120)) {
          break;
        };
        if ((i_33_20 >= maxCount_29_24)) {
          break;
        };
        if ((_IsInForwardRender > 0.0)) {
          fghdtge4_19 = (1.0/(((ejzah4_3 * texture2DLod (_depthTexCustom, mvjidu6_25.xy, 0.0).x) + kklng4_2)));
        } else {
          fghdtge4_19 = (1.0/(((ejzah4_3 * texture2DLod (_CameraDepthTexture, mvjidu6_25.xy, 0.0).x) + kklng4_2)));
        };
        vcfggr4_18 = (1.0/(((ejzah4_3 * mvjidu6_25.z) + kklng4_2)));
        if ((fghdtge4_19 < (vcfggr4_18 - 1e-06))) {
          uytrfb4_17.w = 1.0;
          uytrfb4_17.xyz = mvjidu6_25;
          odpoeir6_22 = uytrfb4_17;
          dlkfeoi_21 = bool(1);
          break;
        };
        mvjidu6_25 = (mvjidu6_25 + iydjer_26);
        fduer6_23 += 1.0;
        i_33_20++;
        s_16++;
      };
      if ((dlkfeoi_21 == bool(0))) {
        vec4 eoiejd4_45;
        eoiejd4_45.w = 0.0;
        eoiejd4_45.xyz = mvjidu6_25;
        odpoeir6_22 = eoiejd4_45;
        dlkfeoi_21 = bool(1);
      };
      utrhfd_7 = fduer6_23;
      rehj5_6 = odpoeir6_22;
      float tmpvar_46;
      tmpvar_46 = abs((odpoeir6_22.x - 0.5));
      origtmp_15 = tmpvar_9;
      if ((_FlipReflectionsMSAA > 0.0)) {
        vec2 tmpouv_47;
        tmpouv_47.x = tmpvar_1.x;
        tmpouv_47.y = (1.0 - xlv_TEXCOORD0.y);
        origtmp_15 = texture2DLod (_MainTex, tmpouv_47, 0.0);
      };
      paAccurateColor_14 = vec4(0.0, 0.0, 0.0, 0.0);
      if ((_SSRRcomposeMode > 0.0)) {
        vec4 tmpvar_48;
        tmpvar_48.w = 0.0;
        tmpvar_48.xyz = origtmp_15.xyz;
        paAccurateColor_14 = tmpvar_48;
      };
      if ((tmpvar_46 > 0.5)) {
        fincxse_8 = paAccurateColor_14;
      } else {
        float tmpvar_49;
        tmpvar_49 = abs((odpoeir6_22.y - 0.5));
        if ((tmpvar_49 > 0.5)) {
          fincxse_8 = paAccurateColor_14;
        } else {
          if ((((1.0/(
            ((_ZBufferParams.x * odpoeir6_22.z) + _ZBufferParams.y)
          )) > _maxDepthCull) && (_skyEnabled < 0.5))) {
            fincxse_8 = paAccurateColor_14;
          } else {
            if ((odpoeir6_22.z < 0.1)) {
              fincxse_8 = paAccurateColor_14;
            } else {
              if ((odpoeir6_22.w == 1.0)) {
                int j_50;
                vec3 tyukhg_51;
                vec4 djkflrq_52;
                float cbjdhet_53;
                float kjdkues5_54;
                vec3 oldPos_50_55;
                int i_49_56;
                bool dflskte_57;
                vec4 iuwejd_58;
                int maxCount_45_59;
                vec3 oldksd7_60;
                vec3 samdpo9_61;
                vec3 tmpvar_62;
                tmpvar_62 = (odpoeir6_22.xyz - tmpvar_44);
                vec3 tmpvar_63;
                tmpvar_63 = (otrre5_5 * (tmpvar_42 / tmpvar_43));
                oldksd7_60 = tmpvar_63;
                maxCount_45_59 = int(_maxFineStep);
                dflskte_57 = bool(0);
                oldPos_50_55 = tmpvar_62;
                samdpo9_61 = (tmpvar_62 + tmpvar_63);
                i_49_56 = 0;
                j_50 = 0;
                while (true) {
                  if ((j_50 >= 40)) {
                    break;
                  };
                  if ((i_49_56 >= maxCount_45_59)) {
                    break;
                  };
                  if ((_IsInForwardRender > 0.0)) {
                    kjdkues5_54 = (1.0/(((ejzah4_3 * texture2DLod (_depthTexCustom, samdpo9_61.xy, 0.0).x) + kklng4_2)));
                  } else {
                    kjdkues5_54 = (1.0/(((ejzah4_3 * texture2DLod (_CameraDepthTexture, samdpo9_61.xy, 0.0).x) + kklng4_2)));
                  };
                  cbjdhet_53 = (1.0/(((ejzah4_3 * samdpo9_61.z) + kklng4_2)));
                  if ((kjdkues5_54 < cbjdhet_53)) {
                    if (((cbjdhet_53 - kjdkues5_54) < _bias)) {
                      djkflrq_52.w = 1.0;
                      djkflrq_52.xyz = samdpo9_61;
                      iuwejd_58 = djkflrq_52;
                      dflskte_57 = bool(1);
                      break;
                    };
                    tyukhg_51 = (oldksd7_60 * 0.5);
                    oldksd7_60 = tyukhg_51;
                    samdpo9_61 = (oldPos_50_55 + tyukhg_51);
                  } else {
                    oldPos_50_55 = samdpo9_61;
                    samdpo9_61 = (samdpo9_61 + oldksd7_60);
                  };
                  i_49_56++;
                  j_50++;
                };
                if ((dflskte_57 == bool(0))) {
                  vec4 oeisadw_64;
                  oeisadw_64.w = 0.0;
                  oeisadw_64.xyz = samdpo9_61;
                  iuwejd_58 = oeisadw_64;
                  dflskte_57 = bool(1);
                };
                rehj5_6 = iuwejd_58;
              };
              if ((rehj5_6.w < 0.01)) {
                fincxse_8 = paAccurateColor_14;
              } else {
                vec4 gresdf_65;
                if ((_FlipReflectionsMSAA > 0.0)) {
                  rehj5_6.y = (1.0 - rehj5_6.y);
                };
                gresdf_65.xyz = texture2DLod (_MainTex, rehj5_6.xy, 0.0).xyz;
                gresdf_65.w = (pow ((1.0 - 
                  (fduer6_23 / float(mftrqw_4))
                ), _fadePower) * 1.06);
                fincxse_8 = gresdf_65;
              };
            };
          };
        };
      };
    };
  };
  gl_FragData[0] = fincxse_8;
}


#endif
"
}
SubProgram "d3d9 " {
// Stats: 5 math
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
"vs_3_0
dcl_position v0
dcl_texcoord v1
dcl_position o0
dcl_texcoord o1.xy
dp4 o0.x, c0, v0
dp4 o0.y, c1, v0
dp4 o0.z, c2, v0
dp4 o0.w, c3, v0
mov o1.xy, v1

"
}
SubProgram "d3d11 " {
// Stats: 4 math
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "UnityPerDraw" 0
"vs_4_0
root12:aaabaaaa
eefiecedaffpdldohodkdgpagjklpapmmnbhcfmlabaaaaaaoeabaaaaadaaaaaa
cmaaaaaaiaaaaaaaniaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcaeabaaaa
eaaaabaaebaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaabaaaaaa
doaaaaab"
}
SubProgram "gles " {
// Stats: 145 math, 12 textures, 30 branches
"!!GLES
#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec2 tmpvar_1;
  tmpvar_1 = _glesMultiTexCoord0.xy;
  highp vec2 tmpvar_2;
  tmpvar_2 = tmpvar_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_texture2DLodEXT(lowp sampler2D sampler, highp vec2 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return texture2DLodEXT(sampler, coord, lod);
#else
	return texture2D(sampler, coord, lod);
#endif
}

uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform sampler2D _depthTexCustom;
uniform sampler2D _MainTex;
uniform highp float _fadePower;
uniform highp float _maxDepthCull;
uniform highp float _maxFineStep;
uniform highp float _maxStep;
uniform highp float _stepGlobalScale;
uniform highp float _bias;
uniform highp mat4 _ProjMatrix;
uniform highp mat4 _ProjectionInv;
uniform highp mat4 _ViewMatrix;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
uniform highp float _SSRRcomposeMode;
uniform highp float _FlipReflectionsMSAA;
uniform highp float _skyEnabled;
uniform sampler2D _CameraDepthNormalsTexture;
uniform sampler2D _CameraGBufferTexture2;
uniform highp float _IsInForwardRender;
uniform highp float _IsInLegacyDeffered;
uniform highp float _FullDeferred;
uniform highp mat4 _CameraMV;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 tmpvar_1;
  highp float kklng4_2;
  highp float ejzah4_3;
  highp int mftrqw_4;
  highp vec3 otrre5_5;
  highp vec4 rehj5_6;
  highp float utrhfd_7;
  highp vec4 fincxse_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = impl_low_texture2DLodEXT (_MainTex, xlv_TEXCOORD0, 0.0);
  highp vec4 tmpvar_10;
  tmpvar_10 = tmpvar_9;
  highp float tmpvar_11;
  if ((_skyEnabled > 0.5)) {
    tmpvar_11 = -24.0;
  } else {
    tmpvar_11 = _ZBufferParams.x;
  };
  ejzah4_3 = tmpvar_11;
  highp float tmpvar_12;
  if ((_skyEnabled > 0.5)) {
    tmpvar_12 = 25.0;
  } else {
    tmpvar_12 = _ZBufferParams.y;
  };
  kklng4_2 = tmpvar_12;
  if ((tmpvar_10.w == 0.0)) {
    fincxse_8 = vec4(0.0, 0.0, 0.0, 0.0);
  } else {
    highp float tmuiq2_13;
    tmuiq2_13 = 0.0;
    if ((_IsInForwardRender > 0.0)) {
      lowp vec4 tmpvar_14;
      tmpvar_14 = impl_low_texture2DLodEXT (_depthTexCustom, xlv_TEXCOORD0, 0.0);
      tmuiq2_13 = tmpvar_14.x;
    } else {
      lowp vec4 tmpvar_15;
      tmpvar_15 = impl_low_texture2DLodEXT (_CameraDepthTexture, xlv_TEXCOORD0, 0.0);
      tmuiq2_13 = tmpvar_15.x;
    };
    highp float tmpvar_16;
    tmpvar_16 = (1.0/(((tmpvar_11 * tmuiq2_13) + tmpvar_12)));
    if ((tmpvar_16 > _maxDepthCull)) {
      fincxse_8 = vec4(0.0, 0.0, 0.0, 0.0);
    } else {
      highp vec4 paAccurateColor_17;
      highp vec4 origtmp_18;
      highp int s_19;
      highp vec4 uytrfb4_20;
      highp float vcfggr4_21;
      highp float fghdtge4_22;
      highp int i_33_23;
      bool dlkfeoi_24;
      highp vec4 odpoeir6_25;
      highp float fduer6_26;
      highp int maxCount_29_27;
      highp vec3 mvjidu6_28;
      highp vec3 iydjer_29;
      highp vec3 ofpeod_30;
      highp vec4 nfkjie2_31;
      highp vec4 fjhdrit_32;
      highp vec3 vredju_33;
      highp vec4 qwmjd7_34;
      mftrqw_4 = int(_maxStep);
      qwmjd7_34.w = 1.0;
      qwmjd7_34.xy = ((xlv_TEXCOORD0 * 2.0) - 1.0);
      qwmjd7_34.z = tmuiq2_13;
      highp vec4 tmpvar_35;
      tmpvar_35 = (_ProjectionInv * qwmjd7_34);
      highp vec4 tmpvar_36;
      tmpvar_36 = (tmpvar_35 / tmpvar_35.w);
      vredju_33.xy = qwmjd7_34.xy;
      vredju_33.z = tmuiq2_13;
      fjhdrit_32.w = 0.0;
      fjhdrit_32.xyz = vec3(0.0, 0.0, 0.0);
      if ((_IsInForwardRender > 0.0)) {
        lowp vec4 tmpvar_37;
        tmpvar_37 = impl_low_texture2DLodEXT (_CameraNormalsTexture, xlv_TEXCOORD0, 0.0);
        fjhdrit_32.xyz = ((tmpvar_37.xyz * 2.0) - 1.0);
      } else {
        if ((_IsInLegacyDeffered > 0.0)) {
          lowp vec4 tmpvar_38;
          tmpvar_38 = impl_low_texture2DLodEXT (_CameraDepthNormalsTexture, xlv_TEXCOORD0, 0.0);
          highp vec4 tmpvar_39;
          tmpvar_39 = tmpvar_38;
          highp vec3 n_40;
          highp vec3 tmpvar_41;
          tmpvar_41 = ((tmpvar_39.xyz * vec3(3.5554, 3.5554, 0.0)) + vec3(-1.7777, -1.7777, 1.0));
          highp float tmpvar_42;
          tmpvar_42 = (2.0 / dot (tmpvar_41, tmpvar_41));
          n_40.xy = (tmpvar_42 * tmpvar_41.xy);
          n_40.z = (tmpvar_42 - 1.0);
          highp mat3 tmpvar_43;
          tmpvar_43[0] = _CameraMV[0].xyz;
          tmpvar_43[1] = _CameraMV[1].xyz;
          tmpvar_43[2] = _CameraMV[2].xyz;
          fjhdrit_32.xyz = (tmpvar_43 * n_40);
        } else {
          if ((_FullDeferred > 0.0)) {
            lowp vec4 tmpvar_44;
            tmpvar_44 = texture2D (_CameraGBufferTexture2, xlv_TEXCOORD0);
            fjhdrit_32.xyz = ((tmpvar_44.xyz * 2.0) - 1.0);
          };
        };
      };
      highp vec3 tmpvar_45;
      tmpvar_45 = normalize(tmpvar_36.xyz);
      highp vec3 tmpvar_46;
      tmpvar_46 = normalize((_ViewMatrix * fjhdrit_32).xyz);
      nfkjie2_31.w = 1.0;
      nfkjie2_31.xyz = (tmpvar_36.xyz + normalize((tmpvar_45 - 
        (2.0 * (dot (tmpvar_46, tmpvar_45) * tmpvar_46))
      )));
      highp vec4 tmpvar_47;
      tmpvar_47 = (_ProjMatrix * nfkjie2_31);
      highp vec3 tmpvar_48;
      tmpvar_48 = normalize(((tmpvar_47.xyz / tmpvar_47.w) - vredju_33));
      otrre5_5.z = tmpvar_48.z;
      otrre5_5.xy = (tmpvar_48.xy * 0.5);
      ofpeod_30.xy = xlv_TEXCOORD0;
      ofpeod_30.z = tmuiq2_13;
      utrhfd_7 = 0.0;
      highp float tmpvar_49;
      tmpvar_49 = (2.0 / _ScreenParams.x);
      highp float tmpvar_50;
      tmpvar_50 = sqrt(dot (otrre5_5.xy, otrre5_5.xy));
      highp vec3 tmpvar_51;
      tmpvar_51 = (otrre5_5 * ((tmpvar_49 * _stepGlobalScale) / tmpvar_50));
      iydjer_29 = tmpvar_51;
      maxCount_29_27 = int(_maxStep);
      fduer6_26 = utrhfd_7;
      dlkfeoi_24 = bool(0);
      mvjidu6_28 = (ofpeod_30 + tmpvar_51);
      i_33_23 = 0;
      s_19 = 0;
      while (true) {
        if ((s_19 >= 120)) {
          break;
        };
        if ((i_33_23 >= maxCount_29_27)) {
          break;
        };
        if ((_IsInForwardRender > 0.0)) {
          lowp vec4 tmpvar_52;
          tmpvar_52 = impl_low_texture2DLodEXT (_depthTexCustom, mvjidu6_28.xy, 0.0);
          fghdtge4_22 = (1.0/(((ejzah4_3 * tmpvar_52.x) + kklng4_2)));
        } else {
          lowp vec4 tmpvar_53;
          tmpvar_53 = impl_low_texture2DLodEXT (_CameraDepthTexture, mvjidu6_28.xy, 0.0);
          fghdtge4_22 = (1.0/(((ejzah4_3 * tmpvar_53.x) + kklng4_2)));
        };
        vcfggr4_21 = (1.0/(((ejzah4_3 * mvjidu6_28.z) + kklng4_2)));
        if ((fghdtge4_22 < (vcfggr4_21 - 1e-06))) {
          uytrfb4_20.w = 1.0;
          uytrfb4_20.xyz = mvjidu6_28;
          odpoeir6_25 = uytrfb4_20;
          dlkfeoi_24 = bool(1);
          break;
        };
        mvjidu6_28 = (mvjidu6_28 + iydjer_29);
        fduer6_26 += 1.0;
        i_33_23++;
        s_19++;
      };
      if ((dlkfeoi_24 == bool(0))) {
        highp vec4 eoiejd4_54;
        eoiejd4_54.w = 0.0;
        eoiejd4_54.xyz = mvjidu6_28;
        odpoeir6_25 = eoiejd4_54;
        dlkfeoi_24 = bool(1);
      };
      utrhfd_7 = fduer6_26;
      rehj5_6 = odpoeir6_25;
      highp float tmpvar_55;
      tmpvar_55 = abs((odpoeir6_25.x - 0.5));
      origtmp_18 = tmpvar_10;
      if ((_FlipReflectionsMSAA > 0.0)) {
        highp vec2 tmpouv_56;
        tmpouv_56.x = xlv_TEXCOORD0.x;
        tmpouv_56.y = (1.0 - xlv_TEXCOORD0.y);
        highp vec4 tmpvar_57;
        lowp vec4 tmpvar_58;
        tmpvar_58 = impl_low_texture2DLodEXT (_MainTex, tmpouv_56, 0.0);
        tmpvar_57 = tmpvar_58;
        origtmp_18 = tmpvar_57;
      };
      paAccurateColor_17 = vec4(0.0, 0.0, 0.0, 0.0);
      if ((_SSRRcomposeMode > 0.0)) {
        highp vec4 tmpvar_59;
        tmpvar_59.w = 0.0;
        tmpvar_59.xyz = origtmp_18.xyz;
        paAccurateColor_17 = tmpvar_59;
      };
      if ((tmpvar_55 > 0.5)) {
        fincxse_8 = paAccurateColor_17;
      } else {
        highp float tmpvar_60;
        tmpvar_60 = abs((odpoeir6_25.y - 0.5));
        if ((tmpvar_60 > 0.5)) {
          fincxse_8 = paAccurateColor_17;
        } else {
          if ((((1.0/(
            ((_ZBufferParams.x * odpoeir6_25.z) + _ZBufferParams.y)
          )) > _maxDepthCull) && (_skyEnabled < 0.5))) {
            fincxse_8 = paAccurateColor_17;
          } else {
            if ((odpoeir6_25.z < 0.1)) {
              fincxse_8 = paAccurateColor_17;
            } else {
              if ((odpoeir6_25.w == 1.0)) {
                highp int j_61;
                highp vec3 tyukhg_62;
                highp vec4 djkflrq_63;
                highp float cbjdhet_64;
                highp float kjdkues5_65;
                highp vec3 oldPos_50_66;
                highp int i_49_67;
                bool dflskte_68;
                highp vec4 iuwejd_69;
                highp int maxCount_45_70;
                highp vec3 oldksd7_71;
                highp vec3 samdpo9_72;
                highp vec3 tmpvar_73;
                tmpvar_73 = (odpoeir6_25.xyz - tmpvar_51);
                highp vec3 tmpvar_74;
                tmpvar_74 = (otrre5_5 * (tmpvar_49 / tmpvar_50));
                oldksd7_71 = tmpvar_74;
                maxCount_45_70 = int(_maxFineStep);
                dflskte_68 = bool(0);
                oldPos_50_66 = tmpvar_73;
                samdpo9_72 = (tmpvar_73 + tmpvar_74);
                i_49_67 = 0;
                j_61 = 0;
                while (true) {
                  if ((j_61 >= 40)) {
                    break;
                  };
                  if ((i_49_67 >= maxCount_45_70)) {
                    break;
                  };
                  if ((_IsInForwardRender > 0.0)) {
                    lowp vec4 tmpvar_75;
                    tmpvar_75 = impl_low_texture2DLodEXT (_depthTexCustom, samdpo9_72.xy, 0.0);
                    kjdkues5_65 = (1.0/(((ejzah4_3 * tmpvar_75.x) + kklng4_2)));
                  } else {
                    lowp vec4 tmpvar_76;
                    tmpvar_76 = impl_low_texture2DLodEXT (_CameraDepthTexture, samdpo9_72.xy, 0.0);
                    kjdkues5_65 = (1.0/(((ejzah4_3 * tmpvar_76.x) + kklng4_2)));
                  };
                  cbjdhet_64 = (1.0/(((ejzah4_3 * samdpo9_72.z) + kklng4_2)));
                  if ((kjdkues5_65 < cbjdhet_64)) {
                    if (((cbjdhet_64 - kjdkues5_65) < _bias)) {
                      djkflrq_63.w = 1.0;
                      djkflrq_63.xyz = samdpo9_72;
                      iuwejd_69 = djkflrq_63;
                      dflskte_68 = bool(1);
                      break;
                    };
                    tyukhg_62 = (oldksd7_71 * 0.5);
                    oldksd7_71 = tyukhg_62;
                    samdpo9_72 = (oldPos_50_66 + tyukhg_62);
                  } else {
                    oldPos_50_66 = samdpo9_72;
                    samdpo9_72 = (samdpo9_72 + oldksd7_71);
                  };
                  i_49_67++;
                  j_61++;
                };
                if ((dflskte_68 == bool(0))) {
                  highp vec4 oeisadw_77;
                  oeisadw_77.w = 0.0;
                  oeisadw_77.xyz = samdpo9_72;
                  iuwejd_69 = oeisadw_77;
                  dflskte_68 = bool(1);
                };
                rehj5_6 = iuwejd_69;
              };
              if ((rehj5_6.w < 0.01)) {
                fincxse_8 = paAccurateColor_17;
              } else {
                highp vec4 gresdf_78;
                if ((_FlipReflectionsMSAA > 0.0)) {
                  rehj5_6.y = (1.0 - rehj5_6.y);
                };
                lowp vec4 tmpvar_79;
                tmpvar_79 = impl_low_texture2DLodEXT (_MainTex, rehj5_6.xy, 0.0);
                gresdf_78.xyz = tmpvar_79.xyz;
                gresdf_78.w = (pow ((1.0 - 
                  (fduer6_26 / float(mftrqw_4))
                ), _fadePower) * 1.06);
                fincxse_8 = gresdf_78;
              };
            };
          };
        };
      };
    };
  };
  tmpvar_1 = fincxse_8;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
"!!GLES3
#ifdef VERTEX
#version 300 es
precision highp float;
precision highp int;
uniform 	vec4 _Time;
uniform 	vec4 _SinTime;
uniform 	vec4 _CosTime;
uniform 	vec4 unity_DeltaTime;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ScreenParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 unity_CameraWorldClipPlanes[6];
uniform 	mat4 unity_CameraProjection;
uniform 	mat4 unity_CameraInvProjection;
uniform 	vec4 _WorldSpaceLightPos0;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_4LightPosX0;
uniform 	vec4 unity_4LightPosY0;
uniform 	vec4 unity_4LightPosZ0;
uniform 	mediump vec4 unity_4LightAtten0;
uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	mediump vec4 unity_LightAtten[8];
uniform 	vec4 unity_SpotDirection[8];
uniform 	mediump vec4 unity_SHAr;
uniform 	mediump vec4 unity_SHAg;
uniform 	mediump vec4 unity_SHAb;
uniform 	mediump vec4 unity_SHBr;
uniform 	mediump vec4 unity_SHBg;
uniform 	mediump vec4 unity_SHBb;
uniform 	mediump vec4 unity_SHC;
uniform 	mediump vec3 unity_LightColor0;
uniform 	mediump vec3 unity_LightColor1;
uniform 	mediump vec3 unity_LightColor2;
uniform 	mediump vec3 unity_LightColor3;
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	mat4 unity_World2Shadow[4];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	mat4 glstate_matrix_mvp;
uniform 	mat4 glstate_matrix_modelview0;
uniform 	mat4 glstate_matrix_invtrans_modelview0;
uniform 	mat4 _Object2World;
uniform 	mat4 _World2Object;
uniform 	vec4 unity_LODFade;
uniform 	mat4 glstate_matrix_transpose_modelview0;
uniform 	mat4 glstate_matrix_projection;
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mat4 unity_MatrixV;
uniform 	mat4 unity_MatrixVP;
uniform 	lowp vec4 unity_AmbientSky;
uniform 	lowp vec4 unity_AmbientEquator;
uniform 	lowp vec4 unity_AmbientGround;
uniform 	lowp vec4 unity_FogColor;
uniform 	vec4 unity_FogParams;
uniform 	vec4 unity_LightmapST;
uniform 	vec4 unity_DynamicLightmapST;
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	vec4 unity_SpecCube0_ProbePosition;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_BoxMax;
uniform 	vec4 unity_SpecCube1_BoxMin;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform 	mediump vec4 unity_SpecCube1_HDR;
uniform 	lowp vec4 unity_ColorSpaceGrey;
uniform 	lowp vec4 unity_ColorSpaceDouble;
uniform 	mediump vec4 unity_ColorSpaceDielectricSpec;
uniform 	mediump vec4 unity_ColorSpaceLuminance;
uniform 	mediump vec4 unity_Lightmap_HDR;
uniform 	mediump vec4 unity_DynamicLightmap_HDR;
uniform 	float _fadePower;
uniform 	float _maxDepthCull;
uniform 	float _maxFineStep;
uniform 	float _maxStep;
uniform 	float _stepGlobalScale;
uniform 	float _bias;
uniform 	mat4 _ProjMatrix;
uniform 	mat4 _ProjectionInv;
uniform 	mat4 _ViewMatrix;
uniform 	vec4 _ProjInfo;
uniform 	float _SSRRcomposeMode;
uniform 	float _FlipReflectionsMSAA;
uniform 	float _skyEnabled;
uniform 	vec4 _MainTex_TexelSize;
uniform 	float _IsInForwardRender;
uniform 	float _IsInLegacyDeffered;
uniform 	float _FullDeferred;
uniform 	mat4 _CameraMV;
in highp vec4 in_POSITION0;
in mediump vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
highp vec4 t0;
void main()
{
    //Instruction 458
    //MUL
    t0 = in_POSITION0.yyyy * glstate_matrix_mvp[1];
    //Instruction 459
    //MAD
    t0 = glstate_matrix_mvp[0] * in_POSITION0.xxxx + t0;
    //Instruction 460
    //MAD
    t0 = glstate_matrix_mvp[2] * in_POSITION0.zzzz + t0;
    //Instruction 461
    //MAD
    gl_Position = glstate_matrix_mvp[3] * in_POSITION0.wwww + t0;
    //Instruction 462
    //MOV
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    //Instruction 463
    //RET
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es
precision highp float;
precision highp int;
uniform 	vec4 _Time;
uniform 	vec4 _SinTime;
uniform 	vec4 _CosTime;
uniform 	vec4 unity_DeltaTime;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ScreenParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 unity_CameraWorldClipPlanes[6];
uniform 	mat4 unity_CameraProjection;
uniform 	mat4 unity_CameraInvProjection;
uniform 	vec4 _WorldSpaceLightPos0;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_4LightPosX0;
uniform 	vec4 unity_4LightPosY0;
uniform 	vec4 unity_4LightPosZ0;
uniform 	mediump vec4 unity_4LightAtten0;
uniform 	mediump vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	mediump vec4 unity_LightAtten[8];
uniform 	vec4 unity_SpotDirection[8];
uniform 	mediump vec4 unity_SHAr;
uniform 	mediump vec4 unity_SHAg;
uniform 	mediump vec4 unity_SHAb;
uniform 	mediump vec4 unity_SHBr;
uniform 	mediump vec4 unity_SHBg;
uniform 	mediump vec4 unity_SHBb;
uniform 	mediump vec4 unity_SHC;
uniform 	mediump vec3 unity_LightColor0;
uniform 	mediump vec3 unity_LightColor1;
uniform 	mediump vec3 unity_LightColor2;
uniform 	mediump vec3 unity_LightColor3;
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	mat4 unity_World2Shadow[4];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	mat4 glstate_matrix_mvp;
uniform 	mat4 glstate_matrix_modelview0;
uniform 	mat4 glstate_matrix_invtrans_modelview0;
uniform 	mat4 _Object2World;
uniform 	mat4 _World2Object;
uniform 	vec4 unity_LODFade;
uniform 	mat4 glstate_matrix_transpose_modelview0;
uniform 	mat4 glstate_matrix_projection;
uniform 	lowp vec4 glstate_lightmodel_ambient;
uniform 	mat4 unity_MatrixV;
uniform 	mat4 unity_MatrixVP;
uniform 	lowp vec4 unity_AmbientSky;
uniform 	lowp vec4 unity_AmbientEquator;
uniform 	lowp vec4 unity_AmbientGround;
uniform 	lowp vec4 unity_FogColor;
uniform 	vec4 unity_FogParams;
uniform 	vec4 unity_LightmapST;
uniform 	vec4 unity_DynamicLightmapST;
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	vec4 unity_SpecCube0_ProbePosition;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_BoxMax;
uniform 	vec4 unity_SpecCube1_BoxMin;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform 	mediump vec4 unity_SpecCube1_HDR;
uniform 	lowp vec4 unity_ColorSpaceGrey;
uniform 	lowp vec4 unity_ColorSpaceDouble;
uniform 	mediump vec4 unity_ColorSpaceDielectricSpec;
uniform 	mediump vec4 unity_ColorSpaceLuminance;
uniform 	mediump vec4 unity_Lightmap_HDR;
uniform 	mediump vec4 unity_DynamicLightmap_HDR;
uniform 	float _fadePower;
uniform 	float _maxDepthCull;
uniform 	float _maxFineStep;
uniform 	float _maxStep;
uniform 	float _stepGlobalScale;
uniform 	float _bias;
uniform 	mat4 _ProjMatrix;
uniform 	mat4 _ProjectionInv;
uniform 	mat4 _ViewMatrix;
uniform 	vec4 _ProjInfo;
uniform 	float _SSRRcomposeMode;
uniform 	float _FlipReflectionsMSAA;
uniform 	float _skyEnabled;
uniform 	vec4 _MainTex_TexelSize;
uniform 	float _IsInForwardRender;
uniform 	float _IsInLegacyDeffered;
uniform 	float _FullDeferred;
uniform 	mat4 _CameraMV;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _depthTexCustom;
uniform lowp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2D _CameraDepthNormalsTexture;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
highp vec4 t0;
highp int ti0;
bool tb0;
highp vec4 t1;
highp vec2 t2;
highp vec4 t3;
highp vec4 t4;
highp vec4 t5;
lowp vec3 t10_5;
highp vec4 t6;
mediump vec3 t16_6;
lowp vec3 t10_6;
highp vec4 t7;
highp vec3 t8;
lowp float t10_8;
bool tb8;
highp vec3 t9;
highp vec3 t10;
bool tb11;
bvec2 tb14;
highp vec3 t17;
highp vec3 t18;
highp float t19;
lowp float t10_19;
highp vec2 t24;
mediump float t16_24;
bool tb24;
bool tb33;
highp float t35;
highp int ti35;
highp float t36;
highp int ti37;
highp int ti38;
highp float t39;
lowp float t10_39;
bool tb39;
highp float t41;
lowp float t10_41;
bool tb42;
void main()
{
    //Instruction 232
    //SAMPLE_L
    t0 = textureLod(_MainTex, vs_TEXCOORD0.xy, 0.0);
    //Instruction 233
    //EQ
    tb33 = t0.w==0.0;
    //Instruction 234
    //IF
    if(tb33){
        //Instruction 235
        //MOV
        t1 = vec4(0.0, 0.0, 0.0, 0.0);
        //Instruction 236
    //ELSE
    } else {
        //Instruction 237
        //LT
        tb33 = 0.5<_skyEnabled;
        //Instruction 238
        //MOVC
        t2.xy = (bool(tb33)) ? vec2(-24.0, 25.0) : _ZBufferParams.xy;
        //Instruction 239
        //LT
        tb33 = 0.0<_IsInForwardRender;
        //Instruction 240
        //IF
        if(tb33){
            //Instruction 241
            //SAMPLE_L
            t3.z = textureLod(_depthTexCustom, vs_TEXCOORD0.xy, 0.0).x;
            //Instruction 242
        //ELSE
        } else {
            //Instruction 243
            //SAMPLE_L
            t3.z = textureLod(_CameraDepthTexture, vs_TEXCOORD0.xy, 0.0).x;
            //Instruction 244
        //ENDIF
        }
        //Instruction 245
        //MAD
        t24.x = t2.x * t3.z + t2.y;
        //Instruction 246
        //DIV
        t24.x = float(1.0) / t24.x;
        //Instruction 247
        //LT
        tb24 = _maxDepthCull<t24.x;
        //Instruction 248
        //IF
        if(tb24){
            //Instruction 249
            //MOV
            t1 = vec4(0.0, 0.0, 0.0, 0.0);
            //Instruction 250
        //ELSE
        } else {
            //Instruction 251
            //MAD
            t24.xy = vs_TEXCOORD0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
            //Instruction 252
            //MUL
            t4 = t24.yyyy * _ProjectionInv[1];
            //Instruction 253
            //MAD
            t4 = _ProjectionInv[0] * t24.xxxx + t4;
            //Instruction 254
            //MAD
            t4 = _ProjectionInv[2] * t3.zzzz + t4;
            //Instruction 255
            //ADD
            t4 = t4 + _ProjectionInv[3];
            //Instruction 256
            //DIV
            t4.xyz = t4.xyz / t4.www;
            //Instruction 257
            //IF
            if(tb33){
                //Instruction 258
                //SAMPLE_L
                t10_5.xyz = textureLod(_CameraNormalsTexture, vs_TEXCOORD0.xy, 0.0).xyz;
                //Instruction 259
                //MAD
                t5.xyz = t10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
                //Instruction 260
            //ELSE
            } else {
                //Instruction 261
                //LT
                tb24 = 0.0<_IsInLegacyDeffered;
                //Instruction 262
                //IF
                if(tb24){
                    //Instruction 263
                    //SAMPLE_L
                    t10_6.xyz = textureLod(_CameraDepthNormalsTexture, vs_TEXCOORD0.xy, 0.0).xyz;
                    //Instruction 264
                    //MAD
                    t16_6.xyz = t10_6.xyz * vec3(3.55539989, 3.55539989, 0.0) + vec3(-1.77769995, -1.77769995, 1.0);
                    //Instruction 265
                    //DP3
                    t16_24 = dot(t16_6.xyz, t16_6.xyz);
                    //Instruction 266
                    //DIV
                    t16_24 = 2.0 / t16_24;
                    //Instruction 267
                    //MUL
                    t16_6.xy = t16_6.xy * vec2(t16_24);
                    //Instruction 268
                    //ADD
                    t16_24 = t16_24 + -1.0;
                    //Instruction 269
                    //MUL
                    t17.xyz = t16_6.yyy * _CameraMV[1].xyz;
                    //Instruction 270
                    //MAD
                    t6.xyz = _CameraMV[0].xyz * t16_6.xxx + t17.xyz;
                    //Instruction 271
                    //MAD
                    t5.xyz = _CameraMV[2].xyz * vec3(t16_24) + t6.xyz;
                    //Instruction 272
                //ELSE
                } else {
                    //Instruction 273
                    //LT
                    tb24 = 0.0<_FullDeferred;
                    //Instruction 274
                    //IF
                    if(tb24){
                        //Instruction 275
                        //SAMPLE
                        t10_6.xyz = texture(_CameraGBufferTexture2, vs_TEXCOORD0.xy).xyz;
                        //Instruction 276
                        //MAD
                        t5.xyz = t10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
                        //Instruction 277
                    //ELSE
                    } else {
                        //Instruction 278
                        //MOV
                        t5.xyz = vec3(0.0, 0.0, 0.0);
                        //Instruction 279
                    //ENDIF
                    }
                    //Instruction 280
                //ENDIF
                }
                //Instruction 281
            //ENDIF
            }
            //Instruction 282
            //DP3
            t24.x = dot(t4.xyz, t4.xyz);
            //Instruction 283
            //RSQ
            t24.x = inversesqrt(t24.x);
            //Instruction 284
            //MUL
            t6.xyz = t24.xxx * t4.xyz;
            //Instruction 285
            //MUL
            t7.xyz = t5.yyy * _ViewMatrix[1].xyz;
            //Instruction 286
            //MAD
            t5.xyw = _ViewMatrix[0].xyz * t5.xxx + t7.xyz;
            //Instruction 287
            //MAD
            t5.xyz = _ViewMatrix[2].xyz * t5.zzz + t5.xyw;
            //Instruction 288
            //DP3
            t24.x = dot(t5.xyz, t5.xyz);
            //Instruction 289
            //RSQ
            t24.x = inversesqrt(t24.x);
            //Instruction 290
            //MUL
            t5.xyz = t24.xxx * t5.xyz;
            //Instruction 291
            //DP3
            t24.x = dot(t5.xyz, t6.xyz);
            //Instruction 292
            //MUL
            t5.xyz = t5.xyz * t24.xxx;
            //Instruction 293
            //MAD
            t5.xyz = (-t5.xyz) * vec3(2.0, 2.0, 2.0) + t6.xyz;
            //Instruction 294
            //DP3
            t24.x = dot(t5.xyz, t5.xyz);
            //Instruction 295
            //RSQ
            t24.x = inversesqrt(t24.x);
            //Instruction 296
            //MAD
            t4.xyz = t5.xyz * t24.xxx + t4.xyz;
            //Instruction 297
            //MUL
            t5 = t4.yyyy * _ProjMatrix[1];
            //Instruction 298
            //MAD
            t5 = _ProjMatrix[0] * t4.xxxx + t5;
            //Instruction 299
            //MAD
            t4 = _ProjMatrix[2] * t4.zzzz + t5;
            //Instruction 300
            //ADD
            t4 = t4 + _ProjMatrix[3];
            //Instruction 301
            //DIV
            t4.xyz = t4.xyz / t4.www;
            //Instruction 302
            //MAD
            t3.xy = vs_TEXCOORD0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
            //Instruction 303
            //ADD
            t4.xyz = (-t3.xyz) + t4.xyz;
            //Instruction 304
            //DP3
            t24.x = dot(t4.xyz, t4.xyz);
            //Instruction 305
            //RSQ
            t24.x = inversesqrt(t24.x);
            //Instruction 306
            //MUL
            t4.xyz = t24.xxx * t4.xyz;
            //Instruction 307
            //MUL
            t24.xy = t4.xy * vec2(0.5, 0.5);
            //Instruction 308
            //DIV
            t36 = 2.0 / _ScreenParams.x;
            //Instruction 309
            //DP2
            t24.x = dot(t24.xy, t24.xy);
            //Instruction 310
            //SQRT
            t24.x = sqrt(t24.x);
            //Instruction 311
            //MUL
            t35 = t36 * _stepGlobalScale;
            //Instruction 312
            //DIV
            t35 = t35 / t24.x;
            //Instruction 313
            //MUL
            t4.xyz = t4.xyz * vec3(0.5, 0.5, 1.0);
            //Instruction 314
            //FTOI
            ti37 = int(_maxStep);
            //Instruction 315
            //MOV
            t3.xy = vs_TEXCOORD0.xy;
            //Instruction 316
            //MAD
            t3.xyz = t4.xyz * vec3(t35) + t3.xyz;
            //Instruction 317
            //MOV
            t5.w = 1.0;
            //Instruction 318
            //MOV
            t6 = vec4(0.0, 0.0, 0.0, 0.0);
            //Instruction 319
            //MOV
            t5.xyz = t3.xyz;
            //Instruction 320
            //MOV
            t7 = vec4(0.0, 0.0, 0.0, 0.0);
            //Instruction 321
            //LOOP
            while(true){
                //Instruction 322
                //IGE
                tb8 = floatBitsToInt(t7).w>=0x78;
                //Instruction 323
                //BREAKC
                if(tb8){break;}
                //Instruction 324
                //IGE
                tb8 = floatBitsToInt(t7).z>=ti37;
                //Instruction 325
                //IF
                if(tb8){
                    //Instruction 326
                    //BREAK
                    break;
                    //Instruction 327
                //ENDIF
                }
                //Instruction 328
                //IF
                if(tb33){
                    //Instruction 329
                    //SAMPLE_L
                    t10_8 = textureLod(_depthTexCustom, t5.xy, 0.0).x;
                    //Instruction 330
                    //MAD
                    t8.x = t2.x * t10_8 + t2.y;
                    //Instruction 331
                    //DIV
                    t8.x = float(1.0) / t8.x;
                    //Instruction 332
                //ELSE
                } else {
                    //Instruction 333
                    //SAMPLE_L
                    t10_19 = textureLod(_CameraDepthTexture, t5.xy, 0.0).x;
                    //Instruction 334
                    //MAD
                    t19 = t2.x * t10_19 + t2.y;
                    //Instruction 335
                    //DIV
                    t8.x = float(1.0) / t19;
                    //Instruction 336
                //ENDIF
                }
                //Instruction 337
                //MAD
                t19 = t2.x * t5.z + t2.y;
                //Instruction 338
                //DIV
                t19 = float(1.0) / t19;
                //Instruction 339
                //ADD
                t19 = t19 + -9.99999997e-007;
                //Instruction 340
                //LT
                tb8 = t8.x<t19;
                //Instruction 341
                //IF
                if(tb8){
                    //Instruction 342
                    //MOV
                    t6 = t5;
                    //Instruction 343
                    //MOV
                    t7.y = intBitsToFloat(int(0xFFFFFFFFu));
                    //Instruction 344
                    //BREAK
                    break;
                    //Instruction 345
                //ENDIF
                }
                //Instruction 346
                //MAD
                t5.xyz = t4.xyz * vec3(t35) + t5.xyz;
                //Instruction 347
                //ADD
                t7.x = t7.x + 1.0;
                //Instruction 348
                //IADD
                t7.z = intBitsToFloat(floatBitsToInt(t7).z + 0x1);
                //Instruction 349
                //IADD
                t7.w = intBitsToFloat(floatBitsToInt(t7).w + 0x1);
                //Instruction 350
                //MOV
                t6 = vec4(0.0, 0.0, 0.0, 0.0);
                //Instruction 351
                //MOV
                t7.y = 0.0;
                //Instruction 352
            //ENDLOOP
            }
            //Instruction 353
            //MOV
            t5.w = 0.0;
            //Instruction 354
            //MOVC
            t5 = (floatBitsToInt(t7).y != 0) ? t6 : t5;
            //Instruction 355
            //ADD
            t3.x = t5.x + -0.5;
            //Instruction 356
            //LT
            tb14.xy = lessThan(vec4(0.0, 0.0, 0.0, 0.0), vec4(_FlipReflectionsMSAA, _SSRRcomposeMode, _FlipReflectionsMSAA, _FlipReflectionsMSAA)).xy;
            //Instruction 357
            //IF
            if(tb14.x){
                //Instruction 358
                //MAD
                t6.xy = vs_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
                //Instruction 359
                //SAMPLE_L
                t0.xyz = textureLod(_MainTex, t6.xy, 0.0).xyz;
                //Instruction 360
            //ENDIF
            }
            //Instruction 361
            //AND
            t1.xyz = mix(vec3(0.0, 0.0, 0.0), t0.xyz, tb14.yyy);
            //Instruction 362
            //MOV
            t1.w = 0.0;
            //Instruction 363
            //LT
            tb0 = 0.5<abs(t3.x);
            //Instruction 364
            //IF
            if(!tb0){
                //Instruction 365
                //ADD
                t0.x = t5.y + -0.5;
                //Instruction 366
                //LT
                tb0 = 0.5<abs(t0.x);
                //Instruction 367
                //IF
                if(!tb0){
                    //Instruction 368
                    //MAD
                    t0.x = _ZBufferParams.x * t5.z + _ZBufferParams.y;
                    //Instruction 369
                    //DIV
                    t0.x = float(1.0) / t0.x;
                    //Instruction 370
                    //LT
                    tb0 = _maxDepthCull<t0.x;
                    //Instruction 371
                    //LT
                    tb11 = _skyEnabled<0.5;
                    //Instruction 372
                    //AND
                    ti0 = int(uint(tb11) * 0xffffffffu & uint(tb0) * 0xffffffffu);
                    //Instruction 373
                    //IF
                    if((uint(ti0))==uint(0u)){
                        //Instruction 374
                        //LT
                        tb0 = t5.z<0.100000001;
                        //Instruction 375
                        //IF
                        if(!tb0){
                            //Instruction 376
                            //EQ
                            tb0 = t5.w==1.0;
                            //Instruction 377
                            //IF
                            if(tb0){
                                //Instruction 378
                                //MAD
                                t0.xyz = (-t4.xyz) * vec3(t35) + t5.xyz;
                                //Instruction 379
                                //DIV
                                t24.x = t36 / t24.x;
                                //Instruction 380
                                //MUL
                                t3.xzw = t24.xxx * t4.xyz;
                                //Instruction 381
                                //FTOI
                                ti35 = int(_maxFineStep);
                                //Instruction 382
                                //MAD
                                t4.xyz = t4.xyz * t24.xxx + t0.xyz;
                                //Instruction 383
                                //MOV
                                t6.z = 1.0;
                                //Instruction 384
                                //MOV
                                t18.xyz = t3.xzw;
                                //Instruction 385
                                //MOV
                                t8.xyz = vec3(0.0, 0.0, 0.0);
                                //Instruction 386
                                //MOV
                                t9.xyz = t0.xyz;
                                //Instruction 387
                                //MOV
                                t10.xyz = t4.xyz;
                                //Instruction 388
                                //MOV
                                tb24 = false;
                                //Instruction 389
                                //MOV
                                ti37 = 0x0;
                                //Instruction 390
                                //MOV
                                ti38 = 0x0;
                                //Instruction 391
                                //LOOP
                                while(true){
                                    //Instruction 392
                                    //IGE
                                    tb39 = ti38>=0x28;
                                    //Instruction 393
                                    //BREAKC
                                    if(tb39){break;}
                                    //Instruction 394
                                    //IGE
                                    tb39 = ti37>=ti35;
                                    //Instruction 395
                                    //IF
                                    if(tb39){
                                        //Instruction 396
                                        //BREAK
                                        break;
                                        //Instruction 397
                                    //ENDIF
                                    }
                                    //Instruction 398
                                    //IF
                                    if(tb33){
                                        //Instruction 399
                                        //SAMPLE_L
                                        t10_39 = textureLod(_depthTexCustom, t10.xy, 0.0).x;
                                        //Instruction 400
                                        //MAD
                                        t39 = t2.x * t10_39 + t2.y;
                                        //Instruction 401
                                        //DIV
                                        t39 = float(1.0) / t39;
                                        //Instruction 402
                                    //ELSE
                                    } else {
                                        //Instruction 403
                                        //SAMPLE_L
                                        t10_41 = textureLod(_CameraDepthTexture, t10.xy, 0.0).x;
                                        //Instruction 404
                                        //MAD
                                        t41 = t2.x * t10_41 + t2.y;
                                        //Instruction 405
                                        //DIV
                                        t39 = float(1.0) / t41;
                                        //Instruction 406
                                    //ENDIF
                                    }
                                    //Instruction 407
                                    //MAD
                                    t41 = t2.x * t10.z + t2.y;
                                    //Instruction 408
                                    //DIV
                                    t41 = float(1.0) / t41;
                                    //Instruction 409
                                    //LT
                                    tb42 = t39<t41;
                                    //Instruction 410
                                    //IF
                                    if(tb42){
                                        //Instruction 411
                                        //ADD
                                        t39 = (-t39) + t41;
                                        //Instruction 412
                                        //LT
                                        tb39 = t39<_bias;
                                        //Instruction 413
                                        //IF
                                        if(tb39){
                                            //Instruction 414
                                            //MOV
                                            t6.xy = t10.xy;
                                            //Instruction 415
                                            //MOV
                                            t8.xyz = t6.xyz;
                                            //Instruction 416
                                            //MOV
                                            tb24 = true;
                                            //Instruction 417
                                            //BREAK
                                            break;
                                            //Instruction 418
                                        //ENDIF
                                        }
                                        //Instruction 419
                                        //MUL
                                        t6.xyw = t18.xyz * vec3(0.5, 0.5, 0.5);
                                        //Instruction 420
                                        //MAD
                                        t10.xyz = t18.xyz * vec3(0.5, 0.5, 0.5) + t9.xyz;
                                        //Instruction 421
                                        //MOV
                                        t18.xyz = t6.xyw;
                                        //Instruction 422
                                    //ELSE
                                    } else {
                                        //Instruction 423
                                        //ADD
                                        t6.xyw = t18.xyz + t10.xyz;
                                        //Instruction 424
                                        //MOV
                                        t9.xyz = t10.xyz;
                                        //Instruction 425
                                        //MOV
                                        t10.xyz = t6.xyw;
                                        //Instruction 426
                                    //ENDIF
                                    }
                                    //Instruction 427
                                    //IADD
                                    ti37 = ti37 + 0x1;
                                    //Instruction 428
                                    //IADD
                                    ti38 = ti38 + 0x1;
                                    //Instruction 429
                                    //MOV
                                    t8.xyz = vec3(0.0, 0.0, 0.0);
                                    //Instruction 430
                                    //MOV
                                    tb24 = false;
                                    //Instruction 431
                                //ENDLOOP
                                }
                                //Instruction 432
                                //MOV
                                t10.z = 0.0;
                                //Instruction 433
                                //MOVC
                                t5.xyz = (bool(tb24)) ? t8.xyz : t10.xyz;
                                //Instruction 434
                            //ELSE
                            } else {
                                //Instruction 435
                                //MOV
                                t5.z = 0.0;
                                //Instruction 436
                            //ENDIF
                            }
                            //Instruction 437
                            //LT
                            tb0 = t5.z<0.00999999978;
                            //Instruction 438
                            //IF
                            if(!tb0){
                                //Instruction 439
                                //ADD
                                t0.x = (-t5.y) + 1.0;
                                //Instruction 440
                                //MOVC
                                t5.y = (tb14.x) ? t0.x : t5.y;
                                //Instruction 441
                                //SAMPLE_L
                                t1.xyz = textureLod(_MainTex, t5.xy, 0.0).xyz;
                                //Instruction 442
                                //ROUND_Z
                                t0.x = trunc(_maxStep);
                                //Instruction 443
                                //DIV
                                t0.x = t7.x / t0.x;
                                //Instruction 444
                                //ADD
                                t0.x = (-t0.x) + 1.0;
                                //Instruction 445
                                //LOG
                                t0.x = log2(t0.x);
                                //Instruction 446
                                //MUL
                                t0.x = t0.x * _fadePower;
                                //Instruction 447
                                //EXP
                                t0.x = exp2(t0.x);
                                //Instruction 448
                                //MUL
                                t1.w = t0.x * 1.05999994;
                                //Instruction 449
                            //ENDIF
                            }
                            //Instruction 450
                        //ENDIF
                        }
                        //Instruction 451
                    //ENDIF
                    }
                    //Instruction 452
                //ENDIF
                }
                //Instruction 453
            //ENDIF
            }
            //Instruction 454
        //ENDIF
        }
        //Instruction 455
    //ENDIF
    }
    //Instruction 456
    //MOV
    SV_Target0 = t1;
    //Instruction 457
    //RET
    return;
}

#endif
"
}
SubProgram "metal " {
// Stats: 1 math
Bind "vertex" ATTR0
Bind "texcoord" ATTR1
ConstBuffer "$Globals" 64
Matrix 0 [glstate_matrix_mvp]
"metal_vs
#include <metal_stdlib>
using namespace metal;
struct xlatMtlShaderInput {
  float4 _glesVertex [[attribute(0)]];
  float4 _glesMultiTexCoord0 [[attribute(1)]];
};
struct xlatMtlShaderOutput {
  float4 gl_Position [[position]];
  float2 xlv_TEXCOORD0;
};
struct xlatMtlShaderUniform {
  float4x4 glstate_matrix_mvp;
};
vertex xlatMtlShaderOutput xlatMtlMain (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(0)]])
{
  xlatMtlShaderOutput _mtl_o;
  half2 tmpvar_1;
  tmpvar_1 = half2(_mtl_i._glesMultiTexCoord0.xy);
  float2 tmpvar_2;
  tmpvar_2 = float2(tmpvar_1);
  _mtl_o.gl_Position = (_mtl_u.glstate_matrix_mvp * _mtl_i._glesVertex);
  _mtl_o.xlv_TEXCOORD0 = tmpvar_2;
  return _mtl_o;
}

"
}
SubProgram "glcore " {
"!!GL2x
#ifdef VERTEX
#version 150
#extension GL_ARB_shader_bit_encoding : require
uniform 	vec4 _Time;
uniform 	vec4 _SinTime;
uniform 	vec4 _CosTime;
uniform 	vec4 unity_DeltaTime;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ScreenParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 unity_CameraWorldClipPlanes[6];
uniform 	mat4 unity_CameraProjection;
uniform 	mat4 unity_CameraInvProjection;
uniform 	vec4 _WorldSpaceLightPos0;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_4LightPosX0;
uniform 	vec4 unity_4LightPosY0;
uniform 	vec4 unity_4LightPosZ0;
uniform 	vec4 unity_4LightAtten0;
uniform 	vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	vec4 unity_LightAtten[8];
uniform 	vec4 unity_SpotDirection[8];
uniform 	vec4 unity_SHAr;
uniform 	vec4 unity_SHAg;
uniform 	vec4 unity_SHAb;
uniform 	vec4 unity_SHBr;
uniform 	vec4 unity_SHBg;
uniform 	vec4 unity_SHBb;
uniform 	vec4 unity_SHC;
uniform 	vec3 unity_LightColor0;
uniform 	vec3 unity_LightColor1;
uniform 	vec3 unity_LightColor2;
uniform 	vec3 unity_LightColor3;
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	mat4 unity_World2Shadow[4];
uniform 	vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	mat4 glstate_matrix_mvp;
uniform 	mat4 glstate_matrix_modelview0;
uniform 	mat4 glstate_matrix_invtrans_modelview0;
uniform 	mat4 _Object2World;
uniform 	mat4 _World2Object;
uniform 	vec4 unity_LODFade;
uniform 	mat4 glstate_matrix_transpose_modelview0;
uniform 	mat4 glstate_matrix_projection;
uniform 	vec4 glstate_lightmodel_ambient;
uniform 	mat4 unity_MatrixV;
uniform 	mat4 unity_MatrixVP;
uniform 	vec4 unity_AmbientSky;
uniform 	vec4 unity_AmbientEquator;
uniform 	vec4 unity_AmbientGround;
uniform 	vec4 unity_FogColor;
uniform 	vec4 unity_FogParams;
uniform 	vec4 unity_LightmapST;
uniform 	vec4 unity_DynamicLightmapST;
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	vec4 unity_SpecCube0_ProbePosition;
uniform 	vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_BoxMax;
uniform 	vec4 unity_SpecCube1_BoxMin;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform 	vec4 unity_SpecCube1_HDR;
uniform 	vec4 unity_ColorSpaceGrey;
uniform 	vec4 unity_ColorSpaceDouble;
uniform 	vec4 unity_ColorSpaceDielectricSpec;
uniform 	vec4 unity_ColorSpaceLuminance;
uniform 	vec4 unity_Lightmap_HDR;
uniform 	vec4 unity_DynamicLightmap_HDR;
uniform 	float _fadePower;
uniform 	float _maxDepthCull;
uniform 	float _maxFineStep;
uniform 	float _maxStep;
uniform 	float _stepGlobalScale;
uniform 	float _bias;
uniform 	mat4 _ProjMatrix;
uniform 	mat4 _ProjectionInv;
uniform 	mat4 _ViewMatrix;
uniform 	vec4 _ProjInfo;
uniform 	float _SSRRcomposeMode;
uniform 	float _FlipReflectionsMSAA;
uniform 	float _skyEnabled;
uniform 	vec4 _MainTex_TexelSize;
uniform 	float _IsInForwardRender;
uniform 	float _IsInLegacyDeffered;
uniform 	float _FullDeferred;
uniform 	mat4 _CameraMV;
in  vec4 in_POSITION0;
in  vec2 in_TEXCOORD0;
out vec2 vs_TEXCOORD0;
vec4 t0;
void main()
{
    //Instruction 237
    //MUL
    t0 = in_POSITION0.yyyy * glstate_matrix_mvp[1];
    //Instruction 238
    //MAD
    t0 = glstate_matrix_mvp[0] * in_POSITION0.xxxx + t0;
    //Instruction 239
    //MAD
    t0 = glstate_matrix_mvp[2] * in_POSITION0.zzzz + t0;
    //Instruction 240
    //MAD
    gl_Position = glstate_matrix_mvp[3] * in_POSITION0.wwww + t0;
    //Instruction 241
    //MOV
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    //Instruction 242
    //RET
    return;
}

#endif
#ifdef FRAGMENT
#version 150
#extension GL_ARB_shader_bit_encoding : require
uniform 	vec4 _Time;
uniform 	vec4 _SinTime;
uniform 	vec4 _CosTime;
uniform 	vec4 unity_DeltaTime;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ScreenParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 unity_CameraWorldClipPlanes[6];
uniform 	mat4 unity_CameraProjection;
uniform 	mat4 unity_CameraInvProjection;
uniform 	vec4 _WorldSpaceLightPos0;
uniform 	vec4 _LightPositionRange;
uniform 	vec4 unity_4LightPosX0;
uniform 	vec4 unity_4LightPosY0;
uniform 	vec4 unity_4LightPosZ0;
uniform 	vec4 unity_4LightAtten0;
uniform 	vec4 unity_LightColor[8];
uniform 	vec4 unity_LightPosition[8];
uniform 	vec4 unity_LightAtten[8];
uniform 	vec4 unity_SpotDirection[8];
uniform 	vec4 unity_SHAr;
uniform 	vec4 unity_SHAg;
uniform 	vec4 unity_SHAb;
uniform 	vec4 unity_SHBr;
uniform 	vec4 unity_SHBg;
uniform 	vec4 unity_SHBb;
uniform 	vec4 unity_SHC;
uniform 	vec3 unity_LightColor0;
uniform 	vec3 unity_LightColor1;
uniform 	vec3 unity_LightColor2;
uniform 	vec3 unity_LightColor3;
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 unity_LightShadowBias;
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	mat4 unity_World2Shadow[4];
uniform 	vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	mat4 glstate_matrix_mvp;
uniform 	mat4 glstate_matrix_modelview0;
uniform 	mat4 glstate_matrix_invtrans_modelview0;
uniform 	mat4 _Object2World;
uniform 	mat4 _World2Object;
uniform 	vec4 unity_LODFade;
uniform 	mat4 glstate_matrix_transpose_modelview0;
uniform 	mat4 glstate_matrix_projection;
uniform 	vec4 glstate_lightmodel_ambient;
uniform 	mat4 unity_MatrixV;
uniform 	mat4 unity_MatrixVP;
uniform 	vec4 unity_AmbientSky;
uniform 	vec4 unity_AmbientEquator;
uniform 	vec4 unity_AmbientGround;
uniform 	vec4 unity_FogColor;
uniform 	vec4 unity_FogParams;
uniform 	vec4 unity_LightmapST;
uniform 	vec4 unity_DynamicLightmapST;
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	vec4 unity_SpecCube0_ProbePosition;
uniform 	vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_BoxMax;
uniform 	vec4 unity_SpecCube1_BoxMin;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform 	vec4 unity_SpecCube1_HDR;
uniform 	vec4 unity_ColorSpaceGrey;
uniform 	vec4 unity_ColorSpaceDouble;
uniform 	vec4 unity_ColorSpaceDielectricSpec;
uniform 	vec4 unity_ColorSpaceLuminance;
uniform 	vec4 unity_Lightmap_HDR;
uniform 	vec4 unity_DynamicLightmap_HDR;
uniform 	float _fadePower;
uniform 	float _maxDepthCull;
uniform 	float _maxFineStep;
uniform 	float _maxStep;
uniform 	float _stepGlobalScale;
uniform 	float _bias;
uniform 	mat4 _ProjMatrix;
uniform 	mat4 _ProjectionInv;
uniform 	mat4 _ViewMatrix;
uniform 	vec4 _ProjInfo;
uniform 	float _SSRRcomposeMode;
uniform 	float _FlipReflectionsMSAA;
uniform 	float _skyEnabled;
uniform 	vec4 _MainTex_TexelSize;
uniform 	float _IsInForwardRender;
uniform 	float _IsInLegacyDeffered;
uniform 	float _FullDeferred;
uniform 	mat4 _CameraMV;
uniform  sampler2D _MainTex;
uniform  sampler2D _depthTexCustom;
uniform  sampler2D _CameraDepthTexture;
uniform  sampler2D _CameraNormalsTexture;
uniform  sampler2D _CameraDepthNormalsTexture;
uniform  sampler2D _CameraGBufferTexture2;
in  vec2 vs_TEXCOORD0;
out vec4 SV_Target0;
vec4 t0;
lowp vec4 t10_0;
vec2 t1;
bool tb1;
vec4 t2;
int ti2;
bool tb2;
vec4 t3;
vec4 t4;
lowp vec4 t10_4;
int ti4;
vec4 t5;
mediump vec3 t16_5;
lowp vec4 t10_5;
vec4 t6;
vec3 t7;
int ti7;
vec3 t8;
lowp vec4 t10_8;
vec3 t9;
vec3 t10;
vec3 t11;
lowp vec4 t10_11;
bvec2 tb14;
vec3 t16;
vec3 t17;
float t19;
bool tb19;
bool tb25;
bool tb26;
float t31;
float t36;
float t37;
mediump float t16_37;
bool tb37;
float t38;
float t39;
int ti39;
int ti41;
int ti42;
float t43;
bool tb43;
float t44;
bool tb45;
void main()
{
    //Instruction 0
    //SAMPLE_L
    t0 = textureLod(_MainTex, vs_TEXCOORD0.xy, 0.0);
    //Instruction 1
    //EQ
    tb1 = t0.w==0.0;
    //Instruction 2
    //IF
    if(tb1){
        //Instruction 3
        //MOV
        SV_Target0 = vec4(0.0, 0.0, 0.0, 0.0);
        //Instruction 4
    //ELSE
    } else {
        //Instruction 5
        //LT
        tb1 = 0.5<_skyEnabled;
        //Instruction 6
        //MOVC
        t1.xy = (bool(tb1)) ? vec2(-24.0, 25.0) : _ZBufferParams.xy;
        //Instruction 7
        //LT
        tb25 = 0.0<_IsInForwardRender;
        //Instruction 8
        //IF
        if(tb25){
            //Instruction 9
            //SAMPLE_L
            t2 = textureLod(_depthTexCustom, vs_TEXCOORD0.xy, 0.0).yzxw;
            //Instruction 10
        //ELSE
        } else {
            //Instruction 11
            //SAMPLE_L
            t2 = textureLod(_CameraDepthTexture, vs_TEXCOORD0.xy, 0.0).yzxw;
            //Instruction 12
        //ENDIF
        }
        //Instruction 13
        //MAD
        t37 = t1.x * t2.z + t1.y;
        //Instruction 14
        //DIV
        t37 = float(1.0) / t37;
        //Instruction 15
        //LT
        tb37 = _maxDepthCull<t37;
        //Instruction 16
        //IF
        if(tb37){
            //Instruction 17
            //MOV
            SV_Target0 = vec4(0.0, 0.0, 0.0, 0.0);
            //Instruction 18
        //ELSE
        } else {
            //Instruction 19
            //MAD
            t3.xy = vs_TEXCOORD0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
            //Instruction 20
            //MUL
            t4 = t3.yyyy * _ProjectionInv[1];
            //Instruction 21
            //MAD
            t3 = _ProjectionInv[0] * t3.xxxx + t4;
            //Instruction 22
            //MAD
            t3 = _ProjectionInv[2] * t2.zzzz + t3;
            //Instruction 23
            //ADD
            t3 = t3 + _ProjectionInv[3];
            //Instruction 24
            //DIV
            t3.xyz = t3.xyz / t3.www;
            //Instruction 25
            //IF
            if(tb25){
                //Instruction 26
                //SAMPLE_L
                t10_4 = textureLod(_CameraNormalsTexture, vs_TEXCOORD0.xy, 0.0);
                //Instruction 27
                //MAD
                t4.xyz = t10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
                //Instruction 28
            //ELSE
            } else {
                //Instruction 29
                //LT
                tb37 = 0.0<_IsInLegacyDeffered;
                //Instruction 30
                //IF
                if(tb37){
                    //Instruction 31
                    //SAMPLE_L
                    t10_5 = textureLod(_CameraDepthNormalsTexture, vs_TEXCOORD0.xy, 0.0);
                    //Instruction 32
                    //MAD
                    t16_5.xyz = t10_5.xyz * vec3(3.55539989, 3.55539989, 0.0) + vec3(-1.77769995, -1.77769995, 1.0);
                    //Instruction 33
                    //DP3
                    t16_37 = dot(t16_5.xyz, t16_5.xyz);
                    //Instruction 34
                    //DIV
                    t16_37 = 2.0 / t16_37;
                    //Instruction 35
                    //MUL
                    t16_5.xy = t16_5.xy * vec2(t16_37);
                    //Instruction 36
                    //ADD
                    t16_37 = t16_37 + -1.0;
                    //Instruction 37
                    //MUL
                    t17.xyz = t16_5.yyy * _CameraMV[1].xyz;
                    //Instruction 38
                    //MAD
                    t5.xyz = _CameraMV[0].xyz * t16_5.xxx + t17.xyz;
                    //Instruction 39
                    //MAD
                    t4.xyz = _CameraMV[2].xyz * vec3(t16_37) + t5.xyz;
                    //Instruction 40
                //ELSE
                } else {
                    //Instruction 41
                    //LT
                    tb37 = 0.0<_FullDeferred;
                    //Instruction 42
                    //IF
                    if(tb37){
                        //Instruction 43
                        //SAMPLE
                        t10_5 = texture(_CameraGBufferTexture2, vs_TEXCOORD0.xy);
                        //Instruction 44
                        //MAD
                        t4.xyz = t10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
                        //Instruction 45
                    //ELSE
                    } else {
                        //Instruction 46
                        //MOV
                        t4.xyz = vec3(0.0, 0.0, 0.0);
                        //Instruction 47
                    //ENDIF
                    }
                    //Instruction 48
                //ENDIF
                }
                //Instruction 49
            //ENDIF
            }
            //Instruction 50
            //DP3
            t37 = dot(t3.xyz, t3.xyz);
            //Instruction 51
            //RSQ
            t37 = inversesqrt(t37);
            //Instruction 52
            //MUL
            t5.xyz = vec3(t37) * t3.xyz;
            //Instruction 53
            //MUL
            t6.xyz = t4.yyy * _ViewMatrix[1].xyz;
            //Instruction 54
            //MAD
            t4.xyw = _ViewMatrix[0].xyz * t4.xxx + t6.xyz;
            //Instruction 55
            //MAD
            t4.xyz = _ViewMatrix[2].xyz * t4.zzz + t4.xyw;
            //Instruction 56
            //DP3
            t37 = dot(t4.xyz, t4.xyz);
            //Instruction 57
            //RSQ
            t37 = inversesqrt(t37);
            //Instruction 58
            //MUL
            t4.xyz = vec3(t37) * t4.xyz;
            //Instruction 59
            //DP3
            t37 = dot(t4.xyz, t5.xyz);
            //Instruction 60
            //MUL
            t4.xyz = t4.xyz * vec3(t37);
            //Instruction 61
            //MAD
            t4.xyz = (-t4.xyz) * vec3(2.0, 2.0, 2.0) + t5.xyz;
            //Instruction 62
            //DP3
            t37 = dot(t4.xyz, t4.xyz);
            //Instruction 63
            //RSQ
            t37 = inversesqrt(t37);
            //Instruction 64
            //MAD
            t3.xyz = t4.xyz * vec3(t37) + t3.xyz;
            //Instruction 65
            //MUL
            t4 = t3.yyyy * _ProjMatrix[1];
            //Instruction 66
            //MAD
            t4 = _ProjMatrix[0] * t3.xxxx + t4;
            //Instruction 67
            //MAD
            t3 = _ProjMatrix[2] * t3.zzzz + t4;
            //Instruction 68
            //ADD
            t3 = t3 + _ProjMatrix[3];
            //Instruction 69
            //DIV
            t3.xyz = t3.xyz / t3.www;
            //Instruction 70
            //MAD
            t2.xy = vs_TEXCOORD0.xy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
            //Instruction 71
            //ADD
            t3.xyz = (-t2.xyz) + t3.xyz;
            //Instruction 72
            //DP3
            t37 = dot(t3.xyz, t3.xyz);
            //Instruction 73
            //RSQ
            t37 = inversesqrt(t37);
            //Instruction 74
            //MUL
            t3.xyz = vec3(t37) * t3.xyz;
            //Instruction 75
            //MUL
            t4.xy = t3.xy * vec2(0.5, 0.5);
            //Instruction 76
            //DIV
            t37 = 2.0 / _ScreenParams.x;
            //Instruction 77
            //DP2
            t38 = dot(t4.xy, t4.xy);
            //Instruction 78
            //SQRT
            t38 = sqrt(t38);
            //Instruction 79
            //MUL
            t39 = t37 * _stepGlobalScale;
            //Instruction 80
            //DIV
            t39 = t39 / t38;
            //Instruction 81
            //MUL
            t3.xyz = t3.xyz * vec3(0.5, 0.5, 1.0);
            //Instruction 82
            //FTOI
            ti4 = int(_maxStep);
            //Instruction 83
            //MOV
            t2.xy = vs_TEXCOORD0.xy;
            //Instruction 84
            //MAD
            t2.xyz = t3.xyz * vec3(t39) + t2.xyz;
            //Instruction 85
            //MOV
            t5.w = 1.0;
            //Instruction 86
            //MOV
            t6 = vec4(0.0, 0.0, 0.0, 0.0);
            //Instruction 87
            //MOV
            t5.xyz = t2.xyz;
            //Instruction 88
            //MOV
            t16.xyz = vec3(0.0, 0.0, 0.0);
            //Instruction 89
            //MOV
            ti7 = 0x0;
            //Instruction 90
            //LOOP
            while(true){
                //Instruction 91
                //IGE
                tb19 = ti7>=0x78;
                //Instruction 92
                //BREAKC
                if(tb19){break;}
                //Instruction 93
                //IGE
                tb19 = floatBitsToInt(t16).z>=ti4;
                //Instruction 94
                //IF
                if(tb19){
                    //Instruction 95
                    //BREAK
                    break;
                    //Instruction 96
                //ENDIF
                }
                //Instruction 97
                //IF
                if(tb25){
                    //Instruction 98
                    //SAMPLE_L
                    t10_8 = textureLod(_depthTexCustom, t5.xy, 0.0);
                    //Instruction 99
                    //MAD
                    t19 = t1.x * t10_8.x + t1.y;
                    //Instruction 100
                    //DIV
                    t19 = float(1.0) / t19;
                    //Instruction 101
                //ELSE
                } else {
                    //Instruction 102
                    //SAMPLE_L
                    t10_8 = textureLod(_CameraDepthTexture, t5.xy, 0.0);
                    //Instruction 103
                    //MAD
                    t31 = t1.x * t10_8.x + t1.y;
                    //Instruction 104
                    //DIV
                    t19 = float(1.0) / t31;
                    //Instruction 105
                //ENDIF
                }
                //Instruction 106
                //MAD
                t31 = t1.x * t5.z + t1.y;
                //Instruction 107
                //DIV
                t31 = float(1.0) / t31;
                //Instruction 108
                //ADD
                t31 = t31 + -9.99999997e-007;
                //Instruction 109
                //LT
                tb19 = t19<t31;
                //Instruction 110
                //IF
                if(tb19){
                    //Instruction 111
                    //MOV
                    t6 = t5;
                    //Instruction 112
                    //MOV
                    t16.y = intBitsToFloat(int(0xFFFFFFFFu));
                    //Instruction 113
                    //BREAK
                    break;
                    //Instruction 114
                //ENDIF
                }
                //Instruction 115
                //MAD
                t5.xyz = t3.xyz * vec3(t39) + t5.xyz;
                //Instruction 116
                //ADD
                t16.x = t16.x + 1.0;
                //Instruction 117
                //IADD
                t16.z = intBitsToFloat(floatBitsToInt(t16).z + 0x1);
                //Instruction 118
                //IADD
                ti7 = ti7 + 0x1;
                //Instruction 119
                //MOV
                t6 = vec4(0.0, 0.0, 0.0, 0.0);
                //Instruction 120
                //MOV
                t16.y = 0.0;
                //Instruction 121
            //ENDLOOP
            }
            //Instruction 122
            //MOV
            t5.w = 0.0;
            //Instruction 123
            //MOVC
            t5 = (floatBitsToInt(t16).y != 0) ? t6 : t5;
            //Instruction 124
            //ADD
            t2.x = t5.x + -0.5;
            //Instruction 125
            //LT
            tb14.xy = lessThan(vec4(0.0, 0.0, 0.0, 0.0), vec4(_FlipReflectionsMSAA, _SSRRcomposeMode, _FlipReflectionsMSAA, _FlipReflectionsMSAA)).xy;
            //Instruction 126
            //IF
            if(tb14.x){
                //Instruction 127
                //MAD
                t4.xz = vs_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
                //Instruction 128
                //SAMPLE_L
                t0 = textureLod(_MainTex, t4.xz, 0.0);
                //Instruction 129
            //ENDIF
            }
            //Instruction 130
            //AND
            t0.xyz = mix(vec3(0.0, 0.0, 0.0), t0.xyz, tb14.yyy);
            //Instruction 131
            //MOV
            t0.w = 0.0;
            //Instruction 132
            //LT
            tb2 = 0.5<abs(t2.x);
            //Instruction 133
            //IF
            if(tb2){
                //Instruction 134
                //MOV
                SV_Target0 = t0;
                //Instruction 135
            //ELSE
            } else {
                //Instruction 136
                //ADD
                t2.x = t5.y + -0.5;
                //Instruction 137
                //LT
                tb2 = 0.5<abs(t2.x);
                //Instruction 138
                //IF
                if(tb2){
                    //Instruction 139
                    //MOV
                    SV_Target0 = t0;
                    //Instruction 140
                //ELSE
                } else {
                    //Instruction 141
                    //MAD
                    t2.x = _ZBufferParams.x * t5.z + _ZBufferParams.y;
                    //Instruction 142
                    //DIV
                    t2.x = float(1.0) / t2.x;
                    //Instruction 143
                    //LT
                    tb2 = _maxDepthCull<t2.x;
                    //Instruction 144
                    //LT
                    tb26 = _skyEnabled<0.5;
                    //Instruction 145
                    //AND
                    ti2 = int(uint(tb26) * 0xffffffffu & uint(tb2) * 0xffffffffu);
                    //Instruction 146
                    //IF
                    if((uint(ti2))!=uint(0u)){
                        //Instruction 147
                        //MOV
                        SV_Target0 = t0;
                        //Instruction 148
                    //ELSE
                    } else {
                        //Instruction 149
                        //LT
                        tb2 = t5.z<0.100000001;
                        //Instruction 150
                        //IF
                        if(tb2){
                            //Instruction 151
                            //MOV
                            SV_Target0 = t0;
                            //Instruction 152
                        //ELSE
                        } else {
                            //Instruction 153
                            //EQ
                            tb2 = t5.w==1.0;
                            //Instruction 154
                            //IF
                            if(tb2){
                                //Instruction 155
                                //MAD
                                t4.xzw = (-t3.xyz) * vec3(t39) + t5.xyz;
                                //Instruction 156
                                //DIV
                                t37 = t37 / t38;
                                //Instruction 157
                                //MUL
                                t2.xzw = vec3(t37) * t3.xyz;
                                //Instruction 158
                                //FTOI
                                ti39 = int(_maxFineStep);
                                //Instruction 159
                                //MAD
                                t3.xyz = t3.xyz * vec3(t37) + t4.xzw;
                                //Instruction 160
                                //MOV
                                t6.z = 1.0;
                                //Instruction 161
                                //MOV
                                t7.xyz = t2.xzw;
                                //Instruction 162
                                //MOV
                                t8.xyz = vec3(0.0, 0.0, 0.0);
                                //Instruction 163
                                //MOV
                                t9.xyz = t4.xzw;
                                //Instruction 164
                                //MOV
                                t10.xyz = t3.xyz;
                                //Instruction 165
                                //MOV
                                tb37 = false;
                                //Instruction 166
                                //MOV
                                ti41 = 0x0;
                                //Instruction 167
                                //MOV
                                ti42 = 0x0;
                                //Instruction 168
                                //LOOP
                                while(true){
                                    //Instruction 169
                                    //IGE
                                    tb43 = ti42>=0x28;
                                    //Instruction 170
                                    //BREAKC
                                    if(tb43){break;}
                                    //Instruction 171
                                    //IGE
                                    tb43 = ti41>=ti39;
                                    //Instruction 172
                                    //IF
                                    if(tb43){
                                        //Instruction 173
                                        //BREAK
                                        break;
                                        //Instruction 174
                                    //ENDIF
                                    }
                                    //Instruction 175
                                    //IF
                                    if(tb25){
                                        //Instruction 176
                                        //SAMPLE_L
                                        t10_11 = textureLod(_depthTexCustom, t10.xy, 0.0);
                                        //Instruction 177
                                        //MAD
                                        t43 = t1.x * t10_11.x + t1.y;
                                        //Instruction 178
                                        //DIV
                                        t43 = float(1.0) / t43;
                                        //Instruction 179
                                    //ELSE
                                    } else {
                                        //Instruction 180
                                        //SAMPLE_L
                                        t10_11 = textureLod(_CameraDepthTexture, t10.xy, 0.0);
                                        //Instruction 181
                                        //MAD
                                        t44 = t1.x * t10_11.x + t1.y;
                                        //Instruction 182
                                        //DIV
                                        t43 = float(1.0) / t44;
                                        //Instruction 183
                                    //ENDIF
                                    }
                                    //Instruction 184
                                    //MAD
                                    t44 = t1.x * t10.z + t1.y;
                                    //Instruction 185
                                    //DIV
                                    t44 = float(1.0) / t44;
                                    //Instruction 186
                                    //LT
                                    tb45 = t43<t44;
                                    //Instruction 187
                                    //IF
                                    if(tb45){
                                        //Instruction 188
                                        //ADD
                                        t43 = (-t43) + t44;
                                        //Instruction 189
                                        //LT
                                        tb43 = t43<_bias;
                                        //Instruction 190
                                        //IF
                                        if(tb43){
                                            //Instruction 191
                                            //MOV
                                            t6.xy = t10.xy;
                                            //Instruction 192
                                            //MOV
                                            t8.xyz = t6.xyz;
                                            //Instruction 193
                                            //MOV
                                            tb37 = true;
                                            //Instruction 194
                                            //BREAK
                                            break;
                                            //Instruction 195
                                        //ENDIF
                                        }
                                        //Instruction 196
                                        //MUL
                                        t11.xyz = t7.xyz * vec3(0.5, 0.5, 0.5);
                                        //Instruction 197
                                        //MAD
                                        t10.xyz = t7.xyz * vec3(0.5, 0.5, 0.5) + t9.xyz;
                                        //Instruction 198
                                        //MOV
                                        t7.xyz = t11.xyz;
                                        //Instruction 199
                                    //ELSE
                                    } else {
                                        //Instruction 200
                                        //ADD
                                        t11.xyz = t7.xyz + t10.xyz;
                                        //Instruction 201
                                        //MOV
                                        t9.xyz = t10.xyz;
                                        //Instruction 202
                                        //MOV
                                        t10.xyz = t11.xyz;
                                        //Instruction 203
                                    //ENDIF
                                    }
                                    //Instruction 204
                                    //IADD
                                    ti41 = ti41 + 0x1;
                                    //Instruction 205
                                    //IADD
                                    ti42 = ti42 + 0x1;
                                    //Instruction 206
                                    //MOV
                                    t8.xyz = vec3(0.0, 0.0, 0.0);
                                    //Instruction 207
                                    //MOV
                                    tb37 = false;
                                    //Instruction 208
                                //ENDLOOP
                                }
                                //Instruction 209
                                //MOV
                                t10.z = 0.0;
                                //Instruction 210
                                //MOVC
                                t5.xyz = (bool(tb37)) ? t8.xyz : t10.xyz;
                                //Instruction 211
                            //ELSE
                            } else {
                                //Instruction 212
                                //MOV
                                t5.z = 0.0;
                                //Instruction 213
                            //ENDIF
                            }
                            //Instruction 214
                            //LT
                            tb1 = t5.z<0.00999999978;
                            //Instruction 215
                            //IF
                            if(tb1){
                                //Instruction 216
                                //MOV
                                SV_Target0 = t0;
                                //Instruction 217
                            //ELSE
                            } else {
                                //Instruction 218
                                //ADD
                                t0.x = (-t5.y) + 1.0;
                                //Instruction 219
                                //MOVC
                                t5.y = (tb14.x) ? t0.x : t5.y;
                                //Instruction 220
                                //SAMPLE_L
                                t10_0 = textureLod(_MainTex, t5.xy, 0.0);
                                //Instruction 221
                                //ROUND_Z
                                t36 = trunc(_maxStep);
                                //Instruction 222
                                //DIV
                                t36 = t16.x / t36;
                                //Instruction 223
                                //ADD
                                t36 = (-t36) + 1.0;
                                //Instruction 224
                                //LOG
                                t36 = log2(t36);
                                //Instruction 225
                                //MUL
                                t36 = t36 * _fadePower;
                                //Instruction 226
                                //EXP
                                t36 = exp2(t36);
                                //Instruction 227
                                //MUL
                                SV_Target0.w = t36 * 1.05999994;
                                //Instruction 228
                                //MOV
                                SV_Target0.xyz = t10_0.xyz;
                                //Instruction 229
                            //ENDIF
                            }
                            //Instruction 230
                        //ENDIF
                        }
                        //Instruction 231
                    //ENDIF
                    }
                    //Instruction 232
                //ENDIF
                }
                //Instruction 233
            //ENDIF
            }
            //Instruction 234
        //ENDIF
        }
        //Instruction 235
    //ENDIF
    }
    //Instruction 236
    //RET
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "opengl " {
"!!GLSL"
}
SubProgram "d3d9 " {
// Stats: 157 math, 23 textures, 44 branches
Matrix 11 [_CameraMV] 3
Matrix 0 [_ProjMatrix]
Matrix 4 [_ProjectionInv]
Matrix 8 [_ViewMatrix] 3
Float 23 [_FlipReflectionsMSAA]
Float 27 [_FullDeferred]
Float 25 [_IsInForwardRender]
Float 26 [_IsInLegacyDeffered]
Float 22 [_SSRRcomposeMode]
Vector 14 [_ScreenParams]
Vector 15 [_ZBufferParams]
Float 21 [_bias]
Float 16 [_fadePower]
Float 17 [_maxDepthCull]
Float 18 [_maxFineStep]
Float 19 [_maxStep]
Float 24 [_skyEnabled]
Float 20 [_stepGlobalScale]
SetTexture 0 [_depthTexCustom] 2D 0
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_CameraNormalsTexture] 2D 2
SetTexture 3 [_CameraDepthTexture] 2D 3
SetTexture 4 [_CameraDepthNormalsTexture] 2D 4
SetTexture 5 [_CameraGBufferTexture2] 2D 5
"ps_3_0
def c28, 1, 0, 0.5, -2
def c29, -24, 25, 0, -9.99999997e-007
def c30, 3.55539989, 0, -1.77769995, 1
def c31, 0.100000001, 0, 0.00999999978, 1.05999994
def c32, 2, 0, -1, 1
defi i0, 120, 0, 0, 0
defi i1, 40, 0, 0, 0
dcl_texcoord v0.xy
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
mul r0, c28.xxyy, v0.xyxx
texldl r1, r0, s1
if_eq r1.w, c28.y
mov_pp oC0, c28.y
else
mov r2.yz, c28
add r2.x, r2.z, -c24.x
mov r3.xy, c15
cmp r2.xw, r2.x, r3.xyzy, c29.xyzy
if_lt -c25.x, r2.y
texldl r3, r0, s0
mov r3.z, r3.x
else
texldl r4, r0, s3
mov r3.z, r4.x
endif
mad r4.x, r2.x, r3.z, r2.w
rcp r4.x, r4.x
if_lt c17.x, r4.x
mov_pp oC0, c28.y
else
frc r4.x, c19.x
add r4.y, -r4.x, c19.x
cmp r4.x, -r4.x, c28.y, c28.x
cmp r4.x, c19.x, r2.y, r4.x
add r4.x, r4.x, r4.y
mad r3.xyw, v0.xyzx, c32.xxzy, c32.zzzw
dp4 r5.x, c4, r3
dp4 r5.y, c5, r3
dp4 r5.z, c6, r3
dp4 r3.w, c7, r3
rcp r3.w, r3.w
mul r4.yzw, r3.w, r5.xxyz
if_lt -c25.x, r2.y
texldl r5, r0, s2
mad r5.xyz, r5, -c28.w, -c28.x
else
if_lt -c26.x, r2.y
texldl r0, r0, s4
mad r0.xyz, r0, c30.xxyw, c30.zzww
dp3 r0.z, r0, r0
rcp r0.z, r0.z
add r0.w, r0.z, r0.z
mul r6.xy, r0, r0.w
mad r6.z, r0.z, -c28.w, -c28.x
dp3 r5.x, c11, r6
dp3 r5.y, c12, r6
dp3 r5.z, c13, r6
else
if_lt -c27.x, r2.y
texld r0, v0, s5
mad r5.xyz, r0, -c28.w, -c28.x
else
mov r5.xyz, c28.y
endif
endif
endif
nrm r0.xyz, r4.yzww
dp3 r6.x, c8, r5
dp3 r6.y, c9, r5
dp3 r6.z, c10, r5
nrm r5.xyz, r6
dp3 r0.w, r5, r0
mul r5.xyz, r5, r0.w
mad r0.xyz, r5, c28.w, r0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mad r0.xyz, r0, r0.w, r4.yzww
mov r0.w, c28.x
dp4 r5.x, c0, r0
dp4 r5.y, c1, r0
dp4 r5.z, c2, r0
dp4 r0.x, c3, r0
rcp r0.x, r0.x
mad r0.xyz, r5, r0.x, -r3
nrm r5.xyz, r0
mul r0.xy, r5, c28.z
rcp r0.z, c14.x
add r0.z, r0.z, r0.z
dp2add r0.x, r0, r0, c28.y
rsq r0.x, r0.x
mul r0.y, r0.z, c20.x
mul r0.y, r0.x, r0.y
mul r4.yzw, r5.xxyz, c28.xzzx
mov r3.xy, v0
mad r3.xyz, r4.yzww, r0.y, r3
mov r5, c28.y
mov r6.xyz, r3
mov r0.w, c28.y
mov r3.w, c28.y
mov r7.x, c28.y
rep i0
if_ge r7.x, r4.x
break_ne c28.x, -c28.x
endif
if_lt -c25.x, r2.y
mul r8, r6.xyxx, c28.xxyy
texldl r8, r8, s0
mad r7.y, r2.x, r8.x, r2.w
rcp r7.y, r7.y
else
mul r8, r6.xyxx, c28.xxyy
texldl r8, r8, s3
mad r7.z, r2.x, r8.x, r2.w
rcp r7.y, r7.z
endif
mad r7.z, r2.x, r6.z, r2.w
rcp r7.z, r7.z
add r7.z, r7.z, c29.w
if_lt r7.y, r7.z
mad r5.xyw, r6.xyzx, c28.xxzy, c28.yyzx
mov r5.z, r6.z
mov r3.w, c28.x
break_ne c28.x, -c28.x
endif
mad r6.xyz, r4.yzww, r0.y, r6
add r0.w, r0.w, c28.x
add r7.x, r7.x, c28.x
mov r5, c28.y
mov r3.w, c28.y
endrep
mov r6.w, c28.y
cmp r3, -r3.w, r6, r5
add r5.x, r3.x, -c28.z
if_lt -c23.x, r2.y
mad r6, v0.xyxx, c32.wzyy, c32.ywyy
texldl r1, r6, s1
endif
cmp r1.xyz, -c22.x, r2.y, r1
mov r1.w, c28.y
if_lt c28.z, r5_abs.x
mov_pp oC0, r1
else
add r5.x, r3.y, -c28.z
if_lt c28.z, r5_abs.x
mov_pp oC0, r1
else
mad r5.x, c15.x, r3.z, c15.y
rcp r5.x, r5.x
add r5.x, -r5.x, c17.x
add r2.z, -r2.z, c24.x
cmp r2.z, r2.z, c28.y, c28.x
cmp r2.z, r5.x, c28.y, r2.z
if_ne r2.z, -r2.z
mov_pp oC0, r1
else
if_lt r3.z, c31.x
mov_pp oC0, r1
else
if_ge r3.w, c28.x
mad r5.xyz, r4.yzww, -r0.y, r3
mul r0.x, r0.x, r0.z
mul r6.xyz, r0.x, r4.yzww
frc r0.y, c18.x
add r0.z, -r0.y, c18.x
cmp r0.y, -r0.y, c28.y, c28.x
cmp r0.y, c18.x, r2.y, r0.y
add r0.y, r0.y, r0.z
mad r4.yzw, r4, r0.x, r5.xxyz
mov r7.xyz, r6
mov r8.xyz, c28.y
mov r9.xyz, r5
mov r10.xyz, r4.yzww
mov r0.xz, c28.y
rep i1
if_ge r0.z, r0.y
break_ne c28.x, -c28.x
endif
if_lt -c25.x, r2.y
mul r11, r10.xyxx, c28.xxyy
texldl r11, r11, s0
mad r2.z, r2.x, r11.x, r2.w
rcp r2.z, r2.z
else
mul r11, r10.xyxx, c28.xxyy
texldl r11, r11, s3
mad r5.w, r2.x, r11.x, r2.w
rcp r2.z, r5.w
endif
mad r5.w, r2.x, r10.z, r2.w
rcp r5.w, r5.w
if_lt r2.z, r5.w
add r2.z, -r2.z, r5.w
if_lt r2.z, c21.x
mad r8.xyz, r10.xyxw, c28.xxyw, c28.yyxw
mov r0.x, c28.x
break_ne c28.x, -c28.x
endif
mul r11.xyz, r7, c28.z
mad r10.xyz, r7, c28.z, r9
mov r7.xyz, r11
else
add r11.xyz, r7, r10
mov r9.xyz, r10
mov r10.xyz, r11
endif
add r0.z, r0.z, c28.x
mov r8.xyz, c28.y
mov r0.x, c28.y
endrep
mov r10.z, c28.y
cmp r3.xyw, -r0.x, r10.xyzz, r8.xyzz
endif
if_lt r3.w, c31.z
mov_pp oC0, r1
else
add r0.x, -r3.y, c28.x
cmp r3.y, -c23.x, r3.y, r0.x
mov r3.z, c28.y
texldl r1, r3.xyzz, s1
rcp r0.x, r4.x
mad r0.x, r0.w, -r0.x, c28.x
pow r1.w, r0.x, c16.x
mul_pp oC0.w, r1.w, c31.w
mov_pp oC0.xyz, r1
endif
endif
endif
endif
endif
endif
endif

"
}
SubProgram "d3d11 " {
// Stats: 114 math, 1 textures, 41 branches
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_depthTexCustom] 2D 0
SetTexture 2 [_CameraDepthTexture] 2D 3
SetTexture 3 [_CameraNormalsTexture] 2D 2
SetTexture 4 [_CameraDepthNormalsTexture] 2D 4
SetTexture 5 [_CameraGBufferTexture2] 2D 5
ConstBuffer "$Globals" 448
Matrix 128 [_ProjMatrix]
Matrix 192 [_ProjectionInv]
Matrix 256 [_ViewMatrix]
Matrix 384 [_CameraMV]
Float 96 [_fadePower]
Float 100 [_maxDepthCull]
Float 104 [_maxFineStep]
Float 108 [_maxStep]
Float 112 [_stepGlobalScale]
Float 116 [_bias]
Float 336 [_SSRRcomposeMode]
Float 340 [_FlipReflectionsMSAA]
Float 344 [_skyEnabled]
Float 368 [_IsInForwardRender]
Float 372 [_IsInLegacyDeffered]
Float 376 [_FullDeferred]
ConstBuffer "UnityPerCamera" 144
Vector 96 [_ScreenParams]
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
root12:agacagaa
eefiecedbfphjagogiblifenbjpdakgncbahefloabaaaaaajibiaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcnibhaaaa
eaaaaaaapgafaaaafjaaaaaeegiocaaaaaaaaaaablaaaaaafjaaaaaeegiocaaa
abaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafkaaaaadaagabaaaafaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaa
fibiaaaeaahabaaaafaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacamaaaaaaeiaaaaalpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaaabeaaaaaaaaaaaaabiaaaaah
bcaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaabpaaaeadakaabaaa
abaaaaaadgaaaaaipccabaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaabcaaaaabdbaaaaaibcaabaaaabaaaaaaabeaaaaaaaaaaadpckiacaaa
aaaaaaaabfaaaaaadhaaaaandcaabaaaabaaaaaaagaabaaaabaaaaaaaceaaaaa
aaaamambaaaamiebaaaaaaaaaaaaaaaaegiacaaaabaaaaaaahaaaaaadbaaaaai
ecaabaaaabaaaaaaabeaaaaaaaaaaaaaakiacaaaaaaaaaaabhaaaaaabpaaaead
ckaabaaaabaaaaaaeiaaaaalpcaabaaaacaaaaaaegbabaaaabaaaaaajghmbaaa
abaaaaaaaagabaaaaaaaaaaaabeaaaaaaaaaaaaabcaaaaabeiaaaaalpcaabaaa
acaaaaaaegbabaaaabaaaaaajghmbaaaacaaaaaaaagabaaaadaaaaaaabeaaaaa
aaaaaaaabfaaaaabdcaaaaajicaabaaaabaaaaaaakaabaaaabaaaaaackaabaaa
acaaaaaabkaabaaaabaaaaaaaoaaaaakicaabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpdkaabaaaabaaaaaadbaaaaaiicaabaaaabaaaaaa
bkiacaaaaaaaaaaaagaaaaaadkaabaaaabaaaaaabpaaaeaddkaabaaaabaaaaaa
dgaaaaaipccabaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
bcaaaaabdcaaaaapdcaabaaaadaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaaaaaaaaaaaaa
diaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaaaaaaaaaaanaaaaaa
dcaaaaakpcaabaaaadaaaaaaegiocaaaaaaaaaaaamaaaaaaagaabaaaadaaaaaa
egaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaaaaaaaaaaaoaaaaaa
kgakbaaaacaaaaaaegaobaaaadaaaaaaaaaaaaaipcaabaaaadaaaaaaegaobaaa
adaaaaaaegiocaaaaaaaaaaaapaaaaaaaoaaaaahhcaabaaaadaaaaaaegacbaaa
adaaaaaapgapbaaaadaaaaaabpaaaeadckaabaaaabaaaaaaeiaaaaalpcaabaaa
aeaaaaaaegbabaaaabaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaaabeaaaaa
aaaaaaaadcaaaaaphcaabaaaaeaaaaaaegacbaaaaeaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaeaaaaaaaaaaceaaaaaaaaaialpaaaaialpaaaaialpaaaaaaaa
bcaaaaabdbaaaaaiicaabaaaabaaaaaaabeaaaaaaaaaaaaabkiacaaaaaaaaaaa
bhaaaaaabpaaaeaddkaabaaaabaaaaaaeiaaaaalpcaabaaaafaaaaaaegbabaaa
abaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaaabeaaaaaaaaaaaaadcaaaaap
hcaabaaaafaaaaaaegacbaaaafaaaaaaaceaaaaakmilgdeakmilgdeaaaaaaaaa
aaaaaaaaaceaaaaakmilodlpkmilodlpaaaaiadpaaaaaaaabaaaaaahicaabaaa
abaaaaaaegacbaaaafaaaaaaegacbaaaafaaaaaaaoaaaaahicaabaaaabaaaaaa
abeaaaaaaaaaaaeadkaabaaaabaaaaaadiaaaaahdcaabaaaafaaaaaaegaabaaa
afaaaaaapgapbaaaabaaaaaaaaaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaa
abeaaaaaaaaaialpdiaaaaaiocaabaaaafaaaaaafgafbaaaafaaaaaaagijcaaa
aaaaaaaabjaaaaaadcaaaaakhcaabaaaafaaaaaaegiccaaaaaaaaaaabiaaaaaa
agaabaaaafaaaaaajgahbaaaafaaaaaadcaaaaakhcaabaaaaeaaaaaaegiccaaa
aaaaaaaabkaaaaaapgapbaaaabaaaaaaegacbaaaafaaaaaabcaaaaabdbaaaaai
icaabaaaabaaaaaaabeaaaaaaaaaaaaackiacaaaaaaaaaaabhaaaaaabpaaaead
dkaabaaaabaaaaaaefaaaaajpcaabaaaafaaaaaaegbabaaaabaaaaaaeghobaaa
afaaaaaaaagabaaaafaaaaaadcaaaaaphcaabaaaaeaaaaaaegacbaaaafaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaaaaceaaaaaaaaaialpaaaaialp
aaaaialpaaaaaaaabcaaaaabdgaaaaaihcaabaaaaeaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaabfaaaaabbfaaaaabbfaaaaabbaaaaaahicaabaaa
abaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaficaabaaaabaaaaaa
dkaabaaaabaaaaaadiaaaaahhcaabaaaafaaaaaapgapbaaaabaaaaaaegacbaaa
adaaaaaadiaaaaaihcaabaaaagaaaaaafgafbaaaaeaaaaaaegiccaaaaaaaaaaa
bbaaaaaadcaaaaaklcaabaaaaeaaaaaaegiicaaaaaaaaaaabaaaaaaaagaabaaa
aeaaaaaaegaibaaaagaaaaaadcaaaaakhcaabaaaaeaaaaaaegiccaaaaaaaaaaa
bcaaaaaakgakbaaaaeaaaaaaegadbaaaaeaaaaaabaaaaaahicaabaaaabaaaaaa
egacbaaaaeaaaaaaegacbaaaaeaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaa
abaaaaaadiaaaaahhcaabaaaaeaaaaaapgapbaaaabaaaaaaegacbaaaaeaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaaeaaaaaaegacbaaaafaaaaaadiaaaaah
hcaabaaaaeaaaaaaegacbaaaaeaaaaaapgapbaaaabaaaaaadcaaaaanhcaabaaa
aeaaaaaaegacbaiaebaaaaaaaeaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaea
aaaaaaaaegacbaaaafaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaaeaaaaaa
egacbaaaaeaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadcaaaaaj
hcaabaaaadaaaaaaegacbaaaaeaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaa
diaaaaaipcaabaaaaeaaaaaafgafbaaaadaaaaaaegiocaaaaaaaaaaaajaaaaaa
dcaaaaakpcaabaaaaeaaaaaaegiocaaaaaaaaaaaaiaaaaaaagaabaaaadaaaaaa
egaobaaaaeaaaaaadcaaaaakpcaabaaaadaaaaaaegiocaaaaaaaaaaaakaaaaaa
kgakbaaaadaaaaaaegaobaaaaeaaaaaaaaaaaaaipcaabaaaadaaaaaaegaobaaa
adaaaaaaegiocaaaaaaaaaaaalaaaaaaaoaaaaahhcaabaaaadaaaaaaegacbaaa
adaaaaaapgapbaaaadaaaaaadcaaaaapdcaabaaaacaaaaaaegbabaaaabaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaaaaaaaaaaaaceaaaaaaaaaialpaaaaialp
aaaaaaaaaaaaaaaaaaaaaaaihcaabaaaadaaaaaaegacbaiaebaaaaaaacaaaaaa
egacbaaaadaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaa
adaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaadiaaaaakdcaabaaaaeaaaaaa
egaabaaaadaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaaaoaaaaai
icaabaaaabaaaaaaabeaaaaaaaaaaaeaakiacaaaabaaaaaaagaaaaaaapaaaaah
icaabaaaacaaaaaaegaabaaaaeaaaaaaegaabaaaaeaaaaaaelaaaaaficaabaaa
acaaaaaadkaabaaaacaaaaaadiaaaaaiicaabaaaadaaaaaadkaabaaaabaaaaaa
akiacaaaaaaaaaaaahaaaaaaaoaaaaahicaabaaaadaaaaaadkaabaaaadaaaaaa
dkaabaaaacaaaaaadiaaaaakhcaabaaaadaaaaaaegacbaaaadaaaaaaaceaaaaa
aaaaaadpaaaaaadpaaaaiadpaaaaaaaablaaaaagbcaabaaaaeaaaaaadkiacaaa
aaaaaaaaagaaaaaadgaaaaafdcaabaaaacaaaaaaegbabaaaabaaaaaadcaaaaaj
hcaabaaaacaaaaaaegacbaaaadaaaaaapgapbaaaadaaaaaaegacbaaaacaaaaaa
dgaaaaaficaabaaaafaaaaaaabeaaaaaaaaaiadpdgaaaaaipcaabaaaagaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadgaaaaafhcaabaaaafaaaaaa
egacbaaaacaaaaaadgaaaaaiocaabaaaaeaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaadgaaaaafbcaabaaaahaaaaaaabeaaaaaaaaaaaaadaaaaaab
cbaaaaahccaabaaaahaaaaaaakaabaaaahaaaaaaabeaaaaahiaaaaaaadaaaead
bkaabaaaahaaaaaacbaaaaahccaabaaaahaaaaaadkaabaaaaeaaaaaaakaabaaa
aeaaaaaabpaaaeadbkaabaaaahaaaaaaacaaaaabbfaaaaabbpaaaeadckaabaaa
abaaaaaaeiaaaaalpcaabaaaaiaaaaaaegaabaaaafaaaaaaeghobaaaabaaaaaa
aagabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaajccaabaaaahaaaaaaakaabaaa
abaaaaaaakaabaaaaiaaaaaabkaabaaaabaaaaaaaoaaaaakccaabaaaahaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpbkaabaaaahaaaaaabcaaaaab
eiaaaaalpcaabaaaaiaaaaaaegaabaaaafaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaaabeaaaaaaaaaaaaadcaaaaajecaabaaaahaaaaaaakaabaaaabaaaaaa
akaabaaaaiaaaaaabkaabaaaabaaaaaaaoaaaaakccaabaaaahaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpckaabaaaahaaaaaabfaaaaabdcaaaaaj
ecaabaaaahaaaaaaakaabaaaabaaaaaackaabaaaafaaaaaabkaabaaaabaaaaaa
aoaaaaakecaabaaaahaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadp
ckaabaaaahaaaaaaaaaaaaahecaabaaaahaaaaaackaabaaaahaaaaaaabeaaaaa
lndhiglfdbaaaaahccaabaaaahaaaaaabkaabaaaahaaaaaackaabaaaahaaaaaa
bpaaaeadbkaabaaaahaaaaaadgaaaaafpcaabaaaagaaaaaaegaobaaaafaaaaaa
dgaaaaafecaabaaaaeaaaaaaabeaaaaappppppppacaaaaabbfaaaaabdcaaaaaj
hcaabaaaafaaaaaaegacbaaaadaaaaaapgapbaaaadaaaaaaegacbaaaafaaaaaa
aaaaaaahccaabaaaaeaaaaaabkaabaaaaeaaaaaaabeaaaaaaaaaiadpboaaaaah
icaabaaaaeaaaaaadkaabaaaaeaaaaaaabeaaaaaabaaaaaaboaaaaahbcaabaaa
ahaaaaaaakaabaaaahaaaaaaabeaaaaaabaaaaaadgaaaaaipcaabaaaagaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadgaaaaafecaabaaaaeaaaaaa
abeaaaaaaaaaaaaabgaaaaabdgaaaaaficaabaaaafaaaaaaabeaaaaaaaaaaaaa
dhaaaaajpcaabaaaafaaaaaakgakbaaaaeaaaaaaegaobaaaagaaaaaaegaobaaa
afaaaaaaaaaaaaahbcaabaaaacaaaaaaakaabaaaafaaaaaaabeaaaaaaaaaaalp
dbaaaaalgcaabaaaacaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
fgiecaaaaaaaaaaabfaaaaaabpaaaeadbkaabaaaacaaaaaadcaaaaapfcaabaaa
aeaaaaaaagbbbaaaabaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaialpaaaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaeiaaaaalpcaabaaaaaaaaaaa
igaabaaaaeaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaaabeaaaaaaaaaaaaa
bfaaaaababaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaakgakbaaaacaaaaaa
dgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaaaaadbaaaaaibcaabaaaacaaaaaa
abeaaaaaaaaaaadpakaabaiaibaaaaaaacaaaaaabpaaaeadakaabaaaacaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaabcaaaaabaaaaaaahbcaabaaa
acaaaaaabkaabaaaafaaaaaaabeaaaaaaaaaaalpdbaaaaaibcaabaaaacaaaaaa
abeaaaaaaaaaaadpakaabaiaibaaaaaaacaaaaaabpaaaeadakaabaaaacaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaabcaaaaabdcaaaaalbcaabaaa
acaaaaaaakiacaaaabaaaaaaahaaaaaackaabaaaafaaaaaabkiacaaaabaaaaaa
ahaaaaaaaoaaaaakbcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpakaabaaaacaaaaaadbaaaaaibcaabaaaacaaaaaabkiacaaaaaaaaaaa
agaaaaaaakaabaaaacaaaaaadbaaaaaiecaabaaaacaaaaaackiacaaaaaaaaaaa
bfaaaaaaabeaaaaaaaaaaadpabaaaaahbcaabaaaacaaaaaackaabaaaacaaaaaa
akaabaaaacaaaaaabpaaaeadakaabaaaacaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaabcaaaaabdbaaaaahbcaabaaaacaaaaaackaabaaaafaaaaaa
abeaaaaamnmmmmdnbpaaaeadakaabaaaacaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaabcaaaaabbiaaaaahbcaabaaaacaaaaaadkaabaaaafaaaaaa
abeaaaaaaaaaiadpbpaaaeadakaabaaaacaaaaaadcaaaaakncaabaaaaeaaaaaa
agajbaiaebaaaaaaadaaaaaapgapbaaaadaaaaaaagajbaaaafaaaaaaaoaaaaah
icaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaacaaaaaadiaaaaahncaabaaa
acaaaaaapgapbaaaabaaaaaaagajbaaaadaaaaaablaaaaagicaabaaaadaaaaaa
ckiacaaaaaaaaaaaagaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaaadaaaaaa
pgapbaaaabaaaaaaigadbaaaaeaaaaaadgaaaaafecaabaaaagaaaaaaabeaaaaa
aaaaiadpdgaaaaafhcaabaaaahaaaaaaigadbaaaacaaaaaadgaaaaaihcaabaaa
aiaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadgaaaaafhcaabaaa
ajaaaaaaigadbaaaaeaaaaaadgaaaaafhcaabaaaakaaaaaaegacbaaaadaaaaaa
dgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaaaaadgaaaaaficaabaaaafaaaaaa
abeaaaaaaaaaaaaadgaaaaaficaabaaaagaaaaaaabeaaaaaaaaaaaaadaaaaaab
cbaaaaahicaabaaaahaaaaaadkaabaaaagaaaaaaabeaaaaaciaaaaaaadaaaead
dkaabaaaahaaaaaacbaaaaahicaabaaaahaaaaaadkaabaaaafaaaaaadkaabaaa
adaaaaaabpaaaeaddkaabaaaahaaaaaaacaaaaabbfaaaaabbpaaaeadckaabaaa
abaaaaaaeiaaaaalpcaabaaaalaaaaaaegaabaaaakaaaaaaeghobaaaabaaaaaa
aagabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaajicaabaaaahaaaaaaakaabaaa
abaaaaaaakaabaaaalaaaaaabkaabaaaabaaaaaaaoaaaaakicaabaaaahaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaahaaaaaabcaaaaab
eiaaaaalpcaabaaaalaaaaaaegaabaaaakaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaaabeaaaaaaaaaaaaadcaaaaajicaabaaaaiaaaaaaakaabaaaabaaaaaa
akaabaaaalaaaaaabkaabaaaabaaaaaaaoaaaaakicaabaaaahaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaaiadpaaaaiadpdkaabaaaaiaaaaaabfaaaaabdcaaaaaj
icaabaaaaiaaaaaaakaabaaaabaaaaaackaabaaaakaaaaaabkaabaaaabaaaaaa
aoaaaaakicaabaaaaiaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadp
dkaabaaaaiaaaaaadbaaaaahicaabaaaajaaaaaadkaabaaaahaaaaaadkaabaaa
aiaaaaaabpaaaeaddkaabaaaajaaaaaaaaaaaaaiicaabaaaahaaaaaadkaabaia
ebaaaaaaahaaaaaadkaabaaaaiaaaaaadbaaaaaiicaabaaaahaaaaaadkaabaaa
ahaaaaaabkiacaaaaaaaaaaaahaaaaaabpaaaeaddkaabaaaahaaaaaadgaaaaaf
dcaabaaaagaaaaaaegaabaaaakaaaaaadgaaaaafhcaabaaaaiaaaaaaegacbaaa
agaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaappppppppacaaaaabbfaaaaab
diaaaaakhcaabaaaalaaaaaaegacbaaaahaaaaaaaceaaaaaaaaaaadpaaaaaadp
aaaaaadpaaaaaaaadcaaaaamhcaabaaaakaaaaaaegacbaaaahaaaaaaaceaaaaa
aaaaaadpaaaaaadpaaaaaadpaaaaaaaaegacbaaaajaaaaaadgaaaaafhcaabaaa
ahaaaaaaegacbaaaalaaaaaabcaaaaabaaaaaaahhcaabaaaalaaaaaaegacbaaa
ahaaaaaaegacbaaaakaaaaaadgaaaaafhcaabaaaajaaaaaaegacbaaaakaaaaaa
dgaaaaafhcaabaaaakaaaaaaegacbaaaalaaaaaabfaaaaabboaaaaahicaabaaa
afaaaaaadkaabaaaafaaaaaaabeaaaaaabaaaaaaboaaaaahicaabaaaagaaaaaa
dkaabaaaagaaaaaaabeaaaaaabaaaaaadgaaaaaihcaabaaaaiaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaa
aaaaaaaabgaaaaabdgaaaaafecaabaaaakaaaaaaabeaaaaaaaaaaaaadhaaaaaj
hcaabaaaafaaaaaapgapbaaaabaaaaaaegacbaaaaiaaaaaaegacbaaaakaaaaaa
bcaaaaabdgaaaaafecaabaaaafaaaaaaabeaaaaaaaaaaaaabfaaaaabdbaaaaah
bcaabaaaabaaaaaackaabaaaafaaaaaaabeaaaaaaknhcddmbpaaaeadakaabaaa
abaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaabcaaaaabaaaaaaai
bcaabaaaaaaaaaaabkaabaiaebaaaaaaafaaaaaaabeaaaaaaaaaiadpdhaaaaaj
ccaabaaaafaaaaaabkaabaaaacaaaaaaakaabaaaaaaaaaaabkaabaaaafaaaaaa
eiaaaaalpcaabaaaaaaaaaaaegaabaaaafaaaaaaeghobaaaaaaaaaaaaagabaaa
abaaaaaaabeaaaaaaaaaaaaaedaaaaagicaabaaaaaaaaaaadkiacaaaaaaaaaaa
agaaaaaaaoaaaaahicaabaaaaaaaaaaabkaabaaaaeaaaaaadkaabaaaaaaaaaaa
aaaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadp
cpaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaakiacaaaaaaaaaaaagaaaaaabjaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahiccabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
bekoihdpdgaaaaafhccabaaaaaaaaaaaegacbaaaaaaaaaaabfaaaaabbfaaaaab
bfaaaaabbfaaaaabbfaaaaabbfaaaaabbfaaaaabdoaaaaab"
}
SubProgram "gles " {
"!!GLES"
}
SubProgram "gles3 " {
"!!GLES3"
}
SubProgram "metal " {
// Stats: 145 math, 12 textures, 30 branches
SetTexture 0 [_depthTexCustom] 2D 0
SetTexture 1 [_MainTex] 2D 1
SetTexture 2 [_CameraNormalsTexture] 2D 2
SetTexture 3 [_CameraDepthTexture] 2D 3
SetTexture 4 [_CameraDepthNormalsTexture] 2D 4
SetTexture 5 [_CameraGBufferTexture2] 2D 5
ConstBuffer "$Globals" 352
Matrix 64 [_ProjMatrix]
Matrix 128 [_ProjectionInv]
Matrix 192 [_ViewMatrix]
Matrix 288 [_CameraMV]
Vector 0 [_ScreenParams]
Vector 16 [_ZBufferParams]
Float 32 [_fadePower]
Float 36 [_maxDepthCull]
Float 40 [_maxFineStep]
Float 44 [_maxStep]
Float 48 [_stepGlobalScale]
Float 52 [_bias]
Float 256 [_SSRRcomposeMode]
Float 260 [_FlipReflectionsMSAA]
Float 264 [_skyEnabled]
Float 268 [_IsInForwardRender]
Float 272 [_IsInLegacyDeffered]
Float 276 [_FullDeferred]
"metal_fs
#include <metal_stdlib>
using namespace metal;
struct xlatMtlShaderInput {
  float2 xlv_TEXCOORD0;
};
struct xlatMtlShaderOutput {
  half4 _glesFragData_0 [[color(0)]];
};
struct xlatMtlShaderUniform {
  float4 _ScreenParams;
  float4 _ZBufferParams;
  float _fadePower;
  float _maxDepthCull;
  float _maxFineStep;
  float _maxStep;
  float _stepGlobalScale;
  float _bias;
  float4x4 _ProjMatrix;
  float4x4 _ProjectionInv;
  float4x4 _ViewMatrix;
  float _SSRRcomposeMode;
  float _FlipReflectionsMSAA;
  float _skyEnabled;
  float _IsInForwardRender;
  float _IsInLegacyDeffered;
  float _FullDeferred;
  float4x4 _CameraMV;
};
fragment xlatMtlShaderOutput xlatMtlMain (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(0)]]
  ,   texture2d<half> _depthTexCustom [[texture(0)]], sampler _mtlsmp__depthTexCustom [[sampler(0)]]
  ,   texture2d<half> _MainTex [[texture(1)]], sampler _mtlsmp__MainTex [[sampler(1)]]
  ,   texture2d<half> _CameraNormalsTexture [[texture(2)]], sampler _mtlsmp__CameraNormalsTexture [[sampler(2)]]
  ,   texture2d<half> _CameraDepthTexture [[texture(3)]], sampler _mtlsmp__CameraDepthTexture [[sampler(3)]]
  ,   texture2d<half> _CameraDepthNormalsTexture [[texture(4)]], sampler _mtlsmp__CameraDepthNormalsTexture [[sampler(4)]]
  ,   texture2d<half> _CameraGBufferTexture2 [[texture(5)]], sampler _mtlsmp__CameraGBufferTexture2 [[sampler(5)]])
{
  xlatMtlShaderOutput _mtl_o;
  half4 tmpvar_1;
  float kklng4_2;
  float ejzah4_3;
  int mftrqw_4;
  float3 otrre5_5;
  float4 rehj5_6;
  float utrhfd_7;
  float4 fincxse_8;
  half4 tmpvar_9;
  tmpvar_9 = _MainTex.sample(_mtlsmp__MainTex, (float2)(_mtl_i.xlv_TEXCOORD0), level(0.0));
  float4 tmpvar_10;
  tmpvar_10 = float4(tmpvar_9);
  float tmpvar_11;
  if ((_mtl_u._skyEnabled > 0.5)) {
    tmpvar_11 = -24.0;
  } else {
    tmpvar_11 = _mtl_u._ZBufferParams.x;
  };
  ejzah4_3 = tmpvar_11;
  float tmpvar_12;
  if ((_mtl_u._skyEnabled > 0.5)) {
    tmpvar_12 = 25.0;
  } else {
    tmpvar_12 = _mtl_u._ZBufferParams.y;
  };
  kklng4_2 = tmpvar_12;
  if ((tmpvar_10.w == 0.0)) {
    fincxse_8 = float4(0.0, 0.0, 0.0, 0.0);
  } else {
    float tmuiq2_13;
    tmuiq2_13 = 0.0;
    if ((_mtl_u._IsInForwardRender > 0.0)) {
      half4 tmpvar_14;
      tmpvar_14 = _depthTexCustom.sample(_mtlsmp__depthTexCustom, (float2)(_mtl_i.xlv_TEXCOORD0), level(0.0));
      tmuiq2_13 = float(tmpvar_14.x);
    } else {
      half4 tmpvar_15;
      tmpvar_15 = _CameraDepthTexture.sample(_mtlsmp__CameraDepthTexture, (float2)(_mtl_i.xlv_TEXCOORD0), level(0.0));
      tmuiq2_13 = float(tmpvar_15.x);
    };
    float tmpvar_16;
    tmpvar_16 = (1.0/(((tmpvar_11 * tmuiq2_13) + tmpvar_12)));
    if ((tmpvar_16 > _mtl_u._maxDepthCull)) {
      fincxse_8 = float4(0.0, 0.0, 0.0, 0.0);
    } else {
      float4 paAccurateColor_17;
      float4 origtmp_18;
      int s_19;
      float4 uytrfb4_20;
      float vcfggr4_21;
      float fghdtge4_22;
      int i_33_23;
      bool dlkfeoi_24;
      float4 odpoeir6_25;
      float fduer6_26;
      int maxCount_29_27;
      float3 mvjidu6_28;
      float3 iydjer_29;
      float3 ofpeod_30;
      float4 nfkjie2_31;
      float4 fjhdrit_32;
      float3 vredju_33;
      float4 qwmjd7_34;
      mftrqw_4 = int(_mtl_u._maxStep);
      qwmjd7_34.w = 1.0;
      qwmjd7_34.xy = ((_mtl_i.xlv_TEXCOORD0 * 2.0) - 1.0);
      qwmjd7_34.z = tmuiq2_13;
      float4 tmpvar_35;
      tmpvar_35 = (_mtl_u._ProjectionInv * qwmjd7_34);
      float4 tmpvar_36;
      tmpvar_36 = (tmpvar_35 / tmpvar_35.w);
      vredju_33.xy = qwmjd7_34.xy;
      vredju_33.z = tmuiq2_13;
      fjhdrit_32.w = 0.0;
      fjhdrit_32.xyz = float3(0.0, 0.0, 0.0);
      if ((_mtl_u._IsInForwardRender > 0.0)) {
        half4 tmpvar_37;
        tmpvar_37 = _CameraNormalsTexture.sample(_mtlsmp__CameraNormalsTexture, (float2)(_mtl_i.xlv_TEXCOORD0), level(0.0));
        fjhdrit_32.xyz = float3(((tmpvar_37.xyz * (half)2.0) - (half)1.0));
      } else {
        if ((_mtl_u._IsInLegacyDeffered > 0.0)) {
          half4 tmpvar_38;
          tmpvar_38 = _CameraDepthNormalsTexture.sample(_mtlsmp__CameraDepthNormalsTexture, (float2)(_mtl_i.xlv_TEXCOORD0), level(0.0));
          float4 tmpvar_39;
          tmpvar_39 = float4(tmpvar_38);
          float3 n_40;
          float3 tmpvar_41;
          tmpvar_41 = ((tmpvar_39.xyz * float3(3.5554, 3.5554, 0.0)) + float3(-1.7777, -1.7777, 1.0));
          float tmpvar_42;
          tmpvar_42 = (2.0 / dot (tmpvar_41, tmpvar_41));
          n_40.xy = (tmpvar_42 * tmpvar_41.xy);
          n_40.z = (tmpvar_42 - 1.0);
          float3x3 tmpvar_43;
          tmpvar_43[0] = _mtl_u._CameraMV[0].xyz;
          tmpvar_43[1] = _mtl_u._CameraMV[1].xyz;
          tmpvar_43[2] = _mtl_u._CameraMV[2].xyz;
          fjhdrit_32.xyz = (tmpvar_43 * n_40);
        } else {
          if ((_mtl_u._FullDeferred > 0.0)) {
            half4 tmpvar_44;
            tmpvar_44 = _CameraGBufferTexture2.sample(_mtlsmp__CameraGBufferTexture2, (float2)(_mtl_i.xlv_TEXCOORD0));
            fjhdrit_32.xyz = float3(((tmpvar_44.xyz * (half)2.0) - (half)1.0));
          };
        };
      };
      float3 tmpvar_45;
      tmpvar_45 = normalize(tmpvar_36.xyz);
      float3 tmpvar_46;
      tmpvar_46 = normalize((_mtl_u._ViewMatrix * fjhdrit_32).xyz);
      nfkjie2_31.w = 1.0;
      nfkjie2_31.xyz = (tmpvar_36.xyz + normalize((tmpvar_45 - 
        (2.0 * (dot (tmpvar_46, tmpvar_45) * tmpvar_46))
      )));
      float4 tmpvar_47;
      tmpvar_47 = (_mtl_u._ProjMatrix * nfkjie2_31);
      float3 tmpvar_48;
      tmpvar_48 = normalize(((tmpvar_47.xyz / tmpvar_47.w) - vredju_33));
      otrre5_5.z = tmpvar_48.z;
      otrre5_5.xy = (tmpvar_48.xy * 0.5);
      ofpeod_30.xy = _mtl_i.xlv_TEXCOORD0;
      ofpeod_30.z = tmuiq2_13;
      utrhfd_7 = 0.0;
      float tmpvar_49;
      tmpvar_49 = (2.0 / _mtl_u._ScreenParams.x);
      float tmpvar_50;
      tmpvar_50 = sqrt(dot (otrre5_5.xy, otrre5_5.xy));
      float3 tmpvar_51;
      tmpvar_51 = (otrre5_5 * ((tmpvar_49 * _mtl_u._stepGlobalScale) / tmpvar_50));
      iydjer_29 = tmpvar_51;
      maxCount_29_27 = int(_mtl_u._maxStep);
      fduer6_26 = utrhfd_7;
      dlkfeoi_24 = bool(0);
      mvjidu6_28 = (ofpeod_30 + tmpvar_51);
      i_33_23 = 0;
      s_19 = 0;
      while (true) {
        if ((s_19 >= 120)) {
          break;
        };
        if ((i_33_23 >= maxCount_29_27)) {
          break;
        };
        if ((_mtl_u._IsInForwardRender > 0.0)) {
          half4 tmpvar_52;
          tmpvar_52 = _depthTexCustom.sample(_mtlsmp__depthTexCustom, (float2)(mvjidu6_28.xy), level(0.0));
          fghdtge4_22 = (1.0/(((ejzah4_3 * (float)tmpvar_52.x) + kklng4_2)));
        } else {
          half4 tmpvar_53;
          tmpvar_53 = _CameraDepthTexture.sample(_mtlsmp__CameraDepthTexture, (float2)(mvjidu6_28.xy), level(0.0));
          fghdtge4_22 = (1.0/(((ejzah4_3 * (float)tmpvar_53.x) + kklng4_2)));
        };
        vcfggr4_21 = (1.0/(((ejzah4_3 * mvjidu6_28.z) + kklng4_2)));
        if ((fghdtge4_22 < (vcfggr4_21 - 1e-06))) {
          uytrfb4_20.w = 1.0;
          uytrfb4_20.xyz = mvjidu6_28;
          odpoeir6_25 = uytrfb4_20;
          dlkfeoi_24 = bool(1);
          break;
        };
        mvjidu6_28 = (mvjidu6_28 + iydjer_29);
        fduer6_26 += 1.0;
        i_33_23++;
        s_19++;
      };
      if ((dlkfeoi_24 == bool(0))) {
        float4 eoiejd4_54;
        eoiejd4_54.w = 0.0;
        eoiejd4_54.xyz = mvjidu6_28;
        odpoeir6_25 = eoiejd4_54;
        dlkfeoi_24 = bool(1);
      };
      utrhfd_7 = fduer6_26;
      rehj5_6 = odpoeir6_25;
      float tmpvar_55;
      tmpvar_55 = abs((odpoeir6_25.x - 0.5));
      origtmp_18 = tmpvar_10;
      if ((_mtl_u._FlipReflectionsMSAA > 0.0)) {
        float2 tmpouv_56;
        tmpouv_56.x = _mtl_i.xlv_TEXCOORD0.x;
        tmpouv_56.y = (1.0 - _mtl_i.xlv_TEXCOORD0.y);
        float4 tmpvar_57;
        half4 tmpvar_58;
        tmpvar_58 = _MainTex.sample(_mtlsmp__MainTex, (float2)(tmpouv_56), level(0.0));
        tmpvar_57 = float4(tmpvar_58);
        origtmp_18 = tmpvar_57;
      };
      paAccurateColor_17 = float4(0.0, 0.0, 0.0, 0.0);
      if ((_mtl_u._SSRRcomposeMode > 0.0)) {
        float4 tmpvar_59;
        tmpvar_59.w = 0.0;
        tmpvar_59.xyz = origtmp_18.xyz;
        paAccurateColor_17 = tmpvar_59;
      };
      if ((tmpvar_55 > 0.5)) {
        fincxse_8 = paAccurateColor_17;
      } else {
        float tmpvar_60;
        tmpvar_60 = abs((odpoeir6_25.y - 0.5));
        if ((tmpvar_60 > 0.5)) {
          fincxse_8 = paAccurateColor_17;
        } else {
          if ((((1.0/(
            ((_mtl_u._ZBufferParams.x * odpoeir6_25.z) + _mtl_u._ZBufferParams.y)
          )) > _mtl_u._maxDepthCull) && (_mtl_u._skyEnabled < 0.5))) {
            fincxse_8 = paAccurateColor_17;
          } else {
            if ((odpoeir6_25.z < 0.1)) {
              fincxse_8 = paAccurateColor_17;
            } else {
              if ((odpoeir6_25.w == 1.0)) {
                int j_61;
                float3 tyukhg_62;
                float4 djkflrq_63;
                float cbjdhet_64;
                float kjdkues5_65;
                float3 oldPos_50_66;
                int i_49_67;
                bool dflskte_68;
                float4 iuwejd_69;
                int maxCount_45_70;
                float3 oldksd7_71;
                float3 samdpo9_72;
                float3 tmpvar_73;
                tmpvar_73 = (odpoeir6_25.xyz - tmpvar_51);
                float3 tmpvar_74;
                tmpvar_74 = (otrre5_5 * (tmpvar_49 / tmpvar_50));
                oldksd7_71 = tmpvar_74;
                maxCount_45_70 = int(_mtl_u._maxFineStep);
                dflskte_68 = bool(0);
                oldPos_50_66 = tmpvar_73;
                samdpo9_72 = (tmpvar_73 + tmpvar_74);
                i_49_67 = 0;
                j_61 = 0;
                while (true) {
                  if ((j_61 >= 40)) {
                    break;
                  };
                  if ((i_49_67 >= maxCount_45_70)) {
                    break;
                  };
                  if ((_mtl_u._IsInForwardRender > 0.0)) {
                    half4 tmpvar_75;
                    tmpvar_75 = _depthTexCustom.sample(_mtlsmp__depthTexCustom, (float2)(samdpo9_72.xy), level(0.0));
                    kjdkues5_65 = (1.0/(((ejzah4_3 * (float)tmpvar_75.x) + kklng4_2)));
                  } else {
                    half4 tmpvar_76;
                    tmpvar_76 = _CameraDepthTexture.sample(_mtlsmp__CameraDepthTexture, (float2)(samdpo9_72.xy), level(0.0));
                    kjdkues5_65 = (1.0/(((ejzah4_3 * (float)tmpvar_76.x) + kklng4_2)));
                  };
                  cbjdhet_64 = (1.0/(((ejzah4_3 * samdpo9_72.z) + kklng4_2)));
                  if ((kjdkues5_65 < cbjdhet_64)) {
                    if (((cbjdhet_64 - kjdkues5_65) < _mtl_u._bias)) {
                      djkflrq_63.w = 1.0;
                      djkflrq_63.xyz = samdpo9_72;
                      iuwejd_69 = djkflrq_63;
                      dflskte_68 = bool(1);
                      break;
                    };
                    tyukhg_62 = (oldksd7_71 * 0.5);
                    oldksd7_71 = tyukhg_62;
                    samdpo9_72 = (oldPos_50_66 + tyukhg_62);
                  } else {
                    oldPos_50_66 = samdpo9_72;
                    samdpo9_72 = (samdpo9_72 + oldksd7_71);
                  };
                  i_49_67++;
                  j_61++;
                };
                if ((dflskte_68 == bool(0))) {
                  float4 oeisadw_77;
                  oeisadw_77.w = 0.0;
                  oeisadw_77.xyz = samdpo9_72;
                  iuwejd_69 = oeisadw_77;
                  dflskte_68 = bool(1);
                };
                rehj5_6 = iuwejd_69;
              };
              if ((rehj5_6.w < 0.01)) {
                fincxse_8 = paAccurateColor_17;
              } else {
                float4 gresdf_78;
                if ((_mtl_u._FlipReflectionsMSAA > 0.0)) {
                  rehj5_6.y = (1.0 - rehj5_6.y);
                };
                half4 tmpvar_79;
                tmpvar_79 = _MainTex.sample(_mtlsmp__MainTex, (float2)(rehj5_6.xy), level(0.0));
                gresdf_78.xyz = float3(tmpvar_79.xyz);
                gresdf_78.w = (pow ((1.0 - 
                  (fduer6_26 / float(mftrqw_4))
                ), _mtl_u._fadePower) * 1.06);
                fincxse_8 = gresdf_78;
              };
            };
          };
        };
      };
    };
  };
  tmpvar_1 = half4(fincxse_8);
  _mtl_o._glesFragData_0 = tmpvar_1;
  return _mtl_o;
}

"
}
SubProgram "glcore " {
"!!GL2x"
}
}
 }
}
Fallback Off
}