#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  vec4 inner;
} v;
uniform highp sampler2DMS arg_0;
vec4 textureLoad_2e09aa() {
  uvec2 arg_1 = uvec2(1u);
  uint arg_2 = 1u;
  uvec2 v_1 = arg_1;
  uint v_2 = arg_2;
  ivec2 v_3 = ivec2(min(v_1, (uvec2(textureSize(arg_0)) - uvec2(1u))));
  vec4 res = texelFetch(arg_0, v_3, int(v_2));
  return res;
}
void main() {
  v.inner = textureLoad_2e09aa();
}
#version 310 es

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  vec4 inner;
} v;
uniform highp sampler2DMS arg_0;
vec4 textureLoad_2e09aa() {
  uvec2 arg_1 = uvec2(1u);
  uint arg_2 = 1u;
  uvec2 v_1 = arg_1;
  uint v_2 = arg_2;
  ivec2 v_3 = ivec2(min(v_1, (uvec2(textureSize(arg_0)) - uvec2(1u))));
  vec4 res = texelFetch(arg_0, v_3, int(v_2));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_2e09aa();
}
#version 310 es


struct VertexOutput {
  vec4 pos;
  vec4 prevent_dce;
};

uniform highp sampler2DMS arg_0;
layout(location = 0) flat out vec4 vertex_main_loc0_Output;
vec4 textureLoad_2e09aa() {
  uvec2 arg_1 = uvec2(1u);
  uint arg_2 = 1u;
  uvec2 v = arg_1;
  uint v_1 = arg_2;
  ivec2 v_2 = ivec2(min(v, (uvec2(textureSize(arg_0)) - uvec2(1u))));
  vec4 res = texelFetch(arg_0, v_2, int(v_1));
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f), vec4(0.0f));
  tint_symbol.pos = vec4(0.0f);
  tint_symbol.prevent_dce = textureLoad_2e09aa();
  return tint_symbol;
}
void main() {
  VertexOutput v_3 = vertex_main_inner();
  gl_Position = v_3.pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  vertex_main_loc0_Output = v_3.prevent_dce;
  gl_PointSize = 1.0f;
}
