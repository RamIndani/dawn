
RWByteAddressBuffer prevent_dce : register(u0);
RWTexture2DArray<uint4> arg_0 : register(u0, space1);
uint4 textureLoad_e9eb65() {
  uint3 v = (0u).xxx;
  arg_0.GetDimensions(v.x, v.y, v.z);
  uint v_1 = min(uint(int(1)), (v.z - 1u));
  uint3 v_2 = (0u).xxx;
  arg_0.GetDimensions(v_2.x, v_2.y, v_2.z);
  int2 v_3 = int2(min((1u).xx, (v_2.xy - (1u).xx)));
  uint4 res = uint4(arg_0.Load(int4(v_3, int(v_1), int(0))));
  return res;
}

void fragment_main() {
  prevent_dce.Store4(0u, textureLoad_e9eb65());
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store4(0u, textureLoad_e9eb65());
}

