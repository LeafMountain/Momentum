// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Amplify/Environment/Y-Projection"
{
	Properties
	{
		_N("N", 2D) = "white" {}
		_Tiling("Tiling", Float) = 1
		_GMAOH("GMAOH", 2D) = "white" {}
		_BC("BC", 2D) = "white" {}
		_NIntensity("N Intensity", Float) = 1
		_BCIntensity("BC Intensity", Float) = 1
		_BCTint("BC Tint", Color) = (1,1,1,0)
		_SmoothMax("Smooth Max", Float) = 0.8
		_SmoothMin("Smooth Min", Float) = 0.2
		_AOInt("AO Int", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#define ASE_TEXTURE_PARAMS(textureName) textureName

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
		};

		uniform sampler2D _N;
		uniform float _Tiling;
		uniform float _NIntensity;
		uniform float4 _BCTint;
		uniform sampler2D _BC;
		uniform float _BCIntensity;
		uniform sampler2D _GMAOH;
		uniform float _AOInt;
		uniform float _SmoothMin;
		uniform float _SmoothMax;


		inline float3 TriplanarSamplingSNF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
			zNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			xNorm.xyz = half3( UnpackNormal( xNorm ).xy * float2( nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
			yNorm.xyz = half3( UnpackNormal( yNorm ).xy * float2( nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
			zNorm.xyz = half3( UnpackNormal( zNorm ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
			return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
		}


		inline float4 TriplanarSamplingSF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
			zNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult44 = (float2(_Tiling , _Tiling));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 triplanar26 = TriplanarSamplingSNF( _N, ase_worldPos, ase_worldNormal, 1.0, appendResult44, 1.0, 0 );
			float3 tanTriplanarNormal26 = mul( ase_worldToTangent, triplanar26 );
			float2 appendResult45 = (float2(tanTriplanarNormal26.x , tanTriplanarNormal26.y));
			float3 appendResult48 = (float3(( appendResult45 * _NIntensity ) , tanTriplanarNormal26.z));
			o.Normal = appendResult48;
			float4 triplanar15 = TriplanarSamplingSF( _BC, ase_worldPos, ase_worldNormal, 1.0, appendResult44, 1.0, 0 );
			float4 temp_output_50_0 = ( _BCTint * triplanar15 );
			float4 clampResult52 = clamp( ( temp_output_50_0 * _BCIntensity ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 triplanar22 = TriplanarSamplingSF( _GMAOH, ase_worldPos, ase_worldNormal, 1.0, appendResult44, 1.0, 0 );
			float4 break24 = triplanar22;
			o.Albedo = ( clampResult52 * pow( break24.z , _AOInt ) ).rgb;
			o.Metallic = break24.y;
			float lerpResult58 = lerp( _SmoothMin , _SmoothMax , break24.x);
			float clampResult59 = clamp( lerpResult58 , 0.2 , 0.8 );
			o.Smoothness = clampResult59;
			float temp_output_24_2 = break24.z;
			o.Occlusion = temp_output_24_2;
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
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
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
-1675;84;1666;954;1404.576;434.6356;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;11;-4232.907,23.02512;Float;False;Property;_Tiling;Tiling;1;0;Create;True;0;0;False;0;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;44;-3260.25,19.62681;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-2702.882,-748.3093;Float;True;Property;_BC;BC;3;0;Create;True;0;0;False;0;None;441f8499bc1372749aa845ea2c4aeb8c;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;20;-2699.407,-161.5036;Float;True;Property;_N;N;0;0;Create;True;0;0;False;0;None;92b763e15b88b7244a5181b4e1618478;True;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;23;-3019.376,455.3942;Float;True;Property;_GMAOH;GMAOH;2;0;Create;True;0;0;False;0;None;ed983a0839cc9374cb06e9aae9b81cc7;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ColorNode;55;-2141.288,-828.4603;Float;False;Property;_BCTint;BC Tint;6;0;Create;True;0;0;False;0;1,1,1,0;0.8078431,0.8537067,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;15;-2296.197,-609.7094;Float;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;-1;None;Mid Texture 0;_MidTexture0;white;2;None;Bot Texture 0;_BotTexture0;white;5;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;26;-2301.825,-51.84256;Float;True;Spherical;World;True;Top Texture 3;_TopTexture3;white;-1;None;Mid Texture 3;_MidTexture3;white;0;None;Bot Texture 3;_BotTexture3;white;1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;22;-2289.282,542.1609;Float;True;Spherical;World;False;Top Texture 2;_TopTexture2;white;-1;None;Mid Texture 2;_MidTexture2;white;3;None;Bot Texture 2;_BotTexture2;white;4;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-1743.623,-559.4273;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1413.131,-429.4272;Float;False;Property;_BCIntensity;BC Intensity;5;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;24;-1877.564,542.541;Float;True;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1215.131,-561.4271;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-1366.151,621.7904;Float;False;Property;_SmoothMin;Smooth Min;8;0;Create;True;0;0;False;0;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-1371.494,706.122;Float;False;Property;_SmoothMax;Smooth Max;7;0;Create;True;0;0;False;0;0.8;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1886.53,111.343;Float;False;Property;_NIntensity;N Intensity;4;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;45;-1866.53,-110.6569;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-1229.576,-241.6356;Float;False;Property;_AOInt;AO Int;9;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;58;-1099.384,490.4073;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1668.53,-110.6569;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;52;-1050.131,-562.4271;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;61;-1020.792,-256.4392;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;59;-828.5208,489.9302;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-1583.047,-425.0128;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;48;-1468.82,-6.934551;Float;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;53;-1883.037,-402.4304;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-750.7568,-306.5197;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-118.1413,-37.11473;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Amplify/Environment/Y-Projection;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;44;0;11;0
WireConnection;44;1;11;0
WireConnection;15;0;18;0
WireConnection;15;3;44;0
WireConnection;26;0;20;0
WireConnection;26;3;44;0
WireConnection;22;0;23;0
WireConnection;22;3;44;0
WireConnection;50;0;55;0
WireConnection;50;1;15;0
WireConnection;24;0;22;0
WireConnection;51;0;50;0
WireConnection;51;1;49;0
WireConnection;45;0;26;1
WireConnection;45;1;26;2
WireConnection;58;0;57;0
WireConnection;58;1;56;0
WireConnection;58;2;24;0
WireConnection;47;0;45;0
WireConnection;47;1;46;0
WireConnection;52;0;51;0
WireConnection;61;0;24;2
WireConnection;61;1;62;0
WireConnection;59;0;58;0
WireConnection;54;0;50;0
WireConnection;54;1;53;0
WireConnection;48;0;47;0
WireConnection;48;2;26;3
WireConnection;60;0;52;0
WireConnection;60;1;61;0
WireConnection;0;0;60;0
WireConnection;0;1;48;0
WireConnection;0;3;24;1
WireConnection;0;4;59;0
WireConnection;0;5;24;2
ASEEND*/
//CHKSM=30457F045339E9856BABC8839AD67FC1E5091E2F