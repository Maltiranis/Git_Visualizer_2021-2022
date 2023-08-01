// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/sh_realistic_eventhorizon"
{
	Properties
	{
		_voroscale("voroscale", Float) = 5
		_vorostrength("vorostrength", Float) = 5
		_Float2("Float 2", Float) = 0.5
		[HDR]_Color0("Color 0", Color) = (0.5697757,0.7465658,0.9339623,0)
		[HDR]_Color1("Color 1", Color) = (1,1,1,0)
		_sub("sub", Float) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 5.0
		#pragma surface surf Standard keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Float2;
		uniform float _voroscale;
		uniform float _vorostrength;
		uniform float _sub;
		uniform float4 _Color0;
		uniform float4 _Color1;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float2 voronoihash113( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi113( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash113( n + g );
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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_Float2).xx;
			float2 appendResult148 = (float2(_Float2 , _Float2));
			float2 uv_TexCoord120 = i.uv_texcoord * temp_cast_0 + ( appendResult148 * float2( -0.5,-0.5 ) );
			float3 hsvTorgb3_g26 = HSVToRGB( float3(length( uv_TexCoord120 ),1.0,1.0) );
			float3 temp_output_144_6 = hsvTorgb3_g26;
			float time113 = 0.0;
			float2 coords113 = i.uv_texcoord * _voroscale;
			float2 id113 = 0;
			float2 uv113 = 0;
			float fade113 = 0.5;
			float voroi113 = 0;
			float rest113 = 0;
			for( int it113 = 0; it113 <8; it113++ ){
			voroi113 += fade113 * voronoi113( coords113, time113, id113, uv113, 0 );
			rest113 += fade113;
			coords113 *= 2;
			fade113 *= 0.5;
			}//Voronoi113
			voroi113 /= rest113;
			float patern135 = ( voroi113 * _vorostrength );
			float3 temp_cast_1 = (0.0).xxx;
			float3 temp_cast_2 = (1.0).xxx;
			float3 temp_cast_3 = (-1.0).xxx;
			float3 temp_cast_4 = (1.0).xxx;
			float3 temp_output_112_0 = (temp_cast_3 + (( temp_output_144_6 * patern135 ) - temp_cast_1) * (temp_cast_4 - temp_cast_3) / (temp_cast_2 - temp_cast_1));
			float3 temp_output_129_0 = ( temp_output_144_6 - ( temp_output_112_0 * ( frac( ( _Time.y * _sub ) ) - 0.5 ) ) );
			float grayscale197 = Luminance(temp_output_129_0);
			float clampResult193 = clamp( ( grayscale197 * _vorostrength ) , 0.0 , 1.0 );
			float3 temp_cast_5 = (0.0).xxx;
			float3 temp_cast_6 = (1.0).xxx;
			float3 temp_cast_7 = (-1.0).xxx;
			float3 temp_cast_8 = (1.0).xxx;
			float grayscale198 = Luminance(( temp_output_144_6 - ( temp_output_112_0 * ( frac( ( ( _Time.y * _sub ) - 0.5 ) ) - 0.5 ) ) ));
			float clampResult194 = clamp( ( grayscale198 * _vorostrength ) , 0.0 , 1.0 );
			float clampResult195 = clamp( abs( ( ( ( _Time.y * _sub ) % 2.0 ) - 1.0 ) ) , 0.0 , 1.0 );
			float4 lerpResult153 = lerp( ( clampResult193 * _Color0 ) , ( clampResult194 * _Color1 ) , clampResult195);
			o.Emission = lerpResult153.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
310.6667;72.66667;1833.333;846;2686.593;809.6796;1.941155;True;True
Node;AmplifyShaderEditor.RangedFloatNode;147;-2868.085,-180.2536;Inherit;False;Property;_Float2;Float 2;4;0;Create;True;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;189.5579,101.1998;Inherit;False;Property;_voroscale;voroscale;0;0;Create;True;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;148;-2776.186,12.54637;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;123;372.3064,101.2161;Inherit;False;Property;_vorostrength;vorostrength;1;0;Create;True;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;113;192.1416,-297.7705;Inherit;True;0;0;1;0;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-2594.885,65.94649;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;-0.5,-0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TimeNode;107;-1421.118,532.6964;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;166;-1305.182,744.4651;Inherit;False;Property;_sub;sub;7;0;Create;True;0;0;False;0;False;0.1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;376.871,-292.4103;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;2.48;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;120;-2462.898,-98.70825;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;145;-2245.395,-408.9691;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;135;267.7366,-407.343;Inherit;False;patern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;-1057.626,701.6865;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;110;-869.614,669.1312;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;136;-1490.689,52.39507;Inherit;False;135;patern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;-1072.626,505.6865;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;144;-1635.541,-407.9156;Inherit;True;Simple HUE;-1;;26;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.RangedFloatNode;163;-1166.374,273.5832;Inherit;False;Constant;_Float3;Float 3;7;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;164;-1160.204,337.0835;Inherit;False;Constant;_Float4;Float 4;7;0;Create;True;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;179;-1310.023,259.2393;Inherit;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-1233.37,-7.915894;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FractNode;111;-861.0762,767.2763;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;108;-860.7197,431.5567;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;112;-1003.666,-8.083763;Inherit;True;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,0,0;False;3;FLOAT3;-1,0,0;False;4;FLOAT3;1,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;127;-870.715,848.9012;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;109;-867.892,501.8282;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;-503.9669,197.8279;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-507.615,528.3311;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;128;-237.7028,482.3305;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.5,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;129;-239.5265,155.8818;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.5,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;181;-1059.626,604.6865;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;198;-22.40747,460.713;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleRemainderNode;184;255.7641,821.049;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;197;-39.81634,254.879;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;185;427.2405,833.3146;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;366.1864,461.4011;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;2.48;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;364.6782,198.7691;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;2.48;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;149;565.1372,256.1065;Inherit;False;Property;_Color0;Color 0;5;1;[HDR];Create;True;0;0;False;0;False;0.5697757,0.7465658,0.9339623,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;150;565.1375,518.9718;Inherit;False;Property;_Color1;Color 1;6;1;[HDR];Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;186;577.2405,830.3146;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;193;732.257,95.65049;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;194;778.7965,381.5341;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;195;865.2924,713.245;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;925.5168,227.0047;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;919.1055,489.8697;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;122;-2461.837,-218.8588;Inherit;False;Property;_offset;offset;2;0;Create;True;0;0;False;0;False;-0.25,-0.25;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;121;-2461.073,-338.0164;Inherit;False;Property;_tiling;tiling;3;0;Create;True;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SaturateNode;161;816.506,951.1661;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;158;930.3495,834.6705;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;162;1088.268,867.2291;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;153;1173.366,477.2953;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;169;-1947.083,63.60131;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;159;977.3245,906.5466;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;157;1168.235,771.4531;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;171;-2082.337,163.1481;Inherit;False;Property;_OP;OP;8;0;Create;True;0;0;False;0;False;1.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;-2092.075,-17.55104;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;124;-508.9402,-99.81408;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;140;186.9719,196.1364;Inherit;True;0;0;1;0;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VoronoiNode;142;188.4799,457.2706;Inherit;True;0;0;1;0;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SaturateNode;160;1209.36,894.1373;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1449.39,405.1806;Float;False;True;-1;7;ASEMaterialInspector;0;0;Standard;Custom/sh_realistic_eventhorizon;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;148;0;147;0
WireConnection;148;1;147;0
WireConnection;113;2;114;0
WireConnection;146;0;148;0
WireConnection;118;0;113;0
WireConnection;118;1;123;0
WireConnection;120;0;147;0
WireConnection;120;1;146;0
WireConnection;145;0;120;0
WireConnection;135;0;118;0
WireConnection;180;0;107;2
WireConnection;180;1;166;0
WireConnection;110;0;180;0
WireConnection;182;0;107;2
WireConnection;182;1;166;0
WireConnection;144;1;145;0
WireConnection;117;0;144;6
WireConnection;117;1;136;0
WireConnection;111;0;110;0
WireConnection;108;0;182;0
WireConnection;112;0;117;0
WireConnection;112;1;179;0
WireConnection;112;2;163;0
WireConnection;112;3;164;0
WireConnection;112;4;163;0
WireConnection;127;0;111;0
WireConnection;109;0;108;0
WireConnection;125;0;112;0
WireConnection;125;1;109;0
WireConnection;126;0;112;0
WireConnection;126;1;127;0
WireConnection;128;0;144;6
WireConnection;128;1;126;0
WireConnection;129;0;144;6
WireConnection;129;1;125;0
WireConnection;181;0;107;2
WireConnection;181;1;166;0
WireConnection;198;0;128;0
WireConnection;184;0;181;0
WireConnection;197;0;129;0
WireConnection;185;0;184;0
WireConnection;143;0;198;0
WireConnection;143;1;123;0
WireConnection;141;0;197;0
WireConnection;141;1;123;0
WireConnection;186;0;185;0
WireConnection;193;0;141;0
WireConnection;194;0;143;0
WireConnection;195;0;186;0
WireConnection;152;0;193;0
WireConnection;152;1;149;0
WireConnection;151;0;194;0
WireConnection;151;1;150;0
WireConnection;153;0;152;0
WireConnection;153;1;151;0
WireConnection;153;2;195;0
WireConnection;140;0;129;0
WireConnection;140;2;114;0
WireConnection;142;2;114;0
WireConnection;0;2;153;0
ASEEND*/
//CHKSM=56E8D392F0A8047D280EE53E190E394863640285