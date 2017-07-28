using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MenuController : MonoBehaviour {

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public Color pink;

    public SkinnedMeshRenderer headRender;
    public Mesh[] headMeshArray;
    private int headMeshIndex = 0;

    public SkinnedMeshRenderer handRender;
    public Mesh[] handMeshArray;
    private int handMeshIndex = 0;



	public void OnHeadMeshNext() {
        headMeshIndex++;
        headMeshIndex %= headMeshArray.Length;
        headRender.sharedMesh = headMeshArray[headMeshIndex];
	}

	public void OnHandMeshNext() {
        handMeshIndex++;
        handMeshIndex %= handMeshArray.Length;
        handRender.sharedMesh = handMeshArray[handMeshIndex];

    }

    public void OnChangeColorBlue() {
		OnChangeColor(Color.blue);
	}

	public void OnChangeColorCyan() {
        OnChangeColor(Color.cyan);
	}
	public void OnChangeColorGreen() {
        OnChangeColor(Color.green);
	}
	public void OnChangeColorPink() {
        OnChangeColor(pink);
	}
	public void OnChangeColorRed() {
        OnChangeColor(Color.red);
	}


	private void OnChangeColor(Color c) {

	}

	public void OnPlay() {
		
	}
}
