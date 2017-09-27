using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TopUpDown : MonoBehaviour {

	public float yUp = 5;

	private bool bIsUp = false;

	private LayerMask mask;

	// Use this for initialization
	void Start () {
		//只与特定层碰撞
		mask = 1 << LayerMask.NameToLayer("RoofTop");
	}

	// Update is called once per frame
	void Update () {
		if (Input.GetMouseButtonDown(0))
		{ //首先判断是否点击了鼠标左键


			Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
			RaycastHit hit;

			if (Physics.Raycast(ray, out hit, mask.value))
			{
				Debug.DrawLine (ray.origin, hit.point, Color.red);

				GameObject go = hit.collider.gameObject;

				Debug.Log(go.name);
				//Debug.Log(go.tag);

				if (go.name == "Cube4") {
					float x = go.transform.position.x;
					float y = go.transform.position.y;
					float z = go.transform.position.z;

					if (bIsUp) {
						//go.transform.DOMoveY (y - yUp, 1.0f);
						go.transform.position = new Vector3(x, y - yUp, z);
						bIsUp = false;
					} else {
						//go.transform.DOMoveY (y + yUp, 1.0f);
						go.transform.position = new Vector3(x, y + yUp, z);
						bIsUp = true;
					}
				}
			}
		}
	}

}
