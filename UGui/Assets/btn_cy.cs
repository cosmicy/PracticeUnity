using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class btn_cy : MonoBehaviour {


	public float threshold = 0.5f;

	// Use this for initialization
	void Start () {
		Image image = GetComponent<Image> ();
		//image.eventAlphaThreshold = threshold;
		image.alphaHitTestMinimumThreshold = threshold;
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void Click()
	{
		Debug.Log ("fewf" + System.DateTime.Now);
	}
}
