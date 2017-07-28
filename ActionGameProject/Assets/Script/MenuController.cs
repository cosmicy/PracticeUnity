using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MenuController : MonoBehaviour {

	// Use this for initialization
	void Start () {
        colorArray = new Color[]
        {
            Color.blue,
            Color.cyan,
            Color.green,
            pink,
            Color.red
        };

        //不销毁这个物体
        //DontDestroyOnLoad(this.gameObject);
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public Color pink;

    private Color[] colorArray;
    private int colorIndex = -1;

    public SkinnedMeshRenderer headRender;
    public Mesh[] headMeshArray;
    private int headMeshIndex = 0;

    public SkinnedMeshRenderer handRender;
    public Mesh[] handMeshArray;
    private int handMeshIndex = 0;

    public SkinnedMeshRenderer[] bodyArray;


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
        colorIndex = 0;
		OnChangeColor(Color.blue);
	}

	public void OnChangeColorCyan() {
        colorIndex = 1;
        OnChangeColor(Color.cyan);
	}
	public void OnChangeColorGreen() {
        colorIndex = 2;
        OnChangeColor(Color.green);
	}
	public void OnChangeColorPink() {
        colorIndex = 3;
        OnChangeColor(pink);
	}
	public void OnChangeColorRed() {
        colorIndex = 4;
        OnChangeColor(Color.red);
	}


	private void OnChangeColor(Color c) {
        foreach (var item in bodyArray)
        {
            item.material.color = c;
        }
	}

    private void Save()
    {
        PlayerPrefs.SetInt("HeadMeshIndex", headMeshIndex);
        PlayerPrefs.SetInt("HandMeshIndex", handMeshIndex);
        PlayerPrefs.SetInt("ColorIndex", colorIndex);
    }


	public void OnPlay() {
        Save();
        //Application.LoadLevel(0);
        SceneManager.LoadScene(0);


    }
}
