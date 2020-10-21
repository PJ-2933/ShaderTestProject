using System.Collections;
using System.Collections.Generic;
using UnityEngine;

 
public class EdgeDetection : PostEffectsBase
{
    public Shader edgeDetectionShader ;
    Material edgeDetectionMaterial;
    public Material material
    {
        get
        {
            edgeDetectionMaterial = CheckShaderAndCreateMaterial(edgeDetectionShader, edgeDetectionMaterial);
            return edgeDetectionMaterial;
        }
    }
    [Range(0,1f)]
    public float edgeOnly = 1;
     
    public Color edgeColor = Color.blue;
    
    public Color BGColor = Color.white;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material != null)
        {
            material.SetFloat("_EdgeOnly", edgeOnly);
            material.SetColor("_EdgeColor", edgeColor);
            material.SetColor("_BGColor", BGColor);
            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}
