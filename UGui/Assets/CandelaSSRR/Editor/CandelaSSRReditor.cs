// CANDELA-SSRR V2 SCREEN SPACE RAYTRACED REFLECTIONS
// Copyright 2015 Livenda

using UnityEngine;
using UnityEditor;
using System.Collections;


[CustomEditor(typeof(CandelaSSRR))]
public class CandelaSSRReditor : Editor
{
	
	private CandelaSSRR cdla;
	private Texture2D candelalogo;
	private GUIStyle back1;
	private GUIStyle back2;
	private GUIStyle back3;
	private GUIStyle back4;


	
	string[] mixOptions = new string[]{"Additive","Physically Accurate" };

	//string[] Convolution = new string[]{"Off (Mobile)","Low","Mid (Default)","High","Ultra","Extreme (Slow)" };

	string[] QualityOptions = new string[]{"Low (Mobile)","Mid (Default)","High","Ultra","Extreme (2K)" };

	
	private Texture2D MakeTex(int width, int height, Color col)
    {
        Color[] pix = new Color[width*height];
     
        for(int i = 0; i < pix.Length; i++)
                pix[i] = col;
     
        Texture2D result = new Texture2D(width, height);
        result.SetPixels(pix); 
        result.Apply();
        result.hideFlags = HideFlags.HideAndDontSave;
        return result;
    }
	
	void OnEnable()
	{
	back1 = new GUIStyle();
	back1.normal.background = MakeTex(600, 1, new Color(1.0f, 1.0f, 1.0f, 0.1f));
	back2 = new GUIStyle();
	back2.normal.background = MakeTex(600, 1, new Color(0.1f, 0.1f, 0.1f, 0.8f));
	back3 = new GUIStyle();
	back3.normal.background = MakeTex(600, 1, new Color(0.0f, 0.0f, 0.0f, 0.0f));
	back4 = new GUIStyle();
	back4.normal.background = MakeTex(600, 1, new Color(0.1f, 0.0f, 0.5f, 0.3f));
	}

	void Awake()
	{
	cdla = (CandelaSSRR)target;
	candelalogo = Resources.Load("CandelaLogo", typeof(Texture2D)) as Texture2D;
	}
	
	public override void OnInspectorGUI() 
	{
		GUILayout.Box(candelalogo, GUILayout.ExpandWidth(true));



		GUILayout.BeginVertical(back2);
		GUI.contentColor = new Color(0.7f,0.7f,1.0f,1.0f);
		GUILayout.Label("Quality & Performance",EditorStyles.boldLabel);
		GUILayout.EndVertical();
		GUI.contentColor = Color.white;

		//cdla.convolutionMode = EditorGUILayout.Popup("Rougness Convolution:", (int)cdla.convolutionMode, Convolution, EditorStyles.popup);
		cdla.qualityIndex    = EditorGUILayout.Popup("Render Quality:", (int)cdla.qualityIndex,    QualityOptions, 	  EditorStyles.popup);

		GUI.backgroundColor = Color.white;
		GUILayout.BeginVertical(back2);
		GUILayout.Space(5);
		GUI.contentColor = new Color(0.7f,0.7f,1.0f,1.0f);
		GUILayout.Label("Global Settings For Reflections",EditorStyles.boldLabel);
		GUILayout.Space(5);
		GUILayout.EndVertical();
		GUI.contentColor = Color.white;
		
		cdla.GlobalScale 		= EditorGUILayout.Slider("Global Step Scale", cdla.GlobalScale, 1.0f, 50.0f);
		cdla.maxGlobalStep      = EditorGUILayout.IntSlider("Global Step Count", cdla.maxGlobalStep, 1, 120);
		cdla.maxFineStep        = EditorGUILayout.IntSlider("Fine Step Count", cdla.maxFineStep, 1, 40);
		GUILayout.Space(5);
		
		GUILayout.BeginVertical(back1);
	
		cdla.fadePower	 		= EditorGUILayout.Slider("Distance Fade Power", cdla.fadePower, 0.0f, 10.0f);
		cdla.ContactBlurPower	= EditorGUILayout.Slider("Contact Blur Power",cdla.ContactBlurPower, 0.0f, 1.0f);
		cdla.fresfade	 		= EditorGUILayout.Slider("Fresnel Fade Range", cdla.fresfade, 1.0f, 10.0f);
		cdla.fresrange	 		= EditorGUILayout.Slider("Fresnel Fade Power", cdla.fresrange, 0.001f, 1.5f);
		cdla.maxDepthCull	 	= EditorGUILayout.Slider("Depth Cull", cdla.maxDepthCull, 0.0f, 1.0f);
		cdla.reflectionMultiply	= EditorGUILayout.Slider("Reflection Multiply", cdla.reflectionMultiply, 0.0f, 1.0f);

		GUILayout.Space(10);
		GUILayout.BeginVertical(back4);

		cdla.ToksvigPower	= EditorGUILayout.Slider("Toksvig Power",cdla.ToksvigPower, 0.0f, 1.0f);


		GUILayout.EndVertical();

		GUILayout.EndVertical();

		GUILayout.Space(3);
		GUI.contentColor = new Color(0.7f,0.7f,1.0f,1.0f);
		GUILayout.BeginVertical(back2);
		GUILayout.Label("Sky Reflections",EditorStyles.boldLabel);
		GUILayout.Space(5);
		GUILayout.EndVertical();
		
		GUI.contentColor = Color.white;

		GUILayout.Space(5);
		
		cdla.enableSkyReflections      = EditorGUILayout.Toggle("Enable Sky Reflection", cdla.enableSkyReflections);

		//-----------------------------------------------------
		GUILayout.Space(5);

		GUILayout.Space(5);
		//-----------------------------------------------------

		GUILayout.Space(3);
		GUILayout.BeginVertical(back2);
		GUI.contentColor = new Color(0.7f,0.7f,1.0f,1.0f);
		GUILayout.Label("Final Composition Mode",EditorStyles.boldLabel);
		GUILayout.Space(5);
		GUI.contentColor = Color.white;

		GUILayout.BeginVertical(back1);

		int mixoption = EditorGUILayout.Popup("Compose Mode:", (int)cdla.SSRRcomposeMode, mixOptions, EditorStyles.popup);
		cdla.SSRRcomposeMode = (float)mixoption;
		cdla.HDRreflections   = EditorGUILayout.Toggle("HDR Reflections",cdla.HDRreflections);
		GUILayout.EndVertical();
		GUILayout.Space(3);

		GUI.contentColor = new Color(0.7f,0.7f,1.0f,1.0f);
		GUILayout.BeginVertical(back1);


		GUILayout.BeginVertical(back2);

		GUILayout.Label("Screen Edge Fade Controls",EditorStyles.boldLabel);
		GUILayout.Space(5);
		GUILayout.EndVertical();
		GUI.contentColor = Color.white;
		
		//SCREEN EDGE FADE CONTROLS

		
		GUILayout.BeginHorizontal();
		
		bool screenfadeTmp = false;
		if(cdla.DebugScreenFade > 0.0f) screenfadeTmp = true;
		if(EditorGUILayout.Toggle("Show Screen Fade", screenfadeTmp))
			cdla.DebugScreenFade = 1.0f;
		else
			cdla.DebugScreenFade = 0.0f;
		
		GUILayout.Label("(Use For Debug)");
		
		GUILayout.EndHorizontal();
		
		cdla.ScreenFadePower  = EditorGUILayout.Slider("ScreenFadePower", cdla.ScreenFadePower, 0.0f, 10.0f);
		cdla.ScreenFadeSpread = EditorGUILayout.Slider("ScreenFadeSpread", cdla.ScreenFadeSpread, 0.0f, 3.0f);
		cdla.ScreenFadeEdge   = EditorGUILayout.Slider("ScreenFadeEdge", cdla.ScreenFadeEdge, 0.0f, 4.0f);
		
		
		GUI.contentColor = Color.cyan;
		bool useEdgeTextureTmp = false;
		if(cdla.UseEdgeTexture > 0.0f) useEdgeTextureTmp = true;
		if(EditorGUILayout.Toggle("Use Edge Texture", useEdgeTextureTmp))
			cdla.UseEdgeTexture = 1.0f;
		else
			cdla.UseEdgeTexture = 0.0f;
	
		cdla.EdgeFadeTexture = (Texture2D) EditorGUILayout.ObjectField("Edge Fade Texture", cdla.EdgeFadeTexture, typeof (Texture2D), false);

		GUI.contentColor = Color.white;
		GUILayout.EndVertical();
		

		GUI.contentColor = new Color(0.7f,0.7f,1.0f,1.0f);
		GUILayout.Space(3);
		GUI.contentColor = Color.white;

		GUILayout.Space(5);
		GUI.contentColor = new Color(0.7f,0.7f,1.0f,1.0f);
		GUILayout.Label("Optional Particle and Transparent Object Mask",EditorStyles.boldLabel);
		GUILayout.EndVertical();
		GUI.contentColor = Color.white;
		cdla.UseLayerMask      = EditorGUILayout.Toggle("Use Layer Mask", cdla.UseLayerMask);

		this . DrawDefaultInspectorWithoutScriptField ( ) ;

		GUILayout.Space(5);

		if(cdla.enableSkyReflections)
		{
			cdla.bias	=  0.0065f;
		}
		else
		{

			cdla.bias	=  0.00010f;
		
		}

		if(GUI.changed)
		{
			EditorUtility.SetDirty(target);

			//------------------------------------
			if(cdla.convolutionMode == 0)
				cdla.convolutionSamples = 0.0f;
			else if(cdla.convolutionMode == 1)
				cdla.convolutionSamples = 4.0f;
			else if(cdla.convolutionMode == 2)
				cdla.convolutionSamples = 8.0f;
			else if(cdla.convolutionMode == 3)
				cdla.convolutionSamples = 16.0f;
			else if(cdla.convolutionMode == 4)
				cdla.convolutionSamples = 32.0f;
			else if(cdla.convolutionMode == 5)
				cdla.convolutionSamples = 64.0f;
			//------------------------------------

			if(cdla.qualityIndex == 0)//LOW
			{
				cdla.qualityWidth  = 512;
				cdla.qualityHeight = 512;

			}
			else if(cdla.qualityIndex == 1)//MID
			{
				cdla.qualityWidth  = 1024;
				cdla.qualityHeight = 512;
			}
			else if(cdla.qualityIndex == 2)//HIGH
			{
				cdla.qualityWidth  = 1024;
				cdla.qualityHeight = 1024;
			}
			else if(cdla.qualityIndex == 3)//ULTRA
			{
				cdla.qualityWidth  = 2048;
				cdla.qualityHeight = 1024;
			}
			else if(cdla.qualityIndex == 4)//EXTREME
			{
				cdla.qualityWidth  = 2048;
				cdla.qualityHeight = 2048;
			}
			//------------------------------------


			//Debug.Log("Convolution Samples Set To:"+cdla.convolutionSamples);


		}
		
		//this . DrawDefaultInspectorWithoutScriptField ( ) ;
	}
	
	
	
}



//------------------
public static class DefaultInspector_EditorExtension
{
    public static bool DrawDefaultInspectorWithoutScriptField ( this Editor Inspector )
    {
        EditorGUI . BeginChangeCheck ( ) ;
       
        Inspector . serializedObject . Update ( ) ;
       
        SerializedProperty Iterator = Inspector . serializedObject . GetIterator ( ) ;
       
        Iterator . NextVisible ( true ) ;
       
        while ( Iterator . NextVisible ( false ) )
        {
            EditorGUILayout . PropertyField ( Iterator , true ) ;
        }
       
        Inspector . serializedObject . ApplyModifiedProperties ( ) ;
       
        return ( EditorGUI . EndChangeCheck ( ) ) ;
    }
}
//------------------
 
