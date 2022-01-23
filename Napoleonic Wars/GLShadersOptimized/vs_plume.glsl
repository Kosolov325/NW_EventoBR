uniform vec4 vMaterialColor;
uniform vec4 vSunColor;
uniform vec4 vAmbientColor;
uniform float fFogDensity;
uniform mat4 matWorldViewProj;
uniform mat4 matWorld;
uniform vec4 vCameraPos;
attribute vec3 inPosition;
attribute vec4 inColor0;
attribute vec2 inTexCoord;
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
  tmpvar_2.xyz = (inColor0.zyxw * (vAmbientColor + (vSunColor * 0.06))).xyz;
  tmpvar_2.w = (inColor0.w * vMaterialColor.w);
  vec3 tmpvar_4;
  tmpvar_4 = (vCameraPos.xyz - (matWorld * tmpvar_1).xyz);
  gl_Position = (matWorldViewProj * tmpvar_1);
  Fog = (1.0/(exp2((
    sqrt(dot (tmpvar_4, tmpvar_4))
   * fFogDensity))));
  Color = tmpvar_2;
  Tex0 = inTexCoord;
  SunLight = ((inColor0.zyxw * vSunColor) * (0.34 * vMaterialColor));
  ShadowTexCoord = tmpvar_3;
}

