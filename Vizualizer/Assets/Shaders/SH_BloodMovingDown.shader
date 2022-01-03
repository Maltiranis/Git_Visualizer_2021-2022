// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ValouShaders/BloodMovingDown"
{
	Properties
	{
		_BloodStep("BloodStep", Float) = -0.1
		[HDR]_Color0("Color 0", Color) = (1,0,0,1)
		[HDR]_Color1("Color 1", Color) = (0.1603774,0,0,1)
		_LightStrength("LightStrength", Float) = 1
		_BSP("BSP", Vector) = (0,1,5,0)
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
		#pragma surface surf Standard alpha:fade keepalpha 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 viewDir;
			float3 worldNormal;
			float4 vertexColor : COLOR;
		};

		uniform float _BloodStep;
		uniform float4 _Color1;
		uniform float4 _Color0;
		uniform float4 _BSP;
		uniform float _LightStrength;


		float2 voronoihash15( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi15( float2 v, inout float2 id )
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
			 		float2 o = voronoihash15( n + g );
					o = ( sin( _Time.x + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
					float d = 0.707 * sqrt(dot( r, r ));
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


		float2 UnityGradientNoiseDir( float2 p )
		{
			p = fmod(p , 289);
			float x = fmod((34 * p.x + 1) * p.x , 289) + p.y;
			x = fmod( (34 * x + 1) * x , 289);
			x = frac( x / 41 ) * 2 - 1;
			return normalize( float2(x - floor(x + 0.5 ), abs( x ) - 0.5 ) );
		}
		
		float UnityGradientNoise( float2 UV, float Scale )
		{
			float2 p = UV * Scale;
			float2 ip = floor( p );
			float2 fp = frac( p );
			float d00 = dot( UnityGradientNoiseDir( ip ), fp );
			float d01 = dot( UnityGradientNoiseDir( ip + float2( 0, 1 ) ), fp - float2( 0, 1 ) );
			float d10 = dot( UnityGradientNoiseDir( ip + float2( 1, 0 ) ), fp - float2( 1, 0 ) );
			float d11 = dot( UnityGradientNoiseDir( ip + float2( 1, 1 ) ), fp - float2( 1, 1 ) );
			fp = fp * fp * fp * ( fp * ( fp * 6 - 15 ) + 10 );
			return lerp( lerp( d00, d01, fp.y ), lerp( d10, d11, fp.y ), fp.x ) + 0.5;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 coords15 = i.uv_texcoord * 2.0;
			float2 id15 = 0;
			float fade15 = 0.5;
			float voroi15 = 0;
			float rest15 = 0;
			for( int it = 0; it <8; it++ ){
			voroi15 += fade15 * voronoi15( coords15, id15 );
			rest15 += fade15;
			coords15 *= 2;
			fade15 *= 0.5;
			}
			voroi15 /= rest15;
			float2 temp_cast_0 = (voroi15).xx;
			float gradientNoise14 = UnityGradientNoise(temp_cast_0,1.0);
			float4 temp_cast_1 = (gradientNoise14).xxxx;
			float4 lerpResult3 = lerp( _Color0 , _Color1 , gradientNoise14);
			float4 clampResult20 = clamp( lerpResult3 , float4( 0,0,0,0 ) , _Color0 );
			float4 smoothstepResult13 = smoothstep( ( _BloodStep * ( _Color1 * gradientNoise14 ) ) , temp_cast_1 , clampResult20);
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV4 = dot( ase_worldNormal, i.viewDir );
			float fresnelNode4 = ( _BSP.x + _BSP.y * pow( 1.0 - fresnelNdotV4, _BSP.z ) );
			o.Emission = ( smoothstepResult13 + ( ( gradientNoise14 * fresnelNode4 ) * _LightStrength ) ).rgb;
			o.Alpha = ( gradientNoise14 * i.vertexColor.a );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
1920;0;1920;1019;2390.521;-0.2768555;1.984487;True;False
Node;AmplifyShaderEditor.TimeNode;31;-2045.214,503.1407;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-1454.472,318.2274;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;15;-1095.027,493.1367;Inherit;True;0;1;1;3;8;False;1;False;3;0;FLOAT2;0,0;False;1;FLOAT;4.8;False;2;FLOAT;2;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.Vector4Node;24;-1331.484,866.7142;Inherit;False;Property;_BSP;BSP;4;0;Create;True;0;0;False;0;0,1,5,0;0,3,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;25;-1323.319,712.7726;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NoiseGeneratorNode;14;-832.5283,491.1384;Inherit;True;Gradient;False;True;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-882.2465,78.09888;Inherit;False;Property;_Color0;Color 0;1;1;[HDR];Create;True;0;0;False;0;1,0,0,1;0,0.03732898,3.56487,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-880.6312,245.883;Inherit;False;Property;_Color1;Color 1;2;1;[HDR];Create;True;0;0;False;0;0.1603774,0,0,1;0.02771044,0,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-287.6262,497.613;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;3;-566.036,294.2823;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;4;-970.4922,841.1722;Inherit;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-333.8144,400.1367;Inherit;False;Property;_BloodStep;BloodStep;0;0;Create;True;0;0;False;0;-0.1;-1.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-70.02644,412.8134;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;-0.01,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;20;-265.376,221.4119;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-292.5179,836.916;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-412.2132,1162.063;Inherit;False;Property;_LightStrength;LightStrength;3;0;Create;True;0;0;False;0;1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;45.40219,913.8898;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;13;175.8122,230.3669;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;35;359.3539,930.8987;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;8;-1207.648,1270.313;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;628.8517,812.0067;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-631.698,1031.544;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;7;-1178.61,1110.595;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;5;549.4071,372.4986;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1796.09,448.4549;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-1607.728,371.8949;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;9;-920.4795,1112.208;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;884.9467,415.6869;Float;False;True;7;ASEMaterialInspector;0;0;Standard;ValouShaders/BloodMovingDown;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;5;True;False;0;False;Transparent;;Transparent;All;15;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.3;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;16;0
WireConnection;15;1;31;1
WireConnection;14;0;15;0
WireConnection;30;0;2;0
WireConnection;30;1;14;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;3;2;14;0
WireConnection;4;4;25;0
WireConnection;4;1;24;1
WireConnection;4;2;24;2
WireConnection;4;3;24;3
WireConnection;29;0;17;0
WireConnection;29;1;30;0
WireConnection;20;0;3;0
WireConnection;20;2;1;0
WireConnection;23;0;14;0
WireConnection;23;1;4;0
WireConnection;22;0;23;0
WireConnection;22;1;21;0
WireConnection;13;0;20;0
WireConnection;13;1;29;0
WireConnection;13;2;14;0
WireConnection;36;0;14;0
WireConnection;36;1;35;4
WireConnection;12;1;9;0
WireConnection;5;0;13;0
WireConnection;5;1;22;0
WireConnection;34;0;31;1
WireConnection;33;1;34;0
WireConnection;9;0;7;0
WireConnection;9;1;8;0
WireConnection;0;2;5;0
WireConnection;0;9;36;0
ASEEND*/
//CHKSM=128F1E963BA2A9C9CC873915C4D3A3DF1D068D94