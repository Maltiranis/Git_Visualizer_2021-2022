using UnityEngine;

public class DestroyTimer : MonoBehaviour
{
    public void SetDestruction(float time)
    {
        Destroy(gameObject, time);
    }
}
