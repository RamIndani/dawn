#version 460

layout(binding = 0, rg32f) uniform highp writeonly image2D arg_0;
void textureStore_51ec82() {
  imageStore(arg_0, ivec2(1, 0), vec4(1.0f));
}

void fragment_main() {
  textureStore_51ec82();
}

void main() {
  fragment_main();
  return;
}
#version 460

layout(binding = 0, rg32f) uniform highp writeonly image2D arg_0;
void textureStore_51ec82() {
  imageStore(arg_0, ivec2(1, 0), vec4(1.0f));
}

void compute_main() {
  textureStore_51ec82();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
