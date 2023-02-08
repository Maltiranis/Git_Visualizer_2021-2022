using UnityEngine;

[CreateAssetMenu(fileName = "profile", menuName = "ScriptableObjects/scriptable_VehicleProfil", order = 1)]
public class scriptable_VehicleProfil : ScriptableObject
{
    public float translateSpeed = 2.0f;
    public float rotateSpeed = 1.5f;
    public float lookSpeed = 30.0f;
    public float forwardPow = 0.05f;
}
