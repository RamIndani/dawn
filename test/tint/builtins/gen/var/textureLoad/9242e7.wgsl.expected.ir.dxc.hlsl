
RWByteAddressBuffer prevent_dce : register(u0);
RWTexture2D<uint4> arg_0 : register(u0, space1);
uint4 textureLoad_9242e7() {
  uint2 arg_1 = (1u).xx;
  uint2 v = (0u).xx;
  arg_0.GetDimensions(v.x, v.y);
  uint4 res = uint4(arg_0.Load(int3(int2(min(arg_1, (v - (1u).xx))), int(0))));
  return res;
}

void fragment_main() {
  prevent_dce.Store4(0u, textureLoad_9242e7());
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store4(0u, textureLoad_9242e7());
}

