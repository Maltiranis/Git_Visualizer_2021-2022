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
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			o.Albedo = tex2D( _TextureSample0, uv_TextureSample0 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
212;73;1395;655;-1980.228;688.0583;1;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;43;211.1659,-845.9394;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;47;535.6161,-568.5148;Inherit;False;Property;_freq;freq;1;0;Create;True;0;0;False;0;5;200;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;473.4611,-798.2997;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;21;593.546,-976.515;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;619.2903,-1077.886;Inherit;False;Property;_speed;speed;0;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;793.6116,-701.287;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;907.3117,-1015.132;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;1211.065,-863.9835;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;50;1567.168,-840.6073;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;1481.403,-483.9015;Inherit;False;Property;_dist;dist;2;0;Create;True;0;0;False;0;0.5;0.005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;1812.768,-793.8258;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;54;1887.284,-397.4388;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;53;2128.485,-597.068;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;2452.053,-482.2738;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;63;2527.228,-241.0583;Inherit;False;Property;_scale;scale;4;0;Create;True;0;0;False;0;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;56;2375.586,-831.308;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;1;[HDR];Create;True;0;0;False;0;None;d72b41bc446749a4dadbcd84cb32bddf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;62;2938.685,-438.2059;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3411.487,-578.9781;Float;False;True;2;ASEMaterialInspector;0;0;Standard;ValouShaders/fish;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;15;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;46;0;43;2
WireConnection;46;1;43;3
WireConnection;41;0;46;0
WireConnection;41;1;47;0
WireConnection;23;0;24;0
WireConnection;23;1;21;2
WireConnection;48;0;23;0
WireConnection;48;1;41;0
WireConnection;50;0;48;0
WireConnection;51;0;50;0
WireConnection;51;1;52;0
WireConnection;53;0;51;0
WireConnection;53;1;54;1
WireConnection;55;0;53;0
WireConnection;55;1;54;2
WireConnection;55;2;54;3
WireConnection;62;0;55;0
WireConnection;62;1;63;0
WireConnection;0;0;56;0
WireConnection;0;11;62;0
ASEEND*/
//CHKSM=3D3C1B362BEE85A2E79B65E9C1FAEF2D79D36498