#version 310 es
precision mediump float;

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void unused_entry_point() {
  return;
}
void main() {
  unused_entry_point();
}



struct S {
  ivec3 v;
};

layout(binding = 0) buffer S_1 {
  ivec3 v;
} U;

void f() {
  U.v = ivec3(1, 2, 3);
  U.v.x = 1;
  U.v.y = 2;
  U.v.z = 3;
}
