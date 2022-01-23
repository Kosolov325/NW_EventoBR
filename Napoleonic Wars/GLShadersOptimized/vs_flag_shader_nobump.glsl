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
  vPosition_2.xzw = tmpvar_1.xzw;
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
  Position2_12.xzw = nextPos_11.xzw;
  sideval_14 = -(inNormal.y);
  float tmpvar_15;
  tmpvar_15 = (time_var * 4.0);
  float tmpvar_16;
  tmpvar_16 = (inPosition.x * 0.15);
  vPosition_2.y = (inPosition.y + (sin(
    ((tmpvar_15 + inPosition.z) + (inPosition.y - inPosition.x))
  ) * tmpvar_16));
  Position1_13.y = (Position1_13.y + (sin(
    ((tmpvar_15 + Position1_13.z) + (Position1_13.y - Position1_13.x))
  ) * (Position1_13.x * 0.15)));
  Position2_12.y = (nextPos_11.y + (sin(
    ((tmpvar_15 + inPosition.z) + (nextPos_11.y - inPosition.x))
  ) * tmpvar_16));
  vec3 a_17;
  a_17 = (Position1_13.xyz - vPosition_2.xyz);
  vec3 b_18;
  b_18 = (Position2_12.xyz - vPosition_2.xyz);
  vNormal_3 = ((a_17.yzx * b_18.zxy) - (a_17.zxy * b_18.yzx));
  vNormal_3.y = (vNormal_3.y + 1.0);
  if ((sideval_14 > 0.0)) {
    vNormal_3 = -(vNormal_3);
  };
  vec4 tmpvar_19;
  tmpvar_19 = (matWorld * vPosition_2);
  vWorldPos_5 = tmpvar_19;
  vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = vNormal_3;
  vec3 tmpvar_21;
  tmpvar_21 = normalize((matWorld * tmpvar_20).xyz);
  if (bUseMotionBlur) {
    vec4 tmpvar_22;
    tmpvar_22 = (matMotionBlur * vPosition_2);
    vec4 tmpvar_23;
    tmpvar_23 = normalize((tmpvar_22 - tmpvar_19));
    float tmpvar_24;
    tmpvar_24 = dot (tmpvar_21, tmpvar_23.xyz);
    float tmpvar_25;
    if ((tmpvar_24 > 0.1)) {
      tmpvar_25 = 1.0;
    } else {
      tmpvar_25 = 0.0;
    };
    vWorldPos_5 = mix (tmpvar_19, tmpvar_22, (tmpvar_25 * clamp (
      (vPosition_2.y + 0.15)
    , 0.0, 1.0)));
    vVertexColor_4.w = ((clamp (
      (0.5 - vPosition_2.y)
    , 0.0, 1.0) + clamp (
      mix (1.1, -0.6999999, clamp ((dot (tmpvar_21, tmpvar_23.xyz) + 0.5), 0.0, 1.0))
    , 0.0, 1.0)) + 0.25);
  };
  if (bUseMotionBlur) {
    tmpvar_6 = (matViewProj * vWorldPos_5);
  } else {
    tmpvar_6 = (matWorldViewProj * vPosition_2);
  };
  tmpvar_7 = vVertexColor_4.zyxw;
  vec4 vWorldPos_26;
  vWorldPos_26 = vWorldPos_5;
  vec3 vWorldN_27;
  vWorldN_27 = tmpvar_21;
  vec4 total_29;
  total_29 = vec4(0.0, 0.0, 0.0, 0.0);
  for (int j_28 = 0; j_28 < iLightPointCount; j_28++) {
    int tmpvar_30;
    tmpvar_30 = iLightIndices[j_28];
    vec3 tmpvar_31;
    tmpvar_31 = (vLightPosDir[tmpvar_30].xyz - vWorldPos_26.xyz);
    total_29 = (total_29 + ((
      clamp (dot (vWorldN_27, normalize(tmpvar_31)), 0.0, 1.0)
     * vLightDiffuse[tmpvar_30]) * (1.0/(
      dot (tmpvar_31, tmpvar_31)
    ))));
  };
  tmpvar_8 = total_29.xyz;
  vec3 tmpvar_32;
  tmpvar_32 = normalize((vCameraPos.xyz - vWorldPos_5.xyz));
  vec3 vWorldPos_33;
  vWorldPos_33 = vWorldPos_5.xyz;
  vec3 vWorldN_34;
  vWorldN_34 = tmpvar_21;
  vec3 vWorldView_35;
  vWorldView_35 = tmpvar_32;
  vec4 total_37;
  total_37 = vec4(0.0, 0.0, 0.0, 0.0);
  for (int i_36 = 0; i_36 < iLightPointCount; i_36++) {
    vec3 tmpvar_38;
    tmpvar_38 = (vLightPosDir[i_36].xyz - vWorldPos_33);
    total_37 = (total_37 + ((
      (1.0/(dot (tmpvar_38, tmpvar_38)))
     * vLightDiffuse[i_36]) * pow (
      clamp (dot (normalize((vWorldView_35 + 
        normalize(tmpvar_38)
      )), vWorldN_34), 0.0, 1.0)
    , fMaterialPower)));
  };
  tmpvar_7.w = (vVertexColor_4.w * vMaterialColor.w);
  vec3 tmpvar_39;
  tmpvar_39 = (matWorldView * vPosition_2).xyz;
  gl_Position = tmpvar_6;
  Fog = (1.0/(exp2((
    sqrt(dot (tmpvar_39, tmpvar_39))
   * fFogDensity))));
  VertexColor = tmpvar_7;
  VertexLighting = tmpvar_8;
  Tex0 = inTexCoord;
  SunLightDir = tmpvar_21;
  SkyLightDir = total_37.xyz;
  PointLightDir = tmpvar_9;
  ShadowTexCoord = tmpvar_10;
  ViewDir = tmpvar_32;
}

