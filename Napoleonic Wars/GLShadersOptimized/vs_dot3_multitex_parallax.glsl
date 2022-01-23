uniform vec4 vSunDir;
uniform vec4 vSkyLightDir;
uniform float fFogDensity;
uniform mat4 matWorldViewProj;
uniform mat4 matWorldView;
uniform mat4 matWorld;
uniform vec4 vCameraPos;
attribute vec3 inPosition;
attribute vec3 inNormal;
attribute vec4 inColor0;
attribute vec4 inColor1;
attribute vec2 inTexCoord;
attribute vec3 inTangent;
attribute vec3 inBinormal;
varying vec4 VertexColor;
varying vec2 Tex0;
varying vec3 SunLightDir;
varying vec3 SkyLightDir;
varying vec4 PointLightDir;
varying vec4 ShadowTexCoord;
varying float Fog;
varying vec3 ViewDir;
varying vec3 WorldNormal;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = inPosition;
  vec4 tmpvar_2;
  vec4 tmpvar_3;
  vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = inNormal;
  vec3 tmpvar_5;
  tmpvar_5 = normalize((matWorld * tmpvar_4).xyz);
  vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = inBinormal;
  vec3 tmpvar_7;
  tmpvar_7 = normalize((matWorld * tmpvar_6).xyz);
  vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = inTangent;
  vec3 tmpvar_9;
  tmpvar_9 = normalize((matWorld * tmpvar_8).xyz);
  vec3 tmpvar_10;
  tmpvar_10 = (matWorldView * tmpvar_1).xyz;
  vec3 tmpvar_11;
  tmpvar_11.x = tmpvar_9.x;
  tmpvar_11.y = tmpvar_7.x;
  tmpvar_11.z = tmpvar_5.x;
  vec3 tmpvar_12;
  tmpvar_12.x = tmpvar_9.y;
  tmpvar_12.y = tmpvar_7.y;
  tmpvar_12.z = tmpvar_5.y;
  vec3 tmpvar_13;
  tmpvar_13.x = tmpvar_9.z;
  tmpvar_13.y = tmpvar_7.z;
  tmpvar_13.z = tmpvar_5.z;
  mat3 tmpvar_14;
  tmpvar_14[0] = tmpvar_11;
  tmpvar_14[1] = tmpvar_12;
  tmpvar_14[2] = tmpvar_13;
  tmpvar_2.xyz = ((2.0 * inColor1.xyz) - 1.0);
  tmpvar_2.w = inColor1.w;
  gl_Position = (matWorldViewProj * tmpvar_1);
  VertexColor = inColor0.zyxw;
  Tex0 = inTexCoord;
  SunLightDir = (tmpvar_14 * -(vSunDir.xyz));
  SkyLightDir = (tmpvar_14 * -(vSkyLightDir.xyz));
  PointLightDir = tmpvar_2;
  ShadowTexCoord = tmpvar_3;
  Fog = (1.0/(exp2((
    sqrt(dot (tmpvar_10, tmpvar_10))
   * fFogDensity))));
  ViewDir = normalize((vCameraPos.xyz - (matWorld * tmpvar_1).xyz));
  WorldNormal = tmpvar_5;
}
