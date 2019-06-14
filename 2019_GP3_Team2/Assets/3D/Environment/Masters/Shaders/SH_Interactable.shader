// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Amplify/Environment/Interactable"
{
	Properties
	{
		_ObjectMaxRadius("Object Max Radius", Float) = 5000
		_TileSize("Tile Size", Float) = 1
		_BC("BC", 2D) = "white" {}
		_GMAOH("GMAOH", 2D) = "white" {}
		_N("N", 2D) = "bump" {}
		_T_Clouds_01("T_Clouds_01", 2D) = "white" {}
		_Metal("Metal", Float) = 0
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_NIntensity("N Intensity", Float) = 0
		_HitTiling("Hit Tiling", Float) = 1
		_BCIntensity("BC Intensity", Float) = 1
		_SmoothMax("Smooth Max", Float) = 0.8
		_SmoothMin("Smooth Min", Float) = 0.2
		_BCTint("BC Tint", Color) = (1,1,1,0)
		_AOIntensity("AO Intensity", Float) = 1
		_HitColor("Hit Color", Color) = (0,0.7212253,1,0)
		_HitIntensity("Hit Intensity", Float) = 1
		[Toggle]_ToggleSwitch0("Toggle Switch0", Float) = 1
		_HitPower("Hit Power", Float) = 5
		_HitScale("Hit Scale", Float) = 1
		_HitBias("Hit Bias", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _N;
		uniform float _ObjectMaxRadius;
		uniform float _TileSize;
		uniform float _NIntensity;
		uniform float4 _BCTint;
		uniform sampler2D _BC;
		uniform float _BCIntensity;
		uniform sampler2D _GMAOH;
		uniform float _AOIntensity;
		uniform float _ToggleSwitch0;
		uniform sampler2D _TextureSample3;
		uniform float _HitTiling;
		uniform sampler2D _T_Clouds_01;
		uniform float _HitBias;
		uniform float _HitScale;
		uniform float _HitPower;
		uniform float4 _HitColor;
		uniform float _HitIntensity;
		uniform float _Metal;
		uniform float _SmoothMin;
		uniform float _SmoothMax;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float clampResult5 = clamp( ase_objectScale.x , 0.0 , _ObjectMaxRadius );
			float clampResult4 = clamp( ase_objectScale.y , 0.0 , _ObjectMaxRadius );
			float clampResult3 = clamp( ase_objectScale.z , 0.0 , _ObjectMaxRadius );
			float3 appendResult10 = (float3(( clampResult5 / _TileSize ) , ( clampResult4 / _TileSize ) , ( clampResult3 / _TileSize )));
			float3 temp_output_12_0 = ( float3( i.uv_texcoord ,  0.0 ) * appendResult10 );
			float3 tex2DNode15 = UnpackNormal( tex2D( _N, temp_output_12_0.xy ) );
			float2 appendResult19 = (float2(tex2DNode15.r , tex2DNode15.g));
			float3 appendResult35 = (float3(( appendResult19 * _NIntensity ) , tex2DNode15.b));
			o.Normal = appendResult35;
			float4 temp_output_18_0 = ( _BCTint * tex2D( _BC, temp_output_12_0.xy ) );
			float4 clampResult30 = clamp( ( temp_output_18_0 * _BCIntensity ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 tex2DNode22 = tex2D( _GMAOH, temp_output_12_0.xy );
			float temp_output_44_0 = pow( tex2DNode22.b , _AOIntensity );
			o.Albedo = ( clampResult30 * temp_output_44_0 ).rgb;
			float2 temp_cast_7 = (_HitTiling).xx;
			float2 uv_TexCoord76 = i.uv_texcoord * temp_cast_7;
			float2 panner77 = ( 0.3 * _Time.y * float2( 1,0 ) + uv_TexCoord76);
			float2 temp_cast_8 = (_HitTiling).xx;
			float2 uv_TexCoord82 = i.uv_texcoord * temp_cast_8;
			float2 panner85 = ( 0.5 * _Time.y * float2( 1,0 ) + uv_TexCoord82);
			float4 tex2DNode86 = tex2D( _T_Clouds_01, panner85 );
			float2 appendResult91 = (float2(( ( 1.0 - ( panner77.y * 2.0 ) ) * tex2DNode86.r ) , ( ( 1.0 - ( panner77.y * 2.0 ) ) * tex2DNode86.r )));
			float2 lerpResult93 = lerp( panner77 , appendResult91 , 5.0);
			float4 tex2DNode94 = tex2D( _TextureSample3, lerpResult93 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV46 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode46 = ( _HitBias + _HitScale * pow( 1.0 - fresnelNdotV46, _HitPower ) );
			float4 temp_cast_9 = (0.0).xxxx;
			o.Emission = lerp(( ( ( tex2DNode94 * fresnelNode46 ) * _HitColor ) * _HitIntensity ),temp_cast_9,_ToggleSwitch0).rgb;
			o.Metallic = _Metal;
			float lerpResult26 = lerp( _SmoothMin , _SmoothMax , tex2DNode22.r);
			float clampResult45 = clamp( lerpResult26 , 0.2 , 0.8 );
			o.Smoothness = clampResult45;
			o.Occlusion = temp_output_44_0;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
-1594;69;1666;954;2889.225;1141.43;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;75;-5432.608,-967.3928;Float;False;Property;_HitTiling;Hit Tiling;12;0;Create;True;0;0;False;0;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;76;-5192.608,-1207.393;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;77;-4824.608,-1303.393;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;0.3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;78;-5176.608,-519.3931;Float;False;Constant;_NoisePanner;Noise Panner;7;0;Create;True;0;0;False;0;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;81;-4600.608,-983.3928;Float;False;Constant;_Float5;Float 5;7;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;79;-4616.608,-1367.393;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;82;-5192.608,-711.393;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;80;-4600.608,-1079.392;Float;False;Constant;_Float4;Float 4;7;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-5746.655,1168.198;Float;False;Property;_ObjectMaxRadius;Object Max Radius;0;0;Create;True;0;0;False;0;5000;5000;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectScaleNode;2;-5717.459,826.2436;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-4312.606,-999.3925;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;85;-4904.608,-615.393;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-4296.606,-1127.393;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;88;-4104.606,-999.3925;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;87;-4104.606,-1111.392;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;86;-4616.608,-807.3928;Float;True;Property;_T_Clouds_01;T_Clouds_01;6;0;Create;True;0;0;False;0;29ea05dc23a4307499dd8ee3fb9b31ac;29ea05dc23a4307499dd8ee3fb9b31ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;4;-5411.337,989.5256;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;3;-5410.04,1126.883;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-5418.053,1301.75;Float;False;Property;_TileSize;Tile Size;1;0;Create;True;0;0;False;0;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;5;-5410.337,851.5255;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-3896.606,-1015.392;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-3896.606,-1127.393;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;9;-5060.521,1125.582;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;7;-5061.327,850.0372;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;8;-5061.338,988.5256;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;10;-4799.778,963.8264;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;91;-3688.607,-1095.392;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-4444.246,686.5999;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;92;-3380.219,-1077.858;Float;False;Constant;_Float6;Float 6;7;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-3027.984,-807.2604;Float;False;Property;_HitScale;Hit Scale;24;0;Create;True;0;0;False;0;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-3031.984,-896.2604;Float;False;Property;_HitBias;Hit Bias;25;0;Create;True;0;0;False;0;0;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;93;-3118.132,-1303.108;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-4104.375,939.9631;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-3029.984,-721.2604;Float;False;Property;_HitPower;Hit Power;23;0;Create;True;0;0;False;0;5;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-3304.208,60.13735;Float;False;Property;_BCTint;BC Tint;18;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-3397.909,251.4848;Float;True;Property;_BC;BC;2;0;Create;True;0;0;False;0;2355afdc9e82a2343a49ebe545deb106;83c0c9c3d44391b4fa3d24a6d1f12d29;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;94;-2815.105,-1325.309;Float;True;Property;_TextureSample3;Texture Sample 3;9;0;Create;True;0;0;False;0;29ea05dc23a4307499dd8ee3fb9b31ac;29ea05dc23a4307499dd8ee3fb9b31ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;46;-2720.074,-860.3753;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;51;-2166.609,-830.3171;Float;False;Property;_HitColor;Hit Color;20;0;Create;True;0;0;False;0;0,0.7212253,1,0;0,0.8746936,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2884.124,351.3875;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2385.871,-1315.339;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-2555.632,591.3875;Float;False;Property;_BCIntensity;BC Intensity;15;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;15;-3445.599,911.5575;Float;True;Property;_N;N;4;0;Create;True;0;0;False;0;d5754936fe852ea438ee176367df232e;c6026e0f82cb210429c4de3d846a2f45;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-3038.913,1886.436;Float;False;Property;_SmoothMax;Smooth Max;16;0;Create;True;0;0;False;0;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1804.797,-883.8519;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;19;-2996.713,853.5964;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1824.797,-742.8519;Float;False;Property;_HitIntensity;Hit Intensity;21;0;Create;True;0;0;False;0;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-3016.913,1805.435;Float;False;Property;_SmoothMin;Smooth Min;17;0;Create;True;0;0;False;0;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-3016.713,1075.596;Float;False;Property;_NIntensity;N Intensity;11;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-2357.632,459.3875;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;22;-3388.501,1952.035;Float;True;Property;_GMAOH;GMAOH;3;0;Create;True;0;0;False;0;1693c1fd44f7f7340a8e265ae9f03e69;47d29e5752a3c80429c27c7d98f51a9f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-2920.81,1620.19;Float;False;Property;_AOIntensity;AO Intensity;19;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;30;-2192.632,458.3875;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-1592.657,-820.663;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;44;-2669.81,1601.19;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-2798.713,853.5964;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-1512.139,-525.4193;Float;False;Constant;_Float1;Float 1;16;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;26;-2816.776,1933.912;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-4282.46,-2752.745;Float;False;Property;_Tiling;Tiling;14;0;Create;True;0;0;False;0;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-3967.781,40.41637;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;70;-3318.505,-3031.954;Float;True;Property;_TextureSample2;Texture Sample 2;10;0;Create;True;0;0;False;0;29ea05dc23a4307499dd8ee3fb9b31ac;29ea05dc23a4307499dd8ee3fb9b31ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;37;-2409.775,1136.448;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-4254.929,-2935.599;Float;False;Constant;_Float2;Float 2;23;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;-3877.488,-2706.423;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;34;-3027.438,585.0843;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;35;-2599.005,957.3188;Float;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;45;-2545.913,1933.435;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;39;-3459.436,1236.808;Float;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;False;0;None;a0c7f527fabc84b4785fd80eda855140;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;54;-1030.495,-706.4998;Float;False;Property;_ToggleSwitch0;Toggle Switch0;22;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-2739.448,561.5019;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-3086.551,1186.847;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;69;-3589.617,-2913.225;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-3806.781,309.4166;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;63;-3607.681,-2599.073;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2888.551,1186.847;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;72;-4062.928,-2882.599;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2197.588,327.5487;Float;False;Property;_Metal;Metal;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-3106.551,1407.847;Float;False;Property;_NBakeInt;N Bake Int;13;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;64;-3336.569,-2717.802;Float;True;Property;_TextureSample0;Texture Sample 0;8;0;Create;True;0;0;False;0;29ea05dc23a4307499dd8ee3fb9b31ac;29ea05dc23a4307499dd8ee3fb9b31ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;32;-2619.541,1286.97;Float;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;-2362.64,-1076.628;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;71;-3859.425,-3020.576;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;43;-4280.78,435.4166;Float;False;Constant;_Vector1;Vector 1;14;0;Create;True;0;0;False;0;2,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;41;-4256.78,33.41637;Float;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-4015.78,337.4166;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-1671.055,50.42826;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;40;-4293.78,169.4165;Float;False;Constant;_Vector0;Vector 0;14;0;Create;True;0;0;False;0;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-2897.703,-2810.992;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4.078791,2.039395;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Amplify/Environment/Interactable;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;76;0;75;0
WireConnection;77;0;76;0
WireConnection;79;0;77;0
WireConnection;82;0;75;0
WireConnection;83;0;79;1
WireConnection;83;1;81;0
WireConnection;85;0;82;0
WireConnection;85;2;78;0
WireConnection;84;0;79;1
WireConnection;84;1;80;0
WireConnection;88;0;83;0
WireConnection;87;0;84;0
WireConnection;86;1;85;0
WireConnection;4;0;2;2
WireConnection;4;2;1;0
WireConnection;3;0;2;3
WireConnection;3;2;1;0
WireConnection;5;0;2;1
WireConnection;5;2;1;0
WireConnection;90;0;88;0
WireConnection;90;1;86;1
WireConnection;89;0;87;0
WireConnection;89;1;86;1
WireConnection;9;0;3;0
WireConnection;9;1;6;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;8;0;4;0
WireConnection;8;1;6;0
WireConnection;10;0;7;0
WireConnection;10;1;8;0
WireConnection;10;2;9;0
WireConnection;91;0;89;0
WireConnection;91;1;90;0
WireConnection;93;0;77;0
WireConnection;93;1;91;0
WireConnection;93;2;92;0
WireConnection;12;0;11;0
WireConnection;12;1;10;0
WireConnection;14;1;12;0
WireConnection;94;1;93;0
WireConnection;46;1;60;0
WireConnection;46;2;59;0
WireConnection;46;3;57;0
WireConnection;18;0;13;0
WireConnection;18;1;14;0
WireConnection;68;0;94;0
WireConnection;68;1;46;0
WireConnection;15;1;12;0
WireConnection;47;0;68;0
WireConnection;47;1;51;0
WireConnection;19;0;15;1
WireConnection;19;1;15;2
WireConnection;25;0;18;0
WireConnection;25;1;21;0
WireConnection;22;1;12;0
WireConnection;30;0;25;0
WireConnection;52;0;47;0
WireConnection;52;1;49;0
WireConnection;44;0;22;3
WireConnection;44;1;24;0
WireConnection;23;0;19;0
WireConnection;23;1;16;0
WireConnection;26;0;20;0
WireConnection;26;1;17;0
WireConnection;26;2;22;1
WireConnection;27;0;40;0
WireConnection;27;1;41;0
WireConnection;70;1;69;0
WireConnection;37;0;35;0
WireConnection;37;1;32;0
WireConnection;62;0;65;0
WireConnection;35;0;23;0
WireConnection;35;2;15;3
WireConnection;45;0;26;0
WireConnection;54;0;52;0
WireConnection;54;1;56;0
WireConnection;29;0;18;0
WireConnection;29;1;34;0
WireConnection;33;0;39;1
WireConnection;33;1;39;2
WireConnection;69;0;71;0
WireConnection;28;0;42;0
WireConnection;28;1;42;0
WireConnection;63;0;62;0
WireConnection;38;0;33;0
WireConnection;38;1;36;0
WireConnection;72;0;73;0
WireConnection;72;1;65;0
WireConnection;64;1;63;0
WireConnection;32;0;38;0
WireConnection;32;2;39;3
WireConnection;96;0;94;0
WireConnection;96;1;46;0
WireConnection;71;0;72;0
WireConnection;42;0;40;0
WireConnection;42;1;43;0
WireConnection;97;0;30;0
WireConnection;97;1;44;0
WireConnection;74;0;70;0
WireConnection;74;1;64;0
WireConnection;0;0;97;0
WireConnection;0;1;35;0
WireConnection;0;2;54;0
WireConnection;0;3;31;0
WireConnection;0;4;45;0
WireConnection;0;5;44;0
ASEEND*/
//CHKSM=64721097F678E38C17B9D951FBA1D843038E0EC6