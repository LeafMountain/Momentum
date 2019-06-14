// Upgrade NOTE: upgraded instancing buffer 'AmplifyEnvironmentWater' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Amplify/Environment/Water"
{
	Properties
	{
		_DarkColor("DarkColor", Color) = (0,0,0,0)
		_LightColor("LightColor", Color) = (0,0,0,0)
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.75
		_RefractionAmount("RefractionAmount", Range( 0 , 0.00015)) = 0.00015
		[Header(Refraction)]
		_ChromaticAberration("Chromatic Aberration", Range( 0 , 0.3)) = 0.1
		_Normal1("Normal1", 2D) = "white" {}
		_Normal2("Normal2", 2D) = "white" {}
		_WaveScale("WaveScale", Range( 1 , 10)) = 5
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.5
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

		uniform sampler2D _Normal1;
		uniform sampler2D _Normal2;
		uniform sampler2D _GrabTexture;
		uniform float _ChromaticAberration;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;

		UNITY_INSTANCING_BUFFER_START(AmplifyEnvironmentWater)
			UNITY_DEFINE_INSTANCED_PROP(float4, _DarkColor)
#define _DarkColor_arr AmplifyEnvironmentWater
			UNITY_DEFINE_INSTANCED_PROP(float4, _LightColor)
#define _LightColor_arr AmplifyEnvironmentWater
			UNITY_DEFINE_INSTANCED_PROP(float, _WaveScale)
#define _WaveScale_arr AmplifyEnvironmentWater
			UNITY_DEFINE_INSTANCED_PROP(float, _Smoothness)
#define _Smoothness_arr AmplifyEnvironmentWater
			UNITY_DEFINE_INSTANCED_PROP(float, _RefractionAmount)
#define _RefractionAmount_arr AmplifyEnvironmentWater
		UNITY_INSTANCING_BUFFER_END(AmplifyEnvironmentWater)

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
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth129 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float distanceDepth129 = abs( ( screenDepth129 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			float _RefractionAmount_Instance = UNITY_ACCESS_INSTANCED_PROP(_RefractionAmount_arr, _RefractionAmount);
			color.rgb = color.rgb + Refraction( i, o, ( distanceDepth129 * _RefractionAmount_Instance ), _ChromaticAberration ) * ( 1 - color.a );
			color.a = 1;
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldPos = i.worldPos;
			float _WaveScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaveScale_arr, _WaveScale);
			float2 temp_output_46_0 = (( ase_worldPos / _WaveScale_Instance )).xz;
			float2 panner47 = ( 1.0 * _Time.y * float2( -0.01,0.01 ) + temp_output_46_0);
			float2 panner48 = ( 1.0 * _Time.y * float2( -0.012,-0.015 ) + temp_output_46_0);
			o.Normal = ( ( tex2D( _Normal1, panner47 ) + tex2D( _Normal2, panner48 ) ) * float4( float3(1,1,0.5) , 0.0 ) ).rgb;
			float4 _DarkColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_DarkColor_arr, _DarkColor);
			float4 _LightColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_LightColor_arr, _LightColor);
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV135 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode135 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV135, 5.0 ) );
			float4 lerpResult112 = lerp( _DarkColor_Instance , _LightColor_Instance , fresnelNode135);
			o.Albedo = lerpResult112.rgb;
			float _Smoothness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Smoothness_arr, _Smoothness);
			o.Smoothness = _Smoothness_Instance;
			float fresnelNdotV132 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode132 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV132, 3.0 ) );
			o.Alpha = ( fresnelNode132 * ( 1.0 - 0.0 ) );
			o.Normal = o.Normal + 0.00001 * i.screenPos * i.worldPos;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha finalcolor:RefractionF fullforwardshadows exclude_path:deferred nofog 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.5
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
-1673;47;1666;954;700.8198;2103.283;2.802129;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;42;179.7354,-919.8263;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;44;215.7847,-770.399;Float;False;InstancedProperty;_WaveScale;WaveScale;8;0;Create;True;0;0;False;0;5;5.69;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;43;383.2143,-893.1916;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;46;507.221,-899.6816;Float;True;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;48;768.6064,-768.937;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.012,-0.015;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;47;763.1804,-872.6339;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.01,0.01;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;8;965.5615,-966.4669;Float;True;Property;_Normal1;Normal1;6;0;Create;True;0;0;False;0;None;1b8e99555b6227d40afa1f4a8f65780f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;980.8075,-747.8062;Float;True;Property;_Normal2;Normal2;7;0;Create;True;0;0;False;0;None;508ffce1753243f4eb064cb9d8d72191;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;49;1320.096,-883.1378;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;129;787.669,-124.4418;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;51;1302.902,-713.5547;Float;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;False;0;1,1,0.5;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FresnelNode;132;790.9371,-434.6467;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;111;895.9161,-1649.49;Float;False;InstancedProperty;_DarkColor;DarkColor;0;0;Create;True;0;0;False;0;0,0,0,0;0.1411761,0.2117643,0.2705878,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;119;782.8471,26.57574;Float;False;InstancedProperty;_RefractionAmount;RefractionAmount;3;0;Create;True;0;0;False;0;0.00015;2.08E-05;0;0.00015;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;114;868.124,-1433.095;Float;False;InstancedProperty;_LightColor;LightColor;1;0;Create;True;0;0;False;0;0,0,0,0;0.4823529,0.6980392,0.7215686,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;135;961.2762,-1243.913;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;130;1081.324,-231.9124;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;1047.606,-7.018991;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;1328.495,-379.1766;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;112;1274.237,-1379.642;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;148;1684.819,-1533.242;Float;False;Property;_IlluminationFactor;Illumination Factor;9;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;1552.395,-483.5287;Float;False;InstancedProperty;_Smoothness;Smoothness;2;0;Create;True;0;0;False;0;0.75;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;1509.06,-901.357;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2921.173,-701.6688;Float;False;True;3;Float;ASEMaterialInspector;0;0;Standard;Amplify/Environment/Water;False;False;False;False;False;False;False;False;False;True;False;False;False;False;True;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;4;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;43;0;42;0
WireConnection;43;1;44;0
WireConnection;46;0;43;0
WireConnection;48;0;46;0
WireConnection;47;0;46;0
WireConnection;8;1;47;0
WireConnection;22;1;48;0
WireConnection;49;0;8;0
WireConnection;49;1;22;0
WireConnection;134;0;129;0
WireConnection;134;1;119;0
WireConnection;131;0;132;0
WireConnection;131;1;130;0
WireConnection;112;0;111;0
WireConnection;112;1;114;0
WireConnection;112;2;135;0
WireConnection;50;0;49;0
WireConnection;50;1;51;0
WireConnection;0;0;112;0
WireConnection;0;1;50;0
WireConnection;0;4;57;0
WireConnection;0;8;134;0
WireConnection;0;9;131;0
ASEEND*/
//CHKSM=68EDE5CE81AEA106F35D3430E412F41BED1C0235