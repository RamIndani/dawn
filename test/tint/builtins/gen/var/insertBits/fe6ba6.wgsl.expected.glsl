#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  ivec2 inner;
} v;
ivec2 insertBits_fe6ba6() {
  ivec2 arg_0 = ivec2(1);
  ivec2 arg_1 = ivec2(1);
  uint arg_2 = 1u;
  uint arg_3 = 1u;
  ivec2 v_1 = arg_0;
  ivec2 v_2 = arg_1;
  uint v_3 = min(arg_2, 32u);
  uint v_4 = min(arg_3, (32u - v_3));
  int v_5 = int(v_3);
  ivec2 res = bitfieldInsert(v_1, v_2, v_5, int(v_4));
  return res;
}
void main() {
  v.inner = insertBits_fe6ba6();
}
#version 310 es

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  ivec2 inner;
} v;
ivec2 insertBits_fe6ba6() {
  ivec2 arg_0 = ivec2(1);
  ivec2 arg_1 = ivec2(1);
  uint arg_2 = 1u;
  uint arg_3 = 1u;
  ivec2 v_1 = arg_0;
  ivec2 v_2 = arg_1;
  uint v_3 = min(arg_2, 32u);
  uint v_4 = min(arg_3, (32u - v_3));
  int v_5 = int(v_3);
  ivec2 res = bitfieldInsert(v_1, v_2, v_5, int(v_4));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = insertBits_fe6ba6();
}
#version 310 es


struct VertexOutput {
  vec4 pos;
  ivec2 prevent_dce;
};

layout(location = 0) flat out ivec2 vertex_main_loc0_Output;
ivec2 insertBits_fe6ba6() {
  ivec2 arg_0 = ivec2(1);
  ivec2 arg_1 = ivec2(1);
  uint arg_2 = 1u;
  uint arg_3 = 1u;
  ivec2 v = arg_0;
  ivec2 v_1 = arg_1;
  uint v_2 = min(arg_2, 32u);
  uint v_3 = min(arg_3, (32u - v_2));
  int v_4 = int(v_2);
  ivec2 res = bitfieldInsert(v, v_1, v_4, int(v_3));
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f), ivec2(0));
  tint_symbol.pos = vec4(0.0f);
  tint_symbol.prevent_dce = insertBits_fe6ba6();
  return tint_symbol;
}
void main() {
  VertexOutput v_5 = vertex_main_inner();
  gl_Position = v_5.pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  vertex_main_loc0_Output = v_5.prevent_dce;
  gl_PointSize = 1.0f;
}
