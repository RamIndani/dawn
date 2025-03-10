#version 310 es
precision highp float;
precision highp int;


struct TintTextureUniformData {
  uint tint_builtin_value_0;
};

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  uvec4 inner;
} v;
layout(binding = 0, std140)
uniform tint_symbol_1_1_ubo {
  TintTextureUniformData inner;
} v_1;
uniform highp usampler2DArray arg_0;
uvec4 textureLoad_656d76() {
  ivec2 arg_1 = ivec2(1);
  int arg_2 = 1;
  uint arg_3 = 1u;
  ivec2 v_2 = arg_1;
  int v_3 = arg_2;
  uint v_4 = arg_3;
  uint v_5 = (uint(textureSize(arg_0, 0).z) - 1u);
  uint v_6 = min(uint(v_3), v_5);
  uint v_7 = min(v_4, (v_1.inner.tint_builtin_value_0 - 1u));
  uvec2 v_8 = (uvec2(textureSize(arg_0, int(v_7)).xy) - uvec2(1u));
  ivec2 v_9 = ivec2(min(uvec2(v_2), v_8));
  ivec3 v_10 = ivec3(v_9, int(v_6));
  uvec4 res = texelFetch(arg_0, v_10, int(v_7));
  return res;
}
void main() {
  v.inner = textureLoad_656d76();
}
#version 310 es


struct TintTextureUniformData {
  uint tint_builtin_value_0;
};

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  uvec4 inner;
} v;
layout(binding = 0, std140)
uniform tint_symbol_1_1_ubo {
  TintTextureUniformData inner;
} v_1;
uniform highp usampler2DArray arg_0;
uvec4 textureLoad_656d76() {
  ivec2 arg_1 = ivec2(1);
  int arg_2 = 1;
  uint arg_3 = 1u;
  ivec2 v_2 = arg_1;
  int v_3 = arg_2;
  uint v_4 = arg_3;
  uint v_5 = (uint(textureSize(arg_0, 0).z) - 1u);
  uint v_6 = min(uint(v_3), v_5);
  uint v_7 = min(v_4, (v_1.inner.tint_builtin_value_0 - 1u));
  uvec2 v_8 = (uvec2(textureSize(arg_0, int(v_7)).xy) - uvec2(1u));
  ivec2 v_9 = ivec2(min(uvec2(v_2), v_8));
  ivec3 v_10 = ivec3(v_9, int(v_6));
  uvec4 res = texelFetch(arg_0, v_10, int(v_7));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_656d76();
}
#version 310 es


struct TintTextureUniformData {
  uint tint_builtin_value_0;
};

struct VertexOutput {
  vec4 pos;
  uvec4 prevent_dce;
};

layout(binding = 0, std140)
uniform tint_symbol_1_1_ubo {
  TintTextureUniformData inner;
} v;
uniform highp usampler2DArray arg_0;
layout(location = 0) flat out uvec4 vertex_main_loc0_Output;
uvec4 textureLoad_656d76() {
  ivec2 arg_1 = ivec2(1);
  int arg_2 = 1;
  uint arg_3 = 1u;
  ivec2 v_1 = arg_1;
  int v_2 = arg_2;
  uint v_3 = arg_3;
  uint v_4 = (uint(textureSize(arg_0, 0).z) - 1u);
  uint v_5 = min(uint(v_2), v_4);
  uint v_6 = min(v_3, (v.inner.tint_builtin_value_0 - 1u));
  uvec2 v_7 = (uvec2(textureSize(arg_0, int(v_6)).xy) - uvec2(1u));
  ivec2 v_8 = ivec2(min(uvec2(v_1), v_7));
  ivec3 v_9 = ivec3(v_8, int(v_5));
  uvec4 res = texelFetch(arg_0, v_9, int(v_6));
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f), uvec4(0u));
  tint_symbol.pos = vec4(0.0f);
  tint_symbol.prevent_dce = textureLoad_656d76();
  return tint_symbol;
}
void main() {
  VertexOutput v_10 = vertex_main_inner();
  gl_Position = v_10.pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  vertex_main_loc0_Output = v_10.prevent_dce;
  gl_PointSize = 1.0f;
}
