// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/SH_Galaxy"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 2
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_VoroAngle("VoroAngle", Float) = 1
		_VoroAngle2("VoroAngle2", Float) = 100
		_Scale("Scale", Float) = 20
		_Scale2("Scale2", Float) = 100
		_Tiling("Tiling", Float) = 5
		_TilingColor1("TilingColor1", Float) = 0.1
		_voro2("voro2", Float) = 2
		_voro1("voro1", Float) = -2
		_SmoothStepS("SmoothStepS", Vector) = (0,0.5,0,0)
		_SmoothStepCenter("SmoothStepCenter", Vector) = (0,0.5,0,0)
		_CenterPower("CenterPower", Float) = 20
		_DividePatern("DividePatern", Float) = 17
		_WhirlArms("WhirlArms", Float) = 1.1
		_Opacity("Opacity", Float) = 0
		_EmPower("EmPower", Float) = 0
		_WhirlTiling("WhirlTiling", Vector) = (1,1,0,0)
		[HDR]_Color1("Color 1", Color) = (0,0,0,0)
		[HDR]_Color0("Color 0", Color) = (0,0,0,0)
		[HDR]_Color2("Color 2", Color) = (0,0,0,0)
		_WhirlWidth("WhirlWidth", Float) = 1.1
		_WhirlRotation("WhirlRotation", Float) = 1.1
		_PaternDif("PaternDif", Float) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _EmPower;
		uniform float4 _Color1;
		uniform float4 _Color0;
		uniform float _TilingColor1;
		uniform float2 _SmoothStepCenter;
		uniform float _Scale;
		uniform float _VoroAngle;
		uniform float2 _WhirlTiling;
		uniform float _WhirlRotation;
		uniform float _WhirlArms;
		uniform float _WhirlWidth;
		uniform float _PaternDif;
		uniform float _Tiling;
		uniform float _CenterPower;
		uniform float _DividePatern;
		uniform float _voro1;
		uniform float2 _SmoothStepS;
		uniform float _Scale2;
		uniform float _VoroAngle2;
		uniform float _voro2;
		uniform float4 _Color2;
		uniform float _Opacity;
		uniform float _Cutoff = 0.5;
		uniform float _EdgeLength;


		float2 voronoihash16( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi16( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash16( n + g );
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


		float2 voronoihash60( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi60( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash60( n + g );
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


		float2 voronoihash50( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi50( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash50( n + g );
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
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_TilingColor1).xx;
			float2 temp_cast_1 = (( _TilingColor1 * -0.5 )).xx;
			float2 uv_TexCoord69 = i.uv_texcoord * temp_cast_0 + temp_cast_1;
			float temp_output_70_0 = length( uv_TexCoord69 );
			float time16 = _VoroAngle;
			float2 coords16 = i.uv_texcoord * _Scale;
			float2 id16 = 0;
			float2 uv16 = 0;
			float fade16 = 0.5;
			float voroi16 = 0;
			float rest16 = 0;
			for( int it16 = 0; it16 <8; it16++ ){
			voroi16 += fade16 * voronoi16( coords16, time16, id16, uv16, 0 );
			rest16 += fade16;
			coords16 *= 2;
			fade16 *= 0.5;
			}//Voronoi16
			voroi16 /= rest16;
			float smoothstepResult142 = smoothstep( _SmoothStepCenter.x , _SmoothStepCenter.y , ( ( 1.0 - temp_output_70_0 ) * voroi16 ));
			float4 lerpResult138 = lerp( _Color1 , _Color0 , ( temp_output_70_0 + smoothstepResult142 ));
			float2 CenteredUV15_g192 = ( ( i.uv_texcoord * _WhirlTiling ) - float2( 0.5,0.5 ) );
			float2 break17_g192 = CenteredUV15_g192;
			float2 appendResult23_g192 = (float2(( length( CenteredUV15_g192 ) * 1.0 * 2.0 ) , ( atan2( break17_g192.x , break17_g192.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float2 break12_g191 = appendResult23_g192;
			float temp_output_15_0_g191 = ( ( break12_g191.y - ( ( _WhirlRotation / 6.28318548202515 ) * break12_g191.x ) ) * _WhirlArms );
			float temp_output_20_0_g191 = ( abs( ( temp_output_15_0_g191 - round( temp_output_15_0_g191 ) ) ) * _WhirlWidth );
			float smoothstepResult22_g191 = smoothstep( 0.45 , 0.55 , temp_output_20_0_g191);
			float2 CenteredUV15_g171 = ( ( i.uv_texcoord * _WhirlTiling ) - float2( 0.5,0.5 ) );
			float2 break17_g171 = CenteredUV15_g171;
			float2 appendResult23_g171 = (float2(( length( CenteredUV15_g171 ) * 1.0 * 2.0 ) , ( atan2( break17_g171.x , break17_g171.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float2 break12_g170 = appendResult23_g171;
			float temp_output_15_0_g170 = ( ( break12_g170.y - ( ( _WhirlRotation / 6.28318548202515 ) * break12_g170.x ) ) * _WhirlArms );
			float temp_output_79_0 = ( _WhirlWidth + _PaternDif );
			float temp_output_20_0_g170 = ( abs( ( temp_output_15_0_g170 - round( temp_output_15_0_g170 ) ) ) * temp_output_79_0 );
			float smoothstepResult22_g170 = smoothstep( 0.45 , 0.55 , temp_output_20_0_g170);
			float2 CenteredUV15_g165 = ( ( i.uv_texcoord * _WhirlTiling ) - float2( 0.5,0.5 ) );
			float2 break17_g165 = CenteredUV15_g165;
			float2 appendResult23_g165 = (float2(( length( CenteredUV15_g165 ) * 1.0 * 2.0 ) , ( atan2( break17_g165.x , break17_g165.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float2 break12_g164 = appendResult23_g165;
			float temp_output_15_0_g164 = ( ( break12_g164.y - ( ( _WhirlRotation / 6.28318548202515 ) * break12_g164.x ) ) * _WhirlArms );
			float temp_output_82_0 = ( temp_output_79_0 + _PaternDif );
			float temp_output_20_0_g164 = ( abs( ( temp_output_15_0_g164 - round( temp_output_15_0_g164 ) ) ) * temp_output_82_0 );
			float smoothstepResult22_g164 = smoothstep( 0.45 , 0.55 , temp_output_20_0_g164);
			float2 CenteredUV15_g186 = ( ( i.uv_texcoord * _WhirlTiling ) - float2( 0.5,0.5 ) );
			float2 break17_g186 = CenteredUV15_g186;
			float2 appendResult23_g186 = (float2(( length( CenteredUV15_g186 ) * 1.0 * 2.0 ) , ( atan2( break17_g186.x , break17_g186.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float2 break12_g185 = appendResult23_g186;
			float temp_output_15_0_g185 = ( ( break12_g185.y - ( ( _WhirlRotation / 6.28318548202515 ) * break12_g185.x ) ) * _WhirlArms );
			float temp_output_83_0 = ( temp_output_82_0 + _PaternDif );
			float temp_output_20_0_g185 = ( abs( ( temp_output_15_0_g185 - round( temp_output_15_0_g185 ) ) ) * temp_output_83_0 );
			float smoothstepResult22_g185 = smoothstep( 0.45 , 0.55 , temp_output_20_0_g185);
			float2 CenteredUV15_g174 = ( ( i.uv_texcoord * _WhirlTiling ) - float2( 0.5,0.5 ) );
			float2 break17_g174 = CenteredUV15_g174;
			float2 appendResult23_g174 = (float2(( length( CenteredUV15_g174 ) * 1.0 * 2.0 ) , ( atan2( break17_g174.x , break17_g174.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float2 break12_g173 = appendResult23_g174;
			float temp_output_15_0_g173 = ( ( break12_g173.y - ( ( _WhirlRotation / 6.28318548202515 ) * break12_g173.x ) ) * _WhirlArms );
			float temp_output_85_0 = ( temp_output_83_0 + _PaternDif );
			float temp_output_20_0_g173 = ( abs( ( temp_output_15_0_g173 - round( temp_output_15_0_g173 ) ) ) * temp_output_85_0 );
			float smoothstepResult22_g173 = smoothstep( 0.45 , 0.55 , temp_output_20_0_g173);
			float2 CenteredUV15_g189 = ( ( i.uv_texcoord * _WhirlTiling ) - float2( 0.5,0.5 ) );
			float2 break17_g189 = CenteredUV15_g189;
			float2 appendResult23_g189 = (float2(( length( CenteredUV15_g189 ) * 1.0 * 2.0 ) , ( atan2( break17_g189.x , break17_g189.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float2 break12_g188 = appendResult23_g189;
			float temp_output_15_0_g188 = ( ( break12_g188.y - ( ( _WhirlRotation / 6.28318548202515 ) * break12_g188.x ) ) * _WhirlArms );
			float temp_output_84_0 = ( temp_output_85_0 + _PaternDif );
			float temp_output_20_0_g188 = ( abs( ( temp_output_15_0_g188 - round( temp_output_15_0_g188 ) ) ) * temp_output_84_0 );
			float smoothstepResult22_g188 = smoothstep( 0.45 , 0.55 , temp_output_20_0_g188);
			float2 CenteredUV15_g177 = ( ( i.uv_texcoord * _WhirlTiling ) - float2( 0.5,0.5 ) );
			float2 break17_g177 = CenteredUV15_g177;
			float2 appendResult23_g177 = (float2(( length( CenteredUV15_g177 ) * 1.0 * 2.0 ) , ( atan2( break17_g177.x , break17_g177.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float2 break12_g176 = appendResult23_g177;
			float temp_output_15_0_g176 = ( ( break12_g176.y - ( ( _WhirlRotation / 6.28318548202515 ) * break12_g176.x ) ) * _WhirlArms );
			float temp_output_86_0 = ( temp_output_84_0 + _PaternDif );
			float temp_output_20_0_g176 = ( abs( ( temp_output_15_0_g176 - round( temp_output_15_0_g176 ) ) ) * temp_output_86_0 );
			float smoothstepResult22_g176 = smoothstep( 0.45 , 0.55 , temp_output_20_0_g176);
			float2 CenteredUV15_g180 = ( ( i.uv_texcoord * _WhirlTiling ) - float2( 0.5,0.5 ) );
			float2 break17_g180 = CenteredUV15_g180;
			float2 appendResult23_g180 = (float2(( length( CenteredUV15_g180 ) * 1.0 * 2.0 ) , ( atan2( break17_g180.x , break17_g180.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float2 break12_g179 = appendResult23_g180;
			float temp_output_15_0_g179 = ( ( break12_g179.y - ( ( _WhirlRotation / 6.28318548202515 ) * break12_g179.x ) ) * _WhirlArms );
			float temp_output_89_0 = ( temp_output_86_0 + _PaternDif );
			float temp_output_20_0_g179 = ( abs( ( temp_output_15_0_g179 - round( temp_output_15_0_g179 ) ) ) * temp_output_89_0 );
			float smoothstepResult22_g179 = smoothstep( 0.45 , 0.55 , temp_output_20_0_g179);
			float2 CenteredUV15_g168 = ( ( i.uv_texcoord * _WhirlTiling ) - float2( 0.5,0.5 ) );
			float2 break17_g168 = CenteredUV15_g168;
			float2 appendResult23_g168 = (float2(( length( CenteredUV15_g168 ) * 1.0 * 2.0 ) , ( atan2( break17_g168.x , break17_g168.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float2 break12_g167 = appendResult23_g168;
			float temp_output_15_0_g167 = ( ( break12_g167.y - ( ( _WhirlRotation / 6.28318548202515 ) * break12_g167.x ) ) * _WhirlArms );
			float temp_output_87_0 = ( temp_output_89_0 + _PaternDif );
			float temp_output_20_0_g167 = ( abs( ( temp_output_15_0_g167 - round( temp_output_15_0_g167 ) ) ) * temp_output_87_0 );
			float smoothstepResult22_g167 = smoothstep( 0.45 , 0.55 , temp_output_20_0_g167);
			float2 CenteredUV15_g183 = ( ( i.uv_texcoord * _WhirlTiling ) - float2( 0.5,0.5 ) );
			float2 break17_g183 = CenteredUV15_g183;
			float2 appendResult23_g183 = (float2(( length( CenteredUV15_g183 ) * 1.0 * 2.0 ) , ( atan2( break17_g183.x , break17_g183.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float2 break12_g182 = appendResult23_g183;
			float temp_output_15_0_g182 = ( ( break12_g182.y - ( ( _WhirlRotation / 6.28318548202515 ) * break12_g182.x ) ) * _WhirlArms );
			float temp_output_20_0_g182 = ( abs( ( temp_output_15_0_g182 - round( temp_output_15_0_g182 ) ) ) * ( temp_output_87_0 + _PaternDif ) );
			float smoothstepResult22_g182 = smoothstep( 0.45 , 0.55 , temp_output_20_0_g182);
			float temp_output_99_0 = ( smoothstepResult22_g191 + ( smoothstepResult22_g170 / 2.0 ) + ( smoothstepResult22_g164 / 3.0 ) + ( smoothstepResult22_g185 / 4.0 ) + ( smoothstepResult22_g173 / 5.0 ) + ( smoothstepResult22_g188 / 6.0 ) + ( smoothstepResult22_g176 / 7.0 ) + ( smoothstepResult22_g179 / 8.0 ) + ( smoothstepResult22_g167 / 9.0 ) + ( smoothstepResult22_g182 / 10.0 ) );
			float2 temp_cast_2 = (_Tiling).xx;
			float2 temp_cast_3 = (( _Tiling * -0.5 )).xx;
			float2 uv_TexCoord3 = i.uv_texcoord * temp_cast_2 + temp_cast_3;
			float temp_output_22_0 = ( ( 1.0 - length( uv_TexCoord3 ) ) * _CenterPower );
			float3 temp_output_20_0 = (( saturate( temp_output_99_0 ) + saturate( ( temp_output_99_0 * temp_output_22_0 ) ) + ( temp_output_22_0 / _DividePatern ) )).xxx;
			float time60 = _Time.x;
			float2 coords60 = i.uv_texcoord * _voro1;
			float2 id60 = 0;
			float2 uv60 = 0;
			float fade60 = 0.5;
			float voroi60 = 0;
			float rest60 = 0;
			for( int it60 = 0; it60 <8; it60++ ){
			voroi60 += fade60 * voronoi60( coords60, time60, id60, uv60, 0 );
			rest60 += fade60;
			coords60 *= 2;
			fade60 *= 0.5;
			}//Voronoi60
			voroi60 /= rest60;
			float smoothstepResult40 = smoothstep( _SmoothStepS.x , _SmoothStepS.y , voroi16);
			float3 temp_cast_4 = (( smoothstepResult40 * -2.0 )).xxx;
			float3 temp_output_44_0 = ( ( temp_output_20_0 * ( 1.0 - ( temp_output_20_0 * voroi60 ) ) ) - temp_cast_4 );
			float3 temp_cast_6 = (( smoothstepResult40 * -2.0 )).xxx;
			float3 temp_cast_7 = (( smoothstepResult40 * -2.0 )).xxx;
			float time50 = _VoroAngle2;
			float2 coords50 = i.uv_texcoord * _Scale2;
			float2 id50 = 0;
			float2 uv50 = 0;
			float fade50 = 0.5;
			float voroi50 = 0;
			float rest50 = 0;
			for( int it50 = 0; it50 <8; it50++ ){
			voroi50 += fade50 * voronoi50( coords50, time50, id50, uv50, 0 );
			rest50 += fade50;
			coords50 *= 2;
			fade50 *= 0.5;
			}//Voronoi50
			voroi50 /= rest50;
			float3 temp_output_148_0 = saturate( saturate( ( temp_output_44_0 + ( temp_output_44_0 * step( voroi50 , ( _voro2 * 0.01 ) ) ) ) ) );
			o.Emission = ( ( _EmPower * ( lerpResult138 * float4( saturate( temp_output_44_0 ) , 0.0 ) ) ) + ( float4( temp_output_148_0 , 0.0 ) * _Color2 ) ).rgb;
			o.Alpha = 1;
			clip( ( temp_output_148_0 * _Opacity ).x - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
333;73;1179;655;855.4659;1179.777;1.682112;True;False
Node;AmplifyShaderEditor.RangedFloatNode;35;-4925.915,-2339.455;Inherit;False;Property;_WhirlWidth;WhirlWidth;25;0;Create;True;0;0;False;0;False;1.1;-2.83;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-5124.399,-1798.014;Inherit;False;Property;_PaternDif;PaternDif;27;0;Create;True;0;0;False;0;False;0.1;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-4431.543,-2194.503;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-4437.586,-2028.021;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;-4434.64,-1828.384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;-4439.839,-1657.092;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;-4457.737,-1498.497;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;86;-4452.338,-1341.105;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;89;-4457.649,-1196.991;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-3933.518,-785.1102;Inherit;False;Property;_Tiling;Tiling;10;0;Create;True;0;0;False;0;False;5;5.98;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;87;-4475.55,-1048.198;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-3843.44,-564.3887;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-4882.872,-1645.008;Inherit;False;Property;_WhirlArms;WhirlArms;18;0;Create;True;0;0;False;0;False;1.1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;134;-5318.506,-1910.161;Inherit;False;Property;_WhirlTiling;WhirlTiling;21;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;133;-5298.284,-1701.586;Inherit;False;Property;_WhirlRotation;WhirlRotation;26;0;Create;True;0;0;False;0;False;1.1;2.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-3708.792,-765.8743;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.5,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-4515.778,-920.4025;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;91;-4225.638,-2069.818;Inherit;False;Whirl;-1;;164;7d75aee9e4d352a4299928ac98404afc;2,26,0,25,1;6;27;FLOAT2;0,0;False;1;FLOAT2;1,1;False;7;FLOAT2;0.5,0.5;False;16;FLOAT;5;False;21;FLOAT;3.86;False;10;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;96;-4257.007,-1430.041;Inherit;False;Whirl;-1;;176;7d75aee9e4d352a4299928ac98404afc;2,26,0,25,1;6;27;FLOAT2;0,0;False;1;FLOAT2;1,1;False;7;FLOAT2;0.5,0.5;False;16;FLOAT;5;False;21;FLOAT;3.86;False;10;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;93;-4275.683,-1122.357;Inherit;False;Whirl;-1;;167;7d75aee9e4d352a4299928ac98404afc;2,26,0,25,1;6;27;FLOAT2;0,0;False;1;FLOAT2;1,1;False;7;FLOAT2;0.5,0.5;False;16;FLOAT;5;False;21;FLOAT;3.86;False;10;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;90;-4224.563,-2231.623;Inherit;False;Whirl;-1;;170;7d75aee9e4d352a4299928ac98404afc;2,26,0,25,1;6;27;FLOAT2;0,0;False;1;FLOAT2;1,1;False;7;FLOAT2;0.5,0.5;False;16;FLOAT;5;False;21;FLOAT;3.86;False;10;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;94;-4239.859,-1732.6;Inherit;False;Whirl;-1;;173;7d75aee9e4d352a4299928ac98404afc;2,26,0,25,1;6;27;FLOAT2;0,0;False;1;FLOAT2;1,1;False;7;FLOAT2;0.5,0.5;False;16;FLOAT;5;False;21;FLOAT;3.86;False;10;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;6;-3291.261,-756.0258;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;92;-4227.209,-1903.717;Inherit;False;Whirl;-1;;185;7d75aee9e4d352a4299928ac98404afc;2,26,0,25,1;6;27;FLOAT2;0,0;False;1;FLOAT2;1,1;False;7;FLOAT2;0.5,0.5;False;16;FLOAT;5;False;21;FLOAT;3.86;False;10;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;97;-4247.323,-1577.524;Inherit;False;Whirl;-1;;188;7d75aee9e4d352a4299928ac98404afc;2,26,0,25,1;6;27;FLOAT2;0,0;False;1;FLOAT2;1,1;False;7;FLOAT2;0.5,0.5;False;16;FLOAT;5;False;21;FLOAT;3.86;False;10;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;95;-4270.137,-1269.198;Inherit;False;Whirl;-1;;179;7d75aee9e4d352a4299928ac98404afc;2,26,0,25,1;6;27;FLOAT2;0,0;False;1;FLOAT2;1,1;False;7;FLOAT2;0.5,0.5;False;16;FLOAT;5;False;21;FLOAT;3.86;False;10;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;98;-4259.222,-954.3842;Inherit;False;Whirl;-1;;182;7d75aee9e4d352a4299928ac98404afc;2,26,0,25,1;6;27;FLOAT2;0,0;False;1;FLOAT2;1,1;False;7;FLOAT2;0.5,0.5;False;16;FLOAT;5;False;21;FLOAT;3.86;False;10;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;107;-3866.878,-1908.621;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;21;-3080.615,-762.5837;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;106;-3872.511,-1780.41;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;102;-3881.118,-1271.8;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;101;-3889.248,-1118.295;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;109;-3856.163,-2196.861;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;18;-4253.421,-2447.227;Inherit;True;Whirl;-1;;191;7d75aee9e4d352a4299928ac98404afc;2,26,0,25,1;6;27;FLOAT2;0,0;False;1;FLOAT2;1,1;False;7;FLOAT2;0.5,0.5;False;16;FLOAT;5;False;21;FLOAT;3.86;False;10;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;103;-3885.502,-1415.158;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;104;-3878.456,-1532.492;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;7;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;108;-3864.947,-2052.88;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;105;-3869.668,-1657.442;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;6;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-3101.87,-637.9824;Inherit;False;Property;_CenterPower;CenterPower;16;0;Create;True;0;0;False;0;False;20;17.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;99;-3274.547,-1911.981;Inherit;True;10;10;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;9;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-2866.215,-786.582;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-2564.026,-966.8161;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-2538.263,-647.7893;Inherit;False;Property;_DividePatern;DividePatern;17;0;Create;True;0;0;False;0;False;17;20.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;62;-2587.891,-1323.728;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;34;-2378.032,-764.9079;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;17;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;46;-2323.878,-962.3893;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;13;-2284.99,-641.7559;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;-989.3313,-1191.804;Inherit;False;Property;_TilingColor1;TilingColor1;11;0;Create;True;0;0;False;0;False;0.1;2.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-2091.769,-973.6916;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-1906.906,-560.915;Inherit;False;Property;_voro1;voro1;13;0;Create;True;0;0;False;0;False;-2;38.86;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-2111.234,-390.0503;Inherit;False;Property;_VoroAngle;VoroAngle;6;0;Create;True;0;0;False;0;False;1;173.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;60;-1657.873,-774.2579;Inherit;True;0;0;1;0;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;20;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-842.4053,-1107.618;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2100.818,-280.8474;Inherit;False;Property;_Scale;Scale;8;0;Create;True;0;0;False;0;False;20;102.99;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;20;-1860.188,-912.9063;Inherit;True;FLOAT3;0;1;2;3;1;0;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;69;-746.8259,-1240.804;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.5,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;16;-1912.426,-378.5426;Inherit;True;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.Vector2Node;129;-1077.422,-143.9941;Inherit;False;Property;_SmoothStepS;SmoothStepS;14;0;Create;True;0;0;False;0;False;0,0.5;-0.84,1.23;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-1057.962,-798.7251;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;65;-738.7693,-803.8157;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;40;-808.3627,-423.7018;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-2118.835,-134.0602;Inherit;False;Property;_VoroAngle2;VoroAngle2;7;0;Create;True;0;0;False;0;False;100;24.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-695.3115,15.01216;Inherit;False;Property;_voro2;voro2;12;0;Create;True;0;0;False;0;False;2;17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;70;-424.4338,-1241.564;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-2108.419,-24.85726;Inherit;False;Property;_Scale2;Scale2;9;0;Create;True;0;0;False;0;False;100;105.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;144;-208.7591,-1194.97;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-539.7313,-559.8687;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-2;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;50;-1907.234,-102.1938;Inherit;True;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-501.1341,-12.22749;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-446.4664,-916.7318;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode;146;-338.4586,-272.9233;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;-83.12903,-1160.18;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;141;-243.3765,-1065.302;Inherit;False;Property;_SmoothStepCenter;SmoothStepCenter;15;0;Create;True;0;0;False;0;False;0,0.5;-0.13,0.6;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;44;-181.7901,-699.1298;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;-50.03756,-473.6911;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;142;41.4476,-1061.41;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;153;116.795,-616.2695;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;139;69.14458,-1484.806;Inherit;False;Property;_Color0;Color 0;23;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,0.2820126,0.5566038,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;145;188.3921,-1223.929;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;140;-195.1318,-1484.843;Inherit;False;Property;_Color1;Color 1;22;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;3.523293,1.78467,0.5151985,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;77;364.6556,-744.0162;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;138;351.092,-1251.539;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;110;190.4028,-596.7805;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;148;313.4247,-505.6873;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;538.6417,-837.6964;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;136;727.1913,-1029.755;Inherit;False;Property;_EmPower;EmPower;20;0;Create;True;0;0;False;0;False;0;1.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;149;430.1466,-256.3255;Inherit;False;Property;_Color2;Color 2;24;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0.2614119,0.1637877,0.1097437,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;762.5065,-891.2079;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;137;546.3145,-370.5818;Inherit;False;Property;_Opacity;Opacity;19;0;Create;True;0;0;False;0;False;0;5.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;727.7961,-545.3593;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;150;896.3797,-659.1557;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientNode;131;23.20063,-1678.833;Inherit;False;0;4;2;1,1,1,0;1,0.7219421,0.4764151,0.02941939;1,0.5153113,0,0.2352941;0.2877358,0.653853,1,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;735.8125,-434.6005;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GradientSampleNode;130;276.7894,-1702.591;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;47;-786.4699,-299.6334;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;166.1663,-256.7434;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-3116.575,-1227.875;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1130.797,-682.6025;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Custom/SH_Galaxy;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;2;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;5;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;79;0;35;0
WireConnection;79;1;81;0
WireConnection;82;0;79;0
WireConnection;82;1;81;0
WireConnection;83;0;82;0
WireConnection;83;1;81;0
WireConnection;85;0;83;0
WireConnection;85;1;81;0
WireConnection;84;0;85;0
WireConnection;84;1;81;0
WireConnection;86;0;84;0
WireConnection;86;1;81;0
WireConnection;89;0;86;0
WireConnection;89;1;81;0
WireConnection;87;0;89;0
WireConnection;87;1;81;0
WireConnection;32;0;1;0
WireConnection;3;0;1;0
WireConnection;3;1;32;0
WireConnection;88;0;87;0
WireConnection;88;1;81;0
WireConnection;91;1;134;0
WireConnection;91;16;132;0
WireConnection;91;21;82;0
WireConnection;91;10;133;0
WireConnection;96;1;134;0
WireConnection;96;16;132;0
WireConnection;96;21;86;0
WireConnection;96;10;133;0
WireConnection;93;1;134;0
WireConnection;93;16;132;0
WireConnection;93;21;87;0
WireConnection;93;10;133;0
WireConnection;90;1;134;0
WireConnection;90;16;132;0
WireConnection;90;21;79;0
WireConnection;90;10;133;0
WireConnection;94;1;134;0
WireConnection;94;16;132;0
WireConnection;94;21;85;0
WireConnection;94;10;133;0
WireConnection;6;0;3;0
WireConnection;92;1;134;0
WireConnection;92;16;132;0
WireConnection;92;21;83;0
WireConnection;92;10;133;0
WireConnection;97;1;134;0
WireConnection;97;16;132;0
WireConnection;97;21;84;0
WireConnection;97;10;133;0
WireConnection;95;1;134;0
WireConnection;95;16;132;0
WireConnection;95;21;89;0
WireConnection;95;10;133;0
WireConnection;98;1;134;0
WireConnection;98;16;132;0
WireConnection;98;21;88;0
WireConnection;98;10;133;0
WireConnection;107;0;92;0
WireConnection;21;0;6;0
WireConnection;106;0;94;0
WireConnection;102;0;93;0
WireConnection;101;0;98;0
WireConnection;109;0;90;0
WireConnection;18;1;134;0
WireConnection;18;16;132;0
WireConnection;18;21;35;0
WireConnection;18;10;133;0
WireConnection;103;0;95;0
WireConnection;104;0;96;0
WireConnection;108;0;91;0
WireConnection;105;0;97;0
WireConnection;99;0;18;0
WireConnection;99;1;109;0
WireConnection;99;2;108;0
WireConnection;99;3;107;0
WireConnection;99;4;106;0
WireConnection;99;5;105;0
WireConnection;99;6;104;0
WireConnection;99;7;103;0
WireConnection;99;8;102;0
WireConnection;99;9;101;0
WireConnection;22;0;21;0
WireConnection;22;1;23;0
WireConnection;19;0;99;0
WireConnection;19;1;22;0
WireConnection;62;0;99;0
WireConnection;34;0;22;0
WireConnection;34;1;128;0
WireConnection;46;0;19;0
WireConnection;33;0;62;0
WireConnection;33;1;46;0
WireConnection;33;2;34;0
WireConnection;60;1;13;1
WireConnection;60;2;126;0
WireConnection;72;0;71;0
WireConnection;20;0;33;0
WireConnection;69;0;71;0
WireConnection;69;1;72;0
WireConnection;16;1;12;0
WireConnection;16;2;15;0
WireConnection;64;0;20;0
WireConnection;64;1;60;0
WireConnection;65;0;64;0
WireConnection;40;0;16;0
WireConnection;40;1;129;1
WireConnection;40;2;129;2
WireConnection;70;0;69;0
WireConnection;144;0;70;0
WireConnection;45;0;40;0
WireConnection;50;1;51;0
WireConnection;50;2;52;0
WireConnection;49;0;127;0
WireConnection;61;0;20;0
WireConnection;61;1;65;0
WireConnection;146;0;50;0
WireConnection;146;1;49;0
WireConnection;143;0;144;0
WireConnection;143;1;16;0
WireConnection;44;0;61;0
WireConnection;44;1;45;0
WireConnection;147;0;44;0
WireConnection;147;1;146;0
WireConnection;142;0;143;0
WireConnection;142;1;141;1
WireConnection;142;2;141;2
WireConnection;153;0;44;0
WireConnection;153;1;147;0
WireConnection;145;0;70;0
WireConnection;145;1;142;0
WireConnection;77;0;44;0
WireConnection;138;0;140;0
WireConnection;138;1;139;0
WireConnection;138;2;145;0
WireConnection;110;0;153;0
WireConnection;148;0;110;0
WireConnection;75;0;138;0
WireConnection;75;1;77;0
WireConnection;135;0;136;0
WireConnection;135;1;75;0
WireConnection;151;0;148;0
WireConnection;151;1;149;0
WireConnection;150;0;135;0
WireConnection;150;1;151;0
WireConnection;152;0;148;0
WireConnection;152;1;137;0
WireConnection;130;0;131;0
WireConnection;47;1;129;1
WireConnection;47;2;129;2
WireConnection;0;2;150;0
WireConnection;0;10;152;0
ASEEND*/
//CHKSM=31FA4C07F812836CBC799E22C2C0D51CC5162A86