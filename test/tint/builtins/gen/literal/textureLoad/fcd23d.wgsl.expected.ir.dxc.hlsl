struct VertexOutput {
  float4 pos;
  float prevent_dce;
};

struct vertex_main_outputs {
  nointerpolation float VertexOutput_prevent_dce : TEXCOORD0;
  float4 VertexOutput_pos : SV_Position;
};


RWByteAddressBuffer prevent_dce : register(u0);
Texture2DMS<float4> arg_0 : register(t0, space1);
float textureLoad_fcd23d() {
  uint3 v = (0u).xxx;
  arg_0.GetDimensions(v.x, v.y, v.z);
  int2 v_1 = int2(min((1u).xx, (v.xy - (1u).xx)));
  float res = arg_0.Load(v_1, int(int(1))).x;
  return res;
}

void fragment_main() {
  prevent_dce.Store(0u, asuint(textureLoad_fcd23d()));
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store(0u, asuint(textureLoad_fcd23d()));
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  tint_symbol.prevent_dce = textureLoad_fcd23d();
  VertexOutput v_2 = tint_symbol;
  return v_2;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_3 = vertex_main_inner();
  vertex_main_outputs v_4 = {v_3.prevent_dce, v_3.pos};
  return v_4;
}

