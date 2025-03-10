struct VertexOutput {
  float4 pos;
  uint3 prevent_dce;
};

struct vertex_main_outputs {
  nointerpolation uint3 VertexOutput_prevent_dce : TEXCOORD0;
  float4 VertexOutput_pos : SV_Position;
};


RWByteAddressBuffer prevent_dce : register(u0);
Texture3D<uint4> arg_0 : register(t0, space1);
uint3 textureDimensions_6e6c7a() {
  uint4 v = (0u).xxxx;
  arg_0.GetDimensions(0u, v.x, v.y, v.z, v.w);
  uint4 v_1 = (0u).xxxx;
  arg_0.GetDimensions(uint(min(1u, (v.w - 1u))), v_1.x, v_1.y, v_1.z, v_1.w);
  uint3 res = v_1.xyz;
  return res;
}

void fragment_main() {
  prevent_dce.Store3(0u, textureDimensions_6e6c7a());
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store3(0u, textureDimensions_6e6c7a());
}

VertexOutput vertex_main_inner() {
  VertexOutput tint_symbol = (VertexOutput)0;
  tint_symbol.pos = (0.0f).xxxx;
  tint_symbol.prevent_dce = textureDimensions_6e6c7a();
  VertexOutput v_2 = tint_symbol;
  return v_2;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_3 = vertex_main_inner();
  vertex_main_outputs v_4 = {v_3.prevent_dce, v_3.pos};
  return v_4;
}

