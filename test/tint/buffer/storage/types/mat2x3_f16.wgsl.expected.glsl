#version 310 es
#extension GL_AMD_gpu_shader_half_float: require

layout(binding = 0, std430)
buffer tint_symbol_block_1_ssbo {
  f16mat2x3 inner;
} v;
layout(binding = 1, std430)
buffer tint_symbol_1_block_1_ssbo {
  f16mat2x3 inner;
} v_1;
void tint_store_and_preserve_padding(f16mat2x3 value_param) {
  v_1.inner[0u] = value_param[0u];
  v_1.inner[1u] = value_param[1u];
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  tint_store_and_preserve_padding(v.inner);
}
