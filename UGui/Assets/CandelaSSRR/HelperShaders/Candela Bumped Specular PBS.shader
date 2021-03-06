    Shader "CandelaSSRR/PBS/Bumped Specular PBS SSR" {
        Properties {
            _Color ("Main Color", Color) = (1,1,1,1)
            _SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
            _SpecInt ("Specular Intensity", Float) = 1.0
            _Shininess ("Shininess", Range (0.03, 1)) = 1
            _MainTex ("Base (RGB)", 2D) = "white" {}
            _SpecTex ("Specular (RGB) Roughness(A)", 2D) = "white" {}
            _BH ("Bump Height", Range (0, 3)) = 1
            _BumpMap ("Normalmap", 2D) = "bump" {}
            
        }
        SubShader {
            Tags { "RenderType" = "Opaque" }
            CGPROGRAM
                
                #pragma surface surf BlinnPhongColor
                
                struct SurfaceOutputSpecColor {
                    half3 Albedo;
                    half3 Normal;
                    half3 Emission;
                    half Specular;
                    half3 GlossColor;
                    half Alpha;
                   
                   
                };
               
                //forward lights pass//
                inline half4 LightingBlinnPhongColor (SurfaceOutputSpecColor s, half3 lightDir, half3 viewDir, half atten) {
                    
                    #ifndef USING_DIRECTIONAL_LIGHT
                    lightDir = normalize(lightDir);
                    #endif
                    
                    viewDir = normalize(viewDir);
                    half3 h = normalize (lightDir + viewDir);
                    
                    half diff = max (0, dot (s.Normal, lightDir));
                    float nh = max (0, dot (s.Normal, h));
                    float spec = pow (nh, s.Specular*128.0);
                   
                    half4 c;
                    
                    c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * s.GlossColor * spec*6) * (atten * 2);
                   
                    c.a = s.Alpha + _LightColor0.a  * spec * atten * Luminance(s.GlossColor);
                    return c;
                }
               
                //deferred lihts pass//
                inline half4 LightingBlinnPhongColor_PrePass (SurfaceOutputSpecColor s, half4 light) {
                   
                    half3 spec = light.a * s.GlossColor;
                   
                    half4 c;
                    c.rgb = (s.Albedo * light.rgb + light.rgb * spec.rgb*6);
                  
                    c.a = s.Alpha + Luminance(spec);
                    return c;
                }
               
                sampler2D _MainTex;
                sampler2D _SpecTex;
                sampler2D _BumpMap;
                float4 _Color;
                float _Shininess;
                float _SpecInt;
                half _BH;
               
                struct Input {
                    float2 uv_MainTex;
                    float2 uv_GlossTex;
                    float2 uv_BumpMap;
     
                };
               
                void surf (Input IN, inout SurfaceOutputSpecColor o) {
                    half4 tex = tex2D(_MainTex, IN.uv_MainTex);
                    half4 gloss = tex2D(_SpecTex, IN.uv_MainTex);
                   
                    float3 normalmap = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
                    normalmap.rg*=_BH;
                    
                  
                                        
                    o.Albedo = tex.rgb * _Color.rgb*(1-_Shininess*gloss.a+(0.95*_Shininess*gloss.a));
                  
                    o.GlossColor = _SpecColor*gloss.rgb*gloss.a*_SpecInt*(_Shininess);
                    o.Alpha = tex.a * _Color.a*gloss.a*_Shininess;
                   
                   
                    o.Specular = clamp(_Shininess*gloss.a,0.01,1.0);
                    o.Normal = normalmap;
                }
            ENDCG
        }
        Fallback "Specular"
    }