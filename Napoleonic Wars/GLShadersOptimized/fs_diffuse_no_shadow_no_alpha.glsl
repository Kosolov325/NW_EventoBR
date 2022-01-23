uniform sampler2D diffuse_texture;
uniform vec4 vFogColor;
uniform vec4 output_gamma_inv;
varying vec4 outColor0;
varying vec2 outTexCoord;
varying float outFog;
void main ()
{
  vec4 finalColor_1;
  vec4 tex_col_2;
  tex_col_2.xyz = texture2D (diffuse_texture, outTexCoord).xyz;
  tex_col_2.w = 1.0;
  tex_col_2.xyz = pow (tex_col_2.xyz, vec3(2.2, 2.2, 2.2));
  vec4 tmpvar_3;
  tmpvar_3 = (outColor0 * tex_col_2);
  finalColor_1.w = tmpvar_3.w;
  finalColor_1.xyz = pow (tmpvar_3.xyz, output_gamma_inv.xyz);
  finalColor_1.xyz = mix (vFogColor.xyz, finalColor_1.xyz, outFog);
  gl_FragColor = finalColor_1;
}

