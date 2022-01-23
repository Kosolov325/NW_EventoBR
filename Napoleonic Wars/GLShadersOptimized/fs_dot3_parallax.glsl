uniform sampler2D diffuse_texture;
uniform sampler2D normal_texture;
uniform vec4 vMaterialColor;
uniform vec4 vSpecularColor;
uniform vec4 vSunColor;
uniform vec4 vAmbientColor;
uniform vec4 vSkyLightColor;
uniform vec4 vPointLightColor;
uniform vec4 vFogColor;
uniform vec4 output_gamma_inv;
varying vec4 VertexColor;
varying vec2 Tex0;
varying vec3 SunLightDir;
varying vec3 SkyLightDir;
varying vec4 PointLightDir;
varying float Fog;
varying vec3 ViewDir;
varying vec3 WorldNormal;
void main ()
{
  vec2 tmpvar_1;
  vec4 tex_col_2;
  vec4 total_light_3;
  vec4 tmpvar_4;
  float tmpvar_5;
  tmpvar_5 = (0.01 * vSpecularColor.x);
  vec4 tmpvar_6;
  tmpvar_6 = texture2D (normal_texture, Tex0);
  tmpvar_1 = (Tex0 + ((
    ((tmpvar_6.w * tmpvar_5) + (tmpvar_5 * -0.5))
   * tmpvar_6.z) * ViewDir.xy));
  vec3 tmpvar_7;
  tmpvar_7 = ((2.0 * texture2D (normal_texture, tmpvar_1).xyz) - 1.0);
  vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = vSunColor.xyz;
  total_light_3 = (vAmbientColor + (clamp (
    dot (SunLightDir, tmpvar_7)
  , 0.0, 1.0) * tmpvar_8));
  total_light_3 = (total_light_3 + (clamp (
    dot (SkyLightDir, tmpvar_7)
  , 0.0, 1.0) * vSkyLightColor));
  vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = vPointLightColor.xyz;
  total_light_3 = (total_light_3 + (clamp (
    dot (PointLightDir.xyz, tmpvar_7)
  , 0.0, 1.0) * tmpvar_9));
  tmpvar_4.xyz = total_light_3.xyz;
  tmpvar_4.w = 1.0;
  tmpvar_4 = (tmpvar_4 * vMaterialColor);
  vec4 tmpvar_10;
  tmpvar_10 = texture2D (diffuse_texture, tmpvar_1);
  tex_col_2.w = tmpvar_10.w;
  tex_col_2.xyz = pow (tmpvar_10.xyz, vec3(2.2, 2.2, 2.2));
  tmpvar_4 = (tmpvar_4 * tex_col_2);
  tmpvar_4 = (tmpvar_4 * VertexColor);
  float tmpvar_11;
  tmpvar_11 = (1.0 - clamp (dot (ViewDir, WorldNormal), 0.0, 1.0));
  tmpvar_4.xyz = (tmpvar_4.xyz * max (0.6, (
    (tmpvar_11 * tmpvar_11)
   + 0.1)));
  tmpvar_4.xyz = pow (tmpvar_4.xyz, output_gamma_inv.xyz);
  if ((tmpvar_4.w < 0.05)) {
    discard;
  };
  tmpvar_4.xyz = mix (vFogColor.xyz, tmpvar_4.xyz, Fog);
  gl_FragColor = tmpvar_4;
}

