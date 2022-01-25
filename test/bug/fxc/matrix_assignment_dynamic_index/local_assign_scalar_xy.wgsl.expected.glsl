#version 310 es
precision mediump float;

struct Uniforms {
  uint i;
  uint j;
};

layout(binding = 4) uniform Uniforms_1 {
  uint i;
  uint j;
} uniforms;

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void tint_symbol() {
  mat2x4 m1 = mat2x4(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
  m1[uniforms.i][uniforms.j] = 1.0f;
  return;
}
void main() {
  tint_symbol();
}


