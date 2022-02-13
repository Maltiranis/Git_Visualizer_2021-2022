// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ValouShaders/sh_LightSaber3"
{
	Properties
	{
		[HDR]_Color0("Color 0", Color) = (1,0,0,0)
		[HDR]_Color2("Color 2", Color) = (1,1,1,0)
		_Float0("Float 0", Float) = 0.06
		_Offset("Offset", Range( -5 , 5)) = 0
		_speed("speed", Float) = 10
		_SmoothStep("SmoothStep", Vector) = (0,1,0,0)
		[HDR]_ColorFresnel("ColorFresnel", Color) = (1,1,1,0)
		_DepthDist("DepthDist", Float) = 1
		_WHR("WHR", Vector) = (0.8,0.8,0.1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _speed;
		uniform float _Offset;
		uniform float2 _SmoothStep;
		uniform float4 _Color0;
		uniform float _Float0;
		uniform float4 _Color2;
		uniform float4 _ColorFresnel;
		uniform float _DepthDist;
		uniform float3 _WHR;


		float2 voronoihash12( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi12( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash12( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float temp_output_38_0 = ( _Time.w * _speed );
			float time12 = temp_output_38_0;
			float2 appendResult32 = (float2(0.0 , ( -1.0 * temp_output_38_0 )));
			float2 uv_TexCoord31 = v.texcoord.xy + appendResult32;
			float2 coords12 = uv_TexCoord31 * 1.0;
			float2 id12 = 0;
			float2 uv12 = 0;
			float fade12 = 0.5;
			float voroi12 = 0;
			float rest12 = 0;
			for( int it12 = 0; it12 <8; it12++ ){
			voroi12 += fade12 * voronoi12( coords12, time12, id12, uv12, 0 );
			rest12 += fade12;
			coords12 *= 2;
			fade12 *= 0.5;
			}//Voronoi12
			voroi12 /= rest12;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 appendResult43 = (float4(ase_vertex3Pos.x , 0.0 , ase_vertex3Pos.z , 0.0));
			v.vertex.xyz += ( ( voroi12 * appendResult43 ) * _Offset ).xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 temp_cast_0 = (_SmoothStep.x).xxxx;
			float4 temp_cast_1 = (_SmoothStep.y).xxxx;
			float2 uv_TexCoord7 = i.uv_texcoord * float2( 1,0 ) + float2( -0.5,-0.5 );
			float temp_output_9_0 = ( 1.0 - length( uv_TexCoord7 ) );
			float dotResult5 = dot( temp_output_9_0 , temp_output_9_0 );
			float4 color17 = IsGammaSpace() ? float4(0.01886791,0.01886791,0.01886791,0) : float4(0.001460365,0.001460365,0.001460365,0);
			float temp_output_38_0 = ( _Time.w * _speed );
			float time12 = temp_output_38_0;
			float2 appendResult32 = (float2(0.0 , ( -1.0 * temp_output_38_0 )));
			float2 uv_TexCoord31 = i.uv_texcoord + appendResult32;
			float2 coords12 = uv_TexCoord31 * 1.0;
			float2 id12 = 0;
			float2 uv12 = 0;
			float fade12 = 0.5;
			float voroi12 = 0;
			float rest12 = 0;
			for( int it12 = 0; it12 <8; it12++ ){
			voroi12 += fade12 * voronoi12( coords12, time12, id12, uv12, 0 );
			rest12 += fade12;
			coords12 *= 2;
			fade12 *= 0.5;
			}//Voronoi12
			voroi12 /= rest12;
			float smoothstepResult18 = smoothstep( ( _Float0 + 0.05 ) , color17.r , voroi12);
			float smoothstepResult16 = smoothstep( _Float0 , color17.r , voroi12);
			float smoothstepResult21 = smoothstep( smoothstepResult18 , smoothstepResult16 , 0.01);
			float4 smoothstepResult51 = smoothstep( temp_cast_0 , temp_cast_1 , ( ( _Color0 * ( dotResult5 * 1.71 ) ) + ( step( smoothstepResult21 , 0.05 ) * _Color2 ) ));
			float temp_output_2_0_g15 = _WHR.x;
			float temp_output_3_0_g15 = _WHR.y;
			float2 appendResult21_g15 = (float2(temp_output_2_0_g15 , temp_output_3_0_g15));
			float Radius25_g15 = max( min( min( abs( ( _WHR.z * 2 ) ) , abs( temp_output_2_0_g15 ) ) , abs( temp_output_3_0_g15 ) ) , 1E-05 );
			float2 temp_cast_4 = (0.0).xx;
			float temp_output_30_0_g15 = ( length( max( ( ( abs( (i.uv_texcoord*2.0 + -1.0) ) - appendResult21_g15 ) + Radius25_g15 ) , temp_cast_4 ) ) / Radius25_g15 );
			o.Emission = ( smoothstepResult51 + ( _ColorFresnel * ( _DepthDist * ( 1.0 - length( saturate( ( ( 1.0 - temp_output_30_0_g15 ) / fwidth( temp_output_30_0_g15 ) ) ) ) ) ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
255;73;1351;450;1458.706;539.8118;4.016964;True;False
Node;AmplifyShaderEditor.RangedFloatNode;39;-2395.793,743.4019;Inherit;False;Property;_speed;speed;4;0;Create;True;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;30;-2363.262,490.7916;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2149.394,713.0019;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-2011.795,620.2018;Inherit;False;2;2;0;FLOAT;-1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;32;-1800.595,604.2021;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1102.95,924.7369;Inherit;False;Property;_Float0;Float 0;2;0;Create;True;0;0;False;0;False;0.06;17.94;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-1522.196,516.2017;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1818.404,-216.8312;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0;False;1;FLOAT2;-0.5,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-868.1515,929.3377;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;8;-1408.996,-138.7732;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-1087.207,724.6448;Inherit;False;Constant;_Color1;Color 1;1;0;Create;True;0;0;False;0;False;0.01886791,0.01886791,0.01886791,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;12;-1213.056,515.959;Inherit;True;0;0;1;0;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TexCoordVertexDataNode;90;1188.433,227.8652;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;84;971.4229,501.5994;Inherit;False;Property;_WHR;WHR;9;0;Create;True;0;0;False;0;False;0.8,0.8,0.1;1.7,30,0.05;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;9;-994.8117,-6.552252;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;18;-751.08,421.9709;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.15;False;2;FLOAT;-0.51;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;16;-749.4867,630.6565;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.15;False;2;FLOAT;-0.51;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;21;-361.1515,516.3377;Inherit;True;3;0;FLOAT;0.01;False;1;FLOAT;0.15;False;2;FLOAT;-0.51;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;5;-719.2755,133.508;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;80;1250.194,530.5148;Inherit;False;Rounded Rectangle;-1;;15;8679f72f5be758f47babb3ba1d5f51d3;0;4;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-468.0652,-126.7735;Inherit;False;Property;_Color0;Color 0;0;1;[HDR];Create;True;0;0;False;0;False;1,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;35;145.7299,543.7189;Inherit;False;Property;_Color2;Color 2;1;1;[HDR];Create;True;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;29;-126.063,492.8918;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-314.0649,185.7059;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1.71;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;79;1469.019,526.7891;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;1482.793,437.6426;Inherit;False;Property;_DepthDist;DepthDist;7;0;Create;True;0;0;False;0;False;1;0.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;40;134.7057,930.0845;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;82;1739.423,600.5994;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;173.8047,159.4016;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;200.5979,446.3806;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;397.8045,285.8014;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;57;1462.195,200.6913;Inherit;False;Property;_ColorFresnel;ColorFresnel;6;1;[HDR];Create;True;0;0;False;0;False;1,1,1,0;4,4,4,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;54;1525.735,-135.9364;Inherit;False;Property;_SmoothStep;SmoothStep;5;0;Create;True;0;0;False;0;False;0,1;0.25,0.48;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;43;487.2931,958.0677;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;1679.678,446.931;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;51;2646.952,197.9049;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;46;550.2556,1149.753;Inherit;False;Property;_Offset;Offset;3;0;Create;True;0;0;False;0;False;0;1;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;1868.652,287.3873;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;753.8919,799.9297;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;121;2244.909,695.3785;Inherit;False;Property;_PaternSelector;PaternSelector;8;1;[IntRange];Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;3;-1108.255,234.673;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;3040.346,289.5598;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;88;832.8152,315.7005;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-851.4406,315.2382;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;6.21;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;86;982.328,347.2708;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;87;641.6152,309.3005;Inherit;False;Property;_TileOffset;TileOffset;10;0;Create;True;0;0;False;0;False;0,0,0,0;-1,1,1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;1021.772,825.1472;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;89;827.6152,412.9006;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1475.45,185.0404;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3807.007,423.8754;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ValouShaders/sh_LightSaber3;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;38;0;30;4
WireConnection;38;1;39;0
WireConnection;33;1;38;0
WireConnection;32;1;33;0
WireConnection;31;1;32;0
WireConnection;23;0;22;0
WireConnection;8;0;7;0
WireConnection;12;0;31;0
WireConnection;12;1;38;0
WireConnection;9;0;8;0
WireConnection;18;0;12;0
WireConnection;18;1;23;0
WireConnection;18;2;17;0
WireConnection;16;0;12;0
WireConnection;16;1;22;0
WireConnection;16;2;17;0
WireConnection;21;1;18;0
WireConnection;21;2;16;0
WireConnection;5;0;9;0
WireConnection;5;1;9;0
WireConnection;80;1;90;0
WireConnection;80;2;84;1
WireConnection;80;3;84;2
WireConnection;80;4;84;3
WireConnection;29;0;21;0
WireConnection;6;0;5;0
WireConnection;79;0;80;0
WireConnection;82;0;79;0
WireConnection;37;0;1;0
WireConnection;37;1;6;0
WireConnection;36;0;29;0
WireConnection;36;1;35;0
WireConnection;34;0;37;0
WireConnection;34;1;36;0
WireConnection;43;0;40;1
WireConnection;43;2;40;3
WireConnection;81;0;68;0
WireConnection;81;1;82;0
WireConnection;51;0;34;0
WireConnection;51;1;54;1
WireConnection;51;2;54;2
WireConnection;75;0;57;0
WireConnection;75;1;81;0
WireConnection;48;0;12;0
WireConnection;48;1;43;0
WireConnection;3;0;2;2
WireConnection;85;0;51;0
WireConnection;85;1;75;0
WireConnection;88;0;87;1
WireConnection;88;1;87;2
WireConnection;10;0;3;0
WireConnection;86;0;88;0
WireConnection;86;1;89;0
WireConnection;42;0;48;0
WireConnection;42;1;46;0
WireConnection;89;0;87;3
WireConnection;89;1;87;4
WireConnection;0;2;85;0
WireConnection;0;11;42;0
ASEEND*/
//CHKSM=88700E738278D3BF3A8DFACC8B31E8A1A366C61D