using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class PostEffectsBase : MonoBehaviour
{
    bool CheckSupport()
    {
        if (!SystemInfo.supportsImageEffects || !SystemInfo.supportsRenderTextures)
        {
            Debug.LogError("This platform don't support image effects or renderTexture!");
            return false;
        }
        return true;
    }
    void CheckResources()
    {
        if (!CheckSupport()) NotSupported();
    }
    void NotSupported()
    {
        enabled = false;
    }
    protected Material CheckShaderAndCreateMaterial(Shader shader,Material material)
    {
        if (shader == null||!shader.isSupported) return null;
        if ( material && material.shader == shader) return material;
        else
        {
            material = new Material(shader);
            material.hideFlags = HideFlags.DontSave;
            if (material) return material;
            else return null;
        }
    }


    // Start is called before the first frame update
    void Start()
    {
        CheckResources();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
