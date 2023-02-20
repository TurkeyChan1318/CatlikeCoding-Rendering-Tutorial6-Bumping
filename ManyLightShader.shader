// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/ManyLightShader"
{
    Properties//属性面板，用来说明参数属性
    {
        _Tint ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo", 2D) = "white"{}
        //_SpecularTint ("SpecularColor", Color) = (1, 1, 1, 1) //如果是金属工作流程则不需要高光颜色
        [NoScaleOffset] _NormalMap ("Normals", 2D) = "bump" {}
        _BumpScale ("Bump Scale", Range(0, 1)) = 0.25
        [Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
        _Smoothness ("Smoothness", Range(0, 1)) = 1
        _DetailTex ("Detail Texture", 2D) = "gray" {}
        [NoScaleOffset] _DetailNormalMap ("Detail Normals", 2D) = "bump" {}
		_DetailBumpScale ("Detail Bump Scale", Range(0, 1)) = 1

    }

    CGINCLUDE

	#define BINORMAL_PER_FRAGMENT

	ENDCG
    
    SubShader
    {
        Pass//基础灯光通道
        {
            Tags{
                "LightMode" = "ForwardBase"
            }
            CGPROGRAM

            #pragma target 3.0

            #pragma multi_compile _ VERTEXLIGHT_ON//启用顶点灯

            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram

            #include "My Lighting.cginc"

            ENDCG
        }

        Pass//其他灯光
        {
            Tags{
                "LightMode" = "ForwardAdd"
            }

            Blend One One
            Zwrite Off

            CGPROGRAM

            #pragma target 3.0

            #pragma multi_compile DIRECTIONAL POINT SPOT

            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram

            #include "My Lighting.cginc"

            ENDCG
        }
    }
}