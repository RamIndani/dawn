struct S {
  int before;
  float2x3 m;
  int after;
};

struct f_inputs {
  uint tint_local_index : SV_GroupIndex;
};


cbuffer cbuffer_u : register(b0) {
  uint4 u[32];
};
groupshared S w[4];
float2x3 v(uint start_byte_offset) {
  return float2x3(asfloat(u[(start_byte_offset / 16u)].xyz), asfloat(u[((16u + start_byte_offset) / 16u)].xyz));
}

S v_1(uint start_byte_offset) {
  int v_2 = asint(u[(start_byte_offset / 16u)][((start_byte_offset % 16u) / 4u)]);
  float2x3 v_3 = v((16u + start_byte_offset));
  S v_4 = {v_2, v_3, asint(u[((64u + start_byte_offset) / 16u)][(((64u + start_byte_offset) % 16u) / 4u)])};
  return v_4;
}

typedef S ary_ret[4];
ary_ret v_5(uint start_byte_offset) {
  S a[4] = (S[4])0;
  {
    uint v_6 = 0u;
    v_6 = 0u;
    while(true) {
      uint v_7 = v_6;
      if ((v_7 >= 4u)) {
        break;
      }
      S v_8 = v_1((start_byte_offset + (v_7 * 128u)));
      a[v_7] = v_8;
      {
        v_6 = (v_7 + 1u);
      }
      continue;
    }
  }
  S v_9[4] = a;
  return v_9;
}

void f_inner(uint tint_local_index) {
  {
    uint v_10 = 0u;
    v_10 = tint_local_index;
    while(true) {
      uint v_11 = v_10;
      if ((v_11 >= 4u)) {
        break;
      }
      S v_12 = (S)0;
      w[v_11] = v_12;
      {
        v_10 = (v_11 + 1u);
      }
      continue;
    }
  }
  GroupMemoryBarrierWithGroupSync();
  S v_13[4] = v_5(0u);
  w = v_13;
  S v_14 = v_1(256u);
  w[1u] = v_14;
  w[3u].m = v(272u);
  w[1u].m[0u] = asfloat(u[2u].xyz).zxy;
}

[numthreads(1, 1, 1)]
void f(f_inputs inputs) {
  f_inner(inputs.tint_local_index);
}

