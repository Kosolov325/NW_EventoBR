uniform vec4 vMaterialColor;
uniform vec4 vSunColor;
uniform vec4 vAmbientColor;
uniform float fFogDensity;
uniform float time_var;
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
  vec4 vPosition_2;
  vPosition_2 = tmpvar_1;
  vec4 tmpvar_3;
  vec4 tmpvar_4;
  if ((inTexCoord.y <= 0.25)) {
    vec3 wind_5;
    wind_5.z = 0.0;
    float tmpvar_6;
    tmpvar_6 = (time_var * 1.188);
    wind_5.x = (sin((
      (inPosition.x * -1.32)
     + tmpvar_6)) * 0.04515);
    wind_5.y = (cos((
      (inPosition.y * -0.66)
     + tmpvar_6)) * 0.022575);
    wind_5 = (wind_5 * sin((time_var * 0.2)));
    wind_5.x = (wind_5.x - 0.04515);
    wind_5.z = (wind_5.z + (wind_5.x * 0.5));
    wind_5.y = (wind_5.y - 0.022575);
    vPosition_2.xyz = (inPosition + wind_5);
  };
  tmpvar_3.xyz = (inColor0.zyxw * (vAmbientColor + (vSunColor * 0.06))).xyz;
  tmpvar_3.w = (inColor0.w * vMaterialColor.w);
  vec3 tmpvar_7;
  tmpvar_7 = (vCameraPos.xyz - (matWorld * vPosition_2).xyz);
  gl_Position = (matWorldViewProj * vPosition_2);
  Fog = (1.0/(exp2((
    sqrt(dot (tmpvar_7, tmpvar_7))
   * fFogDensity))));
  Color = tmpvar_3;
  Tex0 = inTexCoord;
  SunLight = ((inColor0.zyxw * vSunColor) * (0.34 * vMaterialColor));
  ShadowTexCoord = tmpvar_4;
}

