// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/sh_emissiveparticle"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_speed("speed", Float) = 1
		_scale2("scale2", Float) = 1
		_force("force", Float) = 1
		_Float1("Float 1", Float) = 1
		_Float0("Float 0", Float) = 1
		_step("step", Vector) = (0,1,0,0)
		_speed3("speed2", Float) = 0.5
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
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _force;
		uniform float2 _step;
		uniform float _Float0;
		uniform float _speed3;
		uniform float _Float1;
		uniform float _scale2;
		uniform float _speed;
		uniform sampler2D _TextureSample0;
		SamplerState sampler_TextureSample0;
		uniform float4 _TextureSample0_ST;


		float2 voronoihash68( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi68( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash68( n + g );
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


		float2 voronoihash18( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi18( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash18( n + g );
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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_64_0 = ( _Time.y * -5.0 * _speed3 );
			float2 uv_TexCoord62 = i.uv_texcoord + float2( -0.5,-0.5 );
			float2 temp_cast_0 = (length( uv_TexCoord62 )).xx;
			float2 panner66 = ( temp_output_64_0 * float2( 1,1 ) + temp_cast_0);
			float2 temp_output_2_0_g39 = panner66;
			float2 temp_cast_1 = (temp_output_64_0).xx;
			float2 temp_output_11_0_g39 = ( temp_output_2_0_g39 - temp_cast_1 );
			float dotResult12_g39 = dot( temp_output_11_0_g39 , temp_output_11_0_g39 );
			float time68 = ( temp_output_2_0_g39 + ( temp_output_11_0_g39 * ( dotResult12_g39 * dotResult12_g39 * float2( 10,10 ) ) ) + float2( 0,0 ) ).x;
			float2 coords68 = i.uv_texcoord * 5.0;
			float2 id68 = 0;
			float2 uv68 = 0;
			float fade68 = 0.5;
			float voroi68 = 0;
			float rest68 = 0;
			for( int it68 = 0; it68 <8; it68++ ){
			voroi68 += fade68 * voronoi68( coords68, time68, id68, uv68, 0 );
			rest68 += fade68;
			coords68 *= 2;
			fade68 *= 0.5;
			}//Voronoi68
			voroi68 /= rest68;
			float3 temp_cast_3 = (voroi68).xxx;
			float grayscale49 = Luminance(temp_cast_3);
			float temp_output_25_0 = ( _Time.y * _speed );
			float time18 = temp_output_25_0;
			float2 coords18 = i.uv_texcoord * _scale2;
			float2 id18 = 0;
			float2 uv18 = 0;
			float fade18 = 0.5;
			float voroi18 = 0;
			float rest18 = 0;
			for( int it18 = 0; it18 <8; it18++ ){
			voroi18 += fade18 * voronoi18( coords18, time18, id18, uv18, 0 );
			rest18 += fade18;
			coords18 *= 2;
			fade18 *= 0.5;
			}//Voronoi18
			voroi18 /= rest18;
			float smoothstepResult36 = smoothstep( _step.x , _step.y , ( ( _Float0 * grayscale49 ) * ( _Float1 * voroi18 ) ));
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode1 = tex2D( _TextureSample0, uv_TextureSample0 );
			float3 appendResult6 = (float3(tex2DNode1.r , tex2DNode1.g , tex2DNode1.b));
			float3 appendResult7 = (float3(i.vertexColor.r , i.vertexColor.g , i.vertexColor.b));
			float3 temp_output_19_0 = ( smoothstepResult36 * saturate( ( appendResult6 * appendResult7 ) ) );
			o.Emission = ( _force * temp_output_19_0 );
			o.Alpha = saturate( ( temp_output_19_0 * i.vertexColor.a ) ).x;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
310.6667;72.66667;1833.333;846;3363.342;1847.453;2.195248;True;True
Node;AmplifyShaderEditor.RangedFloatNode;63;-3024.616,-1396.711;Inherit;False;Property;_speed3;speed2;8;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;-3168.813,-1874.051;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.5,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;61;-3066.719,-1590.718;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;65;-2863.792,-1874.332;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-2751.242,-1505.713;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;-5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;66;-2600.532,-1877.01;Inherit;True;3;0;FLOAT2;0,1;False;2;FLOAT2;1,1;False;1;FLOAT;0.28;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;67;-2280.632,-1874.763;Inherit;True;Spherize;-1;;39;1488bb72d8899174ba0601b595d32b07;0;4;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TimeNode;24;-2209.781,-645.9412;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;-2189.522,-488.1631;Inherit;False;Property;_speed;speed;1;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1909.827,-581.0386;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1912.805,-343.662;Inherit;False;Property;_scale2;scale2;3;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;68;-1887.259,-1659.836;Inherit;True;0;0;1;0;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TFHCGrayscale;49;-1784.355,-1220.943;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;18;-1662.427,-534.3179;Inherit;True;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VertexColorNode;3;-1240.285,167.1563;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-1292.248,-598.2372;Inherit;False;Property;_Float1;Float 1;5;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1368.336,-46.84734;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;False;-1;0000000000000000f000000000000000;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;-1298.769,-829.7247;Inherit;False;Property;_Float0;Float 0;6;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-946.491,-17.36901;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-1055.228,-519.7155;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;7;-950.8545,104.7776;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1061.749,-751.202;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-607.5474,-519.6909;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-754.5479,72.7868;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;37;-579.1516,-282.8171;Inherit;False;Property;_step;step;7;0;Create;True;0;0;False;0;False;0,1;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SaturateNode;10;-533.5398,29.14913;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;36;-347.1745,-310.9862;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-356.8795,-5.308674;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-67.58432,192.4852;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-31.37679,-143.95;Inherit;False;Property;_force;force;4;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;38;-1944.207,-854.0936;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;205.6438,-65.42823;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1911.727,-429.3206;Inherit;False;Property;_scale;scale;2;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;59;-3237.086,-1259.054;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-2506.306,-874.5974;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;56;-2824.751,-1074.278;Inherit;True;Spherize;-1;;6;1488bb72d8899174ba0601b595d32b07;0;4;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;58;-3069.361,-1150.749;Inherit;True;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;47;-2363.186,-1225.202;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;46;-2160.458,-1229.669;Inherit;True;Simple HUE;-1;;3;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT2;0,0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.FunctionNode;55;-3179.665,-852.1254;Inherit;True;Radial Shear;-1;;5;c6dc9fc7fa9b08c4d95138f2ae88b526;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;11;199.6565,188.1912;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;48;-2625.817,-1232.198;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.5,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;39;-1673.519,-815.5052;Inherit;True;0;0;1;0;2;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-3232.608,-969.5211;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;-0.5,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1695.683,-1048.869;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;499.9474,-93.33007;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/sh_emissiveparticle;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;65;0;62;0
WireConnection;64;0;61;2
WireConnection;64;2;63;0
WireConnection;66;0;65;0
WireConnection;66;1;64;0
WireConnection;67;2;66;0
WireConnection;67;3;64;0
WireConnection;25;0;24;2
WireConnection;25;1;20;0
WireConnection;68;1;67;0
WireConnection;49;0;68;0
WireConnection;18;1;25;0
WireConnection;18;2;41;0
WireConnection;6;0;1;1
WireConnection;6;1;1;2
WireConnection;6;2;1;3
WireConnection;42;0;43;0
WireConnection;42;1;18;0
WireConnection;7;0;3;1
WireConnection;7;1;3;2
WireConnection;7;2;3;3
WireConnection;44;0;45;0
WireConnection;44;1;49;0
WireConnection;40;0;44;0
WireConnection;40;1;42;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;10;0;8;0
WireConnection;36;0;40;0
WireConnection;36;1;37;1
WireConnection;36;2;37;2
WireConnection;19;0;36;0
WireConnection;19;1;10;0
WireConnection;5;0;19;0
WireConnection;5;1;3;4
WireConnection;23;0;22;0
WireConnection;23;1;19;0
WireConnection;57;1;24;2
WireConnection;56;2;60;0
WireConnection;46;1;66;0
WireConnection;11;0;5;0
WireConnection;39;0;69;0
WireConnection;39;1;25;0
WireConnection;39;2;21;0
WireConnection;69;1;38;0
WireConnection;0;2;23;0
WireConnection;0;9;11;0
ASEEND*/
//CHKSM=0526DA6DAC9F825EBD497DDADCADE7C9D1D5D846