SKIP: INVALID


RWByteAddressBuffer prevent_dce : register(u0);
vector<float16_t, 3> subgroupExclusiveAdd_e58e23() {
  vector<float16_t, 3> res = WavePrefixSum((float16_t(1.0h)).xxx);
  return res;
}

void fragment_main() {
  prevent_dce.Store<vector<float16_t, 3> >(0u, subgroupExclusiveAdd_e58e23());
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store<vector<float16_t, 3> >(0u, subgroupExclusiveAdd_e58e23());
}

FXC validation failure:
C:\src\dawn\Shader@0x000001F9755BF4F0(3,8-16): error X3000: syntax error: unexpected token 'float16_t'

