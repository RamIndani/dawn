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

#ifndef SRC_TINT_CMD_BENCH_BENCH_H_
#define SRC_TINT_CMD_BENCH_BENCH_H_

#include <memory>
#include <string>

#include "benchmark/benchmark.h"  // IWYU pragma: export
#include "src/tint/lang/wgsl/program/program.h"
#include "src/tint/utils/macros/compiler.h"
#include "src/tint/utils/result/result.h"

// Autogenerated header that defines the benchmark shaders and macros for registering benchmarks.
#include "src/tint/cmd/bench/benchmark_inputs.h"  // GEN_BUILD:IGNORE_INCLUDE

namespace tint::bench {
/// ProgramAndFile holds a Program and a Source::File.
struct ProgramAndFile {
    /// The tint program parsed from file.
    Program program;
    /// The source file
    std::unique_ptr<Source::File> file;
};

/// GetWgslFile retrieves the WGSL for the benchmark input shader called @p name.
/// Benchmarks that are SPIR-V shaders will have been converted to WGSL at startup.
/// @param name the benchmark input name
/// @returns the Source::File
Result<Source::File> GetWgslFile(std::string name);

/// GetWgslProgram parses the WGSL for a benchmark input program with the given name.
/// @param name the benchmark input name
/// @returns the parsed WGSL program
Result<ProgramAndFile> GetWgslProgram(std::string name);

}  // namespace tint::bench

#endif  // SRC_TINT_CMD_BENCH_BENCH_H_
