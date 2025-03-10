#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  vec4 inner;
} v;
layout(binding = 0, rgba8) uniform highp readonly image2D arg_0;
vec4 textureLoad_f2a7ff() {
  uvec2 arg_1 = uvec2(1u);
  uvec2 v_1 = arg_1;
  vec4 res = imageLoad(arg_0, ivec2(min(v_1, (uvec2(imageSize(arg_0)) - uvec2(1u)))));
  return res;
}
void main() {
  v.inner = textureLoad_f2a7ff();
}
#version 310 es

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  vec4 inner;
} v;
layout(binding = 0, rgba8) uniform highp readonly image2D arg_0;
vec4 textureLoad_f2a7ff() {
  uvec2 arg_1 = uvec2(1u);
  uvec2 v_1 = arg_1;
  vec4 res = imageLoad(arg_0, ivec2(min(v_1, (uvec2(imageSize(arg_0)) - uvec2(1u)))));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_f2a7ff();
}
#version 310 es


struct VertexOutput {
  vec4 pos;
  vec4 prevent_dce;
};

layout(binding = 0, rgba8) uniform highp readonly image2D arg_0;
layout(location = 0) flat out vec4 vertex_main_loc0_Output;
vec4 textureLoad_f2a7ff() {
  uvec2 arg_1 = uvec2(1u);
  uvec2 v = arg_1;
  vec4 res = imageLoad(arg_0, ivec2(min(v, (uvec2(imageSize(arg_0)) - uvec2(1u)))));
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f), vec4(0.0f));
  tint_symbol.pos = vec4(0.0f);
  tint_symbol.prevent_dce = textureLoad_f2a7ff();
  return tint_symbol;
}
void main() {
  VertexOutput v_1 = vertex_main_inner();
  gl_Position = v_1.pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  vertex_main_loc0_Output = v_1.prevent_dce;
  gl_PointSize = 1.0f;
}
