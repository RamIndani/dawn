#version 310 es


struct S {
  vec3 val[3];
};

void a() {
  ivec4 a_1 = ivec4(0);
  a_1[0u] = 1;
  a_1[2u] = 2;
  S d = S(vec3[3](vec3(0.0f), vec3(0.0f), vec3(0.0f)));
  d.val[2u][1u] = 3.0f;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
}
