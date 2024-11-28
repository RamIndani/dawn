#version 310 es


struct TintTextureUniformData {
  uint tint_builtin_value_0;
};

layout(binding = 1, std430)
buffer Result_1_ssbo {
  float values[];
} result;
layout(binding = 0, std140)
uniform tint_symbol_1_1_ubo {
  TintTextureUniformData inner;
} v;
uniform highp sampler2D tex;
void tint_symbol_inner(uvec3 GlobalInvocationId) {
  uint v_1 = min(((GlobalInvocationId[1u] * 128u) + GlobalInvocationId[0u]), (uint(result.values.length()) - 1u));
  int v_2 = int(GlobalInvocationId[0u]);
  ivec2 v_3 = ivec2(v_2, int(GlobalInvocationId[1u]));
  uint v_4 = (v.inner.tint_builtin_value_0 - 1u);
  uint v_5 = min(uint(0), v_4);
  uvec2 v_6 = (uvec2(textureSize(tex, int(v_5))) - uvec2(1u));
  ivec2 v_7 = ivec2(min(uvec2(v_3), v_6));
  result.values[v_1] = texelFetch(tex, v_7, int(v_5)).x;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  tint_symbol_inner(gl_GlobalInvocationID);
}
