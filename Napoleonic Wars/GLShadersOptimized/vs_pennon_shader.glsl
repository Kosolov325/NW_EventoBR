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
  vPosition_2.xyw = tmpvar_1.xyw;
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
  nextPos_13.yzw = tmpvar_1.yzw;
  nextPos_13.x = (inPosition.x + 0.05);
  Position1_15 = nextPos_13;
  nextPos_13.x = tmpvar_1.x;
  nextPos_13.y = (inPosition.y - 0.05);
  Position2_14.xyw = nextPos_13.xyw;
  float tmpvar_16;
  tmpvar_16 = (time_var * 9.0);
  float tmpvar_17;
  tmpvar_17 = (inPosition.x * 0.33);
  vPosition_2.z = (inPosition.z + (sin(
    ((tmpvar_16 + inPosition.z) + (inPosition.y - inPosition.x))
  ) * tmpvar_17));
  Position1_15.z = (Position1_15.z + (sin(
    ((tmpvar_16 + Position1_15.z) + (Position1_15.y - Position1_15.x))
  ) * (Position1_15.x * 0.33)));
  Position2_14.z = (inPosition.z + (sin(
    ((tmpvar_16 + inPosition.z) + (nextPos_13.y - inPosition.x))
  ) * tmpvar_17));
  vec3 a_18;
  a_18 = (Position1_15.xyz - vPosition_2.xyz);
  vec3 b_19;
  b_19 = (Position2_14.xyz - vPosition_2.xyz);
  vNormal_3 = ((a_18.yzx * b_19.zxy) - (a_18.zxy * b_19.yzx));
  if ((inNormal.z > 0.0)) {
    vNormal_3 = -(vNormal_3);
  };
  vec4 tmpvar_20;
  tmpvar_20 = (matWorld * vPosition_2);
  vWorldPos_5 = tmpvar_20;
  vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = vNormal_3;
  vec3 tmpvar_22;
  tmpvar_22 = normalize((matWorld * tmpvar_21).xyz);
  if (bUseMotionBlur) {
    vec4 tmpvar_23;
    tmpvar_23 = (matMotionBlur * vPosition_2);
    vec4 tmpvar_24;
    tmpvar_24 = normalize((tmpvar_23 - tmpvar_20));
    float tmpvar_25;
    tmpvar_25 = dot (tmpvar_22, tmpvar_24.xyz);
    float tmpvar_26;
    if ((tmpvar_25 > 0.1)) {
      tmpvar_26 = 1.0;
    } else {
      tmpvar_26 = 0.0;
    };
    vWorldPos_5 = mix (tmpvar_20, tmpvar_23, (tmpvar_26 * clamp (
      (inPosition.y + 0.15)
    , 0.0, 1.0)));
    vVertexColor_4.w = ((clamp (
      (0.5 - inPosition.y)
    , 0.0, 1.0) + clamp (
      mix (1.1, -0.6999999, clamp ((dot (tmpvar_22, tmpvar_24.xyz) + 0.5), 0.0, 1.0))
    , 0.0, 1.0)) + 0.25);
  };
  if (bUseMotionBlur) {
    tmpvar_6 = (matViewProj * vWorldPos_5);
  } else {
    tmpvar_6 = (matWorldViewProj * vPosition_2);
  };
  vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = inBinormal;
  vec3 tmpvar_28;
  tmpvar_28 = normalize((matWorld * tmpvar_27).xyz);
  vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = inTangent;
  vec3 tmpvar_30;
  tmpvar_30 = normalize((matWorld * tmpvar_29).xyz);
  vec3 tmpvar_31;
  tmpvar_31.x = tmpvar_30.x;
  tmpvar_31.y = tmpvar_28.x;
  tmpvar_31.z = tmpvar_22.x;
  vec3 tmpvar_32;
  tmpvar_32.x = tmpvar_30.y;
  tmpvar_32.y = tmpvar_28.y;
  tmpvar_32.z = tmpvar_22.y;
  vec3 tmpvar_33;
  tmpvar_33.x = tmpvar_30.z;
  tmpvar_33.y = tmpvar_28.z;
  tmpvar_33.z = tmpvar_22.z;
  mat3 tmpvar_34;
  tmpvar_34[0] = tmpvar_31;
  tmpvar_34[1] = tmpvar_32;
  tmpvar_34[2] = tmpvar_33;
  tmpvar_9 = normalize((tmpvar_34 * -(vSunDir.xyz)));
  tmpvar_10 = (tmpvar_34 * vec3(0.0, 0.0, 1.0));
  tmpvar_7 = vVertexColor_4.zyxw;
  vec4 vWorldPos_35;
  vWorldPos_35 = vWorldPos_5;
  vec3 vWorldN_36;
  vWorldN_36 = tmpvar_22;
  vec4 total_38;
  total_38 = vec4(0.0, 0.0, 0.0, 0.0);
  for (int j_37 = 0; j_37 < iLightPointCount; j_37++) {
    if ((j_37 != 0)) {
      int tmpvar_39;
      tmpvar_39 = iLightIndices[j_37];
      vec3 tmpvar_40;
      tmpvar_40 = (vLightPosDir[tmpvar_39].xyz - vWorldPos_35.xyz);
      total_38 = (total_38 + ((
        clamp (dot (vWorldN_36, normalize(tmpvar_40)), 0.0, 1.0)
       * vLightDiffuse[tmpvar_39]) * (1.0/(
        dot (tmpvar_40, tmpvar_40)
      ))));
    };
  };
  tmpvar_8 = total_38.xyz;
  int tmpvar_41;
  tmpvar_41 = iLightIndices[0];
  vec3 tmpvar_42;
  tmpvar_42 = (vLightPosDir[tmpvar_41].xyz - vWorldPos_5.xyz);
  tmpvar_11.xyz = (tmpvar_34 * normalize(tmpvar_42));
  tmpvar_11.w = clamp ((1.0/(dot (tmpvar_42, tmpvar_42))), 0.0, 1.0);
  vec3 tmpvar_43;
  tmpvar_43 = normalize((vCameraPos.xyz - vWorldPos_5.xyz));
  tmpvar_12 = (tmpvar_34 * tmpvar_43);
  vec3 vWorldPos_44;
  vWorldPos_44 = vWorldPos_5.xyz;
  vec3 vWorldN_45;
  vWorldN_45 = tmpvar_22;
  vec3 vWorldView_46;
  vWorldView_46 = tmpvar_43;
  vec4 total_48;
  total_48 = vec4(0.0, 0.0, 0.0, 0.0);
  for (int i_47 = 0; i_47 < iLightPointCount; i_47++) {
    vec3 tmpvar_49;
    tmpvar_49 = (vLightPosDir[i_47].xyz - vWorldPos_44);
    total_48 = (total_48 + ((
      (1.0/(dot (tmpvar_49, tmpvar_49)))
     * vLightDiffuse[i_47]) * pow (
      clamp (dot (normalize((vWorldView_46 + 
        normalize(tmpvar_49)
      )), vWorldN_45), 0.0, 1.0)
    , fMaterialPower)));
  };
  tmpvar_7.w = (vVertexColor_4.w * vMaterialColor.w);
  vec3 tmpvar_50;
  tmpvar_50 = (matWorldView * vPosition_2).xyz;
  gl_Position = tmpvar_6;
  Fog = (1.0/(exp2((
    sqrt(dot (tmpvar_50, tmpvar_50))
   * fFogDensity))));
  VertexColor = tmpvar_7;
  VertexLighting = tmpvar_8;
  Tex0 = inTexCoord;
  SunLightDir = tmpvar_9;
  SkyLightDir = tmpvar_10;
  PointLightDir = tmpvar_11;
  ShadowTexCoord = total_48;
  ViewDir = tmpvar_12;
}

