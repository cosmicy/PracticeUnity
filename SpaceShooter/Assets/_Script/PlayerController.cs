﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//需要添加可序列化的属性
[System.Serializable]
public class Boundary
{
	public float xMin,xMax,zMin,zMax;

}







public class PlayerController : MonoBehaviour {


	public float speed = 5.0f;

	public Boundary boundary;

	public float tilt = 4.0f;


	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	void FixedUpdate()
	{
		float moveHorizontal = Input.GetAxis ("Horizontal");
		float moveVertical = Input.GetAxis ("Vertical");

		Vector3 movement = new Vector3 (moveHorizontal, 0.0f, moveVertical);
		Rigidbody rb = GetComponent<Rigidbody> ();
			rb.velocity = movement * speed;
		rb.position = new Vector3 (Mathf.Clamp (rb.position.x, boundary.xMin, boundary.xMax),
			0.0f,
			Mathf.Clamp (rb.position.z, boundary.zMin, boundary.zMax)
		);

		rb.rotation = Quaternion.Euler (0.0f, 0.0f, rb.velocity.x * -tilt);
	}
}
