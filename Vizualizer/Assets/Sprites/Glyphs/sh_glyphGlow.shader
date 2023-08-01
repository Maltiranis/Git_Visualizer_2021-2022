// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/sh_glyphGlow"
{
	Properties
	{
		[HDR]_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HDR]_Color0("Color 0", Color) = (0,0,0,0)
		_angle("angle", Float) = 0
		_scale("scale", Float) = 1
		_Color1("Color 1", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 5.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _scale;
		uniform float _angle;
		uniform float4 _Color0;
		uniform float4 _Color1;


		float2 voronoihash8( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi8( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash8( n + g );
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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode4 = tex2D( _TextureSample0, uv_TextureSample0 );
			float time8 = _angle;
			float2 coords8 = i.uv_texcoord * _scale;
			float2 id8 = 0;
			float2 uv8 = 0;
			float fade8 = 0.5;
			float voroi8 = 0;
			float rest8 = 0;
			for( int it8 = 0; it8 <8; it8++ ){
			voroi8 += fade8 * voronoi8( coords8, time8, id8, uv8, 0 );
			rest8 += fade8;
			coords8 *= 2;
			fade8 *= 0.5;
			}//Voronoi8
			voroi8 /= rest8;
			float2 appendResult10_g2 = (float2(1.0 , 1.0));
			float2 temp_output_11_0_g2 = ( abs( (i.uv_texcoord*2.0 + -1.0) ) - appendResult10_g2 );
			float2 break16_g2 = ( 1.0 - ( temp_output_11_0_g2 / fwidth( temp_output_11_0_g2 ) ) );
			float2 appendResult10_g1 = (float2(0.95 , 0.95));
			float2 temp_output_11_0_g1 = ( abs( (i.uv_texcoord*2.0 + -1.0) ) - appendResult10_g1 );
			float2 break16_g1 = ( 1.0 - ( temp_output_11_0_g1 / fwidth( temp_output_11_0_g1 ) ) );
			float2 uv_TexCoord21 = i.uv_texcoord + float2( -0.5,-0.5 );
			o.Emission = ( ( ( ( 1.0 - tex2DNode4 ) * voroi8 ) * _Color0 ) + ( _Color0 * ( saturate( min( break16_g2.x , break16_g2.y ) ) - saturate( min( break16_g1.x , break16_g1.y ) ) ) * voroi8 ) + ( _Color1 * tex2DNode4 * ( 1.0 - length( uv_TexCoord21 ) ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
400.6667;72.66667;1605.333;721;1997.092;-418.4712;1;True;True
Node;AmplifyShaderEditor.SamplerNode;4;-1351.471,-41.23038;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;1;[HDR];Create;True;0;0;False;0;False;-1;874b6b25c14e7544f9eddecc17e5df96;874b6b25c14e7544f9eddecc17e5df96;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-1481.909,254.9737;Inherit;False;Property;_scale;scale;3;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-540.2529,1028.403;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.5,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-1478.909,168.9735;Inherit;False;Property;_angle;angle;2;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;12;-1357.251,755.6974;Inherit;True;Rectangle;-1;;2;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;5;-1035.626,2.283215;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;10;-1355.596,968.4143;Inherit;True;Rectangle;-1;;1;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;0.95;False;3;FLOAT;0.95;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;8;-1302.579,178.7794;Inherit;True;0;0;1;0;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.LengthOpNode;20;-514.4449,814.5646;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;18;-923.6866,-309.9296;Inherit;False;Property;_Color1;Color 1;4;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;11;-1072.094,871.2965;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;22;-501.5414,727.923;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-860.8029,162.3048;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;6;-1325.564,474.4301;Inherit;False;Property;_Color0;Color 0;1;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-700.6313,-131.1165;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-628.2111,323.5954;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-630.3247,494.7582;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-367.3399,416.6991;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;3;-122.1717,368.9583;Float;False;True;-1;7;ASEMaterialInspector;0;0;Unlit;Custom/sh_glyphGlow;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;4;0
WireConnection;8;1;15;0
WireConnection;8;2;16;0
WireConnection;20;0;21;0
WireConnection;11;0;12;0
WireConnection;11;1;10;0
WireConnection;22;0;20;0
WireConnection;9;0;5;0
WireConnection;9;1;8;0
WireConnection;17;0;18;0
WireConnection;17;1;4;0
WireConnection;17;2;22;0
WireConnection;7;0;9;0
WireConnection;7;1;6;0
WireConnection;14;0;6;0
WireConnection;14;1;11;0
WireConnection;14;2;8;0
WireConnection;13;0;7;0
WireConnection;13;1;14;0
WireConnection;13;2;17;0
WireConnection;3;2;13;0
ASEEND*/
//CHKSM=679B1A31C69F1CF6E784FC956076C1F3ADA38360