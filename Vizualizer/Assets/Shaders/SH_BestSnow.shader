// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_BestSnow"
{
	Properties
	{
		_Tess("Tess", Range( 1 , 50)) = 1
		[HDR]_Color0("Color 0", Color) = (1,1,1,1)
		[HDR]_ColorPeak("ColorPeak", Color) = (1,1,1,1)
		[HDR]_ColorGround("ColorGround", Color) = (1,1,1,1)
		_Patern_1_Scale("Patern_1_Scale", Float) = 10
		_Patern_2_Scale("Patern_2_Scale", Float) = 10
		_Patern_1_Power("Patern_1_Power", Float) = 1
		_Patern_2_Power("Patern_2_Power", Float) = 1
		_Patern_1_Strength("Patern_1_Strength", Float) = 1
		_Patern_2_Strength("Patern_2_Strength", Float) = 1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Patern_1_power("Patern_1_power", Float) = 0.1
		_StepPeak("StepPeak", Vector) = (0,0,0,0)
		_StepGround("StepGround", Vector) = (0,0,0,0)
		_PaternsAngle("PaternsAngle", Vector) = (0,0,0,0)
		_AngleSpeed("AngleSpeed", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex.SampleLevel(samplerTex,coord, lod)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex2Dlod(tex,float4(coord,0,lod))
		#endif//ASE Sampling Macros

		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Patern_2_Scale;
		uniform float2 _PaternsAngle;
		uniform float _AngleSpeed;
		uniform float _Patern_2_Power;
		uniform float _Patern_2_Strength;
		uniform float _Patern_1_Scale;
		uniform float _Patern_1_Power;
		uniform float _Patern_1_Strength;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_TextureSample0);
		uniform float4 _TextureSample0_ST;
		SamplerState sampler_TextureSample0;
		uniform float _Patern_1_power;
		uniform float2 _StepGround;
		uniform float4 _Color0;
		uniform float4 _ColorPeak;
		uniform float2 _StepPeak;
		uniform float4 _ColorGround;
		uniform float _Tess;


		float2 voronoihash34( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi34( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash34( n + g );
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
			return (F2 + F1) * 0.5;
		}


		float2 voronoihash5( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi5( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash5( n + g );
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
			return (F2 + F1) * 0.5;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _Tess);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_55_0 = ( _AngleSpeed * _Time.y );
			float time34 = ( _PaternsAngle.x + temp_output_55_0 );
			float2 coords34 = v.texcoord.xy * _Patern_2_Scale;
			float2 id34 = 0;
			float2 uv34 = 0;
			float fade34 = 0.5;
			float voroi34 = 0;
			float rest34 = 0;
			for( int it34 = 0; it34 <8; it34++ ){
			voroi34 += fade34 * voronoi34( coords34, time34, id34, uv34, 0 );
			rest34 += fade34;
			coords34 *= 2;
			fade34 *= 0.5;
			}//Voronoi34
			voroi34 /= rest34;
			float time5 = ( _PaternsAngle.y + temp_output_55_0 );
			float2 coords5 = v.texcoord.xy * _Patern_1_Scale;
			float2 id5 = 0;
			float2 uv5 = 0;
			float fade5 = 0.5;
			float voroi5 = 0;
			float rest5 = 0;
			for( int it5 = 0; it5 <8; it5++ ){
			voroi5 += fade5 * voronoi5( coords5, time5, id5, uv5, 0 );
			rest5 += fade5;
			coords5 *= 2;
			fade5 *= 0.5;
			}//Voronoi5
			voroi5 /= rest5;
			float2 uv_TextureSample0 = v.texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 temp_output_24_0 = ( ( ( pow( voroi34 , _Patern_2_Power ) * _Patern_2_Strength ) + ( pow( voroi5 , _Patern_1_Power ) * _Patern_1_Strength ) ) * ( 1.0 - SAMPLE_TEXTURE2D_LOD( _TextureSample0, sampler_TextureSample0, uv_TextureSample0, 0.0 ) ) );
			float3 appendResult18 = (float3(ase_vertex3Pos.x , ( ( ase_vertex3Pos.y + temp_output_24_0 ) * _Patern_1_power ).r , ase_vertex3Pos.z));
			v.vertex.xyz += appendResult18;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 temp_cast_0 = (_StepGround.x).xxxx;
			float4 temp_cast_1 = (_StepGround.y).xxxx;
			float temp_output_55_0 = ( _AngleSpeed * _Time.y );
			float time34 = ( _PaternsAngle.x + temp_output_55_0 );
			float2 coords34 = i.uv_texcoord * _Patern_2_Scale;
			float2 id34 = 0;
			float2 uv34 = 0;
			float fade34 = 0.5;
			float voroi34 = 0;
			float rest34 = 0;
			for( int it34 = 0; it34 <8; it34++ ){
			voroi34 += fade34 * voronoi34( coords34, time34, id34, uv34, 0 );
			rest34 += fade34;
			coords34 *= 2;
			fade34 *= 0.5;
			}//Voronoi34
			voroi34 /= rest34;
			float time5 = ( _PaternsAngle.y + temp_output_55_0 );
			float2 coords5 = i.uv_texcoord * _Patern_1_Scale;
			float2 id5 = 0;
			float2 uv5 = 0;
			float fade5 = 0.5;
			float voroi5 = 0;
			float rest5 = 0;
			for( int it5 = 0; it5 <8; it5++ ){
			voroi5 += fade5 * voronoi5( coords5, time5, id5, uv5, 0 );
			rest5 += fade5;
			coords5 *= 2;
			fade5 *= 0.5;
			}//Voronoi5
			voroi5 /= rest5;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 temp_output_24_0 = ( ( ( pow( voroi34 , _Patern_2_Power ) * _Patern_2_Strength ) + ( pow( voroi5 , _Patern_1_Power ) * _Patern_1_Strength ) ) * ( 1.0 - SAMPLE_TEXTURE2D( _TextureSample0, sampler_TextureSample0, uv_TextureSample0 ) ) );
			float4 lerpResult64 = lerp( _Color0 , _ColorPeak , temp_output_24_0);
			float4 smoothstepResult57 = smoothstep( temp_cast_0 , temp_cast_1 , lerpResult64);
			o.Albedo = smoothstepResult57.rgb;
			float4 temp_cast_3 = (_StepPeak.x).xxxx;
			float4 temp_cast_4 = (_StepPeak.y).xxxx;
			float4 smoothstepResult40 = smoothstep( temp_cast_3 , temp_cast_4 , temp_output_24_0);
			o.Emission = ( smoothstepResult40 * _ColorGround ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
0;0;1920;1019;1255.723;985.3141;1.191084;True;False
Node;AmplifyShaderEditor.RangedFloatNode;54;-3329.579,287.8969;Inherit;False;Property;_AngleSpeed;AngleSpeed;15;0;Create;True;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;53;-3358.179,365.8968;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;49;-3168.378,-13.70309;Inherit;False;Property;_PaternsAngle;PaternsAngle;14;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-3103.379,360.697;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-2743.279,225.4969;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-2749.779,-56.60307;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-2732.942,374.2211;Inherit;False;Property;_Patern_1_Scale;Patern_1_Scale;4;0;Create;True;0;0;False;0;False;10;7.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-2754.569,68.31721;Inherit;False;Property;_Patern_2_Scale;Patern_2_Scale;5;0;Create;True;0;0;False;0;False;10;3.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-2230.079,318.3447;Inherit;False;Property;_Patern_1_Power;Patern_1_Power;6;0;Create;True;0;0;False;0;False;1;2.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2251.706,12.4407;Inherit;False;Property;_Patern_2_Power;Patern_2_Power;7;0;Create;True;0;0;False;0;False;1;3.78;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;34;-2492.702,-96.2448;Inherit;True;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;8.35;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VoronoiNode;5;-2471.076,209.6592;Inherit;True;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;8.35;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.PowerNode;37;-2237.272,-91.7851;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;26;-2215.646,214.1189;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-2038.441,12.4408;Inherit;False;Property;_Patern_2_Strength;Patern_2_Strength;9;0;Create;True;0;0;False;0;False;1;50.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-2016.815,318.3448;Inherit;False;Property;_Patern_1_Strength;Patern_1_Strength;8;0;Create;True;0;0;False;0;False;1;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2004.768,-93.3886;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1983.142,212.5154;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-2352.231,545.6995;Inherit;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;False;0;False;-1;7af2ec1274b2d1649abc0d46367ff987;7af2ec1274b2d1649abc0d46367ff987;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;22;-1938.922,560.3476;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-1722.776,75.9967;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1699.516,431.4083;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;17;-1042.43,340.6608;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-843.5352,659.2657;Inherit;False;Property;_Patern_1_power;Patern_1_power;11;0;Create;True;0;0;False;0;False;0.1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-836.6931,525.6199;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1;-1381.422,-863.9983;Inherit;False;Property;_Color0;Color 0;1;1;[HDR];Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;41;-1376.375,-656.8157;Inherit;False;Property;_ColorPeak;ColorPeak;2;1;[HDR];Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;46;-854.376,181.2969;Inherit;False;Property;_StepPeak;StepPeak;12;0;Create;True;0;0;False;0;False;0,0;0.16,0.09;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;56;-857.7011,-141.8004;Inherit;False;Property;_StepGround;StepGround;13;0;Create;True;0;0;False;0;False;0,0;0.08,1.6;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;58;-593.8018,-189.9006;Inherit;False;Property;_ColorGround;ColorGround;3;1;[HDR];Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-531.0875,855.463;Inherit;False;Property;_Tess;Tess;0;0;Create;True;0;0;False;0;False;1;1;1;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-632.6024,524.1284;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;64;-672.7072,-543.5706;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;40;-587.8769,17.4967;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;73.07956,33.19079;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-283.6759,48.69678;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-287.001,-274.4005;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;334.4212,-290.838;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;57;-284.127,-443.6291;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;3;-232.2908,836.6281;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-444.7684,364.4911;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-387.3834,-691.2905;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VoronoiNode;62;-101.7313,94.63439;Inherit;True;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;50;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.OneMinusNode;63;-348.4137,-44.72095;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-1643.292,698.897;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;789.8186,-143.1051;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;SH_BestSnow;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;55;0;54;0
WireConnection;55;1;53;2
WireConnection;52;0;49;2
WireConnection;52;1;55;0
WireConnection;50;0;49;1
WireConnection;50;1;55;0
WireConnection;34;1;50;0
WireConnection;34;2;33;0
WireConnection;5;1;52;0
WireConnection;5;2;6;0
WireConnection;37;0;34;0
WireConnection;37;1;35;0
WireConnection;26;0;5;0
WireConnection;26;1;27;0
WireConnection;38;0;37;0
WireConnection;38;1;36;0
WireConnection;29;0;26;0
WireConnection;29;1;28;0
WireConnection;22;0;8;0
WireConnection;47;0;38;0
WireConnection;47;1;29;0
WireConnection;24;0;47;0
WireConnection;24;1;22;0
WireConnection;21;0;17;2
WireConnection;21;1;24;0
WireConnection;9;0;21;0
WireConnection;9;1;10;0
WireConnection;64;0;1;0
WireConnection;64;1;41;0
WireConnection;64;2;24;0
WireConnection;40;0;24;0
WireConnection;40;1;46;1
WireConnection;40;2;46;2
WireConnection;61;1;62;0
WireConnection;43;0;63;0
WireConnection;59;0;40;0
WireConnection;59;1;58;0
WireConnection;57;0;64;0
WireConnection;57;1;56;1
WireConnection;57;2;56;2
WireConnection;3;0;4;0
WireConnection;18;0;17;1
WireConnection;18;1;9;0
WireConnection;18;2;17;3
WireConnection;63;0;57;0
WireConnection;0;0;57;0
WireConnection;0;2;59;0
WireConnection;0;11;18;0
WireConnection;0;14;3;0
ASEEND*/
//CHKSM=6FCB05071E9BC6170F3ABADF9293791BD93AA282