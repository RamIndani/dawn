#version 310 es
precision highp float;
precision highp int;

void transpose_ace596() {
  mat2x3 res = mat2x3(vec3(1.0f), vec3(1.0f));
}
void main() {
  transpose_ace596();
}
#version 310 es

void transpose_ace596() {
  mat2x3 res = mat2x3(vec3(1.0f), vec3(1.0f));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  transpose_ace596();
}
#version 310 es


struct VertexOutput {
  vec4 pos;
};

void transpose_ace596() {
  mat2x3 res = mat2x3(vec3(1.0f), vec3(1.0f));
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f));
  tint_symbol.pos = vec4(0.0f);
  transpose_ace596();
  return tint_symbol;
}
void main() {
  gl_Position = vertex_main_inner().pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  gl_PointSize = 1.0f;
}
