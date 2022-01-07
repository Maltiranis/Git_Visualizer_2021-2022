// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ValouShaders/fish"
{
	Properties
	{
		_speed("speed", Float) = 1
		_freq("freq", Float) = 5
		_dist("dist", Float) = 0.5
		[HDR]_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_scale("scale", Float) = 0
		_Color0("Color 0", Color) = (0,0,0,0)
		[IntRange]_AddColor("AddColor", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _speed;
		uniform float _freq;
		uniform float _dist;
		uniform float _scale;
		uniform float _AddColor;
		uniform float4 _Color0;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 appendResult55 = (float4(( ( sin( ( ( _speed * _Time.y ) + ( ( ase_vertex3Pos.y + ase_vertex3Pos.z ) * _freq ) ) ) * _dist ) + ase_vertex3Pos.x ) , ase_vertex3Pos.y , ase_vertex3Pos.z , 0.0));
			v.vertex.xyz += (appendResult55*_scale + 0.0).xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ifLocalVar68 = 0;
			if( _AddColor == 1.0 )
				ifLocalVar68 = _Color0;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 ifLocalVar69 = 0;
			if( _AddColor == 0.0 )
				ifLocalVar69 = tex2D( _TextureSample0, uv_TextureSample0 );
			o.Albedo = ( ( _AddColor * ifLocalVar68 ) + ifLocalVar69 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
212;73;1395;655;-874.6993;1398.812;2.820001;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;43;-527.8118,-877.7771;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;21;154.9601,-1066.481;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-170.4321,-835.725;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;97.03009,-658.4813;Inherit;False;Property;_freq;freq;1;0;Create;True;0;0;False;0;5;200;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;180.7043,-1167.852;Inherit;False;Property;_speed;speed;0;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;468.726,-1105.098;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;355.0257,-791.2535;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;772.4791,-953.9501;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;50;1128.582,-930.5739;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;1042.817,-573.868;Inherit;False;Property;_dist;dist;2;0;Create;True;0;0;False;0;0.5;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;1374.182,-883.7924;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;65;2455.678,-1014.772;Inherit;False;Property;_Color0;Color 0;5;0;Create;True;0;0;False;0;0,0,0,0;1,0.3509255,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;54;1746.468,-380.541;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;67;2457.385,-1118.98;Inherit;False;Property;_AddColor;AddColor;6;1;[IntRange];Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;53;2128.485,-597.068;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;68;2908.388,-954.9779;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;56;2375.586,-831.308;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;1;[HDR];Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;3125.346,-999.3963;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;63;2527.228,-241.0583;Inherit;False;Property;_scale;scale;4;0;Create;True;0;0;False;0;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;69;2899.844,-756.813;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;2452.053,-482.2738;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;3273.969,-804.646;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;62;2938.685,-438.2059;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3411.487,-578.9781;Float;False;True;2;ASEMaterialInspector;0;0;Standard;ValouShaders/fish;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;15;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;46;0;43;2
WireConnection;46;1;43;3
WireConnection;23;0;24;0
WireConnection;23;1;21;2
WireConnection;41;0;46;0
WireConnection;41;1;47;0
WireConnection;48;0;23;0
WireConnection;48;1;41;0
WireConnection;50;0;48;0
WireConnection;51;0;50;0
WireConnection;51;1;52;0
WireConnection;53;0;51;0
WireConnection;53;1;54;1
WireConnection;68;0;67;0
WireConnection;68;3;65;0
WireConnection;66;0;67;0
WireConnection;66;1;68;0
WireConnection;69;0;67;0
WireConnection;69;3;56;0
WireConnection;55;0;53;0
WireConnection;55;1;54;2
WireConnection;55;2;54;3
WireConnection;64;0;66;0
WireConnection;64;1;69;0
WireConnection;62;0;55;0
WireConnection;62;1;63;0
WireConnection;0;0;64;0
WireConnection;0;11;62;0
ASEEND*/
//CHKSM=90DD4A1C410910E89332B86D783AA80208045394