struct VertexOutput {
  float4 pos;
  uint4 prevent_dce;
};

struct vertex_main_outputs {
  nointerpolation uint4 VertexOutput_prevent_dce : TEXCOORD0;
  float4 VertexOutput_pos : SV_Position;
};


RWByteAddressBuffer prevent_dce : register(u0);
Texture3D<uint4> arg_0 : register(t0, space1);
uint4 textureLoad_92eb1f() {
  uint4 v = (0u).xxxx;
  arg_0.GetDimensions(0u, v.x, v.y, v.z, v.w);
  uint v_1 = min(uint(int(1)), (v.w - 1u));
  uint4 v_2 = (0u).xxxx;
  arg_0.GetDimensions(uint(v_1), v_2.x, v_2.y, v_2.z, v_2.w);
  int3 v_3 = int3(min((1u).xxx, (v_2.xyz - (1u).xxx)));
  uint4 res = uint4(arg_0.Load(int4(v_3, int(v_1))));
  return res;
}

void fragment_main() {
  prevent_dce.Store4(0u, textureLoad_92eb1f());
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store4(0u, textureLoad_92eb1f());
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  tint_symbol.prevent_dce = textureLoad_92eb1f();
  VertexOutput v_4 = tint_symbol;
  return v_4;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_5 = vertex_main_inner();
  vertex_main_outputs v_6 = {v_5.prevent_dce, v_5.pos};
  return v_6;
}

