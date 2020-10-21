using System.Collections;
using System.Collections.Generic;
using UnityEngine;

 
public class GaussianBlur : PostEffectsBase
{
    public Shader gaussianBlurShader;
    Material gaussianBlurMaterial;
    public Material material
    {
        get
        {
            gaussianBlurMaterial = CheckShaderAndCreateMaterial(gaussianBlurShader, gaussianBlurMaterial);
            return gaussianBlurMaterial;
        }
    }
    [Range(0,4)]
    public int iteration = 2;
    [Range(0.2f, 3f)]
    public float blurSpread = 0.6f;

    [Range(1, 8)]
    public int downSample = 4;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material != null)
        {
            int rtWidth = source.width / downSample;
            int rtHeight = source.height/downSample;
            RenderTexture buffer0 = RenderTexture.GetTemporary(rtWidth, rtHeight, 0);
            RenderTexture buffer1 = RenderTexture.GetTemporary(rtWidth, rtHeight, 0);
            Graphics.Blit(source, buffer0);
            for (int i = 0; i < iteration; i++) {
                //material.SetFloat("_BlurSize", 1 + i * blurSpread);
                //RenderTexture buffer1 = RenderTexture.GetTemporary(rtWidth, rtHeight, 0);
                //Graphics.Blit(buffer0, buffer1, material, 0);
                //RenderTexture.ReleaseTemporary(buffer0);
                //buffer0 = buffer1;
                //buffer1 = RenderTexture.GetTemporary(rtWidth, rtHeight, 0);
                //Graphics.Blit(buffer1, buffer0, material, 1);
                //RenderTexture.ReleaseTemporary(buffer0);
                //buffer0 = buffer1;

                material.SetFloat("_BlurSize", 1 + i * blurSpread);
                Graphics.Blit(buffer0, buffer1, material, 0);
                Graphics.Blit(buffer1, buffer0, material, 1);

            }
            Graphics.Blit(buffer0, destination);
            RenderTexture.ReleaseTemporary(buffer0);
            RenderTexture.ReleaseTemporary(buffer1);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}
