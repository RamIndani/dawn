#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  vec4 inner;
} v;
layout(binding = 0, rgba8) uniform highp readonly image2DArray arg_0;
vec4 textureLoad_8a291b() {
  ivec2 arg_1 = ivec2(1);
  uint arg_2 = 1u;
  ivec2 v_1 = arg_1;
  uint v_2 = arg_2;
  uint v_3 = min(v_2, (uint(imageSize(arg_0).z) - 1u));
  uvec2 v_4 = (uvec2(imageSize(arg_0).xy) - uvec2(1u));
  ivec2 v_5 = ivec2(min(uvec2(v_1), v_4));
  vec4 res = imageLoad(arg_0, ivec3(v_5, int(v_3))).zyxw;
  return res;
}
void main() {
  v.inner = textureLoad_8a291b();
}
#version 310 es

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  vec4 inner;
} v;
layout(binding = 0, rgba8) uniform highp readonly image2DArray arg_0;
vec4 textureLoad_8a291b() {
  ivec2 arg_1 = ivec2(1);
  uint arg_2 = 1u;
  ivec2 v_1 = arg_1;
  uint v_2 = arg_2;
  uint v_3 = min(v_2, (uint(imageSize(arg_0).z) - 1u));
  uvec2 v_4 = (uvec2(imageSize(arg_0).xy) - uvec2(1u));
  ivec2 v_5 = ivec2(min(uvec2(v_1), v_4));
  vec4 res = imageLoad(arg_0, ivec3(v_5, int(v_3))).zyxw;
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_8a291b();
}
#version 310 es


struct VertexOutput {
  vec4 pos;
  vec4 prevent_dce;
};

layout(binding = 0, rgba8) uniform highp readonly image2DArray arg_0;
layout(location = 0) flat out vec4 vertex_main_loc0_Output;
vec4 textureLoad_8a291b() {
  ivec2 arg_1 = ivec2(1);
  uint arg_2 = 1u;
  ivec2 v = arg_1;
  uint v_1 = arg_2;
  uint v_2 = min(v_1, (uint(imageSize(arg_0).z) - 1u));
  uvec2 v_3 = (uvec2(imageSize(arg_0).xy) - uvec2(1u));
  ivec2 v_4 = ivec2(min(uvec2(v), v_3));
  vec4 res = imageLoad(arg_0, ivec3(v_4, int(v_2))).zyxw;
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f), vec4(0.0f));
  tint_symbol.pos = vec4(0.0f);
  tint_symbol.prevent_dce = textureLoad_8a291b();
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
