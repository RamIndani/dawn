#version 460
#extension GL_EXT_texture_shadow_lod: require
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  float inner;
} v;
uniform highp samplerCubeShadow arg_0_arg_1;
float textureSampleLevel_ae92a2() {
  vec3 arg_2 = vec3(1.0f);
  uint arg_3 = 1u;
  uint v_1 = arg_3;
  vec4 v_2 = vec4(arg_2, 0.0f);
  float res = textureLod(arg_0_arg_1, v_2, float(v_1));
  return res;
}
void main() {
  v.inner = textureSampleLevel_ae92a2();
}
#version 460
#extension GL_EXT_texture_shadow_lod: require

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  float inner;
} v;
uniform highp samplerCubeShadow arg_0_arg_1;
float textureSampleLevel_ae92a2() {
  vec3 arg_2 = vec3(1.0f);
  uint arg_3 = 1u;
  uint v_1 = arg_3;
  vec4 v_2 = vec4(arg_2, 0.0f);
  float res = textureLod(arg_0_arg_1, v_2, float(v_1));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureSampleLevel_ae92a2();
}
#version 460
#extension GL_EXT_texture_shadow_lod: require


struct VertexOutput {
  vec4 pos;
  float prevent_dce;
};

uniform highp samplerCubeShadow arg_0_arg_1;
layout(location = 0) flat out float vertex_main_loc0_Output;
float textureSampleLevel_ae92a2() {
  vec3 arg_2 = vec3(1.0f);
  uint arg_3 = 1u;
  uint v = arg_3;
  vec4 v_1 = vec4(arg_2, 0.0f);
  float res = textureLod(arg_0_arg_1, v_1, float(v));
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f), 0.0f);
  tint_symbol.pos = vec4(0.0f);
  tint_symbol.prevent_dce = textureSampleLevel_ae92a2();
  return tint_symbol;
}
void main() {
  VertexOutput v_2 = vertex_main_inner();
  gl_Position = v_2.pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  vertex_main_loc0_Output = v_2.prevent_dce;
  gl_PointSize = 1.0f;
}
