using System.Collections;
using System.Collections.Generic;
using UnityEngine;

 
public class Bloom : PostEffectsBase
{
    public Shader bloomShader;
    Material bloomMaterial;
    public Material material
    {
        get
        {
            bloomMaterial = CheckShaderAndCreateMaterial(bloomShader, bloomMaterial);
            return bloomMaterial;
        }
    }
    [Range(0,4)]
    public int iteration = 2;
    [Range(0.2f, 3f)]
    public float blurSpread = 0.6f;

    [Range(1, 8)]
    public int downSample = 4;
    [Range(0, 4f)]
    public float lumianceThreshold = 0.6f;


    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material != null)
        {
            material.SetFloat("_LumianceThreshold", lumianceThreshold);
            int rtWidth = source.width / downSample;
            int rtHeight = source.height/downSample;
            RenderTexture buffer0 = RenderTexture.GetTemporary(rtWidth, rtHeight, 0);
            RenderTexture buffer1 = RenderTexture.GetTemporary(rtWidth, rtHeight, 0);
            //提取亮步
            Graphics.Blit(source, buffer0,material,0);

            //高斯模糊亮部
            for (int i = 0; i < iteration; i++) {   
                material.SetFloat("_BlurSize", 1 + i * blurSpread);
                Graphics.Blit(buffer0, buffer1, material, 1);
                Graphics.Blit(buffer1, buffer0, material, 2);

            }
            //传入模糊后的亮部
            material.SetTexture("_Bloom", buffer0);

            //混合原图和亮部
            Graphics.Blit(source, destination,material,3);

            RenderTexture.ReleaseTemporary(buffer0);
            RenderTexture.ReleaseTemporary(buffer1);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}
