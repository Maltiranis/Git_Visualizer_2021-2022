// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sh_MaskingObjects"
{
	Properties
	{
		[HDR][NoScaleOffset]_TextureSample0("Texture Sample 0", 2D) = "black" {}
		[HDR]_Color1("Color 1", Color) = (1,1,1,1)
		[HDR]_Color0("Color 0", Color) = (1,1,1,1)
		[HDR]_Color2("Color 2", Color) = (1,1,1,1)
		_Dist("Dist", Float) = 0
		_DepthFadePower("DepthFadePower", Float) = 0
		_voroscale("voroscale", Float) = 0
		_pow("pow", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 5.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
			float4 screenPosition7;
		};

		uniform sampler2D _TextureSample0;
		SamplerState sampler_TextureSample0;
		uniform float2 _pow;
		uniform float _voroscale;
		uniform float4 _Color1;
		uniform float4 _Color2;
		uniform float4 _Color0;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Dist;
		uniform float _DepthFadePower;


		float2 voronoihash56( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi56( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash56( n + g );
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
			return F2;
		}


		float2 voronoihash144( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi144( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash144( n + g );
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
			return F2;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 appendResult41 = (float3(ase_vertex3Pos.x , ase_vertex3Pos.y , 0.0));
			float3 vertexPos7 = appendResult41;
			float4 ase_screenPos7 = ComputeScreenPos( UnityObjectToClipPos( vertexPos7 ) );
			o.screenPosition7 = ase_screenPos7;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float time56 = _Time.y;
			float2 coords56 = i.uv_texcoord * _voroscale;
			float2 id56 = 0;
			float2 uv56 = 0;
			float fade56 = 0.5;
			float voroi56 = 0;
			float rest56 = 0;
			for( int it56 = 0; it56 <8; it56++ ){
			voroi56 += fade56 * voronoi56( coords56, time56, id56, uv56, 0 );
			rest56 += fade56;
			coords56 *= 2;
			fade56 *= 0.5;
			}//Voronoi56
			voroi56 /= rest56;
			float time144 = _Time.y;
			float2 uv_TexCoord146 = i.uv_texcoord + float2( 0.01,0.01 );
			float2 coords144 = uv_TexCoord146 * _voroscale;
			float2 id144 = 0;
			float2 uv144 = 0;
			float fade144 = 0.5;
			float voroi144 = 0;
			float rest144 = 0;
			for( int it144 = 0; it144 <8; it144++ ){
			voroi144 += fade144 * voronoi144( coords144, time144, id144, uv144, 0 );
			rest144 += fade144;
			coords144 *= 2;
			fade144 *= 0.5;
			}//Voronoi144
			voroi144 /= rest144;
			float smoothstepResult148 = smoothstep( ( _pow.x / 100.0 ) , ( _pow.y / 100.0 ) , ( voroi56 * voroi144 ));
			float WeirdNoise73 = ( length( tex2D( _TextureSample0, ase_screenPosNorm.xy ).a ) * smoothstepResult148 );
			float4 CamCapture45 = ( WeirdNoise73 * _Color1 );
			float4 ase_screenPos7 = i.screenPosition7;
			float4 ase_screenPosNorm7 = ase_screenPos7 / ase_screenPos7.w;
			ase_screenPosNorm7.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm7.z : ase_screenPosNorm7.z * 0.5 + 0.5;
			float screenDepth7 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm7.xy ));
			float distanceDepth7 = abs( ( screenDepth7 - LinearEyeDepth( ase_screenPosNorm7.z ) ) / ( _Dist ) );
			float4 lerpResult28 = lerp( _Color2 , _Color0 , ( distanceDepth7 / _DepthFadePower ));
			float4 DepthColoration46 = lerpResult28;
			o.Emission = ( CamCapture45 + DepthColoration46 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
263;73;1303;655;4439.436;1687.715;2.739556;True;False
Node;AmplifyShaderEditor.RangedFloatNode;110;-4315.24,-79.84471;Inherit;False;Property;_voroscale;voroscale;7;0;Create;True;0;0;False;0;False;0;1000;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;57;-4355.025,-310.4549;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;146;-4211.651,-2.43174;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.01,0.01;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;145;-4450.497,-0.8517227;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;144;-3970.126,-74.17831;Inherit;True;0;0;1;1;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;20;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VoronoiNode;56;-3973.165,-345.5598;Inherit;True;0;0;1;1;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;20;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.Vector2Node;149;-3561.342,37.60542;Inherit;False;Property;_pow;pow;8;0;Create;True;0;0;False;0;False;0,0;5,-5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScreenPosInputsNode;64;-3638.158,-461.6823;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;150;-3249.372,-39.31873;Inherit;False;2;0;FLOAT;100;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;151;-3243.673,60.39803;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;51;-1961.141,386.2628;Inherit;False;1729.363;676.2233;;10;28;11;31;9;10;41;7;25;27;46;Depth Coloration;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;65;-3362.387,-473.2044;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;2;[HDR];[NoScaleOffset];Create;True;0;0;False;0;False;-1;fca4fe9614a08c24587ad1af7bb337fc;fca4fe9614a08c24587ad1af7bb337fc;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;-3567.207,-182.9818;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;9;-1911.141,680.7411;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;62;-2972.527,-497.1063;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;148;-3006.307,-170.9148;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;41;-1614.811,711.1855;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-2689.284,-326.6287;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1634.466,927.0579;Inherit;False;Property;_Dist;Dist;5;0;Create;True;0;0;False;0;False;0;0.84;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-1893.225,-839.5579;Inherit;True;WeirdNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1325.412,946.4861;Inherit;False;Property;_DepthFadePower;DepthFadePower;6;0;Create;True;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;50;-1896.593,-435.7206;Inherit;False;1531.243;509.1727;;7;5;13;3;1;24;45;74;Cam Capture;1,1,1,1;0;0
Node;AmplifyShaderEditor.DepthFade;7;-1405.932,762.7836;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;-1006.403,-385.7212;Inherit;True;73;WeirdNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;-1100.533,618.3135;Inherit;False;Property;_Color0;Color 0;3;1;[HDR];Create;True;0;0;False;0;False;1,1,1,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;31;-1097.612,436.2628;Inherit;False;Property;_Color2;Color 2;4;1;[HDR];Create;True;0;0;False;0;False;1,1,1,1;0.2169811,0.1765048,0.1627358,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;27;-1064.11,832.0858;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-1211.661,-138.5479;Inherit;False;Property;_Color1;Color 1;2;1;[HDR];Create;True;0;0;False;0;False;1,1,1,1;2,2,2,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-840.4863,-270.5199;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;28;-668.7894,604.6616;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-589.35,-288.0832;Inherit;False;CamCapture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;49;205.7201,-15.37104;Inherit;False;952.4738;554;;4;0;8;48;47;Paterns addition;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-464.7776,595.7914;Inherit;False;DepthColoration;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;263.6294,60.30393;Inherit;False;45;CamCapture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;255.7201,147.3073;Inherit;False;46;DepthColoration;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-1568.185,-326.3963;Inherit;True;Property;_CamObjects;CamObjects;0;2;[HDR];[NoScaleOffset];Create;True;0;0;False;0;False;-1;fca4fe9614a08c24587ad1af7bb337fc;fca4fe9614a08c24587ad1af7bb337fc;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;8;504.8989,82.9606;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LengthOpNode;13;-1178.597,-385.7206;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;-2111.473,-736.9518;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;157;-2149.371,-937.0607;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;154;-2420.865,-847.2132;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-2595.068,-721.7921;Inherit;False;Property;_ReverseDepth;ReverseDepth;9;0;Create;True;0;0;False;0;False;0;3.96;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;153;-2635.808,-898.8113;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;152;-2926.074,-929.2557;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;24;-1846.593,-305.3618;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;918.1938,56.62896;Float;False;True;-1;7;ASEMaterialInspector;0;0;Standard;sh_MaskingObjects;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;144;0;146;0
WireConnection;144;1;57;2
WireConnection;144;2;110;0
WireConnection;56;0;145;0
WireConnection;56;1;57;2
WireConnection;56;2;110;0
WireConnection;150;0;149;1
WireConnection;151;0;149;2
WireConnection;65;1;64;0
WireConnection;143;0;56;0
WireConnection;143;1;144;0
WireConnection;62;0;65;4
WireConnection;148;0;143;0
WireConnection;148;1;150;0
WireConnection;148;2;151;0
WireConnection;41;0;9;1
WireConnection;41;1;9;2
WireConnection;63;0;62;0
WireConnection;63;1;148;0
WireConnection;73;0;63;0
WireConnection;7;1;41;0
WireConnection;7;0;10;0
WireConnection;27;0;7;0
WireConnection;27;1;25;0
WireConnection;5;0;74;0
WireConnection;5;1;3;0
WireConnection;28;0;31;0
WireConnection;28;1;11;0
WireConnection;28;2;27;0
WireConnection;45;0;5;0
WireConnection;46;0;28;0
WireConnection;1;1;24;0
WireConnection;8;0;47;0
WireConnection;8;1;48;0
WireConnection;13;0;1;4
WireConnection;156;0;157;0
WireConnection;157;0;154;0
WireConnection;154;1;153;0
WireConnection;154;0;155;0
WireConnection;153;0;152;1
WireConnection;153;1;152;2
WireConnection;0;2;8;0
ASEEND*/
//CHKSM=2F7C10BEB3045FBFB98B15A2CF8D9BB129CD82E2