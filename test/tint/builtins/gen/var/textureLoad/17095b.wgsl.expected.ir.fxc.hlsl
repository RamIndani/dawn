
RWByteAddressBuffer prevent_dce : register(u0);
RWTexture1D<uint4> arg_0 : register(u0, space1);
uint4 textureLoad_17095b() {
  uint arg_1 = 1u;
  uint v = 0u;
  arg_0.GetDimensions(v);
  uint4 res = uint4(arg_0.Load(int2(int(min(arg_1, (v - 1u))), int(0))));
  return res;
}

void fragment_main() {
  prevent_dce.Store4(0u, textureLoad_17095b());
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store4(0u, textureLoad_17095b());
}

