#version 310 es
precision mediump float;

struct S {
  int i;
};

layout(binding = 0) uniform S_1 {
  int i;
} u;

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void tint_symbol() {
  return;
}
void main() {
  tint_symbol();
}


