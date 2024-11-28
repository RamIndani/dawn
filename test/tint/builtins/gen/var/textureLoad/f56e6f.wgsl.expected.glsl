#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  uvec4 inner;
} v;
layout(binding = 0, rgba16ui) uniform highp readonly uimage3D arg_0;
uvec4 textureLoad_f56e6f() {
  ivec3 arg_1 = ivec3(1);
  ivec3 v_1 = arg_1;
  uvec3 v_2 = (uvec3(imageSize(arg_0)) - uvec3(1u));
  uvec4 res = imageLoad(arg_0, ivec3(min(uvec3(v_1), v_2)));
  return res;
}
void main() {
  v.inner = textureLoad_f56e6f();
}
#version 310 es

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  uvec4 inner;
} v;
layout(binding = 0, rgba16ui) uniform highp readonly uimage3D arg_0;
uvec4 textureLoad_f56e6f() {
  ivec3 arg_1 = ivec3(1);
  ivec3 v_1 = arg_1;
  uvec3 v_2 = (uvec3(imageSize(arg_0)) - uvec3(1u));
  uvec4 res = imageLoad(arg_0, ivec3(min(uvec3(v_1), v_2)));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_f56e6f();
}
#version 310 es


struct VertexOutput {
  vec4 pos;
  uvec4 prevent_dce;
};

layout(binding = 0, rgba16ui) uniform highp readonly uimage3D arg_0;
layout(location = 0) flat out uvec4 vertex_main_loc0_Output;
uvec4 textureLoad_f56e6f() {
  ivec3 arg_1 = ivec3(1);
  ivec3 v = arg_1;
  uvec3 v_1 = (uvec3(imageSize(arg_0)) - uvec3(1u));
  uvec4 res = imageLoad(arg_0, ivec3(min(uvec3(v), v_1)));
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f), uvec4(0u));
  tint_symbol.pos = vec4(0.0f);
  tint_symbol.prevent_dce = textureLoad_f56e6f();
  return tint_symbol;
}
void main() {
  VertexOutput v_2 = vertex_main_inner();
  gl_Position = v_2.pos;
  gl_Position[1u] = -(gl_Position.y);
  gl_Position[2u] = ((2.0f * gl_Position.z) - gl_Position.w);
  vertex_main_loc0_Output = v_2.prevent_dce;
  gl_PointSize = 1.0f;
}
