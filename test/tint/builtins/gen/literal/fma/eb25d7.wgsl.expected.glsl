#version 310 es
precision highp float;
precision highp int;

void fma_eb25d7() {
  vec3 res = vec3(2.0f);
}
void main() {
  fma_eb25d7();
}
#version 310 es

void fma_eb25d7() {
  vec3 res = vec3(2.0f);
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  fma_eb25d7();
}
#version 310 es


struct VertexOutput {
  vec4 pos;
};

void fma_eb25d7() {
  vec3 res = vec3(2.0f);
}
VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = VertexOutput(vec4(0.0f));
  tint_symbol.pos = vec4(0.0f);
  fma_eb25d7();
  return tint_symbol;
}
void main() {
  gl_Position = vertex_main_inner().pos;
  gl_Position.y = -(gl_Position.y);
  gl_Position.z = ((2.0f * gl_Position.z) - gl_Position.w);
  gl_PointSize = 1.0f;
}
