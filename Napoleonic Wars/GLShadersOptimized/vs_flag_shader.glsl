uniform vec4 vLightDiffuse[4];
uniform vec4 vMaterialColor;
uniform vec4 vSunDir;
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
attribute vec3 inTangent;
attribute vec3 inBinormal;
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
  vec3 tmpvar_9;
  vec3 tmpvar_10;
  vec4 tmpvar_11;
  vec3 tmpvar_12;
  vec4 nextPos_13;
  vec4 Position2_14;
  vec4 Position1_15;
  float sideval_16;
  nextPos_13.yzw = tmpvar_1.yzw;
  nextPos_13.x = (inPosition.x + 0.05);
  Position1_15 = nextPos_13;
  nextPos_13.x = tmpvar_1.x;
  nextPos_13.y = (inPosition.y - 0.05);
  Position2_14.xzw = nextPos_13.xzw;
  sideval_16 = -(inNormal.y);
  float tmpvar_17;
  tmpvar_17 = (time_var * 4.0);
  float tmpvar_18;
  tmpvar_18 = (inPosition.x * 0.15);
  vPosition_2.y = (inPosition.y + (sin(
    ((tmpvar_17 + inPosition.z) + (inPosition.y - inPosition.x))
  ) * tmpvar_18));
  Position1_15.y = (Position1_15.y + (sin(
    ((tmpvar_17 + Position1_15.z) + (Position1_15.y - Position1_15.x))
  ) * (Position1_15.x * 0.15)));
  Position2_14.y = (nextPos_13.y + (sin(
    ((tmpvar_17 + inPosition.z) + (nextPos_13.y - inPosition.x))
  ) * tmpvar_18));
  vec3 a_19;
  a_19 = (Position1_15.xyz - vPosition_2.xyz);
  vec3 b_20;
  b_20 = (Position2_14.xyz - vPosition_2.xyz);
  vNormal_3 = ((a_19.yzx * b_20.zxy) - (a_19.zxy * b_20.yzx));
  vNormal_3.y = (vNormal_3.y + 1.0);
  if ((sideval_16 > 0.0)) {
    vNormal_3 = -(vNormal_3);
  };
  vec4 tmpvar_21;
  tmpvar_21 = (matWorld * vPosition_2);
  vWorldPos_5 = tmpvar_21;
  vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = vNormal_3;
  vec3 tmpvar_23;
  tmpvar_23 = normalize((matWorld * tmpvar_22).xyz);
  if (bUseMotionBlur) {
    vec4 tmpvar_24;
    tmpvar_24 = (matMotionBlur * vPosition_2);
    vec4 tmpvar_25;
    tmpvar_25 = normalize((tmpvar_24 - tmpvar_21));
    float tmpvar_26;
    tmpvar_26 = dot (tmpvar_23, tmpvar_25.xyz);
    float tmpvar_27;
    if ((tmpvar_26 > 0.1)) {
      tmpvar_27 = 1.0;
    } else {
      tmpvar_27 = 0.0;
    };
    vWorldPos_5 = mix (tmpvar_21, tmpvar_24, (tmpvar_27 * clamp (
      (vPosition_2.y + 0.15)
    , 0.0, 1.0)));
    vVertexColor_4.w = ((clamp (
      (0.5 - vPosition_2.y)
    , 0.0, 1.0) + clamp (
      mix (1.1, -0.6999999, clamp ((dot (tmpvar_23, tmpvar_25.xyz) + 0.5), 0.0, 1.0))
    , 0.0, 1.0)) + 0.25);
  };
  if (bUseMotionBlur) {
    tmpvar_6 = (matViewProj * vWorldPos_5);
  } else {
    tmpvar_6 = (matWorldViewProj * vPosition_2);
  };
  vec4 tmpvar_28;
  tmpvar_28.w = 0.0;
  tmpvar_28.xyz = inBinormal;
  vec3 tmpvar_29;
  tmpvar_29 = normalize((matWorld * tmpvar_28).xyz);
  vec4 tmpvar_30;
  tmpvar_30.w = 0.0;
  tmpvar_30.xyz = inTangent;
  vec3 tmpvar_31;
  tmpvar_31 = normalize((matWorld * tmpvar_30).xyz);
  vec3 tmpvar_32;
  tmpvar_32.x = tmpvar_31.x;
  tmpvar_32.y = tmpvar_29.x;
  tmpvar_32.z = tmpvar_23.x;
  vec3 tmpvar_33;
  tmpvar_33.x = tmpvar_31.y;
  tmpvar_33.y = tmpvar_29.y;
  tmpvar_33.z = tmpvar_23.y;
  vec3 tmpvar_34;
  tmpvar_34.x = tmpvar_31.z;
  tmpvar_34.y = tmpvar_29.z;
  tmpvar_34.z = tmpvar_23.z;
  mat3 tmpvar_35;
  tmpvar_35[0] = tmpvar_32;
  tmpvar_35[1] = tmpvar_33;
  tmpvar_35[2] = tmpvar_34;
  tmpvar_9 = normalize((tmpvar_35 * -(vSunDir.xyz)));
  tmpvar_10 = (tmpvar_35 * vec3(0.0, 0.0, 1.0));
  tmpvar_7 = vVertexColor_4.zyxw;
  vec4 vWorldPos_36;
  vWorldPos_36 = vWorldPos_5;
  vec3 vWorldN_37;
  vWorldN_37 = tmpvar_23;
  vec4 total_39;
  total_39 = vec4(0.0, 0.0, 0.0, 0.0);
  for (int j_38 = 0; j_38 < iLightPointCount; j_38++) {
    if ((j_38 != 0)) {
      int tmpvar_40;
      tmpvar_40 = iLightIndices[j_38];
      vec3 tmpvar_41;
      tmpvar_41 = (vLightPosDir[tmpvar_40].xyz - vWorldPos_36.xyz);
      total_39 = (total_39 + ((
        clamp (dot (vWorldN_37, normalize(tmpvar_41)), 0.0, 1.0)
       * vLightDiffuse[tmpvar_40]) * (1.0/(
        dot (tmpvar_41, tmpvar_41)
      ))));
    };
  };
  tmpvar_8 = total_39.xyz;
  int tmpvar_42;
  tmpvar_42 = iLightIndices[0];
  vec3 tmpvar_43;
  tmpvar_43 = (vLightPosDir[tmpvar_42].xyz - vWorldPos_5.xyz);
  tmpvar_11.xyz = (tmpvar_35 * normalize(tmpvar_43));
  tmpvar_11.w = clamp ((1.0/(dot (tmpvar_43, tmpvar_43))), 0.0, 1.0);
  vec3 tmpvar_44;
  tmpvar_44 = normalize((vCameraPos.xyz - vWorldPos_5.xyz));
  tmpvar_12 = (tmpvar_35 * tmpvar_44);
  vec3 vWorldPos_45;
  vWorldPos_45 = vWorldPos_5.xyz;
  vec3 vWorldN_46;
  vWorldN_46 = tmpvar_23;
  vec3 vWorldView_47;
  vWorldView_47 = tmpvar_44;
  vec4 total_49;
  total_49 = vec4(0.0, 0.0, 0.0, 0.0);
  for (int i_48 = 0; i_48 < iLightPointCount; i_48++) {
    vec3 tmpvar_50;
    tmpvar_50 = (vLightPosDir[i_48].xyz - vWorldPos_45);
    total_49 = (total_49 + ((
      (1.0/(dot (tmpvar_50, tmpvar_50)))
     * vLightDiffuse[i_48]) * pow (
      clamp (dot (normalize((vWorldView_47 + 
        normalize(tmpvar_50)
      )), vWorldN_46), 0.0, 1.0)
    , fMaterialPower)));
  };
  tmpvar_7.w = (vVertexColor_4.w * vMaterialColor.w);
  vec3 tmpvar_51;
  tmpvar_51 = (matWorldView * vPosition_2).xyz;
  gl_Position = tmpvar_6;
  Fog = (1.0/(exp2((
    sqrt(dot (tmpvar_51, tmpvar_51))
   * fFogDensity))));
  VertexColor = tmpvar_7;
  VertexLighting = tmpvar_8;
  Tex0 = inTexCoord;
  SunLightDir = tmpvar_9;
  SkyLightDir = tmpvar_10;
  PointLightDir = tmpvar_11;
  ShadowTexCoord = total_49;
  ViewDir = tmpvar_12;
}

