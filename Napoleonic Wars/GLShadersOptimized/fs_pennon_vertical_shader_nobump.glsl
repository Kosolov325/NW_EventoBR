uniform sampler2D diffuse_texture;
uniform vec4 vMaterialColor;
uniform vec4 vSunDir;
uniform vec4 vSunColor;
uniform vec4 vAmbientColor;
uniform vec4 vSkyLightDir;
uniform vec4 vSkyLightColor;
uniform vec4 vFogColor;
uniform vec4 output_gamma_inv;
varying float Fog;
varying vec4 VertexColor;
varying vec3 VertexLighting;
varying vec2 Tex0;
varying vec3 SunLightDir;
void main ()
{
  vec4 tex_col_1;
  vec4 total_light_2;
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  total_light_2.w = vAmbientColor.w;
  total_light_2.xyz = (vAmbientColor.xyz + (vec3(clamp (
    dot (-(vSunDir.xyz), SunLightDir)
  , 0.0, 1.0)) * vSunColor.xyz));
  total_light_2 = (total_light_2 + (clamp (
    dot (-(vSkyLightDir.xyz), SunLightDir)
  , 0.0, 1.0) * vSkyLightColor));
  total_light_2.xyz = (total_light_2.xyz + VertexLighting);
  tmpvar_3.xyz = min (total_light_2.xyz, 2.0);
  tmpvar_3.xyz = (tmpvar_3.xyz * vMaterialColor.xyz);
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (diffuse_texture, Tex0);
  tex_col_1.w = tmpvar_4.w;
  tex_col_1.xyz = pow (tmpvar_4.xyz, vec3(2.2, 2.2, 2.2));
  tmpvar_3.xyz = (tmpvar_3.xyz * tex_col_1.xyz);
  tmpvar_3.xyz = (tmpvar_3.xyz * VertexColor.xyz);
  tmpvar_3.xyz = pow (tmpvar_3.xyz, output_gamma_inv.xyz);
  tmpvar_3.xyz = mix (vFogColor.xyz, tmpvar_3.xyz, Fog);
  tmpvar_3.w = (VertexColor.w * tmpvar_4.w);
  gl_FragColor = tmpvar_3;
}

