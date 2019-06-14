// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Amplify/Environment/JumpPadRings"
{
	Properties
	{
		_EStrenght("E Strenght", Float) = 1
		_EmissionColor("_EmissionColor", Color) = (1,1,1,0)
		_T_Cirlce_Sharp_01("T_Cirlce_Sharp_01", 2D) = "white" {}
		_Opacity("Opacity", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _EmissionColor;
		uniform float _EStrenght;
		uniform sampler2D _T_Cirlce_Sharp_01;
		uniform float4 _T_Cirlce_Sharp_01_ST;
		uniform float _Opacity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = ( _EmissionColor * _EStrenght ).rgb;
			float2 uv_T_Cirlce_Sharp_01 = i.uv_texcoord * _T_Cirlce_Sharp_01_ST.xy + _T_Cirlce_Sharp_01_ST.zw;
			o.Alpha = ( tex2D( _T_Cirlce_Sharp_01, uv_T_Cirlce_Sharp_01 ).r * _Opacity );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
70;106;1394;836;1334.414;476.8079;1.676968;True;True
Node;AmplifyShaderEditor.RangedFloatNode;2;-488,-123.8333;Float;False;Property;_EStrenght;E Strenght;0;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-627.5374,93.97241;Float;True;Property;_T_Cirlce_Sharp_01;T_Cirlce_Sharp_01;2;0;Create;True;0;0;False;0;20336e0ad375d074781ae5e18bd43a2c;e79d52be46bea2c48a9b666a507fe58c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-522.5374,349.9724;Float;False;Property;_Opacity;Opacity;3;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-528,-353.8333;Float;False;Property;_EmissionColor;_EmissionColor;1;0;Create;True;0;0;False;0;1,1,1,0;1,0.6114954,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-235,-159.8333;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-210.5374,221.9724;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;142,-84;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Amplify/Environment/JumpPadRings;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;9;0;8;1
WireConnection;9;1;10;0
WireConnection;0;0;3;0
WireConnection;0;9;9;0
ASEEND*/
//CHKSM=D8610F7C96353358152121ADB9F2133BCF36322C