#version 460
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  ivec4 inner;
} v;
layout(binding = 0, rg32i) uniform highp iimage2D arg_0;
ivec4 textureLoad_2eaf31() {
  uvec2 arg_1 = uvec2(1u);
  uvec2 v_1 = arg_1;
  ivec4 res = imageLoad(arg_0, ivec2(min(v_1, (uvec2(imageSize(arg_0)) - uvec2(1u)))));
  return res;
}
void main() {
  v.inner = textureLoad_2eaf31();
}
#version 460

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  ivec4 inner;
} v;
layout(binding = 0, rg32i) uniform highp iimage2D arg_0;
ivec4 textureLoad_2eaf31() {
  uvec2 arg_1 = uvec2(1u);
  uvec2 v_1 = arg_1;
  ivec4 res = imageLoad(arg_0, ivec2(min(v_1, (uvec2(imageSize(arg_0)) - uvec2(1u)))));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_2eaf31();
}
