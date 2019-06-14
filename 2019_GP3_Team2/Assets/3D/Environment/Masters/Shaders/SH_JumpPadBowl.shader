// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Amplify/Environment/JumpPadBowl"
{
	Properties
	{
		_EStrenght("E Strenght", Float) = 1
		_EmissionColor("EmissionColor", Color) = (1,1,1,0)
		_FresnelScale("Fresnel Scale", Float) = 1
		_FresnelPower("Fresnel Power", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#pragma target 3.5
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _EmissionColor;
		uniform float _EStrenght;
		uniform float _FresnelScale;
		uniform float _FresnelPower;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = ( _EmissionColor * _EStrenght ).rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV4 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode4 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV4, _FresnelPower ) );
			o.Alpha = fresnelNode4;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
70;106;1394;836;1690.555;492.4886;1.9;True;True
Node;AmplifyShaderEditor.RangedFloatNode;5;-904.2012,127.0105;Float;False;Property;_FresnelScale;Fresnel Scale;2;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-901.2012,229.3358;Float;False;Property;_FresnelPower;Fresnel Power;3;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-844.4777,-5.575246;Float;False;Property;_EStrenght;E Strenght;0;0;Create;True;0;0;False;0;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-884.4777,-235.5752;Float;False;Property;_EmissionColor;EmissionColor;1;0;Create;True;0;0;False;0;1,1,1,0;0.3333333,1,0.8789236,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;4;-682.5449,120.4233;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-591.4777,-41.57526;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;3;Float;ASEMaterialInspector;0;0;Standard;Amplify/Environment/JumpPadBowl;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;2;5;0
WireConnection;4;3;6;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;0;0;3;0
WireConnection;0;9;4;0
ASEEND*/
//CHKSM=2B5A3C41CD99FE6CD3E066846C04DD261E76A407