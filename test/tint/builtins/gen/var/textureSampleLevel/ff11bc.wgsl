// Copyright 2022 The Dawn & Tint Authors
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its
//    contributors may be used to endorse or promote products derived from
//    this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

////////////////////////////////////////////////////////////////////////////////
// File generated by 'tools/src/cmd/gen' using the template:
//   test/tint/builtins/gen/gen.wgsl.tmpl
//
// To regenerate run: './tools/run gen'
//
//                       Do not modify this file directly
////////////////////////////////////////////////////////////////////////////////


// flags: --glsl-desktop

@group(0) @binding(0) var<storage, read_write> prevent_dce : f32;

@group(1) @binding(0) var arg_0: texture_depth_cube_array;
@group(1) @binding(1) var arg_1: sampler;

// fn textureSampleLevel(texture: texture_depth_cube_array, sampler: sampler, coords: vec3<f32>, array_index: u32, level: i32) -> f32
fn textureSampleLevel_ff11bc() -> f32{
  var arg_2 = vec3<f32>(1.f);
  var arg_3 = 1u;
  var arg_4 = 1i;
  var res: f32 = textureSampleLevel(arg_0, arg_1, arg_2, arg_3, arg_4);
  return res;
}
@fragment
fn fragment_main() {
  prevent_dce = textureSampleLevel_ff11bc();
}

@compute @workgroup_size(1)
fn compute_main() {
  prevent_dce = textureSampleLevel_ff11bc();
}

struct VertexOutput {
    @builtin(position) pos: vec4<f32>,
    @location(0) @interpolate(flat) prevent_dce : f32
};

@vertex
fn vertex_main() -> VertexOutput {
  var out : VertexOutput;
  out.pos = vec4<f32>();
  out.prevent_dce = textureSampleLevel_ff11bc();
  return out;
}
