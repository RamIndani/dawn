#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer tint_symbol_1_1_ssbo {
  uint tint_symbol;
} v;
layout(binding = 0, rgba16ui) uniform highp writeonly uimage2DArray arg_0;
uint textureNumLayers_014a3b() {
  uint res = uint(imageSize(arg_0).z);
  return res;
}
void main() {
  v.tint_symbol = textureNumLayers_014a3b();
}
#version 310 es

layout(binding = 0, std430)
buffer tint_symbol_1_1_ssbo {
  uint tint_symbol;
} v;
layout(binding = 0, rgba16ui) uniform highp writeonly uimage2DArray arg_0;
uint textureNumLayers_014a3b() {
  uint res = uint(imageSize(arg_0).z);
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.tint_symbol = textureNumLayers_014a3b();
}
