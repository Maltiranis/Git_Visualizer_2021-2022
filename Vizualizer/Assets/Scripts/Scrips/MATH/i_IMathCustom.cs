using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class i_IMathCustom : MonoBehaviour, IRotateAroundPivot<Vector3, Vector3, Vector3>
{
    public Vector3 RotateAroundPivot(Vector3 point, Vector3 pivot, Vector3 angles)
    {
        Vector3 dir = point - pivot;

        dir = Quaternion.Euler(angles) * dir;
        point = dir + pivot;

        return point;
    }
}

public class i_IDebug : MonoBehaviour, IDebug<string>
{
    public void DebugCustom(string message)
    {
        Debug.Log(message);
    }
}

public interface IRotateAroundPivot<A, B, C>
{
    Vector3 RotateAroundPivot(A point, B pivot, C angles);
}

public interface IDebug<T>
{
    void DebugCustom(T message);
}