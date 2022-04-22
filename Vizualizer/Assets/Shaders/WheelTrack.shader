// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WheelTrack"
{
	Properties
	{
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha 
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float3 worldPos;
		};

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 temp_output_15_0_g5 = ase_worldPos.xy;
			float2 break26_g5 = ( i.uv_texcoord * temp_output_15_0_g5 );
			float2 appendResult27_g5 = (float2(( ( 0.5 * step( 1.0 , ( break26_g5.y % 2.0 ) ) ) + break26_g5.x ) , break26_g5.y));
			float2 break12_g5 = temp_output_15_0_g5;
			float temp_output_21_0_g5 = sign( ( break12_g5.y - break12_g5.x ) );
			float temp_output_14_0_g5 = 0.5;
			float2 appendResult10_g6 = (float2(( ( ( 1.0 / break12_g5.y ) * max( temp_output_21_0_g5 , 0.0 ) ) + temp_output_14_0_g5 ) , ( temp_output_14_0_g5 + ( ( -1.0 / break12_g5.x ) * min( temp_output_21_0_g5 , 0.0 ) ) )));
			float2 temp_output_11_0_g6 = ( abs( (frac( appendResult27_g5 )*2.0 + -1.0) ) - appendResult10_g6 );
			float2 break16_g6 = ( 1.0 - ( temp_output_11_0_g6 / fwidth( temp_output_11_0_g6 ) ) );
			float temp_output_2_0_g5 = saturate( min( break16_g6.x , break16_g6.y ) );
			float temp_output_29_0 = temp_output_2_0_g5;
			o.Albedo = ( i.vertexColor * temp_output_29_0 ).rgb;
			o.Alpha = temp_output_29_0;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
249;73;1249;650;2049.984;587.5941;1.918976;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;42;-1359.153,308.5688;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VertexColorNode;30;-382.3944,-203.7967;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;29;-516.7635,-1.270012;Inherit;False;Bricks Pattern;-1;;5;7d219d3a79fd53a48987a86fa91d6bac;0;4;15;FLOAT2;2,4;False;14;FLOAT;0.5;False;16;FLOAT;0.5;False;17;FLOAT2;0,1;False;2;FLOAT;0;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-1029.09,9.209402;Inherit;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;41;-438.0437,214.5388;Inherit;True;Rectangle;-1;;9;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;0.5;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;34;-965.764,-196.1213;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-702.8611,-104.0113;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector4Node;23;-1700.35,-107.0961;Inherit;False;Property;_TilingOffset;TilingOffset;0;0;Create;True;0;0;False;0;False;1,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;28;-1267.61,-67.37565;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1658.513,212.6198;Inherit;False;Property;_MoveToMat;MoveToMat;1;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;36;-1439.751,160.8073;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;38;-1247.852,133.9418;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-79.19617,-46.44061;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;35;-608.8348,-395.6954;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;40;-702.8624,199.1869;Inherit;False;Square Wave;-1;;8;6f8df4c09ccca5d42b0d3d422aad9cbd;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;191.8976,-38.37952;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;WheelTrack;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;29;15;42;0
WireConnection;32;0;42;0
WireConnection;32;1;42;0
WireConnection;41;1;32;0
WireConnection;39;0;34;0
WireConnection;39;1;32;0
WireConnection;28;0;23;1
WireConnection;28;1;23;2
WireConnection;36;0;23;3
WireConnection;36;1;37;0
WireConnection;38;0;36;0
WireConnection;38;1;23;4
WireConnection;31;0;30;0
WireConnection;31;1;29;0
WireConnection;0;0;31;0
WireConnection;0;9;29;0
ASEEND*/
//CHKSM=5333407875FE157367B50317F454AB414324A5BE