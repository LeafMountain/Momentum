// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "New Amplify Shader"
{
	Properties
	{
		_EStrenght("E Strenght", Float) = 1
		_EmissionColor("EmissionColor", Color) = (1,1,1,0)
		_Power("Power", Float) = 1
		_OpacityStrenght("Opacity Strenght", Float) = 1
		_FresnelPower("Fresnel Power", Float) = 1
		_FresnelScale("Fresnel Scale", Float) = 1
		_T_Clouds_01("T_Clouds_01", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_GradientHeight("Gradient Height", Float) = 1
		_Tiling("Tiling", Float) = 1
		_WhiteFadeDistance("White Fade Distance", Range( 0 , 1)) = 0.75
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.5
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _EmissionColor;
		uniform float _EStrenght;
		uniform sampler2D _TextureSample0;
		uniform float _Tiling;
		uniform sampler2D _T_Clouds_01;
		uniform float _WhiteFadeDistance;
		uniform float _GradientHeight;
		uniform float _Power;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float _OpacityStrenght;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Emission = ( _EmissionColor * _EStrenght ).rgb;
			float2 temp_cast_1 = (_Tiling).xx;
			float2 uv_TexCoord49 = i.uv_texcoord * temp_cast_1;
			float2 panner71 = ( 1.0 * _Time.y * float2( 1,0 ) + uv_TexCoord49);
			float2 temp_cast_2 = (_Tiling).xx;
			float2 uv_TexCoord28 = i.uv_texcoord * temp_cast_2;
			float2 panner23 = ( 2.0 * _Time.y * float2( 1,0 ) + uv_TexCoord28);
			float4 tex2DNode27 = tex2D( _T_Clouds_01, panner23 );
			float2 appendResult64 = (float2(( ( 1.0 - ( panner71.y * 2.0 ) ) * tex2DNode27.r ) , ( ( 1.0 - ( panner71.y * 2.0 ) ) * tex2DNode27.r )));
			float2 lerpResult54 = lerp( panner71 , appendResult64 , 0.5);
			float clampResult91 = clamp( tex2D( _TextureSample0, lerpResult54 ).r , _WhiteFadeDistance , 1.0 );
			float temp_output_73_0 = pow( i.uv_texcoord.y , _GradientHeight );
			float clampResult66 = clamp( ( ( clampResult91 - temp_output_73_0 ) + ( pow( clampResult91 , 2.0 ) - temp_output_73_0 ) ) , 0.0 , 1.0 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV18 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode18 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV18, _FresnelPower ) );
			float clampResult77 = clamp( ( 1.0 - fresnelNode18 ) , 0.0 , 1.0 );
			o.Alpha = ( ( pow( clampResult66 , _Power ) * clampResult77 ) * _OpacityStrenght );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
70;106;1394;836;2167.594;685.8581;1.896238;True;True
Node;AmplifyShaderEditor.RangedFloatNode;85;-5928.896,-177.2211;Float;False;Property;_Tiling;Tiling;9;0;Create;True;0;0;False;0;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;-5689.605,-409.7023;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;71;-5317.149,-501.1812;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;30;-5667.097,278.8418;Float;False;Constant;_NoisePanner;Noise Panner;7;0;Create;True;0;0;False;0;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-5690.098,76.84196;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;72;-5111.606,-572.9905;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;50;-5095.358,-280.8763;Float;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-5091.358,-192.8763;Float;False;Constant;_Float2;Float 2;7;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-4807.358,-203.3108;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-4794.513,-325.0876;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;23;-5392.291,180.1921;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;62;-4594.358,-203.3108;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;59;-4595.855,-323.2844;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;27;-5110.241,-6.894046;Float;True;Property;_T_Clouds_01;T_Clouds_01;6;0;Create;True;0;0;False;0;29ea05dc23a4307499dd8ee3fb9b31ac;29ea05dc23a4307499dd8ee3fb9b31ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-4390.358,-336.4763;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-4386.237,-222.4807;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;64;-4180.238,-298.4807;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-3867.613,-286.4656;Float;False;Constant;_Float3;Float 3;7;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;54;-3605.525,-511.7154;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-3317.05,-311.0081;Float;False;Property;_WhiteFadeDistance;White Fade Distance;11;0;Create;True;0;0;False;0;0.75;0.65;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;65;-3302.498,-533.9168;Float;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;False;0;29ea05dc23a4307499dd8ee3fb9b31ac;29ea05dc23a4307499dd8ee3fb9b31ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;74;-3614.765,109.5552;Float;False;Property;_GradientHeight;Gradient Height;8;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-3646.581,-157.6293;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;91;-2955.044,-517.0104;Float;True;3;0;FLOAT;0;False;1;FLOAT;0.75;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;33;-2746.599,56.26715;Float;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;73;-3104.765,-95.44482;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;82;-2421.96,-64.85187;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;81;-2423.96,-171.8519;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2308.921,467.9907;Float;False;Property;_FresnelScale;Fresnel Scale;5;0;Create;True;0;0;False;0;1;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2301.921,559.9907;Float;False;Property;_FresnelPower;Fresnel Power;4;0;Create;True;0;0;False;0;1;-2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;18;-2015.526,429.7005;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-2200.51,-121.7936;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;75;-1682.125,432.315;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1783.856,207.8458;Float;False;Property;_Power;Power;2;0;Create;True;0;0;False;0;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;66;-1971.689,-122.0822;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;77;-1483.863,436.8402;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;8;-1547.439,128.2261;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-941.2562,212.756;Float;False;Property;_OpacityStrenght;Opacity Strenght;3;0;Create;True;0;0;False;0;1;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1232.721,340.2907;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-878.919,-231.0432;Float;False;Property;_EmissionColor;EmissionColor;1;0;Create;True;0;0;False;0;1,1,1,0;1,0.5004901,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-838.919,-1.04309;Float;False;Property;_EStrenght;E Strenght;0;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;88;-5781.05,-2.376432;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-2258.347,788.7847;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-585.9191,-37.04309;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;44;-2076.347,782.7847;Float;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-678.756,126.9559;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-2429.347,928.7847;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-2625.347,1012.785;Float;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;42;-2615.347,828.7847;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;86;-5983.919,-41.90651;Float;False;Property;_Speed;Speed;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-5992.72,60.99348;Float;False;Constant;_Float4;Float 4;11;0;Create;True;0;0;False;0;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;7;-131.8,-80.00002;Float;False;True;3;Float;ASEMaterialInspector;0;0;Standard;New Amplify Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;49;0;85;0
WireConnection;71;0;49;0
WireConnection;28;0;85;0
WireConnection;72;0;71;0
WireConnection;60;0;72;1
WireConnection;60;1;51;0
WireConnection;47;0;72;1
WireConnection;47;1;50;0
WireConnection;23;0;28;0
WireConnection;23;2;30;0
WireConnection;62;0;60;0
WireConnection;59;0;47;0
WireConnection;27;1;23;0
WireConnection;52;0;59;0
WireConnection;52;1;27;1
WireConnection;63;0;62;0
WireConnection;63;1;27;1
WireConnection;64;0;52;0
WireConnection;64;1;63;0
WireConnection;54;0;71;0
WireConnection;54;1;64;0
WireConnection;54;2;58;0
WireConnection;65;1;54;0
WireConnection;91;0;65;1
WireConnection;91;1;96;0
WireConnection;33;0;91;0
WireConnection;73;0;4;2
WireConnection;73;1;74;0
WireConnection;82;0;33;0
WireConnection;82;1;73;0
WireConnection;81;0;91;0
WireConnection;81;1;73;0
WireConnection;18;2;20;0
WireConnection;18;3;19;0
WireConnection;68;0;81;0
WireConnection;68;1;82;0
WireConnection;75;0;18;0
WireConnection;66;0;68;0
WireConnection;77;0;75;0
WireConnection;8;0;66;0
WireConnection;8;1;10;0
WireConnection;21;0;8;0
WireConnection;21;1;77;0
WireConnection;88;0;86;0
WireConnection;88;1;87;0
WireConnection;43;0;19;0
WireConnection;43;1;45;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;44;0;43;0
WireConnection;15;0;21;0
WireConnection;15;1;17;0
WireConnection;45;0;42;4
WireConnection;45;1;46;0
WireConnection;7;2;3;0
WireConnection;7;9;15;0
ASEEND*/
//CHKSM=D91129D01CCDB173D27E786432F4087DB4251574