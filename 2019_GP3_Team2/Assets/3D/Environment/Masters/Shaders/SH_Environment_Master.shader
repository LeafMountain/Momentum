// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Amplify/Environment/Standard"
{
	Properties
	{
		_ObjectMaxRadius("Object Max Radius", Float) = 5000
		_TileSize("Tile Size", Float) = 1
		_BC("BC", 2D) = "white" {}
		_GMAOH("GMAOH", 2D) = "white" {}
		_N("N", 2D) = "bump" {}
		_Metal("Metal", Float) = 0
		_NIntensity("N Intensity", Float) = 0
		_BCIntensity("BC Intensity", Float) = 1
		_SmoothMax("Smooth Max", Float) = 0.8
		_SmoothMin("Smooth Min", Float) = 0.2
		_BCTint("BC Tint", Color) = (1,1,1,0)
		_AOIntensity("AO Intensity", Float) = 0
		_Emissive("Emissive", 2D) = "white" {}
		_EStrenght("E Strenght", Float) = 1
		[Toggle]_UseEmissive("Use Emissive", Float) = 0
		[Toggle]_UseMetalMap("Use Metal Map", Float) = 0
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

		uniform sampler2D _N;
		uniform float _ObjectMaxRadius;
		uniform float _TileSize;
		uniform float _NIntensity;
		uniform sampler2D _GMAOH;
		uniform float _AOIntensity;
		uniform float4 _BCTint;
		uniform sampler2D _BC;
		uniform float _BCIntensity;
		uniform float _UseEmissive;
		uniform sampler2D _Emissive;
		uniform float4 _Emissive_ST;
		uniform float _EStrenght;
		uniform float _UseMetalMap;
		uniform float _Metal;
		uniform float _SmoothMin;
		uniform float _SmoothMax;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float clampResult66 = clamp( ase_objectScale.x , 0.0 , _ObjectMaxRadius );
			float clampResult65 = clamp( ase_objectScale.y , 0.0 , _ObjectMaxRadius );
			float clampResult3 = clamp( ase_objectScale.z , 0.0 , _ObjectMaxRadius );
			float3 appendResult71 = (float3(( clampResult66 / _TileSize ) , ( clampResult65 / _TileSize ) , ( clampResult3 / _TileSize )));
			float3 temp_output_59_0 = ( float3( i.uv_texcoord ,  0.0 ) * appendResult71 );
			float3 tex2DNode13 = UnpackNormal( tex2D( _N, temp_output_59_0.xy ) );
			float2 appendResult22 = (float2(tex2DNode13.r , tex2DNode13.g));
			float3 appendResult38 = (float3(( appendResult22 * _NIntensity ) , tex2DNode13.b));
			o.Normal = appendResult38;
			float4 tex2DNode12 = tex2D( _GMAOH, temp_output_59_0.xy );
			float temp_output_60_0 = pow( tex2DNode12.b , _AOIntensity );
			float4 temp_output_29_0 = ( _BCTint * tex2D( _BC, temp_output_59_0.xy ) );
			float4 clampResult32 = clamp( ( temp_output_29_0 * _BCIntensity ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Albedo = ( temp_output_60_0 * clampResult32 ).rgb;
			float4 temp_cast_7 = (0.0).xxxx;
			float4 color81 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float2 uv_Emissive = i.uv_texcoord * _Emissive_ST.xy + _Emissive_ST.zw;
			o.Emission = lerp(temp_cast_7,( ( color81 * tex2D( _Emissive, uv_Emissive ) ) * _EStrenght ),_UseEmissive).rgb;
			o.Metallic = lerp(_Metal,tex2DNode12.g,_UseMetalMap);
			float lerpResult14 = lerp( _SmoothMin , _SmoothMax , tex2DNode12.r);
			float clampResult18 = clamp( lerpResult14 , 0.2 , 0.8 );
			o.Smoothness = clampResult18;
			o.Occlusion = temp_output_60_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
-1675;84;1666;954;5847.937;1770.148;4.987209;True;True
Node;AmplifyShaderEditor.RangedFloatNode;5;-4035.134,222.3108;Float;False;Property;_ObjectMaxRadius;Object Max Radius;0;0;Create;True;0;0;False;0;5000;5000;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectScaleNode;2;-4005.938,-119.6434;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;3;-3698.517,180.9962;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;65;-3699.814,43.63864;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;66;-3698.814,-94.36137;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-3706.53,355.8629;Float;False;Property;_TileSize;Tile Size;1;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;6;-3348.997,179.6951;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;63;-3349.803,-95.84969;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;67;-3349.814,42.63864;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;71;-3088.252,17.93948;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-2732.72,-259.2872;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2392.849,-5.92371;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;10;-1686.382,-694.4022;Float;True;Property;_BC;BC;2;0;Create;True;0;0;False;0;2355afdc9e82a2343a49ebe545deb106;ac523fab0065caa46823d4bd8a803725;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;35;-1592.682,-885.7496;Float;False;Property;_BCTint;BC Tint;12;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;81;-1674.86,1645.916;Float;False;Constant;_Color0;Color 0;15;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;13;-1806.681,-4.076145;Float;True;Property;_N;N;4;0;Create;True;0;0;False;0;d5754936fe852ea438ee176367df232e;a8419041d3c0ec444af2ea62eb757e8d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1172.597,-594.4997;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;78;-1755.132,1847.81;Float;True;Property;_Emissive;Emissive;14;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-844.105,-354.4996;Float;False;Property;_BCIntensity;BC Intensity;9;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-1288.86,1791.916;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-1289.021,1031.648;Float;False;Property;_AOIntensity;AO Intensity;13;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-1756.713,1363.493;Float;True;Property;_GMAOH;GMAOH;3;0;Create;True;0;0;False;0;1693c1fd44f7f7340a8e265ae9f03e69;fef5dc1f8b36ae745afaaafdc64280ad;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-1407.124,1297.893;Float;False;Property;_SmoothMax;Smooth Max;10;0;Create;True;0;0;False;0;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1377.795,159.9628;Float;False;Property;_NIntensity;N Intensity;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;22;-1357.795,-62.0372;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1385.124,1216.893;Float;False;Property;_SmoothMin;Smooth Min;11;0;Create;True;0;0;False;0;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-646.105,-486.4995;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-1310.86,1905.916;Float;False;Property;_EStrenght;E Strenght;15;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-1067.859,1790.916;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;14;-1184.988,1345.37;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;60;-1038.021,1012.648;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-200.5644,147.2957;Float;False;Property;_Metal;Metal;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1159.795,-62.0372;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-1075.805,1705.767;Float;False;Constant;_Float1;Float 1;17;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;32;-481.1051,-487.4995;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;41;-1820.518,321.1748;Float;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;False;0;None;a0c7f527fabc84b4785fd80eda855140;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1249.632,271.2138;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;43;-1447.632,271.2138;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1467.632,492.2138;Float;False;Property;_NBakeInt;N Bake Int;8;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;87;-27.67964,187.2284;Float;False;Property;_UseMetalMap;Use Metal Map;17;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;38;-960.0857,41.68521;Float;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;73;-2845.361,-1055.286;Float;False;Constant;_Vector0;Vector 0;14;0;Create;True;0;0;False;0;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;18;-914.1243,1344.893;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;46;-770.8558,220.8144;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-2808.361,-1191.286;Float;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-2519.361,-1184.286;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;74;-2832.361,-789.2859;Float;False;Constant;_Vector1;Vector 1;14;0;Create;True;0;0;False;0;2,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-2358.361,-915.2859;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-2567.361,-887.2859;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-1027.921,-384.3852;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;34;-1315.911,-360.8028;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-124.5805,-117.583;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;84;-824.8055,1781.767;Float;False;Property;_UseEmissive;Use Emissive;16;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;45;-980.6222,371.3362;Float;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;397.3599,3.196094;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Amplify/Environment/Standard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;2;3
WireConnection;3;2;5;0
WireConnection;65;0;2;2
WireConnection;65;2;5;0
WireConnection;66;0;2;1
WireConnection;66;2;5;0
WireConnection;6;0;3;0
WireConnection;6;1;7;0
WireConnection;63;0;66;0
WireConnection;63;1;7;0
WireConnection;67;0;65;0
WireConnection;67;1;7;0
WireConnection;71;0;63;0
WireConnection;71;1;67;0
WireConnection;71;2;6;0
WireConnection;59;0;9;0
WireConnection;59;1;71;0
WireConnection;10;1;59;0
WireConnection;13;1;59;0
WireConnection;29;0;35;0
WireConnection;29;1;10;0
WireConnection;79;0;81;0
WireConnection;79;1;78;0
WireConnection;12;1;59;0
WireConnection;22;0;13;1
WireConnection;22;1;13;2
WireConnection;31;0;29;0
WireConnection;31;1;30;0
WireConnection;82;0;79;0
WireConnection;82;1;83;0
WireConnection;14;0;15;0
WireConnection;14;1;16;0
WireConnection;14;2;12;1
WireConnection;60;0;12;3
WireConnection;60;1;62;0
WireConnection;23;0;22;0
WireConnection;23;1;25;0
WireConnection;32;0;31;0
WireConnection;44;0;43;0
WireConnection;44;1;42;0
WireConnection;43;0;41;1
WireConnection;43;1;41;2
WireConnection;87;0;20;0
WireConnection;87;1;12;2
WireConnection;38;0;23;0
WireConnection;38;2;13;3
WireConnection;18;0;14;0
WireConnection;46;0;38;0
WireConnection;46;1;45;0
WireConnection;75;0;73;0
WireConnection;75;1;76;0
WireConnection;77;0;72;0
WireConnection;77;1;72;0
WireConnection;72;0;73;0
WireConnection;72;1;74;0
WireConnection;33;0;29;0
WireConnection;33;1;34;0
WireConnection;86;0;60;0
WireConnection;86;1;32;0
WireConnection;84;0;85;0
WireConnection;84;1;82;0
WireConnection;45;0;44;0
WireConnection;45;2;41;3
WireConnection;0;0;86;0
WireConnection;0;1;38;0
WireConnection;0;2;84;0
WireConnection;0;3;87;0
WireConnection;0;4;18;0
WireConnection;0;5;60;0
ASEEND*/
//CHKSM=F2C23087908B18A740BF20DAC04298717DC5046F