uniform vec4 vMaterialColor;
uniform vec4 vSunColor;
uniform vec4 vAmbientColor;
uniform float fFogDensity;
uniform mat4 matWorldViewProj;
uniform mat4 matWorld;
uniform mat4 matWorldArray[32];
uniform vec4 vCameraPos;
attribute vec3 inPosition;
attribute vec4 inColor0;
attribute vec2 inTexCoord;
attribute vec4 inBlendWeight;
attribute vec4 inBlendIndices;
varying float Fog;
varying vec4 Color;
varying vec2 Tex0;
varying vec4 SunLight;
varying vec4 ShadowTexCoord;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = inPosition;
  vec4 tmpvar_2;
  vec4 tmpvar_3;
  vec4 tmpvar_4;
  tmpvar_4 = (((
    ((matWorldArray[int(inBlendIndices.x)] * tmpvar_1) * inBlendWeight.x)
   + 
    ((matWorldArray[int(inBlendIndices.y)] * tmpvar_1) * inBlendWeight.y)
  ) + (
    (matWorldArray[int(inBlendIndices.z)] * tmpvar_1)
   * inBlendWeight.z)) + ((matWorldArray[
    int(inBlendIndices.w)
  ] * tmpvar_1) * inBlendWeight.w));
  tmpvar_2.xyz = (inColor0.zyxw * (vAmbientColor + (vSunColor * 0.06))).xyz;
  tmpvar_2.w = (inColor0.w * vMaterialColor.w);
  vec3 tmpvar_5;
  tmpvar_5 = (vCameraPos.xyz - (matWorld * tmpvar_4).xyz);
  gl_Position = (matWorldViewProj * tmpvar_4);
  Fog = (1.0/(exp2((
    sqrt(dot (tmpvar_5, tmpvar_5))
   * fFogDensity))));
  Color = tmpvar_2;
  Tex0 = inTexCoord;
  SunLight = ((inColor0.zyxw * vSunColor) * (0.34 * vMaterialColor));
  ShadowTexCoord = tmpvar_3;
}

