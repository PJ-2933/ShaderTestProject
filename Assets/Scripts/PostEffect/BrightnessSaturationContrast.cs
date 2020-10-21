using System.Collections;
using System.Collections.Generic;
using UnityEngine;

 
public class BrightnessSaturationContrast : PostEffectsBase
{
    public Shader shaderBSC;
    Material matBSC;
    public Material material
    {
        get
        {
            matBSC = CheckShaderAndCreateMaterial(shaderBSC, matBSC);
            return matBSC;
        }
    }
    [Range(0,3f)]
    public float brightness = 1;
    [Range(0, 3f)]
    public float saturation = 1;
    [Range(0, 3f)]
    public float contrast = 1;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material != null)
        {
            material.SetFloat("_Brightness", brightness);
            material.SetFloat("_Saturation", saturation);
            material.SetFloat("_Contrast", contrast);
            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}
