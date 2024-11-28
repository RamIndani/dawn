struct main_inputs {
  uint3 LocalInvocationID : SV_GroupThreadID;
  uint tint_local_index : SV_GroupIndex;
  uint3 WorkGroupID : SV_GroupID;
};


SamplerState samp : register(s0);
cbuffer cbuffer_params : register(b1) {
  uint4 params[1];
};
Texture2D<float4> inputTex : register(t1, space1);
RWTexture2D<float4> outputTex : register(u2, space1);
cbuffer cbuffer_flip : register(b3, space1) {
  uint4 flip[1];
};
groupshared float3 tile[4][256];
uint tint_div_u32(uint lhs, uint rhs) {
  return (lhs / (((rhs == 0u)) ? (1u) : (rhs)));
}

void main_inner(uint3 WorkGroupID, uint3 LocalInvocationID, uint tint_local_index) {
  {
    uint v = 0u;
    v = tint_local_index;
    while(true) {
      uint v_1 = v;
      if ((v_1 >= 1024u)) {
        break;
      }
      tile[(v_1 / 256u)][(v_1 % 256u)] = (0.0f).xxx;
      {
        v = (v_1 + 64u);
      }
      continue;
    }
  }
  GroupMemoryBarrierWithGroupSync();
  uint filterOffset = tint_div_u32((params[0u].x - 1u), 2u);
  uint3 v_2 = (0u).xxx;
  inputTex.GetDimensions(0u, v_2.x, v_2.y, v_2.z);
  uint3 v_3 = (0u).xxx;
  inputTex.GetDimensions(uint(min(uint(int(0)), (v_2.z - 1u))), v_3.x, v_3.y, v_3.z);
  uint2 dims = v_3.xy;
  uint2 v_4 = ((WorkGroupID.xy * uint2(params[0u].y, 4u)) + (LocalInvocationID.xy * uint2(4u, 1u)));
  uint2 baseIndex = (v_4 - uint2(filterOffset, 0u));
  {
    uint r = 0u;
    while(true) {
      if ((r < 4u)) {
      } else {
        break;
      }
      {
        uint c = 0u;
        while(true) {
          if ((c < 4u)) {
          } else {
            break;
          }
          uint2 loadIndex = (baseIndex + uint2(c, r));
          if ((flip[0u].x != 0u)) {
            loadIndex = loadIndex.yx;
          }
          uint v_5 = min(r, 3u);
          uint v_6 = min(((4u * LocalInvocationID.x) + c), 255u);
          float2 v_7 = (float2(loadIndex) + (0.25f).xx);
          float2 v_8 = (v_7 / float2(dims));
          tile[v_5][v_6] = inputTex.SampleLevel(samp, v_8, float(0.0f)).xyz;
          {
            c = (c + 1u);
          }
          continue;
        }
      }
      {
        r = (r + 1u);
      }
      continue;
    }
  }
  GroupMemoryBarrierWithGroupSync();
  {
    uint r = 0u;
    while(true) {
      if ((r < 4u)) {
      } else {
        break;
      }
      {
        uint c = 0u;
        while(true) {
          if ((c < 4u)) {
          } else {
            break;
          }
          uint2 writeIndex = (baseIndex + uint2(c, r));
          if ((flip[0u].x != 0u)) {
            writeIndex = writeIndex.yx;
          }
          uint center = ((4u * LocalInvocationID.x) + c);
          bool v_9 = false;
          if ((center >= filterOffset)) {
            v_9 = (center < (256u - filterOffset));
          } else {
            v_9 = false;
          }
          bool v_10 = false;
          if (v_9) {
            v_10 = all((writeIndex < dims));
          } else {
            v_10 = false;
          }
          if (v_10) {
            float3 acc = (0.0f).xxx;
            {
              uint f = 0u;
              while(true) {
                if ((f < params[0u].x)) {
                } else {
                  break;
                }
                uint i = ((center + f) - filterOffset);
                float3 v_11 = acc;
                float v_12 = (1.0f / float(params[0u].x));
                uint v_13 = min(r, 3u);
                uint v_14 = min(i, 255u);
                acc = (v_11 + (v_12 * tile[v_13][v_14]));
                {
                  f = (f + 1u);
                }
                continue;
              }
            }
            uint2 v_15 = writeIndex;
            outputTex[v_15] = float4(acc, 1.0f);
          }
          {
            c = (c + 1u);
          }
          continue;
        }
      }
      {
        r = (r + 1u);
      }
      continue;
    }
  }
}

[numthreads(64, 1, 1)]
void main(main_inputs inputs) {
  main_inner(inputs.WorkGroupID, inputs.LocalInvocationID, inputs.tint_local_index);
}

