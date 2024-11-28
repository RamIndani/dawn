#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  ivec4 inner;
} v;
layout(binding = 0, rgba8i) uniform highp readonly iimage2D arg_0;
ivec4 textureLoad_c9cc40() {
  int arg_1 = 1;
  int v_1 = arg_1;
  uint v_2 = (uvec2(imageSize(arg_0)).x - 1u);
  ivec4 res = imageLoad(arg_0, ivec2(uvec2(min(uint(v_1), v_2), 0u)));
  return res;
}
void main() {
  v.inner = textureLoad_c9cc40();
}
#version 310 es

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  ivec4 inner;
} v;
layout(binding = 0, rgba8i) uniform highp readonly iimage2D arg_0;
ivec4 textureLoad_c9cc40() {
  int arg_1 = 1;
  int v_1 = arg_1;
  uint v_2 = (uvec2(imageSize(arg_0)).x - 1u);
  ivec4 res = imageLoad(arg_0, ivec2(uvec2(min(uint(v_1), v_2), 0u)));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_c9cc40();
}
#version 310 es


struct VertexOutput {
  vec4 pos;
  ivec4 prevent_dce;
};

layout(binding = 0, rgba8i) uniform highp readonly iimage2D arg_0;
layout(location = 0) flat out ivec4 vertex_main_loc0_Output;
ivec4 textureLoad_c9cc40() {
  int arg_1 = 1;
  int v = arg_1;
  uint v_1 = (uvec2(imageSize(arg_0)).x - 1u);
  ivec4 res = imageLoad(arg_0, ivec2(uvec2(min(uint(v), v_1), 0u)));
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f), ivec4(0));
  tint_symbol.pos = vec4(0.0f);
  tint_symbol.prevent_dce = textureLoad_c9cc40();
  return tint_symbol;
}
void main() {
  VertexOutput v_2 = vertex_main_inner();
  gl_Position = v_2.pos;
  gl_Position[1u] = -(gl_Position.y);
  gl_Position[2u] = ((2.0f * gl_Position.z) - gl_Position.w);
  vertex_main_loc0_Output = v_2.prevent_dce;
  gl_PointSize = 1.0f;
}
