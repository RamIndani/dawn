SKIP: INVALID


RWByteAddressBuffer prevent_dce : register(u0);
vector<float16_t, 3> subgroupAdd_0dd12a() {
  vector<float16_t, 3> res = WaveActiveSum((float16_t(1.0h)).xxx);
  return res;
}

void fragment_main() {
  prevent_dce.Store<vector<float16_t, 3> >(0u, subgroupAdd_0dd12a());
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store<vector<float16_t, 3> >(0u, subgroupAdd_0dd12a());
}

FXC validation failure:
C:\src\dawn\Shader@0x00000203FE9B1D80(3,8-16): error X3000: syntax error: unexpected token 'float16_t'

