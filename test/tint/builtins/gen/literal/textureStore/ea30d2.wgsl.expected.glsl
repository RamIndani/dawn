#version 460
precision highp float;
precision highp int;

layout(binding = 0, rg32i) uniform highp iimage2DArray arg_0;
void textureStore_ea30d2() {
  ivec2 v = ivec2(uvec2(1u));
  imageStore(arg_0, ivec3(v, int(1)), ivec4(1));
}
void main() {
  textureStore_ea30d2();
}
#version 460

layout(binding = 0, rg32i) uniform highp iimage2DArray arg_0;
void textureStore_ea30d2() {
  ivec2 v = ivec2(uvec2(1u));
  imageStore(arg_0, ivec3(v, int(1)), ivec4(1));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  textureStore_ea30d2();
}
