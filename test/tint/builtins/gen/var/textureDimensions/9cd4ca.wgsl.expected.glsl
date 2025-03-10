#version 310 es
precision highp float;
precision highp int;


struct TintTextureUniformData {
  uint tint_builtin_value_0;
};

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  uvec2 inner;
} v;
layout(binding = 0, std140)
uniform tint_symbol_1_1_ubo {
  TintTextureUniformData inner;
} v_1;
uniform highp usamplerCube arg_0;
uvec2 textureDimensions_9cd4ca() {
  int arg_1 = 1;
  uint v_2 = (v_1.inner.tint_builtin_value_0 - 1u);
  uvec2 res = uvec2(textureSize(arg_0, int(min(uint(arg_1), v_2))));
  return res;
}
void main() {
  v.inner = textureDimensions_9cd4ca();
}
#version 310 es


struct TintTextureUniformData {
  uint tint_builtin_value_0;
};

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  uvec2 inner;
} v;
layout(binding = 0, std140)
uniform tint_symbol_1_1_ubo {
  TintTextureUniformData inner;
} v_1;
uniform highp usamplerCube arg_0;
uvec2 textureDimensions_9cd4ca() {
  int arg_1 = 1;
  uint v_2 = (v_1.inner.tint_builtin_value_0 - 1u);
  uvec2 res = uvec2(textureSize(arg_0, int(min(uint(arg_1), v_2))));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureDimensions_9cd4ca();
}
#version 310 es


struct TintTextureUniformData {
  uint tint_builtin_value_0;
};

struct VertexOutput {
  vec4 pos;
  uvec2 prevent_dce;
};

layout(binding = 0, std140)
uniform tint_symbol_1_1_ubo {
  TintTextureUniformData inner;
} v;
uniform highp usamplerCube arg_0;
layout(location = 0) flat out uvec2 vertex_main_loc0_Output;
uvec2 textureDimensions_9cd4ca() {
  int arg_1 = 1;
  uint v_1 = (v.inner.tint_builtin_value_0 - 1u);
  uvec2 res = uvec2(textureSize(arg_0, int(min(uint(arg_1), v_1))));
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f), uvec2(0u));
  tint_symbol.pos = vec4(0.0f);
  tint_symbol.prevent_dce = textureDimensions_9cd4ca();
  return tint_symbol;
}
void main() {
  VertexOutput v_2 = vertex_main_inner();
  gl_Position = v_2.pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  vertex_main_loc0_Output = v_2.prevent_dce;
  gl_PointSize = 1.0f;
}
