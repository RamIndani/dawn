
RWByteAddressBuffer prevent_dce : register(u0);
RWTexture2DArray<uint4> arg_0 : register(u0, space1);
uint4 textureLoad_c2d09a() {
  uint2 arg_1 = (1u).xx;
  int arg_2 = int(1);
  uint2 v = arg_1;
  uint3 v_1 = (0u).xxx;
  arg_0.GetDimensions(v_1.x, v_1.y, v_1.z);
  uint v_2 = min(uint(arg_2), (v_1.z - 1u));
  uint3 v_3 = (0u).xxx;
  arg_0.GetDimensions(v_3.x, v_3.y, v_3.z);
  int2 v_4 = int2(min(v, (v_3.xy - (1u).xx)));
  uint4 res = uint4(arg_0.Load(int4(v_4, int(v_2), int(0))));
  return res;
}

void fragment_main() {
  prevent_dce.Store4(0u, textureLoad_c2d09a());
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store4(0u, textureLoad_c2d09a());
}

