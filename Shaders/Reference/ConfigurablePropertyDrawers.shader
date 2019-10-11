// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ConfigurablePropertyDrawers.shader" company="Supyrb">
//   Copyright (c) 2018 Supyrb. All rights reserved.
// </copyright>
// <repository>
//   https://github.com/supyrb/ConfigurableShaders
// </repository>
// <author>
//   Johannes Deml
//   public@deml.io
// </author>
// <documentation>
//   https://github.com/supyrb/ConfigurableShaders/wiki/PropertyDrawers
// </documentation>
// --------------------------------------------------------------------------------------------------------------------
Shader "Configurable/Reference/PropertyDrawers"
{
	Properties
	{		
		[HeaderHelpURL(HeaderHelp URL, https, github.com supyrb ConfigurableShaders wiki PropertyDrawers)]
		[EightBit] _EightBit ("EightBit", Int) = 0
		[RangeMapper01] _RangeMapper01("RangeMapper01", Vector) = (0,1,0,1)
		[RangeMapper] _RangeMapper("RangeMapper", Vector) = (0,1,0,1)
		[SimpleToggle] _SimpleToggle("SimpleToggle", Float) = 0.0
		[Tooltip(Tooltip Text)] _Tooltip("Tooltip", Float) = 0.0
	}
	
	CGINCLUDE
	#include "UnityCG.cginc"
	
	struct appdata_t {
		float4 vertex : POSITION;
		UNITY_VERTEX_INPUT_INSTANCE_ID
	};
	
	struct v2f
	{
		float4 vertex : SV_POSITION;
		UNITY_VERTEX_OUTPUT_STEREO
	};
	
	v2f vert (appdata_t v)
	{
		v2f o;
		UNITY_SETUP_INSTANCE_ID(v);
		UNITY_INITIALIZE_OUTPUT(v2f, o);
		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
		
		o.vertex = UnityObjectToClipPos(v.vertex);
		return o;
	}
	
	half4 frag (v2f i) : SV_Target
	{
		UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
		
		return half4(1,1,1,1);
	}
	
	struct v2fShadow {
		V2F_SHADOW_CASTER;
		UNITY_VERTEX_OUTPUT_STEREO
	};

	v2fShadow vertShadow( appdata_base v )
	{
		v2fShadow o;
		UNITY_SETUP_INSTANCE_ID(v);
		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
		TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
		return o;
	}

	float4 fragShadow( v2fShadow i ) : SV_Target
	{
		SHADOW_CASTER_FRAGMENT(i)
	}
	
	ENDCG
		
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue" = "Geometry" }
		LOD 100
		Cull Off
		ZWrite On
		ZTest LEqual
		ColorMask RGBA

		Pass
		{			
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}
		
		// Pass to render object as a shadow caster
		Pass
		{
			Name "ShadowCaster"
			Tags { "LightMode" = "ShadowCaster" }
			
			CGPROGRAM
			#pragma vertex vertShadow
			#pragma fragment fragShadow
			#pragma target 2.0
			#pragma multi_compile_shadowcaster
			ENDCG
		}
	}
}