uniform vec4 vLightDiffuse[4];
uniform vec4 vMaterialColor;
uniform float fMaterialPower;
uniform float fFogDensity;
uniform int iLightPointCount;
uniform int iLightIndices[4];
uniform bool bUseMotionBlur;
uniform float time_var;
uniform mat4 matWorldViewProj;
uniform mat4 matWorldView;
uniform mat4 matWorld;
uniform mat4 matMotionBlur;
uniform mat4 matViewProj;
uniform vec4 vLightPosDir[4];
uniform vec4 vCameraPos;
attribute vec3 inPosition;
attribute vec3 inNormal;
attribute vec4 inColor0;
attribute vec2 inTexCoord;
varying float Fog;
varying vec4 VertexColor;
varying vec3 VertexLighting;
varying vec2 Tex0;
varying vec3 SunLightDir;
varying vec3 SkyLightDir;
varying vec4 PointLightDir;
varying vec4 ShadowTexCoord;
varying vec3 ViewDir;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = inPosition;
  vec4 vPosition_2;
  vPosition_2.yzw = tmpvar_1.yzw;
  vec3 vNormal_3;
  vec4 vVertexColor_4;
  vVertexColor_4 = inColor0;
  vec4 vWorldPos_5;
  vec4 tmpvar_6;
  vec4 tmpvar_7;
  vec3 tmpvar_8;
  vec4 tmpvar_9;
  vec4 tmpvar_10;
  vec4 nextPos_11;
  vec4 Position2_12;
  vec4 Position1_13;
  float sideval_14;
  nextPos_11.yzw = tmpvar_1.yzw;
  nextPos_11.x = (inPosition.x + 0.05);
  Position1_13 = nextPos_11;
  nextPos_11.x = tmpvar_1.x;
  nextPos_11.y = (inPosition.y - 0.05);
  Position2_12.yzw = nextPos_11.yzw;
  sideval_14 = -(inNormal.x);
  float tmpvar_15;
  tmpvar_15 = (time_var * 8.0);
  vPosition_2.x = (inPosition.x + (sin(
    ((tmpvar_15 + inPosition.z) + (inPosition.y - inPosition.x))
  ) * (inPosition.y * 0.3)));
  Position1_13.x = (Position1_13.x + (sin(
    ((tmpvar_15 + Position1_13.z) + (Position1_13.y - Position1_13.x))
  ) * (Position1_13.y * 0.3)));
  Position2_12.x = (inPosition.x + (sin(
    ((tmpvar_15 + inPosition.z) + (nextPos_11.y - inPosition.x))
  ) * (nextPos_11.y * 0.3)));
  vec3 a_16;
  a_16 = (Position1_13.xyz - vPosition_2.xyz);
  vec3 b_17;
  b_17 = (Position2_12.xyz - vPosition_2.xyz);
  vNormal_3 = ((a_16.yzx * b_17.zxy) - (a_16.zxy * b_17.yzx));
  vNormal_3.x = (vNormal_3.x + 1.0);
  if ((sideval_14 > 0.0)) {
    vNormal_3 = -(vNormal_3);
  };
  vec4 tmpvar_18;
  tmpvar_18 = (matWorld * vPosition_2);
  vWorldPos_5 = tmpvar_18;
  vec4 tmpvar_19;
  tmpvar_19.w = 0.0;
  tmpvar_19.xyz = vNormal_3;
  vec3 tmpvar_20;
  tmpvar_20 = normalize((matWorld * tmpvar_19).xyz);
  if (bUseMotionBlur) {
    vec4 tmpvar_21;
    tmpvar_21 = (matMotionBlur * vPosition_2);
    vec4 tmpvar_22;
    tmpvar_22 = normalize((tmpvar_21 - tmpvar_18));
    float tmpvar_23;
    tmpvar_23 = dot (tmpvar_20, tmpvar_22.xyz);
    float tmpvar_24;
    if ((tmpvar_23 > 0.1)) {
      tmpvar_24 = 1.0;
    } else {
      tmpvar_24 = 0.0;
    };
    vWorldPos_5 = mix (tmpvar_18, tmpvar_21, (tmpvar_24 * clamp (
      (inPosition.y + 0.15)
    , 0.0, 1.0)));
    vVertexColor_4.w = ((clamp (
      (0.5 - inPosition.y)
    , 0.0, 1.0) + clamp (
      mix (1.1, -0.6999999, clamp ((dot (tmpvar_20, tmpvar_22.xyz) + 0.5), 0.0, 1.0))
    , 0.0, 1.0)) + 0.25);
  };
  if (bUseMotionBlur) {
    tmpvar_6 = (matViewProj * vWorldPos_5);
  } else {
    tmpvar_6 = (matWorldViewProj * vPosition_2);
  };
  tmpvar_7 = vVertexColor_4.zyxw;
  vec4 vWorldPos_25;
  vWorldPos_25 = vWorldPos_5;
  vec3 vWorldN_26;
  vWorldN_26 = tmpvar_20;
  vec4 total_28;
  total_28 = vec4(0.0, 0.0, 0.0, 0.0);
  for (int j_27 = 0; j_27 < iLightPointCount; j_27++) {
    int tmpvar_29;
    tmpvar_29 = iLightIndices[j_27];
    vec3 tmpvar_30;
    tmpvar_30 = (vLightPosDir[tmpvar_29].xyz - vWorldPos_25.xyz);
    total_28 = (total_28 + ((
      clamp (dot (vWorldN_26, normalize(tmpvar_30)), 0.0, 1.0)
     * vLightDiffuse[tmpvar_29]) * (1.0/(
      dot (tmpvar_30, tmpvar_30)
    ))));
  };
  tmpvar_8 = total_28.xyz;
  vec3 tmpvar_31;
  tmpvar_31 = normalize((vCameraPos.xyz - vWorldPos_5.xyz));
  vec3 vWorldPos_32;
  vWorldPos_32 = vWorldPos_5.xyz;
  vec3 vWorldN_33;
  vWorldN_33 = tmpvar_20;
  vec3 vWorldView_34;
  vWorldView_34 = tmpvar_31;
  vec4 total_36;
  total_36 = vec4(0.0, 0.0, 0.0, 0.0);
  for (int i_35 = 0; i_35 < iLightPointCount; i_35++) {
    vec3 tmpvar_37;
    tmpvar_37 = (vLightPosDir[i_35].xyz - vWorldPos_32);
    total_36 = (total_36 + ((
      (1.0/(dot (tmpvar_37, tmpvar_37)))
     * vLightDiffuse[i_35]) * pow (
      clamp (dot (normalize((vWorldView_34 + 
        normalize(tmpvar_37)
      )), vWorldN_33), 0.0, 1.0)
    , fMaterialPower)));
  };
  tmpvar_7.w = (vVertexColor_4.w * vMaterialColor.w);
  vec3 tmpvar_38;
  tmpvar_38 = (matWorldView * vPosition_2).xyz;
  gl_Position = tmpvar_6;
  Fog = (1.0/(exp2((
    sqrt(dot (tmpvar_38, tmpvar_38))
   * fFogDensity))));
  VertexColor = tmpvar_7;
  VertexLighting = tmpvar_8;
  Tex0 = inTexCoord;
  SunLightDir = tmpvar_20;
  SkyLightDir = total_36.xyz;
  PointLightDir = tmpvar_9;
  ShadowTexCoord = tmpvar_10;
  ViewDir = tmpvar_31;
}

