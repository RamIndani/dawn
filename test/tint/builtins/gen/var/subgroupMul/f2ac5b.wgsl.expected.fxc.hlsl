SKIP: INVALID

RWByteAddressBuffer prevent_dce : register(u0);

vector<float16_t, 4> subgroupMul_f2ac5b() {
  vector<float16_t, 4> arg_0 = (float16_t(1.0h)).xxxx;
  vector<float16_t, 4> res = WaveActiveProduct(arg_0);
  return res;
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store<vector<float16_t, 4> >(0u, subgroupMul_f2ac5b());
  return;
}
FXC validation failure:
C:\src\dawn\Shader@0x000002BF0EFF69B0(3,8-16): error X3000: syntax error: unexpected token 'float16_t'

