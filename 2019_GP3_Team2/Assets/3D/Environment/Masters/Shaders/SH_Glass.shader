// Upgrade NOTE: upgraded instancing buffer 'AmplifyEnviromentMaster' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Amplify/Enviroment/Master"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_T_Glass_N("T_Glass_N", 2D) = "white" {}
		_NormalScale("NormalScale", Range( 0 , 10)) = 5
		_T_Glass_Noise_001_("T_Glass_Noise_001_", 2D) = "white" {}
		_SmoothnessScale("SmoothnessScale", Range( 0 , 10)) = 3
		_SmoothnessIntensity("SmoothnessIntensity", Float) = 7.04
		[Header(Refraction)]
		_ChromaticAberration("Chromatic Aberration", Range( 0 , 0.3)) = 0.1
		_ReflectionFront("Reflection Front", Range( 0 , 1)) = 0.05
		_ReflectionSide("Reflection Side", Range( 0 , 2)) = 1
		_OpacityFront("Opacity Front", Range( 0 , 1)) = 0.05
		_OpacitySide("Opacity Side", Range( 0 , 1)) = 0.2
		_RefractionFront("Refraction Front", Range( 0 , 2)) = 1
		_RefractionSide("Refraction Side", Range( 0 , 2)) = 0.5
		_FresnelPower("Fresnel Power", Range( 0 , 5)) = 1.5
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma multi_compile _ALPHAPREMULTIPLY_ON
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
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float4 screenPos;
		};

		uniform sampler2D _T_Glass_N;
		uniform sampler2D _T_Glass_Noise_001_;
		uniform sampler2D _GrabTexture;
		uniform float _ChromaticAberration;

		UNITY_INSTANCING_BUFFER_START(AmplifyEnviromentMaster)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
#define _Color_arr AmplifyEnviromentMaster
			UNITY_DEFINE_INSTANCED_PROP(float, _NormalScale)
#define _NormalScale_arr AmplifyEnviromentMaster
			UNITY_DEFINE_INSTANCED_PROP(float, _ReflectionFront)
#define _ReflectionFront_arr AmplifyEnviromentMaster
			UNITY_DEFINE_INSTANCED_PROP(float, _ReflectionSide)
#define _ReflectionSide_arr AmplifyEnviromentMaster
			UNITY_DEFINE_INSTANCED_PROP(float, _FresnelPower)
#define _FresnelPower_arr AmplifyEnviromentMaster
			UNITY_DEFINE_INSTANCED_PROP(float, _SmoothnessScale)
#define _SmoothnessScale_arr AmplifyEnviromentMaster
			UNITY_DEFINE_INSTANCED_PROP(float, _SmoothnessIntensity)
#define _SmoothnessIntensity_arr AmplifyEnviromentMaster
			UNITY_DEFINE_INSTANCED_PROP(float, _OpacityFront)
#define _OpacityFront_arr AmplifyEnviromentMaster
			UNITY_DEFINE_INSTANCED_PROP(float, _OpacitySide)
#define _OpacitySide_arr AmplifyEnviromentMaster
			UNITY_DEFINE_INSTANCED_PROP(float, _RefractionFront)
#define _RefractionFront_arr AmplifyEnviromentMaster
			UNITY_DEFINE_INSTANCED_PROP(float, _RefractionSide)
#define _RefractionSide_arr AmplifyEnviromentMaster
		UNITY_INSTANCING_BUFFER_END(AmplifyEnviromentMaster)

		inline float4 Refraction( Input i, SurfaceOutputStandard o, float indexOfRefraction, float chomaticAberration ) {
			float3 worldNormal = o.Normal;
			float4 screenPos = i.screenPos;
			#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
			#else
				float scale = 1.0;
			#endif
			float halfPosW = screenPos.w * 0.5;
			screenPos.y = ( screenPos.y - halfPosW ) * _ProjectionParams.x * scale + halfPosW;
			#if SHADER_API_D3D9 || SHADER_API_D3D11
				screenPos.w += 0.00000000001;
			#endif
			float2 projScreenPos = ( screenPos / screenPos.w ).xy;
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float3 refractionOffset = ( ( ( ( indexOfRefraction - 1.0 ) * mul( UNITY_MATRIX_V, float4( worldNormal, 0.0 ) ) ) * ( 1.0 / ( screenPos.z + 1.0 ) ) ) * ( 1.0 - dot( worldNormal, worldViewDir ) ) );
			float2 cameraRefraction = float2( refractionOffset.x, -( refractionOffset.y * _ProjectionParams.x ) );
			float4 redAlpha = tex2D( _GrabTexture, ( projScreenPos + cameraRefraction ) );
			float green = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 - chomaticAberration ) ) ) ).g;
			float blue = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 + chomaticAberration ) ) ) ).b;
			return float4( redAlpha.r, green, blue, redAlpha.a );
		}

		void RefractionF( Input i, SurfaceOutputStandard o, inout half4 color )
		{
			#ifdef UNITY_PASS_FORWARDBASE
			float _RefractionFront_Instance = UNITY_ACCESS_INSTANCED_PROP(_RefractionFront_arr, _RefractionFront);
			float _RefractionSide_Instance = UNITY_ACCESS_INSTANCED_PROP(_RefractionSide_arr, _RefractionSide);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float _FresnelPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_FresnelPower_arr, _FresnelPower);
			float fresnelNdotV32 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode32 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV32, _FresnelPower_Instance ) );
			float lerpResult26 = lerp( _RefractionFront_Instance , _RefractionSide_Instance , fresnelNode32);
			color.rgb = color.rgb + Refraction( i, o, lerpResult26, _ChromaticAberration ) * ( 1 - color.a );
			color.a = 1;
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldPos = i.worldPos;
			float _NormalScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_NormalScale_arr, _NormalScale);
			o.Normal = tex2D( _T_Glass_N, ( ase_worldPos / _NormalScale_Instance ).xy ).rgb;
			float4 _Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Color_arr, _Color);
			o.Albedo = _Color_Instance.rgb;
			float _ReflectionFront_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReflectionFront_arr, _ReflectionFront);
			float _ReflectionSide_Instance = UNITY_ACCESS_INSTANCED_PROP(_ReflectionSide_arr, _ReflectionSide);
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float _FresnelPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_FresnelPower_arr, _FresnelPower);
			float fresnelNdotV32 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode32 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV32, _FresnelPower_Instance ) );
			float lerpResult43 = lerp( _ReflectionFront_Instance , _ReflectionSide_Instance , fresnelNode32);
			o.Metallic = lerpResult43;
			float _SmoothnessScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmoothnessScale_arr, _SmoothnessScale);
			float _SmoothnessIntensity_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmoothnessIntensity_arr, _SmoothnessIntensity);
			o.Smoothness = ( tex2D( _T_Glass_Noise_001_, ( ase_worldPos / _SmoothnessScale_Instance ).xy ) * _SmoothnessIntensity_Instance ).r;
			float _OpacityFront_Instance = UNITY_ACCESS_INSTANCED_PROP(_OpacityFront_arr, _OpacityFront);
			float _OpacitySide_Instance = UNITY_ACCESS_INSTANCED_PROP(_OpacitySide_arr, _OpacitySide);
			float lerpResult27 = lerp( _OpacityFront_Instance , _OpacitySide_Instance , fresnelNode32);
			o.Alpha = lerpResult27;
			o.Normal = o.Normal + 0.00001 * i.screenPos * i.worldPos;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha finalcolor:RefractionF fullforwardshadows exclude_path:deferred 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 screenPos : TEXCOORD1;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
-1282;41;1209;854;1539.277;1158.268;1.82628;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;62;-929.3073,-760.1948;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;63;-892.0139,-610.7675;Float;False;InstancedProperty;_SmoothnessScale;SmoothnessScale;5;0;Create;True;0;0;False;0;3;8;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;60;-914.3074,-1087.195;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;59;-878.2581,-937.7674;Float;False;InstancedProperty;_NormalScale;NormalScale;3;0;Create;True;0;0;False;0;5;8;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1315.668,328.0334;Float;False;InstancedProperty;_FresnelPower;Fresnel Power;15;0;Create;True;0;0;False;0;1.5;1.5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;64;-538.3387,-697.9929;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-553.5068,389.2679;Float;False;InstancedProperty;_OpacitySide;Opacity Side;12;0;Create;True;0;0;False;0;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-306.1426,-492.7444;Float;False;InstancedProperty;_SmoothnessIntensity;SmoothnessIntensity;6;0;Create;True;0;0;False;0;7.04;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;32;-988.9035,238.8391;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;55;-388.0493,-709.2603;Float;True;Property;_T_Glass_Noise_001_;T_Glass_Noise_001_;4;0;Create;True;0;0;False;0;6cebece1c14fdda4e9dae708e127ff53;6cebece1c14fdda4e9dae708e127ff53;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;-558.1877,300.8418;Float;False;InstancedProperty;_OpacityFront;Opacity Front;11;0;Create;True;0;0;False;0;0.05;0.05;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-791.8003,-328.1161;Float;False;InstancedProperty;_ReflectionSide;Reflection Side;10;0;Create;True;0;0;False;0;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-546.7836,34.05523;Float;False;InstancedProperty;_RefractionSide;Refraction Side;14;0;Create;True;0;0;False;0;0.5;0.5;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-553.7173,-46.34916;Float;False;InstancedProperty;_RefractionFront;Refraction Front;13;0;Create;True;0;0;False;0;1;1.2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;61;-710.8284,-1060.56;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-798.4447,-415.9816;Float;False;InstancedProperty;_ReflectionFront;Reflection Front;9;0;Create;True;0;0;False;0;0.05;0.05;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-53.73189,-591.3734;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;52;-356.7489,-999.0848;Float;True;Property;_T_Glass_N;T_Glass_N;2;0;Create;True;0;0;False;0;cfbf1b6257f67234597f896d83f6b5ac;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;43;-459.3531,-332.9141;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;39;270.2498,-681.9487;Float;False;InstancedProperty;_Color;Color;1;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;26;-210.1808,103.7772;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;27;-235.9711,624.1282;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;565,-129;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Amplify/Enviroment/Master;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;2;7;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;64;0;62;0
WireConnection;64;1;63;0
WireConnection;32;3;34;0
WireConnection;55;1;64;0
WireConnection;61;0;60;0
WireConnection;61;1;59;0
WireConnection;57;0;55;0
WireConnection;57;1;42;0
WireConnection;52;1;61;0
WireConnection;43;0;23;0
WireConnection;43;1;44;0
WireConnection;43;2;32;0
WireConnection;26;0;30;0
WireConnection;26;1;31;0
WireConnection;26;2;32;0
WireConnection;27;0;28;0
WireConnection;27;1;29;0
WireConnection;27;2;32;0
WireConnection;0;0;39;0
WireConnection;0;1;52;0
WireConnection;0;3;43;0
WireConnection;0;4;57;0
WireConnection;0;8;26;0
WireConnection;0;9;27;0
ASEEND*/
//CHKSM=B2F6A180EFEC8C307A12732A79EE9D934485F1EB