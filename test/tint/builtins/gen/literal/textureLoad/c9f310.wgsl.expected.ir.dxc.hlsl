
RWByteAddressBuffer prevent_dce : register(u0);
RWTexture1D<int4> arg_0 : register(u0, space1);
int4 textureLoad_c9f310() {
  uint v = 0u;
  arg_0.GetDimensions(v);
  uint v_1 = (v - 1u);
  int4 res = int4(arg_0.Load(int2(int(min(uint(int(1)), v_1)), int(0))));
  return res;
}

void fragment_main() {
  prevent_dce.Store4(0u, asuint(textureLoad_c9f310()));
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store4(0u, asuint(textureLoad_c9f310()));
}

