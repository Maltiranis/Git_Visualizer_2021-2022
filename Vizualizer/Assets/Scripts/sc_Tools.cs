using UnityEngine;

public static class sc_Tools
{
    public static void SetNewMaterials(GameObject go, Material[] mat)
    {
        MeshRenderer goRend = go.GetComponent<MeshRenderer>();
        goRend.materials = mat;
    }

    public static void SetNewColor(GameObject gameobj, Color col)
    {
        MeshRenderer goRend = gameobj.GetComponent<MeshRenderer>();
        goRend.material.color = col;
    }

    public static void SetActiveGameObjects(GameObject[] gameObjects, bool active)
    {
        foreach (GameObject go in gameObjects)
        {
            go.SetActive(active);
        }
    }
}
