// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ValouShaders/FireBall"
{
	Properties
	{
		[HDR]_PrincipalColor("PrincipalColor", Color) = (2,0,0,1)
		[HDR]_SecondaryColor("SecondaryColor", Color) = (2.670157,2.305967,0,1)
		_VoroScale("VoroScale", Float) = 5
		_SmoothStep("SmoothStep", Vector) = (0,1,0,0)
		_PaternSpeed("PaternSpeed", Float) = 0
		_HeatSpeed("HeatSpeed", Float) = 1
		_HeatDirection("HeatDirection", Vector) = (0,-1,0,0)
		_OpacityParameters("OpacityParameters", Vector) = (0,0.1,0,0)
		_NoiseScale("NoiseScale", Float) = 2
		_VoroPaternScale("VoroPaternScale", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 5.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _PrincipalColor;
		uniform float2 _SmoothStep;
		uniform float _VoroScale;
		uniform float _VoroPaternScale;
		uniform float2 _HeatDirection;
		uniform float _PaternSpeed;
		uniform float _NoiseScale;
		uniform float _HeatSpeed;
		uniform float4 _SecondaryColor;
		uniform float2 _OpacityParameters;


		float2 voronoihash4( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi4( float2 v, inout float2 id )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mr = 0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash4( n + g );
					o = ( sin( 0.0 + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return (F2 + F1) * 0.5;
		}


		float2 voronoihash25( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi25( float2 v, inout float2 id )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mr = 0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash25( n + g );
					o = ( sin( ( _HeatDirection.x + ( _Time.y * _PaternSpeed ) ) + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return (F2 + F1) * 0.5;
		}


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (0.5).xx;
			float2 temp_cast_1 = (( 0.5 / -2.0 )).xx;
			float2 uv_TexCoord34 = i.uv_texcoord * temp_cast_0 + temp_cast_1;
			float smoothstepResult38 = smoothstep( 0.15 , 0.25 , length( uv_TexCoord34 ));
			float temp_output_39_0 = ( 1.0 - smoothstepResult38 );
			float2 coords25 = i.uv_texcoord * _VoroPaternScale;
			float2 id25 = 0;
			float fade25 = 0.5;
			float voroi25 = 0;
			float rest25 = 0;
			for( int it = 0; it <8; it++ ){
			voroi25 += fade25 * voronoi25( coords25, id25 );
			rest25 += fade25;
			coords25 *= 2;
			fade25 *= 0.5;
			}
			voroi25 /= rest25;
			float2 temp_cast_2 = (voroi25).xx;
			float simplePerlin2D24 = snoise( temp_cast_2*_NoiseScale );
			float temp_output_12_0 = ( _HeatSpeed * _Time.y );
			float2 appendResult14 = (float2(simplePerlin2D24 , ( _HeatDirection.y * temp_output_12_0 )));
			float2 uv_TexCoord5 = i.uv_texcoord + appendResult14;
			float2 coords4 = uv_TexCoord5 * _VoroScale;
			float2 id4 = 0;
			float fade4 = 0.5;
			float voroi4 = 0;
			float rest4 = 0;
			voroi4 += fade4 * voronoi4( coords4, id4 );
			rest4 += fade4;
			coords4 *= 2;
			fade4 *= 0.5;
			voroi4 /= rest4;
			float smoothstepResult8 = smoothstep( _SmoothStep.x , _SmoothStep.y , voroi4);
			float temp_output_41_0 = ( ( temp_output_39_0 * smoothstepResult8 ) - smoothstepResult38 );
			float4 temp_cast_3 = (temp_output_41_0).xxxx;
			float4 lerpResult3 = lerp( _PrincipalColor , temp_cast_3 , temp_output_41_0);
			float4 temp_cast_4 = (temp_output_41_0).xxxx;
			float4 lerpResult42 = lerp( _SecondaryColor , temp_cast_4 , temp_output_41_0);
			float smoothstepResult45 = smoothstep( _OpacityParameters.x , _OpacityParameters.y , temp_output_41_0);
			float clampResult47 = clamp( saturate( smoothstepResult45 ) , 0.0 , 1.0 );
			float4 lerpResult43 = lerp( lerpResult3 , lerpResult42 , clampResult47);
			o.Emission = ( temp_output_39_0 * lerpResult43 ).rgb;
			o.Alpha = clampResult47;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
217;73;1174;655;3352.214;-116.7289;1.790809;True;False
Node;AmplifyShaderEditor.TimeNode;9;-2353.924,-151.5119;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-2339.798,16.00368;Inherit;False;Property;_PaternSpeed;PaternSpeed;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;15;-1886.061,-483.5873;Inherit;False;Property;_HeatDirection;HeatDirection;6;0;Create;True;0;0;False;0;0,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-2324.409,108.3294;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2339.795,-344.0659;Inherit;False;Property;_HeatSpeed;HeatSpeed;5;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-2105.81,1136.351;Inherit;False;Property;_VoroPaternScale;VoroPaternScale;9;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-2077.321,235.9627;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-2132.327,357.4633;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-2325.945,-250.2017;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1133.322,-1006.105;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;25;-2152.964,503.0297;Inherit;True;0;0;1;3;8;False;1;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;5;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.RangedFloatNode;50;-2093.276,1045.959;Inherit;False;Property;_NoiseScale;NoiseScale;8;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;36;-1123.35,-910.4088;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-2;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;24;-2153.505,759.426;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1866.058,-222.6225;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-1822.693,-22.02633;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-1166.786,-794.3572;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.5,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;30;-1145.693,-650.8154;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1423.415,-4.511827;Inherit;False;Property;_VoroScale;VoroScale;2;0;Create;True;0;0;False;0;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1454.477,-150.3018;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;38;-1195.532,-571.158;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.15;False;2;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;4;-1474.305,91.49368;Inherit;True;0;0;1;3;8;False;1;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.Vector2Node;6;-935.8779,-41.70254;Inherit;False;Property;_SmoothStep;SmoothStep;3;0;Create;True;0;0;False;0;0,1;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;39;-939.5953,-571.1042;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;8;-968.3691,95.97227;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-664.9993,86.5724;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;41;-210.1581,-61.73767;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;49;163.0609,579.9943;Inherit;False;Property;_OpacityParameters;OpacityParameters;7;0;Create;True;0;0;False;0;0,0.1;0,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SmoothstepOpNode;45;439.3165,483.4411;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.12;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;44;654.936,462.9946;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;91.24933,93.61173;Inherit;False;Property;_SecondaryColor;SecondaryColor;1;1;[HDR];Create;True;0;0;False;0;2.670157,2.305967,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1;98.63851,-441.1677;Inherit;False;Property;_PrincipalColor;PrincipalColor;0;1;[HDR];Create;True;0;0;False;0;2,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;42;78.72507,278.7609;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;47;840.395,486.9159;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;3;77.33899,-215.8877;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;43;477.7558,-33.44363;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;46;854.1055,-356.5002;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;843.3011,-46.86013;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1867.597,-334.952;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1138.372,-61.44345;Float;False;True;7;ASEMaterialInspector;0;0;Standard;ValouShaders/FireBall;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;15;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;9;2
WireConnection;10;1;11;0
WireConnection;23;0;15;1
WireConnection;23;1;10;0
WireConnection;12;0;13;0
WireConnection;12;1;9;2
WireConnection;25;0;28;0
WireConnection;25;1;23;0
WireConnection;25;2;51;0
WireConnection;36;0;37;0
WireConnection;24;0;25;0
WireConnection;24;1;50;0
WireConnection;18;0;15;2
WireConnection;18;1;12;0
WireConnection;14;0;24;0
WireConnection;14;1;18;0
WireConnection;34;0;37;0
WireConnection;34;1;36;0
WireConnection;30;0;34;0
WireConnection;5;1;14;0
WireConnection;38;0;30;0
WireConnection;4;0;5;0
WireConnection;4;2;7;0
WireConnection;39;0;38;0
WireConnection;8;0;4;0
WireConnection;8;1;6;1
WireConnection;8;2;6;2
WireConnection;35;0;39;0
WireConnection;35;1;8;0
WireConnection;41;0;35;0
WireConnection;41;1;38;0
WireConnection;45;0;41;0
WireConnection;45;1;49;1
WireConnection;45;2;49;2
WireConnection;44;0;45;0
WireConnection;42;0;2;0
WireConnection;42;1;41;0
WireConnection;42;2;41;0
WireConnection;47;0;44;0
WireConnection;3;0;1;0
WireConnection;3;1;41;0
WireConnection;3;2;41;0
WireConnection;43;0;3;0
WireConnection;43;1;42;0
WireConnection;43;2;47;0
WireConnection;48;0;39;0
WireConnection;48;1;43;0
WireConnection;17;0;15;1
WireConnection;17;1;12;0
WireConnection;0;2;48;0
WireConnection;0;9;47;0
ASEEND*/
//CHKSM=BE366DFF2029E2E98D279409BA1E5F8E93CB3344