#version 310 es

layout(location = 0) in int tint_symbol_loc0_Input;
layout(location = 1) in uint tint_symbol_loc1_Input;
layout(location = 2) in float tint_symbol_loc2_Input;
layout(location = 3) in vec4 tint_symbol_loc3_Input;
vec4 tint_symbol_inner(int loc0, uint loc1, float loc2, vec4 loc3) {
  int i = loc0;
  uint u = loc1;
  float f = loc2;
  vec4 v = loc3;
  return vec4(0.0f);
}
void main() {
  gl_Position = tint_symbol_inner(tint_symbol_loc0_Input, tint_symbol_loc1_Input, tint_symbol_loc2_Input, tint_symbol_loc3_Input);
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  gl_PointSize = 1.0f;
}
