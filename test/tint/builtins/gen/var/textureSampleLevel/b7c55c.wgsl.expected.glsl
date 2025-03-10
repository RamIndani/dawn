#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  vec4 inner;
} v;
uniform highp sampler2DArray arg_0_arg_1;
vec4 textureSampleLevel_b7c55c() {
  vec2 arg_2 = vec2(1.0f);
  int arg_3 = 1;
  float arg_4 = 1.0f;
  vec2 v_1 = arg_2;
  float v_2 = arg_4;
  vec3 v_3 = vec3(v_1, float(arg_3));
  vec4 res = textureLodOffset(arg_0_arg_1, v_3, float(v_2), ivec2(1));
  return res;
}
void main() {
  v.inner = textureSampleLevel_b7c55c();
}
#version 310 es

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  vec4 inner;
} v;
uniform highp sampler2DArray arg_0_arg_1;
vec4 textureSampleLevel_b7c55c() {
  vec2 arg_2 = vec2(1.0f);
  int arg_3 = 1;
  float arg_4 = 1.0f;
  vec2 v_1 = arg_2;
  float v_2 = arg_4;
  vec3 v_3 = vec3(v_1, float(arg_3));
  vec4 res = textureLodOffset(arg_0_arg_1, v_3, float(v_2), ivec2(1));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureSampleLevel_b7c55c();
}
#version 310 es


struct VertexOutput {
  vec4 pos;
  vec4 prevent_dce;
};

uniform highp sampler2DArray arg_0_arg_1;
layout(location = 0) flat out vec4 vertex_main_loc0_Output;
vec4 textureSampleLevel_b7c55c() {
  vec2 arg_2 = vec2(1.0f);
  int arg_3 = 1;
  float arg_4 = 1.0f;
  vec2 v = arg_2;
  float v_1 = arg_4;
  vec3 v_2 = vec3(v, float(arg_3));
  vec4 res = textureLodOffset(arg_0_arg_1, v_2, float(v_1), ivec2(1));
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f), vec4(0.0f));
  tint_symbol.pos = vec4(0.0f);
  tint_symbol.prevent_dce = textureSampleLevel_b7c55c();
  return tint_symbol;
}
void main() {
  VertexOutput v_3 = vertex_main_inner();
  gl_Position = v_3.pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  vertex_main_loc0_Output = v_3.prevent_dce;
  gl_PointSize = 1.0f;
}
