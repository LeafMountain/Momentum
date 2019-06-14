// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "New Amplify Shader"
{
	Properties
	{
		_Final_low_BC("Final_low_BC", 2D) = "white" {}
		_Final_low_N("Final_low_N", 2D) = "white" {}
		_Final_low_Emissive("Final_low_Emissive", 2D) = "white" {}
		_Final_low_GMAO("Final_low_GMAO", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Final_low_N;
		uniform float4 _Final_low_N_ST;
		uniform sampler2D _Final_low_BC;
		uniform float4 _Final_low_BC_ST;
		uniform sampler2D _Final_low_Emissive;
		uniform float4 _Final_low_Emissive_ST;
		uniform sampler2D _Final_low_GMAO;
		uniform float4 _Final_low_GMAO_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Final_low_N = i.uv_texcoord * _Final_low_N_ST.xy + _Final_low_N_ST.zw;
			o.Normal = tex2D( _Final_low_N, uv_Final_low_N ).rgb;
			float2 uv_Final_low_BC = i.uv_texcoord * _Final_low_BC_ST.xy + _Final_low_BC_ST.zw;
			o.Albedo = tex2D( _Final_low_BC, uv_Final_low_BC ).rgb;
			float2 uv_Final_low_Emissive = i.uv_texcoord * _Final_low_Emissive_ST.xy + _Final_low_Emissive_ST.zw;
			o.Emission = tex2D( _Final_low_Emissive, uv_Final_low_Emissive ).rgb;
			float2 uv_Final_low_GMAO = i.uv_texcoord * _Final_low_GMAO_ST.xy + _Final_low_GMAO_ST.zw;
			float4 tex2DNode4 = tex2D( _Final_low_GMAO, uv_Final_low_GMAO );
			o.Metallic = tex2DNode4.g;
			o.Smoothness = tex2DNode4.r;
			o.Occlusion = tex2DNode4.b;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
1920;1;1906;1011;2550.419;894.5966;2.353846;True;True
Node;AmplifyShaderEditor.SamplerNode;1;-312,-356;Float;True;Property;_Final_low_BC;Final_low_BC;0;0;Create;True;0;0;False;0;b9a68a13ef0d05f4eadc53d78870434a;b9a68a13ef0d05f4eadc53d78870434a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-655,-229;Float;True;Property;_Final_low_N;Final_low_N;1;0;Create;True;0;0;False;0;127718160eeb14d4fa7c4fcfaee0741b;127718160eeb14d4fa7c4fcfaee0741b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-988,-88;Float;True;Property;_Final_low_Emissive;Final_low_Emissive;2;0;Create;True;0;0;False;0;d6215a5bd11cee94ebf5225e6acd11a9;d6215a5bd11cee94ebf5225e6acd11a9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-626,144;Float;True;Property;_Final_low_GMAO;Final_low_GMAO;3;0;Create;True;0;0;False;0;8bd844b8c6fe32142a11c79a6b6801b8;8bd844b8c6fe32142a11c79a6b6801b8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;New Amplify Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;0;0;1;0
WireConnection;0;1;2;0
WireConnection;0;2;3;0
WireConnection;0;3;4;2
WireConnection;0;4;4;1
WireConnection;0;5;4;3
ASEEND*/
//CHKSM=D9C359C9153734D81BA45112517838C49CA0AB81