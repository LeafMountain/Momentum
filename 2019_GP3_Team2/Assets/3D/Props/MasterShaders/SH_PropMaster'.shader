// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Master_Props"
{
	Properties
	{
		_BaseColor("Base Color", 2D) = "white" {}
		_Normalmap("Normal map", 2D) = "bump" {}
		_GMAO("GMAO", 2D) = "white" {}
		[Toggle(_METALNESSTEXTURE_SWITCH_ON)] _MetalnessTexture_Switch("MetalnessTexture_Switch", Float) = 0
		_Metallness("Metallness", Range( 0 , 1)) = 0
		_AOIntensity("AO Intensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature _METALNESSTEXTURE_SWITCH_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normalmap;
		uniform float4 _Normalmap_ST;
		uniform sampler2D _BaseColor;
		uniform float4 _BaseColor_ST;
		uniform sampler2D _GMAO;
		uniform float4 _GMAO_ST;
		uniform float _Metallness;
		uniform float _AOIntensity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normalmap = i.uv_texcoord * _Normalmap_ST.xy + _Normalmap_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normalmap, uv_Normalmap ) );
			float2 uv_BaseColor = i.uv_texcoord * _BaseColor_ST.xy + _BaseColor_ST.zw;
			o.Albedo = tex2D( _BaseColor, uv_BaseColor ).rgb;
			float2 uv_GMAO = i.uv_texcoord * _GMAO_ST.xy + _GMAO_ST.zw;
			float4 tex2DNode6 = tex2D( _GMAO, uv_GMAO );
			#ifdef _METALNESSTEXTURE_SWITCH_ON
				float staticSwitch7 = _Metallness;
			#else
				float staticSwitch7 = tex2DNode6.g;
			#endif
			o.Metallic = staticSwitch7;
			o.Smoothness = tex2DNode6.r;
			o.Occlusion = ( tex2DNode6.b * _AOIntensity );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
-1214;155;1264;774;2186.878;1501.052;2.946165;True;False
Node;AmplifyShaderEditor.RangedFloatNode;12;-186.4945,397.2371;Float;False;Property;_AOIntensity;AO Intensity;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-648.1255,259.1116;Float;True;Property;_GMAO;GMAO;2;0;Create;True;0;0;False;0;d1622c4da2e181f43976ac2a665fe629;d1622c4da2e181f43976ac2a665fe629;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-636.7106,146.0724;Float;False;Property;_Metallness;Metallness;4;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-625.2614,-116.4459;Float;True;Property;_Normalmap;Normal map;1;0;Create;True;0;0;False;0;678d31d5697cb10479ac984207ab22d1;678d31d5697cb10479ac984207ab22d1;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;7;-204.1697,126.2337;Float;False;Property;_MetalnessTexture_Switch;MetalnessTexture_Switch;3;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-15.81569,322.5732;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-674.5569,-371.5511;Float;True;Property;_BaseColor;Base Color;0;0;Create;True;0;0;False;0;5f8fa2630a90d214ba23d4b5b1b028df;5f8fa2630a90d214ba23d4b5b1b028df;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;5;709.8907,19.70128;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Master_Props;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;1;6;2
WireConnection;7;0;8;0
WireConnection;11;0;6;3
WireConnection;11;1;12;0
WireConnection;5;0;1;0
WireConnection;5;1;2;0
WireConnection;5;3;7;0
WireConnection;5;4;6;1
WireConnection;5;5;11;0
ASEEND*/
//CHKSM=64C951EC847D85221A844575BCC34ECAB6550B34