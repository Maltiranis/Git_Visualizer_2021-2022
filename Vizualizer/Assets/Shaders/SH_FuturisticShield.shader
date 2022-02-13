// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ValouShaders/SH_FuturisticShield"
{
	Properties
	{
		_Tess("Tess", Range( 1 , 10)) = 10
		[HDR]_Color("Color", Color) = (0,1.39203,1.414214,1)
		_NoiseSpeedChanger("NoiseSpeedChanger", Float) = 1
		_NoiseScale("NoiseScale", Float) = 2
		_SmoothSte_color1("SmoothSte_color1", Vector) = (0,0,0,0)
		_SmoothSte_color2("SmoothSte_color2", Vector) = (0,0,0,0)
		_SmoothStepOpacity("SmoothStepOpacity", Vector) = (0,0,0,0)
		_Radials("Radials", Vector) = (1,1,0,0)
		_depth("depth", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 5.0
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			float4 screenPos;
		};

		uniform float4 _Color;
		uniform float2 _SmoothSte_color1;
		uniform float _NoiseScale;
		uniform float _NoiseSpeedChanger;
		uniform float2 _Radials;
		uniform float2 _SmoothSte_color2;
		uniform float2 _SmoothStepOpacity;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _depth;
		uniform float _Tess;


		float2 voronoihash3( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi3( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash3( n + g );
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
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float time3 = ( _NoiseSpeedChanger * _Time.y );
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float2 temp_cast_0 = (ase_vertexNormal.y).xx;
			float2 CenteredUV15_g1 = ( i.uv_texcoord - temp_cast_0 );
			float2 break17_g1 = CenteredUV15_g1;
			float2 appendResult23_g1 = (float2(( length( CenteredUV15_g1 ) * _Radials.x * 2.0 ) , ( atan2( break17_g1.x , break17_g1.y ) * ( 1.0 / 6.28318548202515 ) * _Radials.y )));
			float2 coords3 = appendResult23_g1 * _NoiseScale;
			float2 id3 = 0;
			float2 uv3 = 0;
			float fade3 = 0.5;
			float voroi3 = 0;
			float rest3 = 0;
			for( int it3 = 0; it3 <8; it3++ ){
			voroi3 += fade3 * voronoi3( coords3, time3, id3, uv3, 0 );
			rest3 += fade3;
			coords3 *= 2;
			fade3 *= 0.5;
			}//Voronoi3
			voroi3 /= rest3;
			float smoothstepResult24 = smoothstep( _SmoothSte_color1.x , _SmoothSte_color1.y , voroi3);
			float smoothstepResult36 = smoothstep( _SmoothSte_color2.x , _SmoothSte_color2.y , voroi3);
			float temp_output_44_0 = ( smoothstepResult24 - smoothstepResult36 );
			o.Emission = ( ( _Color * temp_output_44_0 ) + float4( 0,0,0,0 ) ).rgb;
			float smoothstepResult46 = smoothstep( _SmoothStepOpacity.x , _SmoothStepOpacity.y , temp_output_44_0);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float eyeDepth57 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			o.Alpha = ( smoothstepResult46 + ( 1.0 - ( eyeDepth57 - ( ase_screenPosNorm.w - _depth ) ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
1920;0;1920;1019;148.3744;369.3505;1.332873;True;False
Node;AmplifyShaderEditor.RangedFloatNode;8;-1262.338,-59.21149;Inherit;False;Property;_NoiseSpeedChanger;NoiseSpeedChanger;4;0;Create;True;0;0;False;0;False;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;40;-1483.466,-387.0291;Inherit;False;Property;_Radials;Radials;9;0;Create;True;0;0;False;0;False;1,1;0.5,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;6;-1253.338,52.78851;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;42;-1481.21,-542.4228;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1039.338,3.788513;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1049.338,136.7885;Inherit;False;Property;_NoiseScale;NoiseScale;5;0;Create;True;0;0;False;0;False;2;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;39;-1181.16,-422.405;Inherit;True;Polar Coordinates;-1;;1;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;3;-827.1878,-218.2897;Inherit;True;0;0;1;0;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;66;655.348,774.2545;Inherit;False;Property;_depth;depth;11;0;Create;True;0;0;False;0;False;0;13.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;35;-594.2914,-165.0628;Inherit;False;Property;_SmoothSte_color2;SmoothSte_color2;7;0;Create;True;0;0;False;0;False;0,0;0.26,0.26;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScreenPosInputsNode;63;427.4267,570.3248;Float;True;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;25;-694.0463,-373.2856;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;26;-606.5466,-363.7856;Inherit;False;Property;_SmoothSte_color1;SmoothSte_color1;6;0;Create;True;0;0;False;0;False;0,0;0.21,0.25;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScreenDepthNode;57;666.0105,503.682;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;36;-367.9024,-247.7172;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;24;-391.8576,-436.2307;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;65;929.9199,692.9493;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;44;-87.71982,-300.6056;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;5;-420.6484,-612.8216;Inherit;False;Property;_Color;Color;2;1;[HDR];Create;True;0;0;False;0;False;0,1.39203,1.414214,1;0,0.7985763,0.8027793,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;45;-410.791,23.3561;Inherit;False;Property;_SmoothStepOpacity;SmoothStepOpacity;8;0;Create;True;0;0;False;0;False;0,0;0.5,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;56;963.0433,509.7122;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;1319.233,513.694;Inherit;False;Property;_Tess;Tess;1;0;Create;True;0;0;False;0;False;10;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;58;1120.521,430.3733;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;180.1775,-290.128;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;46;-62.6557,-70.49332;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;48;686.4483,252.3635;Inherit;False;Property;_Color2;Color2;3;1;[HDR];Create;True;0;0;False;0;False;0,1.39203,1.414214,1;0,0.7985763,0.8027793,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;50;316.9485,208.9659;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;1281.033,272.1095;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;1;1595.884,507.826;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;53;1673.572,85.97224;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;49;637.3514,116.7818;Inherit;False;Property;_Depth;Depth;10;0;Create;True;0;0;False;0;False;0;11.87;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;51;300.3821,45.84921;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;64;1617.682,330.4078;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;47;812.3106,76.8998;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;69;414.0981,385.0557;Inherit;True;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1825.151,43.52;Float;False;True;-1;7;ASEMaterialInspector;0;0;Standard;ValouShaders/SH_FuturisticShield;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;False;TransparentCutout;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;8;0
WireConnection;7;1;6;2
WireConnection;39;2;42;2
WireConnection;39;3;40;1
WireConnection;39;4;40;2
WireConnection;3;0;39;0
WireConnection;3;1;7;0
WireConnection;3;2;9;0
WireConnection;25;0;3;0
WireConnection;36;0;3;0
WireConnection;36;1;35;1
WireConnection;36;2;35;2
WireConnection;24;0;25;0
WireConnection;24;1;26;1
WireConnection;24;2;26;2
WireConnection;65;0;63;4
WireConnection;65;1;66;0
WireConnection;44;0;24;0
WireConnection;44;1;36;0
WireConnection;56;0;57;0
WireConnection;56;1;65;0
WireConnection;58;0;56;0
WireConnection;4;0;5;0
WireConnection;4;1;44;0
WireConnection;46;0;44;0
WireConnection;46;1;45;1
WireConnection;46;2;45;2
WireConnection;54;0;48;0
WireConnection;1;0;2;0
WireConnection;53;0;4;0
WireConnection;64;0;46;0
WireConnection;64;1;58;0
WireConnection;47;0;49;0
WireConnection;0;2;53;0
WireConnection;0;9;64;0
WireConnection;0;14;1;0
ASEEND*/
//CHKSM=AFCC17634216B9ADD1076C40F326C80E863C8AE0