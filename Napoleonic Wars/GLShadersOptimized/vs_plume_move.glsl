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
  if (!(((
    (inTexCoord.x >= 0.18)
   && 
    (inTexCoord.x <= 0.25)
  ) && (
    (inTexCoord.y >= 0.18)
   && 
    (inTexCoord.y <= 0.25)
  )))) {
    float tmpvar_5;
    tmpvar_5 = (time_var * 2.3);
    float tmpvar_6;
    tmpvar_6 = noise1(time_var);
    vPosition_2.x = (inPosition.x + ((
      sin(((tmpvar_5 + inPosition.x) + (inPosition.y - inPosition.x)))
     * 0.015) * tmpvar_6));
    vPosition_2.y = (inPosition.y + ((
      sin(((tmpvar_5 + inPosition.y) + (inPosition.y - vPosition_2.x)))
     * 0.015) * tmpvar_6));
    vPosition_2.z = (inPosition.z + ((
      cos(((tmpvar_5 + inPosition.z) + (vPosition_2.y - vPosition_2.x)))
     * 0.015) * tmpvar_6));
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

