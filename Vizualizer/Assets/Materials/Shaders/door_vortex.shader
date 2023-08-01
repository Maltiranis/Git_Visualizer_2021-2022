// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/door_vortex"
{
	Properties
	{
		[HDR]_Color1("Color 1", Color) = (0,0.4550867,1,0)
		[HDR]_em("em", Color) = (1,1,1,0)
		_Vector0("Vector 0", Vector) = (2,5,2,2)
		_step3("step3", Vector) = (1,0,0,0)
		_step1("step 1", Vector) = (1,0,0,0)
		_BSP("BSP", Vector) = (0,1,5,0)
		_tilinoffset1("tilinoffset 1", Vector) = (2,2,0,0)
		_FakeLightSource("FakeLightSource", Vector) = (0,0,0,0)
		_speed("speed", Float) = 0.5
		_speed2("speed2", Float) = 0.5
		_Steponoff("Steponoff", Range( -0.1 , 1)) = 0.2388621
		_overpowerstart("overpowerstart", Float) = 10
		_smoothonoff("smoothonoff", Float) = 1.19
		_thickness("thickness", Float) = 0
		_stepify("stepify", Float) = 1
		_powerize("powerize", Float) = 1
		_stepmod("stepmod", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			INTERNAL_DATA
		};

		uniform float2 _step1;
		uniform float4 _Vector0;
		uniform float _speed2;
		uniform float _thickness;
		uniform float _speed;
		uniform float _stepmod;
		uniform float _stepify;
		uniform float _powerize;
		uniform float4 _em;
		uniform float2 _step3;
		uniform float2 _tilinoffset1;
		uniform float2 _FakeLightSource;
		uniform float3 _BSP;
		uniform float4 _Color1;
		uniform float _Steponoff;
		uniform float _smoothonoff;
		uniform float _overpowerstart;


		float2 voronoihash229( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi229( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash229( n + g );
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


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		inline float2 UnityVoronoiRandomVector( float2 UV, float offset )
		{
			float2x2 m = float2x2( 15.27, 47.63, 99.41, 89.98 );
			UV = frac( sin(mul(UV, m) ) * 46839.32 );
			return float2( sin(UV.y* +offset ) * 0.5 + 0.5, cos( UV.x* offset ) * 0.5 + 0.5 );
		}
		
		//x - Out y - Cells
		float3 UnityVoronoi( float2 UV, float AngleOffset, float CellDensity, inout float2 mr )
		{
			float2 g = floor( UV * CellDensity );
			float2 f = frac( UV * CellDensity );
			float t = 8.0;
			float3 res = float3( 8.0, 0.0, 0.0 );
		
			for( int y = -1; y <= 1; y++ )
			{
				for( int x = -1; x <= 1; x++ )
				{
					float2 lattice = float2( x, y );
					float2 offset = UnityVoronoiRandomVector( lattice + g, AngleOffset );
					float d = distance( lattice + offset, f );
		
					if( d < res.x )
					{
						mr = f - lattice - offset;
						res = float3( d, offset.x, offset.y );
					}
				}
			}
			return res;
		}


		float2 voronoihash70( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi70( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash70( n + g );
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


		float2 voronoihash168( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi168( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash168( n + g );
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
			float temp_output_144_0 = ( _Time.y * -5.0 * _speed2 );
			float2 uv_TexCoord143 = i.uv_texcoord + float2( -0.5,-0.5 );
			float2 temp_cast_0 = (length( uv_TexCoord143 )).xx;
			float2 panner146 = ( temp_output_144_0 * float2( 1,1 ) + temp_cast_0);
			float2 temp_output_2_0_g39 = panner146;
			float2 temp_cast_1 = (temp_output_144_0).xx;
			float2 temp_output_11_0_g39 = ( temp_output_2_0_g39 - temp_cast_1 );
			float dotResult12_g39 = dot( temp_output_11_0_g39 , temp_output_11_0_g39 );
			float2 temp_output_147_0 = ( temp_output_2_0_g39 + ( temp_output_11_0_g39 * ( dotResult12_g39 * dotResult12_g39 * float2( 10,10 ) ) ) + float2( 0,0 ) );
			float time229 = temp_output_147_0.x;
			float2 coords229 = i.uv_texcoord * _Vector0.z;
			float2 id229 = 0;
			float2 uv229 = 0;
			float fade229 = 0.5;
			float voroi229 = 0;
			float rest229 = 0;
			for( int it229 = 0; it229 <8; it229++ ){
			voroi229 += fade229 * voronoi229( coords229, time229, id229, uv229, 0 );
			rest229 += fade229;
			coords229 *= 2;
			fade229 *= 0.5;
			}//Voronoi229
			voroi229 /= rest229;
			float2 temp_cast_3 = (_thickness).xx;
			float2 temp_cast_4 = (( _thickness * -0.5 )).xx;
			float2 uv_TexCoord74 = i.uv_texcoord * temp_cast_3 + temp_cast_4;
			float2 appendResult223 = (float2(( _Time.y * -1.0 * _speed ) , 1.0));
			float2 temp_cast_6 = (length( uv_TexCoord74 )).xx;
			float2 panner72 = ( 1E-05 * _Time.y * appendResult223 + temp_cast_6);
			float2 temp_output_2_0_g24 = panner72;
			float2 temp_output_11_0_g24 = ( temp_output_2_0_g24 - float2( 0.5,0.5 ) );
			float dotResult12_g24 = dot( temp_output_11_0_g24 , temp_output_11_0_g24 );
			float2 temp_cast_7 = (0.0).xx;
			float3 hsvTorgb3_g25 = HSVToRGB( float3(( temp_output_2_0_g24 + ( temp_output_11_0_g24 * ( dotResult12_g24 * dotResult12_g24 * temp_cast_7 ) ) + float2( 0,0 ) ).x,1.0,1.0) );
			float simplePerlin3D222 = snoise( hsvTorgb3_g25 );
			float2 uv217 = 0;
			float3 unityVoronoy217 = UnityVoronoi(i.uv_texcoord,uv_TexCoord74.x,simplePerlin3D222,uv217);
			float3 temp_cast_9 = (unityVoronoy217.x).xxx;
			float grayscale120 = dot(temp_cast_9, float3(0.299,0.587,0.114));
			float time70 = temp_output_147_0.x;
			float2 coords70 = i.uv_texcoord * _Vector0.z;
			float2 id70 = 0;
			float2 uv70 = 0;
			float fade70 = 0.5;
			float voroi70 = 0;
			float rest70 = 0;
			for( int it70 = 0; it70 <8; it70++ ){
			voroi70 += fade70 * voronoi70( coords70, time70, id70, uv70, 0 );
			rest70 += fade70;
			coords70 *= 2;
			fade70 *= 0.5;
			}//Voronoi70
			voroi70 /= rest70;
			float temp_output_242_0 = ( _stepmod + _stepify );
			float temp_output_246_0 = ( _stepmod + temp_output_242_0 );
			float temp_output_238_0 = step( voroi70 , _stepify );
			float dotResult255 = dot( voroi229 , _powerize );
			float2 temp_cast_11 = (( ( voroi229 * grayscale120 * ( ( ( step( voroi70 , ( _stepmod + temp_output_246_0 ) ) + step( voroi70 , ( _stepmod + temp_output_246_0 ) ) + step( voroi70 , temp_output_246_0 ) + step( voroi70 , temp_output_242_0 ) + temp_output_238_0 ) + temp_output_238_0 ) + temp_output_238_0 ) ) + voroi70 + grayscale120 + dotResult255 )).xx;
			float gradientNoise2 = UnityGradientNoise(temp_cast_11,_Vector0.x);
			float smoothstepResult15 = smoothstep( _step1.x , _step1.y , gradientNoise2);
			float temp_output_18_0 = ( smoothstepResult15 - gradientNoise2 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 appendResult32 = (float2(( _tilinoffset1.x / -2.0 ) , ( _tilinoffset1.y / -2.0 )));
			float2 uv_TexCoord23 = i.uv_texcoord * _tilinoffset1 + ( appendResult32 + _FakeLightSource );
			float smoothstepResult42 = smoothstep( _step3.x , _step3.y , length( uv_TexCoord23 ));
			float3 temp_cast_12 = (( 1.0 - smoothstepResult42 )).xxx;
			float fresnelNdotV27 = dot( temp_cast_12, ase_worldViewDir );
			float fresnelNode27 = ( _BSP.x + _BSP.y * pow( 1.0 - fresnelNdotV27, _BSP.z ) );
			float4 temp_output_21_0 = ( _Color1 * ( 1.0 - saturate( temp_output_18_0 ) ) );
			o.Emission = ( ( ( temp_output_18_0 * _em ) * _Vector0.y ) + fresnelNode27 + temp_output_21_0 ).rgb;
			float temp_output_158_0 = ( _Steponoff + 0.1 );
			float2 uv_TexCoord153 = i.uv_texcoord + float2( -0.5,-0.5 );
			float temp_output_154_0 = length( uv_TexCoord153 );
			float smoothstepResult157 = smoothstep( _Steponoff , temp_output_158_0 , temp_output_154_0);
			float smoothstepResult155 = smoothstep( 0.0 , 1.5 , smoothstepResult157);
			float smoothstepResult160 = smoothstep( temp_output_158_0 , ( temp_output_154_0 * _smoothonoff ) , smoothstepResult157);
			float time168 = _Time.w;
			float2 coords168 = i.uv_texcoord * 5.0;
			float2 id168 = 0;
			float2 uv168 = 0;
			float fade168 = 0.5;
			float voroi168 = 0;
			float rest168 = 0;
			for( int it168 = 0; it168 <8; it168++ ){
			voroi168 += fade168 * voronoi168( coords168, time168, id168, uv168, 0 );
			rest168 += fade168;
			coords168 *= 2;
			fade168 *= 0.5;
			}//Voronoi168
			voroi168 /= rest168;
			o.Alpha = ( smoothstepResult155 + ( ( smoothstepResult155 * ( 1.0 - smoothstepResult160 ) ) * _overpowerstart * voroi168 ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
310.6667;72.66667;1833.333;846;2633.737;517.5784;1.3;True;True
Node;AmplifyShaderEditor.RangedFloatNode;202;-5639.111,1207.009;Inherit;False;Property;_thickness;thickness;14;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;78;-5260.306,1686.427;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;79;-5218.204,1880.433;Inherit;False;Property;_speed;speed;8;0;Create;True;0;0;False;0;False;0.5;-0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;201;-5424.998,1389.142;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;141;-2931.771,79.82288;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;143;-3033.865,-203.5102;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.5,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;142;-2889.669,273.8297;Inherit;False;Property;_speed2;speed2;9;0;Create;True;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;74;-5242.537,1187.194;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-1.11,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-4901.904,1660.213;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;239;-1736.642,-445.8615;Inherit;False;Property;_stepify;stepify;16;0;Create;True;0;0;False;0;False;1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-2616.295,164.8271;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;-5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;145;-2728.845,-203.7912;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;240;-1805.542,-583.6617;Inherit;False;Property;_stepmod;stepmod;18;0;Create;True;0;0;False;0;False;1;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;242;-1583.243,-570.6631;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;146;-2465.585,-206.4699;Inherit;True;3;0;FLOAT2;0,1;False;2;FLOAT2;1,1;False;1;FLOAT;0.28;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;73;-4931.663,1186.913;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;223;-4687.305,1486.916;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;10;-1756.079,406.1048;Inherit;False;Property;_Vector0;Vector 0;2;0;Create;True;0;0;False;0;False;2,5,2,2;0.25,-15,20,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;246;-1585.843,-677.2631;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;147;-2145.684,-204.2228;Inherit;True;Spherize;-1;;39;1488bb72d8899174ba0601b595d32b07;0;4;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;72;-4646.919,1169.733;Inherit;True;3;0;FLOAT2;0,1;False;2;FLOAT2;0.1,1;False;1;FLOAT;1E-05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;197;-4479.352,1565.666;Inherit;False;Constant;_Float0;Float 0;19;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;70;-1820.439,-78.27106;Inherit;True;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.FunctionNode;77;-4327.016,1170.38;Inherit;True;Spherize;-1;;24;1488bb72d8899174ba0601b595d32b07;0;4;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;248;-1554.642,-872.2628;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;247;-1559.842,-770.8629;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;244;-1380.442,-869.663;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;245;-1370.042,-978.8629;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;238;-1386.24,-536.0925;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;241;-1396.041,-664.2609;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;243;-1393.442,-755.2628;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;75;-3968.386,1170.497;Inherit;True;Simple HUE;-1;;25;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT2;0,0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.NoiseGeneratorNode;222;-3362.459,901.5631;Inherit;True;Simplex3D;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;249;-1130.025,-584.9914;Inherit;True;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;251;-870.8927,-634.764;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;217;-3365.573,1196.629;Inherit;True;0;0;1;0;8;False;1;True;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;6.24;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TFHCGrayscale;120;-2536.031,712.7495;Inherit;True;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;252;-704.9557,-632.1092;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;254;-1474.23,292.9141;Inherit;False;Property;_powerize;powerize;17;0;Create;True;0;0;False;0;False;1;0.015;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;35;-2010.859,1108.913;Inherit;False;Property;_tilinoffset1;tilinoffset 1;6;0;Create;True;0;0;False;0;False;2,2;1.5,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.VoronoiNode;229;-1471.77,-174.4996;Inherit;True;0;0;1;0;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;33;-1823.204,1275.826;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;230;-1259.244,-195.3501;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;34;-1834.004,1372.126;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-2;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;255;-1315.537,202.6215;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;32;-1628.532,1240.922;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;37;-1840.859,1488.913;Inherit;False;Property;_FakeLightSource;FakeLightSource;7;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;159;-925.9952,2390.096;Inherit;False;Property;_Steponoff;Steponoff;10;0;Create;True;0;0;False;0;False;0.2388621;-0.1;-0.1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;228;-1163.418,-18.68299;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;153;-1088.572,2122.532;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.5,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;16;-760.7126,600.3251;Inherit;False;Property;_step1;step 1;4;0;Create;True;0;0;False;0;False;1,0;0.1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;2;-795.0589,86.7158;Inherit;True;Gradient;False;True;2;0;FLOAT2;0,0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;158;-563.7019,2409.109;Inherit;False;2;2;0;FLOAT;0.1;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;166;-737.2191,2596.046;Inherit;False;Property;_smoothonoff;smoothonoff;12;0;Create;True;0;0;False;0;False;1.19;1.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;154;-777.7731,2118.351;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1421.859,1326.913;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;-477.4055,2605.946;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-1380.485,1080.989;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.5,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;157;-411.9435,2113.969;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.07;False;2;FLOAT;0.14;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;15;-521.0402,606.3296;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;160;-310.9107,2377.489;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.07;False;2;FLOAT;1.42;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;18;-483.7937,113.1403;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;41;-1066.857,1356.011;Inherit;False;Property;_step3;step3;3;0;Create;True;0;0;False;0;False;1,0;-0.5,0.75;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LengthOpNode;22;-1065.786,1084.608;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;170;-112.9256,2690.725;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;155;-92.10155,2094.811;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-1025.167,305.0374;Inherit;False;Property;_em;em;1;1;[HDR];Create;True;0;0;False;0;False;1,1,1,0;2,2,2,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;20;-308.4605,72.91877;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;161;-39.56857,2545.881;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;42;-822.7087,1351.633;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;6;-792.0491,-359.5781;Inherit;False;Property;_Color1;Color 1;0;1;[HDR];Create;True;0;0;False;0;False;0,0.4550867,1,0;0.7429983,0.9985898,1.515717,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;19;-311.6602,-5.481271;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;205.4214,2341.361;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;168;215.4204,2596.901;Inherit;True;0;0;1;0;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.Vector3Node;28;-555.1324,1387.908;Inherit;False;Property;_BSP;BSP;5;0;Create;True;0;0;False;0;False;0,1,5;-2,0.8,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;165;466.0794,2715.22;Inherit;False;Property;_overpowerstart;overpowerstart;11;0;Create;True;0;0;False;0;False;10;181.93;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;24;-782.1561,1239.845;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-95.10898,270.9551;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;456.3184,2344.548;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;27;-313.3946,1232.391;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-82.04399,-96.50408;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;248.7888,414.4587;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;163;675.3486,2263.958;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;214;-4550.515,1866.043;Inherit;True;3;0;FLOAT;0.9;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;1300.843,697.3824;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;219;-5619.776,1547.454;Inherit;False;Property;_thicknesspow;thicknesspow;15;0;Create;True;0;0;False;0;False;0;2.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;198;-3505.673,1573.738;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;196;-3645.85,1193.853;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;199;-3693.489,1616.097;Inherit;False;Property;_waveforce;waveforce;13;0;Create;True;0;0;False;0;False;0,0;0,2.82;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;233;-3075.146,-550.1664;Inherit;True;Spherize;-1;;41;1488bb72d8899174ba0601b595d32b07;0;4;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2579.357,796.6089;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/door_vortex;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;201;0;202;0
WireConnection;74;0;202;0
WireConnection;74;1;201;0
WireConnection;80;0;78;2
WireConnection;80;2;79;0
WireConnection;144;0;141;2
WireConnection;144;2;142;0
WireConnection;145;0;143;0
WireConnection;242;0;240;0
WireConnection;242;1;239;0
WireConnection;146;0;145;0
WireConnection;146;1;144;0
WireConnection;73;0;74;0
WireConnection;223;0;80;0
WireConnection;246;0;240;0
WireConnection;246;1;242;0
WireConnection;147;2;146;0
WireConnection;147;3;144;0
WireConnection;72;0;73;0
WireConnection;72;2;223;0
WireConnection;70;1;147;0
WireConnection;70;2;10;3
WireConnection;77;2;72;0
WireConnection;77;4;197;0
WireConnection;248;0;240;0
WireConnection;248;1;246;0
WireConnection;247;0;240;0
WireConnection;247;1;246;0
WireConnection;244;0;70;0
WireConnection;244;1;247;0
WireConnection;245;0;70;0
WireConnection;245;1;248;0
WireConnection;238;0;70;0
WireConnection;238;1;239;0
WireConnection;241;0;70;0
WireConnection;241;1;242;0
WireConnection;243;0;70;0
WireConnection;243;1;246;0
WireConnection;75;1;77;0
WireConnection;222;0;75;6
WireConnection;249;0;245;0
WireConnection;249;1;244;0
WireConnection;249;2;243;0
WireConnection;249;3;241;0
WireConnection;249;4;238;0
WireConnection;251;0;249;0
WireConnection;251;1;238;0
WireConnection;217;1;74;0
WireConnection;217;2;222;0
WireConnection;120;0;217;0
WireConnection;252;0;251;0
WireConnection;252;1;238;0
WireConnection;229;1;147;0
WireConnection;229;2;10;3
WireConnection;33;0;35;1
WireConnection;230;0;229;0
WireConnection;230;1;120;0
WireConnection;230;2;252;0
WireConnection;34;0;35;2
WireConnection;255;0;229;0
WireConnection;255;1;254;0
WireConnection;32;0;33;0
WireConnection;32;1;34;0
WireConnection;228;0;230;0
WireConnection;228;1;70;0
WireConnection;228;2;120;0
WireConnection;228;3;255;0
WireConnection;2;0;228;0
WireConnection;2;1;10;1
WireConnection;158;0;159;0
WireConnection;154;0;153;0
WireConnection;36;0;32;0
WireConnection;36;1;37;0
WireConnection;167;0;154;0
WireConnection;167;1;166;0
WireConnection;23;0;35;0
WireConnection;23;1;36;0
WireConnection;157;0;154;0
WireConnection;157;1;159;0
WireConnection;157;2;158;0
WireConnection;15;0;2;0
WireConnection;15;1;16;1
WireConnection;15;2;16;2
WireConnection;160;0;157;0
WireConnection;160;1;158;0
WireConnection;160;2;167;0
WireConnection;18;0;15;0
WireConnection;18;1;2;0
WireConnection;22;0;23;0
WireConnection;155;0;157;0
WireConnection;20;0;18;0
WireConnection;161;0;160;0
WireConnection;42;0;22;0
WireConnection;42;1;41;1
WireConnection;42;2;41;2
WireConnection;19;0;20;0
WireConnection;162;0;155;0
WireConnection;162;1;161;0
WireConnection;168;1;170;4
WireConnection;24;0;42;0
WireConnection;8;0;18;0
WireConnection;8;1;7;0
WireConnection;164;0;162;0
WireConnection;164;1;165;0
WireConnection;164;2;168;0
WireConnection;27;0;24;0
WireConnection;27;1;28;1
WireConnection;27;2;28;2
WireConnection;27;3;28;3
WireConnection;21;0;6;0
WireConnection;21;1;19;0
WireConnection;12;0;8;0
WireConnection;12;1;10;2
WireConnection;163;0;155;0
WireConnection;163;1;164;0
WireConnection;29;0;12;0
WireConnection;29;1;27;0
WireConnection;29;2;21;0
WireConnection;198;1;199;1
WireConnection;198;2;199;2
WireConnection;196;0;75;7
WireConnection;0;2;29;0
WireConnection;0;9;163;0
ASEEND*/
//CHKSM=06EE6E6BA6AA6C05925FD14553A87AB0C71AAE9C