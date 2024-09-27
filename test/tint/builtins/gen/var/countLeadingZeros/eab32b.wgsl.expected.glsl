#version 310 es
precision highp float;
precision highp int;

ivec4 tint_count_leading_zeros(ivec4 v) {
  uvec4 x = uvec4(v);
  uvec4 b16 = mix(uvec4(0u), uvec4(16u), lessThanEqual(x, uvec4(65535u)));
  x = (x << b16);
  uvec4 b8 = mix(uvec4(0u), uvec4(8u), lessThanEqual(x, uvec4(16777215u)));
  x = (x << b8);
  uvec4 b4 = mix(uvec4(0u), uvec4(4u), lessThanEqual(x, uvec4(268435455u)));
  x = (x << b4);
  uvec4 b2 = mix(uvec4(0u), uvec4(2u), lessThanEqual(x, uvec4(1073741823u)));
  x = (x << b2);
  uvec4 b1 = mix(uvec4(0u), uvec4(1u), lessThanEqual(x, uvec4(2147483647u)));
  uvec4 is_zero = mix(uvec4(0u), uvec4(1u), equal(x, uvec4(0u)));
  return ivec4((((((b16 | b8) | b4) | b2) | b1) + is_zero));
}

layout(binding = 0, std430) buffer prevent_dce_block_ssbo {
  ivec4 inner;
} prevent_dce;

ivec4 countLeadingZeros_eab32b() {
  ivec4 arg_0 = ivec4(1);
  ivec4 res = tint_count_leading_zeros(arg_0);
  return res;
}

struct VertexOutput {
  vec4 pos;
  ivec4 prevent_dce;
};

void fragment_main() {
  prevent_dce.inner = countLeadingZeros_eab32b();
}

void main() {
  fragment_main();
  return;
}
#version 310 es

ivec4 tint_count_leading_zeros(ivec4 v) {
  uvec4 x = uvec4(v);
  uvec4 b16 = mix(uvec4(0u), uvec4(16u), lessThanEqual(x, uvec4(65535u)));
  x = (x << b16);
  uvec4 b8 = mix(uvec4(0u), uvec4(8u), lessThanEqual(x, uvec4(16777215u)));
  x = (x << b8);
  uvec4 b4 = mix(uvec4(0u), uvec4(4u), lessThanEqual(x, uvec4(268435455u)));
  x = (x << b4);
  uvec4 b2 = mix(uvec4(0u), uvec4(2u), lessThanEqual(x, uvec4(1073741823u)));
  x = (x << b2);
  uvec4 b1 = mix(uvec4(0u), uvec4(1u), lessThanEqual(x, uvec4(2147483647u)));
  uvec4 is_zero = mix(uvec4(0u), uvec4(1u), equal(x, uvec4(0u)));
  return ivec4((((((b16 | b8) | b4) | b2) | b1) + is_zero));
}

layout(binding = 0, std430) buffer prevent_dce_block_ssbo {
  ivec4 inner;
} prevent_dce;

ivec4 countLeadingZeros_eab32b() {
  ivec4 arg_0 = ivec4(1);
  ivec4 res = tint_count_leading_zeros(arg_0);
  return res;
}

struct VertexOutput {
  vec4 pos;
  ivec4 prevent_dce;
};

void compute_main() {
  prevent_dce.inner = countLeadingZeros_eab32b();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
#version 310 es

ivec4 tint_count_leading_zeros(ivec4 v) {
  uvec4 x = uvec4(v);
  uvec4 b16 = mix(uvec4(0u), uvec4(16u), lessThanEqual(x, uvec4(65535u)));
  x = (x << b16);
  uvec4 b8 = mix(uvec4(0u), uvec4(8u), lessThanEqual(x, uvec4(16777215u)));
  x = (x << b8);
  uvec4 b4 = mix(uvec4(0u), uvec4(4u), lessThanEqual(x, uvec4(268435455u)));
  x = (x << b4);
  uvec4 b2 = mix(uvec4(0u), uvec4(2u), lessThanEqual(x, uvec4(1073741823u)));
  x = (x << b2);
  uvec4 b1 = mix(uvec4(0u), uvec4(1u), lessThanEqual(x, uvec4(2147483647u)));
  uvec4 is_zero = mix(uvec4(0u), uvec4(1u), equal(x, uvec4(0u)));
  return ivec4((((((b16 | b8) | b4) | b2) | b1) + is_zero));
}

layout(location = 0) flat out ivec4 prevent_dce_1;
ivec4 countLeadingZeros_eab32b() {
  ivec4 arg_0 = ivec4(1);
  ivec4 res = tint_count_leading_zeros(arg_0);
  return res;
}

struct VertexOutput {
  vec4 pos;
  ivec4 prevent_dce;
};

VertexOutput vertex_main() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f, 0.0f, 0.0f, 0.0f), ivec4(0, 0, 0, 0));
  tint_symbol.pos = vec4(0.0f);
  tint_symbol.prevent_dce = countLeadingZeros_eab32b();
  return tint_symbol;
}

void main() {
  gl_PointSize = 1.0;
  VertexOutput inner_result = vertex_main();
  gl_Position = inner_result.pos;
  prevent_dce_1 = inner_result.prevent_dce;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  return;
}
