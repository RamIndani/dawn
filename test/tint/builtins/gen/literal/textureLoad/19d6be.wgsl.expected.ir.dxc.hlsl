
RWByteAddressBuffer prevent_dce : register(u0);
RWTexture3D<uint4> arg_0 : register(u0, space1);
uint4 textureLoad_19d6be() {
  uint3 v = (0u).xxx;
  arg_0.GetDimensions(v.x, v.y, v.z);
  uint4 res = uint4(arg_0.Load(int4(int3(min((1u).xxx, (v - (1u).xxx))), int(0))));
  return res;
}

void fragment_main() {
  prevent_dce.Store4(0u, textureLoad_19d6be());
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store4(0u, textureLoad_19d6be());
}

