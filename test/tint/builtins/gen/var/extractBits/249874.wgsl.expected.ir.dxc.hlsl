struct VertexOutput {
  float4 pos;
  int prevent_dce;
};

struct vertex_main_outputs {
  nointerpolation int VertexOutput_prevent_dce : TEXCOORD0;
  float4 VertexOutput_pos : SV_Position;
};


RWByteAddressBuffer prevent_dce : register(u0);
int extractBits_249874() {
  int arg_0 = int(1);
  uint arg_1 = 1u;
  uint arg_2 = 1u;
  int v = arg_0;
  uint v_1 = min(arg_1, 32u);
  uint v_2 = (32u - min(32u, (v_1 + arg_2)));
  int v_3 = (((v_2 < 32u)) ? ((v << uint(v_2))) : (int(0)));
  int res = ((((v_2 + v_1) < 32u)) ? ((v_3 >> uint((v_2 + v_1)))) : (((v_3 >> 31u) >> 1u)));
  return res;
}

void fragment_main() {
  prevent_dce.Store(0u, asuint(extractBits_249874()));
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store(0u, asuint(extractBits_249874()));
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  tint_symbol.prevent_dce = extractBits_249874();
  VertexOutput v_4 = tint_symbol;
  return v_4;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_5 = vertex_main_inner();
  vertex_main_outputs v_6 = {v_5.prevent_dce, v_5.pos};
  return v_6;
}

