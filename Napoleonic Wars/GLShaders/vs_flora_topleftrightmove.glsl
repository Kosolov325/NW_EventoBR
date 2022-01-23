
attribute vec3 inPosition;
attribute vec4 inColor0;
attribute vec2 inTexCoord;
 
varying float  Fog;
varying float4 Color;
varying float2 Tex0;
varying float4 SunLight;
varying float4 ShadowTexCoord;
#ifdef USE_ShadowTexelPos_INTERPOLATOR
	varying float2 ShadowTexelPos;
#endif

	
VS_OUTPUT_FLORA vs_flora_topleftrightmove(int PcfMode, float4 vPosition, float4 vColor, float2 tc)
{
	VS_OUTPUT_FLORA Out;
  
  if ( (tc.y <= 0.25)
    || (tc.x <= 0.25)
    || (tc.x >= 0.75)
     )
  {
    // AON wind animation for flora.
    vPosition.xyz += CalcFloraVertexAnimation(vPosition.xy); 
  }
  
	Out.Pos = mul(matWorldViewProj, vPosition);
	float4 vWorldPos = mul(matWorld,vPosition);

	Out.Tex0 = tc;
  float4 combicolor1 = (vAmbientColor + vSunColor * 0.06);
	Out.Color = vColor.bgra * combicolor1; //add some sun color to simulate sun passing through leaves.
	Out.Color.a = vColor.a * vMaterialColor.a;

	//shadow mapping variables
  float4 combicolor2 = (vSunColor * 0.34) * vMaterialColor;
	Out.SunLight = vColor.bgra * combicolor2;
   
  
	if (PcfMode != PCF_NONE)
	{
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		#ifdef SET_SHADOWCOORD_W_TO_1
			Out.ShadowTexCoord.z /= ShadowPos.w;
			Out.ShadowTexCoord.w = 1.0;
		#endif
		#ifdef USE_ShadowTexelPos_INTERPOLATOR
			Out.ShadowTexelPos = Out.ShadowTexCoord.xy * fShadowMapSize;
		#endif
	}
	//shadow mapping variables end
	
	//apply fog
/* 	float3 P = mul(matWorldView, orgPos).xyz; //position in view space
	float d = length(P); */
  float d = distance(vCameraPos.xyz, vWorldPos.xyz);
	Out.Fog = get_fog_amount(d);

	return Out;
}


void main()
{
	VS_OUTPUT_FLORA VSOut;
	//VSOut = vs_flora_topleftrightmove(CURRENT_PCF_MODE, vec4(inPosition, 1.0), inColor0, inTexCoord);
	VSOut = vs_flora(CURRENT_PCF_MODE, vec4(inPosition, 1.0), inColor0, inTexCoord);
	
	gl_Position = VSOut.Pos;
	Fog = VSOut.Fog;
	Color = VSOut.Color;
	Tex0 = VSOut.Tex0;
	SunLight = VSOut.SunLight;
	ShadowTexCoord = VSOut.ShadowTexCoord;
	#ifdef USE_ShadowTexelPos_INTERPOLATOR
		ShadowTexelPos = VSOut.ShadowTexelPos;
	#endif
}
