using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class NotchDisplay : MonoBehaviour
{
    [Range(10, 100)]
    public int BoundW = 50;

    [Range(50, 500)]
    public int BoundH = 120;

    private RenderTexture accumTexture;
    private Shader shader;
    private Material m_Material;

    protected Material material
    {
        get
        {
            if (m_Material == null)
            {
                if(shader == null)
                {
                    shader = Shader.Find("Custom/NotchDisplay");
                }
                if (shader == null)
                {
                    Debug.LogError("ImageEffectShader is Null");
                    return null;
                }
                m_Material = new Material(shader);
                m_Material.hideFlags = HideFlags.HideAndDontSave;
            }
            return m_Material;
        }
    }

    void Start()
    {
        shader = Shader.Find("Custom/NotchDisplay");
    }

    void OnDisable()
    {
        if (m_Material)
        {
            DestroyImmediate(m_Material);
        }
        DestroyImmediate(accumTexture);
    }
    

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (accumTexture == null || accumTexture.width != source.width || accumTexture.height != source.height)
        {
            DestroyImmediate(accumTexture);
            accumTexture = new RenderTexture(source.width, source.height, 0);
            accumTexture.hideFlags = HideFlags.HideAndDontSave;
            Graphics.Blit(source, accumTexture);

        }
        SetBoundPoint(source.height / 2);

        material.SetTexture("_MainTex", accumTexture);
        accumTexture.MarkRestoreExpected();

        Graphics.Blit(source, accumTexture, material);
        Graphics.Blit(accumTexture, destination);
    }

    void SetBoundPoint(int halfScreenHeight)
    {
        int halfBoundY = BoundH / 2;
        material.SetVector("_W_Bound1", new Vector4(BoundW, halfScreenHeight - halfBoundY));
        material.SetVector("_W_Bound2", new Vector4(BoundW, halfScreenHeight + halfBoundY));
        material.SetVector("_H_Bound1", new Vector4(0, halfScreenHeight - halfBoundY - BoundW * 0.25f));
        material.SetVector("_H_Bound2", new Vector4(0, halfScreenHeight + halfBoundY + BoundW * 0.25f));
    }
}
