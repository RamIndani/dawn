struct VertexOutput {
  float4 pos;
  int4 prevent_dce;
};

struct vertex_main_outputs {
  nointerpolation int4 VertexOutput_prevent_dce : TEXCOORD0;
  float4 VertexOutput_pos : SV_Position;
};


RWByteAddressBuffer prevent_dce : register(u0);
Texture2DArray<int4> arg_0 : register(t0, space1);
int4 textureLoad_fc6d36() {
  int2 arg_1 = (int(1)).xx;
  int arg_2 = int(1);
  int2 v = arg_1;
  uint3 v_1 = (0u).xxx;
  arg_0.GetDimensions(v_1.x, v_1.y, v_1.z);
  uint v_2 = min(uint(arg_2), (v_1.z - 1u));
  uint3 v_3 = (0u).xxx;
  arg_0.GetDimensions(v_3.x, v_3.y, v_3.z);
  uint2 v_4 = (v_3.xy - (1u).xx);
  int2 v_5 = int2(min(uint2(v), v_4));
  int4 res = int4(arg_0.Load(int4(v_5, int(v_2), int(0))));
  return res;
}

void fragment_main() {
  prevent_dce.Store4(0u, asuint(textureLoad_fc6d36()));
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store4(0u, asuint(textureLoad_fc6d36()));
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  tint_symbol.prevent_dce = textureLoad_fc6d36();
  VertexOutput v_6 = tint_symbol;
  return v_6;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_7 = vertex_main_inner();
  vertex_main_outputs v_8 = {v_7.prevent_dce, v_7.pos};
  return v_8;
}

