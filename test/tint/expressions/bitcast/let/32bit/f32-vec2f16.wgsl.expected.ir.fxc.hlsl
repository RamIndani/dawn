SKIP: INVALID


vector<float16_t, 2> tint_bitcast_to_f16(float src) {
  uint v = asuint(src);
  float t_low = f16tof32((v & 65535u));
  float t_high = f16tof32(((v >> 16u) & 65535u));
  float16_t v_1 = float16_t(t_low);
  return vector<float16_t, 2>(v_1, float16_t(t_high));
}

[numthreads(1, 1, 1)]
void f() {
  float a = 2.003662109375f;
  vector<float16_t, 2> b = tint_bitcast_to_f16(a);
}

FXC validation failure:
C:\src\dawn\Shader@0x00000211E9CE96A0(2,8-16): error X3000: syntax error: unexpected token 'float16_t'

