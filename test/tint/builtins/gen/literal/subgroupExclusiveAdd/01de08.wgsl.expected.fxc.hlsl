SKIP: INVALID

RWByteAddressBuffer prevent_dce : register(u0);

vector<float16_t, 2> subgroupExclusiveAdd_01de08() {
  vector<float16_t, 2> res = WavePrefixSum((float16_t(1.0h)).xx);
  return res;
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store<vector<float16_t, 2> >(0u, subgroupExclusiveAdd_01de08());
  return;
}
FXC validation failure:
C:\src\dawn\Shader@0x000001C39A2580B0(3,8-16): error X3000: syntax error: unexpected token 'float16_t'

