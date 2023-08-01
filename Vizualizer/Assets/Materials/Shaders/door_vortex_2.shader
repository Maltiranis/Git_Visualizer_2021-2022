// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/door_vortex_2"
{
	Properties
	{
		_Steponoff("Steponoff", Range( -0.1 , 1)) = 0.2388621
		_smoothonoff("smoothonoff", Float) = 1.19
		[HDR]_Colorcenter("Color center", Color) = (0,0,0,0)
		[HDR]_Colorbg("Color bg", Color) = (0,0,0,0)
		[HDR]_Colorglobal("Color global", Color) = (0,0,0,0)
		_tess("tess", Float) = 0
		_Smoothstep1("Smoothstep1", Vector) = (0,0,0,0)
		_Smoothstep2("Smoothstep2", Vector) = (0,0,0,0)
		_Smoothstep3("Smoothstep3", Vector) = (0,0,0,0)
		_Smoothstep4("Smoothstep4", Vector) = (0,0,0,0)
		_noiseScale("noiseScale", Float) = 0
		_spherize("spherize", Vector) = (1,1,0,0)
		_noiseSpeed("noiseSpeed", Float) = 0
		[HDR]_Color0("Color 0", Color) = (1,1,1,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard alpha:fade keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Colorbg;
		uniform float2 _Smoothstep1;
		uniform float4 _Colorglobal;
		uniform float2 _Smoothstep2;
		uniform float2 _Smoothstep3;
		uniform float2 _spherize;
		uniform float _noiseSpeed;
		uniform float _noiseScale;
		uniform float4 _Colorcenter;
		uniform float2 _Smoothstep4;
		uniform float _Steponoff;
		uniform float _smoothonoff;
		uniform float4 _Color0;
		uniform float _tess;


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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _tess);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 CenteredUV15_g46 = ( i.uv_texcoord - float2( 0.5,0.5 ) );
			float2 break17_g46 = CenteredUV15_g46;
			float2 appendResult23_g46 = (float2(( length( CenteredUV15_g46 ) * 1.0 * 2.0 ) , ( atan2( break17_g46.x , break17_g46.y ) * ( 1.0 / 6.28318548202515 ) * 0.0 )));
			float2 temp_output_305_0 = appendResult23_g46;
			float smoothstepResult311 = smoothstep( _Smoothstep1.x , _Smoothstep1.y , length( temp_output_305_0 ));
			float lerpResult419 = lerp( 0.0 , 0.0 , 0.509434);
			float smoothstepResult319 = smoothstep( _Smoothstep2.x , _Smoothstep2.y , ( 1.0 - length( temp_output_305_0 ) ));
			float smoothstepResult326 = smoothstep( _Smoothstep3.x , _Smoothstep3.y , ( 1.0 - length( temp_output_305_0 ) ));
			float2 uv_TexCoord430 = i.uv_texcoord + float2( 0.5,0.5 );
			float simplePerlin3D423 = snoise( float3( uv_TexCoord430 ,  0.0 )*12.0 );
			simplePerlin3D423 = simplePerlin3D423*0.5 + 0.5;
			float2 temp_output_2_0_g48 = i.uv_texcoord;
			float2 temp_output_11_0_g48 = ( temp_output_2_0_g48 - float2( 0.5,0.5 ) );
			float dotResult12_g48 = dot( temp_output_11_0_g48 , temp_output_11_0_g48 );
			float2 appendResult398 = (float2(( _noiseSpeed * _Time.y ) , 0.0));
			float dotResult4_g40 = dot( float2( 0,0 ) , float2( 12.9898,78.233 ) );
			float lerpResult10_g40 = lerp( _noiseScale , 1.0 , frac( ( sin( dotResult4_g40 ) * 43758.55 ) ));
			float simplePerlin3D343 = snoise( float3( ( temp_output_2_0_g48 + ( temp_output_11_0_g48 * ( dotResult12_g48 * dotResult12_g48 * _spherize ) ) + ( 1.0 - appendResult398 ) ) ,  0.0 )*lerpResult10_g40 );
			simplePerlin3D343 = simplePerlin3D343*0.5 + 0.5;
			float2 temp_output_2_0_g45 = i.uv_texcoord;
			float2 temp_output_11_0_g45 = ( temp_output_2_0_g45 - float2( 0.5,0.5 ) );
			float dotResult12_g45 = dot( temp_output_11_0_g45 , temp_output_11_0_g45 );
			float dotResult4_g42 = dot( float2( 0,0 ) , float2( 12.9898,78.233 ) );
			float lerpResult10_g42 = lerp( _noiseScale , 1.0 , frac( ( sin( dotResult4_g42 ) * 43758.55 ) ));
			float simplePerlin3D395 = snoise( float3( ( temp_output_2_0_g45 + ( temp_output_11_0_g45 * ( dotResult12_g45 * dotResult12_g45 * _spherize ) ) + appendResult398 ) ,  0.0 )*lerpResult10_g42 );
			simplePerlin3D395 = simplePerlin3D395*0.5 + 0.5;
			float2 temp_output_2_0_g43 = i.uv_texcoord;
			float2 temp_output_11_0_g43 = ( temp_output_2_0_g43 - float2( 0.5,0.5 ) );
			float dotResult12_g43 = dot( temp_output_11_0_g43 , temp_output_11_0_g43 );
			float2 appendResult407 = (float2(0.0 , ( _noiseSpeed * _Time.y )));
			float dotResult4_g44 = dot( float2( 0,0 ) , float2( 12.9898,78.233 ) );
			float lerpResult10_g44 = lerp( _noiseScale , 1.0 , frac( ( sin( dotResult4_g44 ) * 43758.55 ) ));
			float simplePerlin3D403 = snoise( float3( ( temp_output_2_0_g43 + ( temp_output_11_0_g43 * ( dotResult12_g43 * dotResult12_g43 * _spherize ) ) + ( 1.0 - appendResult407 ) ) ,  0.0 )*lerpResult10_g44 );
			simplePerlin3D403 = simplePerlin3D403*0.5 + 0.5;
			float2 temp_output_2_0_g41 = i.uv_texcoord;
			float2 temp_output_11_0_g41 = ( temp_output_2_0_g41 - float2( 0.5,0.5 ) );
			float dotResult12_g41 = dot( temp_output_11_0_g41 , temp_output_11_0_g41 );
			float dotResult4_g47 = dot( float2( 0,0 ) , float2( 12.9898,78.233 ) );
			float lerpResult10_g47 = lerp( _noiseScale , 1.0 , frac( ( sin( dotResult4_g47 ) * 43758.55 ) ));
			float simplePerlin3D405 = snoise( float3( ( temp_output_2_0_g41 + ( temp_output_11_0_g41 * ( dotResult12_g41 * dotResult12_g41 * _spherize ) ) + appendResult407 ) ,  0.0 )*lerpResult10_g47 );
			simplePerlin3D405 = simplePerlin3D405*0.5 + 0.5;
			float temp_output_355_0 = saturate( ( smoothstepResult326 * ( simplePerlin3D423 + ( simplePerlin3D343 + simplePerlin3D395 + simplePerlin3D403 + simplePerlin3D405 ) ) ) );
			float temp_output_375_0 = ( smoothstepResult319 * ( 1.0 - temp_output_355_0 ) );
			float smoothstepResult379 = smoothstep( _Smoothstep4.x , _Smoothstep4.y , temp_output_355_0);
			float4 result313 = ( ( _Colorbg * saturate( smoothstepResult311 ) ) + lerpResult419 + ( _Colorglobal * temp_output_375_0 ) + ( _Colorcenter * smoothstepResult379 ) );
			float temp_output_456_0 = ( _Steponoff + 0.6 );
			float time168 = _Time.w;
			float2 coords168 = i.uv_texcoord * 20.0;
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
			float2 uv_TexCoord153 = i.uv_texcoord + float2( -0.5,-0.5 );
			float temp_output_154_0 = length( uv_TexCoord153 );
			float smoothstepResult455 = smoothstep( 1.0 , voroi168 , temp_output_154_0);
			float smoothstepResult160 = smoothstep( temp_output_456_0 , smoothstepResult455 , temp_output_154_0);
			float smoothstepResult465 = smoothstep( ( temp_output_456_0 * _smoothonoff ) , smoothstepResult455 , temp_output_154_0);
			float smoothstepResult464 = smoothstep( ( 1.0 - smoothstepResult160 ) , smoothstepResult465 , smoothstepResult455);
			float temp_output_163_0 = ( ( smoothstepResult160 * smoothstepResult464 ) + 0.0 );
			float normalizeResult472 = normalize( temp_output_163_0 );
			o.Emission = ( result313 - ( normalizeResult472 * _Color0 ) ).rgb;
			o.Alpha = temp_output_163_0;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
244.6667;72.66667;1938.333;864;1663.243;-2235.08;1.355736;True;True
Node;AmplifyShaderEditor.RangedFloatNode;410;-3649.258,1206.204;Inherit;False;Property;_noiseSpeed;noiseSpeed;17;0;Create;True;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;363;-3709.109,868.1661;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;366;-3025.998,791.6849;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;408;-2897.186,1314.636;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;407;-2721.799,1272.961;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;398;-2837.844,860.5939;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;346;-2802.359,349.2614;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;390;-2669.941,533.7136;Inherit;False;Property;_spherize;spherize;16;0;Create;True;0;0;False;0;False;1,1;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;349;-2300.767,669.9419;Inherit;False;Property;_noiseScale;noiseScale;15;0;Create;True;0;0;False;0;False;0;12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;409;-2612.415,1160.091;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;402;-2672.745,750.608;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;389;-2388.918,440.1078;Inherit;True;Spherize;-1;;48;1488bb72d8899174ba0601b595d32b07;0;4;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;404;-2351.966,1088.408;Inherit;True;Spherize;-1;;43;1488bb72d8899174ba0601b595d32b07;0;4;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;415;-1870.819,844.0744;Inherit;True;Random Range;-1;;42;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;414;-1813.783,1390.935;Inherit;True;Random Range;-1;;47;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;305;-1161.049,-555.8057;Inherit;False;Polar Coordinates;-1;;46;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;406;-2326.266,1347.754;Inherit;True;Spherize;-1;;41;1488bb72d8899174ba0601b595d32b07;0;4;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;396;-2365.013,828.4229;Inherit;True;Spherize;-1;;45;1488bb72d8899174ba0601b595d32b07;0;4;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;416;-1857.593,1088.004;Inherit;True;Random Range;-1;;44;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;417;-1916.496,528.004;Inherit;True;Random Range;-1;;40;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;403;-1519.18,1007.154;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;12;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;343;-1536.941,417.5974;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;12;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;324;-681.9965,-70.27362;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;395;-1532.228,747.1683;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;12;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;430;-1395.724,20.69826;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.5,0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;405;-1493.479,1266.5;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;12;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;357;-457.9965,-54.27364;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;397;-1045.977,810.5231;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;325;-233.9966,-182.2737;Inherit;False;Property;_Smoothstep3;Smoothstep3;13;0;Create;True;0;0;False;0;False;0,0;-1.56,5.03;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;170;-1169.903,2475.022;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;153;-1059.748,2736.069;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.5,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;423;-1027.046,97.28901;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;12;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;159;-914.1711,2981.633;Inherit;False;Property;_Steponoff;Steponoff;4;0;Create;True;0;0;False;0;False;0.2388621;0.675;-0.1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;422;-295.859,644.3052;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;326;-249.9966,-70.27362;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.55;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;154;-748.949,2731.888;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;168;-837.4309,2465.787;Inherit;True;0;0;1;0;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;20;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleAddOpNode;456;-625.7405,2939.612;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;166;-861.6825,3084.457;Inherit;False;Property;_smoothonoff;smoothonoff;6;0;Create;True;0;0;False;0;False;1.19;-8.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;358;294.0034,185.7263;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;455;-513.5364,2535.462;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;318;-681.9965,-454.2737;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;160;-55.85259,2505.491;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1.42;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;356;-457.9965,-454.2737;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;355;513.5949,154.8064;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;-243.6775,2880.276;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;304;-681.9965,-822.2736;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;317;-249.9966,-566.2736;Inherit;False;Property;_Smoothstep2;Smoothstep2;12;0;Create;True;0;0;False;0;False;0,0;0,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;316;-249.9966,-934.2736;Inherit;False;Property;_Smoothstep1;Smoothstep1;11;0;Create;True;0;0;False;0;False;0,0;0,4;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SmoothstepOpNode;465;-38.97348,2791.418;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1.42;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;319;-249.9966,-438.2737;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.55;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;311;-249.9966,-822.2736;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.55;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;382;644.428,-213.0882;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;463;231.1597,2631.99;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;378;950.0032,233.7263;Inherit;False;Property;_Smoothstep4;Smoothstep4;14;0;Create;True;0;0;False;0;False;0,0;0.55,0.87;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SmoothstepOpNode;379;950.0032,361.7263;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.55;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;375;607.235,-468.8877;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;359;374.0033,-694.2736;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;464;446.7039,2676.494;Inherit;True;3;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;1.42;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;256;566.0032,-902.2736;Inherit;False;Property;_Colorbg;Color bg;8;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,0.1188679,0.4811321,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;337;1083.049,-596.267;Inherit;False;Property;_Colorglobal;Color global;9;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0.1289307,0.3511424,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;257;1134.756,25.90364;Inherit;False;Property;_Colorcenter;Color center;7;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;2.102977,2.376091,6.964404,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;334;1431.945,124.0639;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;339;1463.987,-489.5786;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;419;1697.123,-204.5344;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.509434;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;332;849.8602,-748.246;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;466;976.7545,2624.242;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;163;2009.441,1190.262;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;341;1862.003,-518.2736;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;313;2281.476,-468.6535;Inherit;False;result;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;469;1825.115,879.9975;Inherit;False;Property;_Color0;Color 0;20;1;[HDR];Create;True;0;0;False;0;False;1,1,1,1;0.00837323,0.00837323,0.00837323,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;472;2195.855,1001.96;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;467;2303.319,887.5349;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;312;1936.43,756.3672;Inherit;False;313;result;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;273;2361.599,1331.369;Inherit;False;Property;_tess;tess;10;0;Create;True;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;27;-284.5706,1845.93;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;354;838.0032,-470.2738;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;447;-30.26551,451.6036;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;33;-1794.38,1889.365;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;22;-1036.962,1698.147;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;37;-1812.035,2102.452;Inherit;False;Property;_FakeLightSource;FakeLightSource;3;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;462;657.3083,2457.435;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;271;1647.145,1075.151;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;457;341.9507,3094.305;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;448;-662.7379,3105.254;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;449;-861.3614,3193.675;Inherit;False;Property;_Vector3;Vector 3;18;0;Create;True;0;0;False;0;False;0,0;1.23,-0.36;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.HSVToRGBNode;388;757.0015,2090.076;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;41;-1038.033,1969.55;Inherit;False;Property;_step3;step3;0;0;Create;True;0;0;False;0;False;1,0;-0.5,0.75;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.EdgeLengthTessNode;272;2329.004,1240.286;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;32;-1599.708,1854.461;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;386;303.7449,1904.792;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;270;1154.026,1736.515;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;-411.2643,3311.74;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;28;-526.3083,2001.447;Inherit;False;Property;_BSP;BSP;1;0;Create;True;0;0;False;0;False;0,1,5;-2,0.8,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;24;-753.3321,1853.384;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;473;-129.9094,3134.382;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;461;344.2376,2332.35;Inherit;False;Property;_closeDoorEffect;closeDoorEffect;19;1;[HDR];Create;True;0;0;False;0;False;2.670157,0,0,0;8.47419,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1393.035,1940.452;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;381;86.00347,-742.2736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;380;102.0035,-342.2737;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;434;-686.0128,167.0921;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;385;305.3862,1657.676;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;351;1819.67,266.9193;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GammaToLinearNode;387;801.0081,1946.977;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;420;1822.483,32.25082;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;370;530.2093,1679.937;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;34;-1805.18,1985.665;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;383;-212.1833,1656.144;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;384;89.47695,1663.801;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;3.52;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;165;-596.3738,3604.463;Inherit;False;Property;_overpowerstart;overpowerstart;5;0;Create;True;0;0;False;0;False;10;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;471;2356.855,765.9598;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;338;-457.9965,-902.2736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;35;-1982.035,1722.452;Inherit;False;Property;_tilinoffset1;tilinoffset 1;2;0;Create;True;0;0;False;0;False;2,2;1.5,2.11;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SmoothstepOpNode;42;-793.8846,1965.172;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-1351.661,1694.528;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.5,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2579.357,796.6089;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Custom/door_vortex_2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;366;0;410;0
WireConnection;366;1;363;2
WireConnection;408;0;410;0
WireConnection;408;1;363;2
WireConnection;407;1;408;0
WireConnection;398;0;366;0
WireConnection;409;0;407;0
WireConnection;402;0;398;0
WireConnection;389;2;346;0
WireConnection;389;4;390;0
WireConnection;389;5;402;0
WireConnection;404;2;346;0
WireConnection;404;4;390;0
WireConnection;404;5;409;0
WireConnection;415;2;349;0
WireConnection;414;2;349;0
WireConnection;406;2;346;0
WireConnection;406;4;390;0
WireConnection;406;5;407;0
WireConnection;396;2;346;0
WireConnection;396;4;390;0
WireConnection;396;5;398;0
WireConnection;416;2;349;0
WireConnection;417;2;349;0
WireConnection;403;0;404;0
WireConnection;403;1;416;0
WireConnection;343;0;389;0
WireConnection;343;1;417;0
WireConnection;324;0;305;0
WireConnection;395;0;396;0
WireConnection;395;1;415;0
WireConnection;405;0;406;0
WireConnection;405;1;414;0
WireConnection;357;0;324;0
WireConnection;397;0;343;0
WireConnection;397;1;395;0
WireConnection;397;2;403;0
WireConnection;397;3;405;0
WireConnection;423;0;430;0
WireConnection;422;0;423;0
WireConnection;422;1;397;0
WireConnection;326;0;357;0
WireConnection;326;1;325;1
WireConnection;326;2;325;2
WireConnection;154;0;153;0
WireConnection;168;1;170;4
WireConnection;456;0;159;0
WireConnection;358;0;326;0
WireConnection;358;1;422;0
WireConnection;455;0;154;0
WireConnection;455;2;168;0
WireConnection;318;0;305;0
WireConnection;160;0;154;0
WireConnection;160;1;456;0
WireConnection;160;2;455;0
WireConnection;356;0;318;0
WireConnection;355;0;358;0
WireConnection;167;0;456;0
WireConnection;167;1;166;0
WireConnection;304;0;305;0
WireConnection;465;0;154;0
WireConnection;465;1;167;0
WireConnection;465;2;455;0
WireConnection;319;0;356;0
WireConnection;319;1;317;1
WireConnection;319;2;317;2
WireConnection;311;0;304;0
WireConnection;311;1;316;1
WireConnection;311;2;316;2
WireConnection;382;0;355;0
WireConnection;463;0;160;0
WireConnection;379;0;355;0
WireConnection;379;1;378;1
WireConnection;379;2;378;2
WireConnection;375;0;319;0
WireConnection;375;1;382;0
WireConnection;359;0;311;0
WireConnection;464;0;455;0
WireConnection;464;1;463;0
WireConnection;464;2;465;0
WireConnection;334;0;257;0
WireConnection;334;1;379;0
WireConnection;339;0;337;0
WireConnection;339;1;375;0
WireConnection;332;0;256;0
WireConnection;332;1;359;0
WireConnection;466;0;160;0
WireConnection;466;1;464;0
WireConnection;163;0;466;0
WireConnection;341;0;332;0
WireConnection;341;1;419;0
WireConnection;341;2;339;0
WireConnection;341;3;334;0
WireConnection;313;0;341;0
WireConnection;472;0;163;0
WireConnection;467;0;472;0
WireConnection;467;1;469;0
WireConnection;27;0;24;0
WireConnection;27;1;28;1
WireConnection;27;2;28;2
WireConnection;27;3;28;3
WireConnection;354;0;375;0
WireConnection;33;0;35;1
WireConnection;22;0;23;0
WireConnection;462;1;461;0
WireConnection;271;1;270;0
WireConnection;272;0;273;0
WireConnection;32;0;33;0
WireConnection;32;1;34;0
WireConnection;386;0;384;0
WireConnection;164;1;165;0
WireConnection;24;0;42;0
WireConnection;36;0;32;0
WireConnection;36;1;37;0
WireConnection;34;0;35;2
WireConnection;471;0;312;0
WireConnection;471;1;467;0
WireConnection;42;0;22;0
WireConnection;42;1;41;1
WireConnection;42;2;41;2
WireConnection;23;0;35;0
WireConnection;23;1;36;0
WireConnection;0;2;471;0
WireConnection;0;9;163;0
WireConnection;0;14;272;0
ASEEND*/
//CHKSM=09D82C00CFF59170590D47E37597C6F6EFB8DADA