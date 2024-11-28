#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  uvec4 inner;
} v;
layout(binding = 0, r32ui) uniform highp uimage2DArray arg_0;
uvec4 textureLoad_c2d09a() {
  uvec2 arg_1 = uvec2(1u);
  int arg_2 = 1;
  uvec2 v_1 = arg_1;
  int v_2 = arg_2;
  uint v_3 = (uint(imageSize(arg_0).z) - 1u);
  uint v_4 = min(uint(v_2), v_3);
  ivec2 v_5 = ivec2(min(v_1, (uvec2(imageSize(arg_0).xy) - uvec2(1u))));
  uvec4 res = imageLoad(arg_0, ivec3(v_5, int(v_4)));
  return res;
}
void main() {
  v.inner = textureLoad_c2d09a();
}
#version 310 es

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  uvec4 inner;
} v;
layout(binding = 0, r32ui) uniform highp uimage2DArray arg_0;
uvec4 textureLoad_c2d09a() {
  uvec2 arg_1 = uvec2(1u);
  int arg_2 = 1;
  uvec2 v_1 = arg_1;
  int v_2 = arg_2;
  uint v_3 = (uint(imageSize(arg_0).z) - 1u);
  uint v_4 = min(uint(v_2), v_3);
  ivec2 v_5 = ivec2(min(v_1, (uvec2(imageSize(arg_0).xy) - uvec2(1u))));
  uvec4 res = imageLoad(arg_0, ivec3(v_5, int(v_4)));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_c2d09a();
}
