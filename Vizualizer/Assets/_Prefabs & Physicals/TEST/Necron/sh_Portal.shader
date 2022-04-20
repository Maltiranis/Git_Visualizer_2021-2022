// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sh_Portal"
{
	Properties
	{
		[HDR]_Color0("Color 0", Color) = (1,0,0,0)
		[HDR]_Color1("Color 1", Color) = (0,0.05397367,1,0)
		_Norm("Norm", Float) = 0
		_Offset3D("Offset3D", Float) = 0
		_TwirlStrength("TwirlStrength", Float) = 10
		_PaternWaving("PaternWaving", Float) = 0
		_VoroScale("VoroScale", Float) = 0
		_PaternRotate("PaternRotate", Float) = 0
		_Tess("Tess", Float) = 0
		_OffsetAxe("OffsetAxe", Vector) = (0,0,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard alpha:fade keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _VoroScale;
		uniform float _PaternWaving;
		uniform float _PaternRotate;
		uniform float _TwirlStrength;
		uniform float _Offset3D;
		uniform float3 _OffsetAxe;
		uniform float _Norm;
		uniform float4 _Color1;
		uniform float4 _Color0;
		uniform float _Tess;


		float2 voronoihash2( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash2( n + g );
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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _Tess);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float time2 = ( _Time.y * _PaternWaving );
			float cos18 = cos( ( _PaternRotate * _Time.y ) );
			float sin18 = sin( ( _PaternRotate * _Time.y ) );
			float2 rotator18 = mul( v.texcoord.xy - float2( 0.5,0.5 ) , float2x2( cos18 , -sin18 , sin18 , cos18 )) + float2( 0.5,0.5 );
			float2 center45_g1 = float2( 0.5,0.5 );
			float2 delta6_g1 = ( rotator18 - center45_g1 );
			float angle10_g1 = ( length( delta6_g1 ) * _TwirlStrength );
			float x23_g1 = ( ( cos( angle10_g1 ) * delta6_g1.x ) - ( sin( angle10_g1 ) * delta6_g1.y ) );
			float2 break40_g1 = center45_g1;
			float2 break41_g1 = float2( 0,0 );
			float y35_g1 = ( ( sin( angle10_g1 ) * delta6_g1.x ) + ( cos( angle10_g1 ) * delta6_g1.y ) );
			float2 appendResult44_g1 = (float2(( x23_g1 + break40_g1.x + break41_g1.x ) , ( break40_g1.y + break41_g1.y + y35_g1 )));
			float2 coords2 = appendResult44_g1 * _VoroScale;
			float2 id2 = 0;
			float2 uv2 = 0;
			float fade2 = 0.5;
			float voroi2 = 0;
			float rest2 = 0;
			for( int it2 = 0; it2 <8; it2++ ){
			voroi2 += fade2 * voronoi2( coords2, time2, id2, uv2, 0 );
			rest2 += fade2;
			coords2 *= 2;
			fade2 *= 0.5;
			}//Voronoi2
			voroi2 /= rest2;
			v.vertex.xyz += ( ( voroi2 * _Offset3D ) * _OffsetAxe );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldPos = i.worldPos;
			float3 temp_output_16_0_g2 = ( ase_worldPos * 100.0 );
			float3 crossY18_g2 = cross( ase_worldNormal , ddy( temp_output_16_0_g2 ) );
			float3 worldDerivativeX2_g2 = ddx( temp_output_16_0_g2 );
			float dotResult6_g2 = dot( crossY18_g2 , worldDerivativeX2_g2 );
			float crossYDotWorldDerivX34_g2 = abs( dotResult6_g2 );
			float time2 = ( _Time.y * _PaternWaving );
			float cos18 = cos( ( _PaternRotate * _Time.y ) );
			float sin18 = sin( ( _PaternRotate * _Time.y ) );
			float2 rotator18 = mul( i.uv_texcoord - float2( 0.5,0.5 ) , float2x2( cos18 , -sin18 , sin18 , cos18 )) + float2( 0.5,0.5 );
			float2 center45_g1 = float2( 0.5,0.5 );
			float2 delta6_g1 = ( rotator18 - center45_g1 );
			float angle10_g1 = ( length( delta6_g1 ) * _TwirlStrength );
			float x23_g1 = ( ( cos( angle10_g1 ) * delta6_g1.x ) - ( sin( angle10_g1 ) * delta6_g1.y ) );
			float2 break40_g1 = center45_g1;
			float2 break41_g1 = float2( 0,0 );
			float y35_g1 = ( ( sin( angle10_g1 ) * delta6_g1.x ) + ( cos( angle10_g1 ) * delta6_g1.y ) );
			float2 appendResult44_g1 = (float2(( x23_g1 + break40_g1.x + break41_g1.x ) , ( break40_g1.y + break41_g1.y + y35_g1 )));
			float2 coords2 = appendResult44_g1 * _VoroScale;
			float2 id2 = 0;
			float2 uv2 = 0;
			float fade2 = 0.5;
			float voroi2 = 0;
			float rest2 = 0;
			for( int it2 = 0; it2 <8; it2++ ){
			voroi2 += fade2 * voronoi2( coords2, time2, id2, uv2, 0 );
			rest2 += fade2;
			coords2 *= 2;
			fade2 *= 0.5;
			}//Voronoi2
			voroi2 /= rest2;
			float temp_output_20_0_g2 = ( voroi2 * _Norm );
			float3 crossX19_g2 = cross( ase_worldNormal , worldDerivativeX2_g2 );
			float3 break29_g2 = ( sign( crossYDotWorldDerivX34_g2 ) * ( ( ddx( temp_output_20_0_g2 ) * crossY18_g2 ) + ( ddy( temp_output_20_0_g2 ) * crossX19_g2 ) ) );
			float3 appendResult30_g2 = (float3(break29_g2.x , -break29_g2.y , break29_g2.z));
			float3 normalizeResult39_g2 = normalize( ( ( crossYDotWorldDerivX34_g2 * ase_worldNormal ) - appendResult30_g2 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 worldToTangentDir42_g2 = mul( ase_worldToTangent, normalizeResult39_g2);
			o.Normal = worldToTangentDir42_g2;
			o.Emission = ( ( ( 1.0 - voroi2 ) * _Color1 ) + ( voroi2 * _Color0 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
226;73;1135;655;2649.193;453.8031;2.142517;True;False
Node;AmplifyShaderEditor.RangedFloatNode;21;-2429.068,248.5323;Inherit;False;Property;_PaternRotate;PaternRotate;7;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;15;-2403.565,376.3531;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-2365.778,-44.57262;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-2186.4,243.0671;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;18;-2029.256,0.5157561;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;9;-1631.007,56.30651;Inherit;False;Constant;_Vector1;Vector 1;2;0;Create;True;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;11;-1613.5,201.4153;Inherit;False;Property;_TwirlStrength;TwirlStrength;4;0;Create;True;0;0;False;0;False;10;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1557.294,637.386;Inherit;False;Property;_PaternWaving;PaternWaving;5;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1083.013,551.0374;Inherit;False;Property;_VoroScale;VoroScale;6;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1306.875,582.3705;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1;-1350.688,15.90717;Inherit;True;Twirl;-1;;1;90936742ac32db8449cd21ab6dd337c8;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;2;-1007.497,27.85781;Inherit;True;0;0;1;0;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;25;0.3917847,745.7064;Inherit;False;Property;_Offset3D;Offset3D;3;0;Create;True;0;0;False;0;False;0;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-792.5234,736.7454;Inherit;False;Property;_Norm;Norm;2;0;Create;True;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;6;-644.3739,-183.2823;Inherit;False;Property;_Color1;Color 1;1;1;[HDR];Create;True;0;0;False;0;False;0,0.05397367,1,0;0,2,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;5;-641.1597,228.8255;Inherit;False;Property;_Color0;Color 0;0;1;[HDR];Create;True;0;0;False;0;False;1,0,0,0;2.828427,2.828427,2.828427,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;4;-581.959,-274.7721;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-356.5422,-178.9862;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-425.2453,152.5084;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;23;543.4734,403.5377;Inherit;False;Property;_Tess;Tess;8;0;Create;True;0;0;False;0;False;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-636.8441,638.7898;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;27;322.4788,771.7166;Inherit;False;Property;_OffsetAxe;OffsetAxe;9;0;Create;True;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;156.071,647.7508;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;12;-442.6821,558.3263;Inherit;True;Normal From Height;-1;;2;1942fe2c5f1a1f94881a33d532e4afeb;0;1;20;FLOAT;0;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-213.0423,-19.85089;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;22;508.4653,315.0972;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;318.1937,641.0231;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;123.6664,-24.04623;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;sh_Portal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;20;0;21;0
WireConnection;20;1;15;2
WireConnection;18;0;10;0
WireConnection;18;2;20;0
WireConnection;17;0;15;2
WireConnection;17;1;16;0
WireConnection;1;1;18;0
WireConnection;1;2;9;0
WireConnection;1;3;11;0
WireConnection;2;0;1;0
WireConnection;2;1;17;0
WireConnection;2;2;28;0
WireConnection;4;0;2;0
WireConnection;7;0;4;0
WireConnection;7;1;6;0
WireConnection;8;0;2;0
WireConnection;8;1;5;0
WireConnection;14;0;2;0
WireConnection;14;1;13;0
WireConnection;24;0;2;0
WireConnection;24;1;25;0
WireConnection;12;20;14;0
WireConnection;3;0;7;0
WireConnection;3;1;8;0
WireConnection;22;0;23;0
WireConnection;26;0;24;0
WireConnection;26;1;27;0
WireConnection;0;1;12;40
WireConnection;0;2;3;0
WireConnection;0;11;26;0
WireConnection;0;14;22;0
ASEEND*/
//CHKSM=211B49A6240966410C5FFACD3AD82D06F2F1C9EE