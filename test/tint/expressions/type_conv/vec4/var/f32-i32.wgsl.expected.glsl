#version 310 es

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void unused_entry_point() {
  return;
}
ivec4 tint_ftoi(vec4 v) {
  return mix(ivec4(2147483647), mix(ivec4(v), ivec4((-2147483647 - 1)), lessThan(v, vec4(-2147483648.0f))), lessThanEqual(v, vec4(2147483520.0f)));
}

vec4 u = vec4(1.0f);
void f() {
  ivec4 v = tint_ftoi(u);
}

