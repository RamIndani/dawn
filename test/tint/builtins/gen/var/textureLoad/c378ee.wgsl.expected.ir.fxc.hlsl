struct VertexOutput {
  float4 pos;
  uint4 prevent_dce;
};

struct vertex_main_outputs {
  nointerpolation uint4 VertexOutput_prevent_dce : TEXCOORD0;
  float4 VertexOutput_pos : SV_Position;
};


RWByteAddressBuffer prevent_dce : register(u0);
Texture2DMS<uint4> arg_0 : register(t0, space1);
uint4 textureLoad_c378ee() {
  int2 arg_1 = (int(1)).xx;
  int arg_2 = int(1);
  int v = arg_2;
  uint3 v_1 = (0u).xxx;
  arg_0.GetDimensions(v_1.x, v_1.y, v_1.z);
  uint2 v_2 = (v_1.xy - (1u).xx);
  int2 v_3 = int2(min(uint2(arg_1), v_2));
  uint4 res = uint4(arg_0.Load(v_3, int(v)));
  return res;
}

void fragment_main() {
  prevent_dce.Store4(0u, textureLoad_c378ee());
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store4(0u, textureLoad_c378ee());
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  tint_symbol.prevent_dce = textureLoad_c378ee();
  VertexOutput v_4 = tint_symbol;
  return v_4;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_5 = vertex_main_inner();
  vertex_main_outputs v_6 = {v_5.prevent_dce, v_5.pos};
  return v_6;
}

