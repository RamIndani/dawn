SKIP: INVALID


cbuffer cbuffer_u : register(b0) {
  uint4 u[1];
};
RWByteAddressBuffer s : register(u1);
vector<float16_t, 2> tint_bitcast_to_f16(uint src) {
  uint v = src;
  float t_low = f16tof32((v & 65535u));
  float t_high = f16tof32(((v >> 16u) & 65535u));
  float16_t v_1 = float16_t(t_low);
  return vector<float16_t, 2>(v_1, float16_t(t_high));
}

void v_2(uint offset, matrix<float16_t, 2, 2> obj) {
  s.Store<vector<float16_t, 2> >((offset + 0u), obj[0u]);
  s.Store<vector<float16_t, 2> >((offset + 4u), obj[1u]);
}

matrix<float16_t, 2, 2> v_3(uint start_byte_offset) {
  uint4 v_4 = u[(start_byte_offset / 16u)];
  vector<float16_t, 2> v_5 = tint_bitcast_to_f16((((((start_byte_offset % 16u) / 4u) == 2u)) ? (v_4.z) : (v_4.x)));
  uint4 v_6 = u[((4u + start_byte_offset) / 16u)];
  return matrix<float16_t, 2, 2>(v_5, tint_bitcast_to_f16(((((((4u + start_byte_offset) % 16u) / 4u) == 2u)) ? (v_6.z) : (v_6.x))));
}

[numthreads(1, 1, 1)]
void f() {
  v_2(0u, v_3(0u));
  s.Store<vector<float16_t, 2> >(4u, tint_bitcast_to_f16(u[0u].x));
  s.Store<vector<float16_t, 2> >(4u, tint_bitcast_to_f16(u[0u].x).yx);
  s.Store<float16_t>(2u, float16_t(f16tof32(u[0u].y)));
}

FXC validation failure:
C:\src\dawn\Shader@0x000002089EA9ECA0(6,8-16): error X3000: syntax error: unexpected token 'float16_t'

