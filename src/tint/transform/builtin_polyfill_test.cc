// Copyright 2022 The Tint Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "src/tint/transform/builtin_polyfill.h"

#include <utility>

#include "src/tint/transform/test_helper.h"

namespace tint {
namespace transform {
namespace {

using BuiltinPolyfillTest = TransformTest;

TEST_F(BuiltinPolyfillTest, ShouldRunEmptyModule) {
  auto* src = R"()";

  EXPECT_FALSE(ShouldRun<BuiltinPolyfill>(src));
}

TEST_F(BuiltinPolyfillTest, EmptyModule) {
  auto* src = R"()";

  auto* expect = src;

  auto got = Run<BuiltinPolyfill>(src);

  EXPECT_EQ(expect, str(got));
}

////////////////////////////////////////////////////////////////////////////////
// countLeadingZeros
////////////////////////////////////////////////////////////////////////////////
DataMap polyfillCountLeadingZeros() {
  BuiltinPolyfill::Builtins builtins;
  builtins.count_leading_zeros = true;
  DataMap data;
  data.Add<BuiltinPolyfill::Config>(builtins);
  return data;
}

TEST_F(BuiltinPolyfillTest, ShouldRunCountLeadingZeros) {
  auto* src = R"(
fn f() {
  countLeadingZeros(0xf);
}
)";

  EXPECT_FALSE(ShouldRun<BuiltinPolyfill>(src));
  EXPECT_TRUE(ShouldRun<BuiltinPolyfill>(src, polyfillCountLeadingZeros()));
}

TEST_F(BuiltinPolyfillTest, CountLeadingZeros_i32) {
  auto* src = R"(
fn f() {
  let r : i32 = countLeadingZeros(15);
}
)";

  auto* expect = R"(
fn tint_count_leading_zeros(v : i32) -> i32 {
  var x = u32(v);
  let b16 = select(0u, 16u, (x <= 65535u));
  x = (x << b16);
  let b8 = select(0u, 8u, (x <= 16777215u));
  x = (x << b8);
  let b4 = select(0u, 4u, (x <= 268435455u));
  x = (x << b4);
  let b2 = select(0u, 2u, (x <= 1073741823u));
  x = (x << b2);
  let b1 = select(0u, 1u, (x <= 2147483647u));
  let is_zero = select(0u, 1u, (x == 0u));
  return i32((((((b16 | b8) | b4) | b2) | b1) + is_zero));
}

fn f() {
  let r : i32 = tint_count_leading_zeros(15);
}
)";

  auto got = Run<BuiltinPolyfill>(src, polyfillCountLeadingZeros());

  EXPECT_EQ(expect, str(got));
}

TEST_F(BuiltinPolyfillTest, CountLeadingZeros_u32) {
  auto* src = R"(
fn f() {
  let r : u32 = countLeadingZeros(15u);
}
)";

  auto* expect = R"(
fn tint_count_leading_zeros(v : u32) -> u32 {
  var x = u32(v);
  let b16 = select(0u, 16u, (x <= 65535u));
  x = (x << b16);
  let b8 = select(0u, 8u, (x <= 16777215u));
  x = (x << b8);
  let b4 = select(0u, 4u, (x <= 268435455u));
  x = (x << b4);
  let b2 = select(0u, 2u, (x <= 1073741823u));
  x = (x << b2);
  let b1 = select(0u, 1u, (x <= 2147483647u));
  let is_zero = select(0u, 1u, (x == 0u));
  return u32((((((b16 | b8) | b4) | b2) | b1) + is_zero));
}

fn f() {
  let r : u32 = tint_count_leading_zeros(15u);
}
)";

  auto got = Run<BuiltinPolyfill>(src, polyfillCountLeadingZeros());

  EXPECT_EQ(expect, str(got));
}

TEST_F(BuiltinPolyfillTest, CountLeadingZeros_vec3_i32) {
  auto* src = R"(
fn f() {
  let r : vec3<i32> = countLeadingZeros(vec3<i32>(15));
}
)";

  auto* expect = R"(
fn tint_count_leading_zeros(v : vec3<i32>) -> vec3<i32> {
  var x = vec3<u32>(v);
  let b16 = select(vec3<u32>(0u), vec3<u32>(16u), (x <= vec3<u32>(65535u)));
  x = (x << b16);
  let b8 = select(vec3<u32>(0u), vec3<u32>(8u), (x <= vec3<u32>(16777215u)));
  x = (x << b8);
  let b4 = select(vec3<u32>(0u), vec3<u32>(4u), (x <= vec3<u32>(268435455u)));
  x = (x << b4);
  let b2 = select(vec3<u32>(0u), vec3<u32>(2u), (x <= vec3<u32>(1073741823u)));
  x = (x << b2);
  let b1 = select(vec3<u32>(0u), vec3<u32>(1u), (x <= vec3<u32>(2147483647u)));
  let is_zero = select(vec3<u32>(0u), vec3<u32>(1u), (x == vec3<u32>(0u)));
  return vec3<i32>((((((b16 | b8) | b4) | b2) | b1) + is_zero));
}

fn f() {
  let r : vec3<i32> = tint_count_leading_zeros(vec3<i32>(15));
}
)";

  auto got = Run<BuiltinPolyfill>(src, polyfillCountLeadingZeros());

  EXPECT_EQ(expect, str(got));
}

TEST_F(BuiltinPolyfillTest, CountLeadingZeros_vec3_u32) {
  auto* src = R"(
fn f() {
  let r : vec3<u32> = countLeadingZeros(vec3<u32>(15u));
}
)";

  auto* expect = R"(
fn tint_count_leading_zeros(v : vec3<u32>) -> vec3<u32> {
  var x = vec3<u32>(v);
  let b16 = select(vec3<u32>(0u), vec3<u32>(16u), (x <= vec3<u32>(65535u)));
  x = (x << b16);
  let b8 = select(vec3<u32>(0u), vec3<u32>(8u), (x <= vec3<u32>(16777215u)));
  x = (x << b8);
  let b4 = select(vec3<u32>(0u), vec3<u32>(4u), (x <= vec3<u32>(268435455u)));
  x = (x << b4);
  let b2 = select(vec3<u32>(0u), vec3<u32>(2u), (x <= vec3<u32>(1073741823u)));
  x = (x << b2);
  let b1 = select(vec3<u32>(0u), vec3<u32>(1u), (x <= vec3<u32>(2147483647u)));
  let is_zero = select(vec3<u32>(0u), vec3<u32>(1u), (x == vec3<u32>(0u)));
  return vec3<u32>((((((b16 | b8) | b4) | b2) | b1) + is_zero));
}

fn f() {
  let r : vec3<u32> = tint_count_leading_zeros(vec3<u32>(15u));
}
)";

  auto got = Run<BuiltinPolyfill>(src, polyfillCountLeadingZeros());

  EXPECT_EQ(expect, str(got));
}

////////////////////////////////////////////////////////////////////////////////
// countTrailingZeros
////////////////////////////////////////////////////////////////////////////////
DataMap polyfillCountTrailingZeros() {
  BuiltinPolyfill::Builtins builtins;
  builtins.count_trailing_zeros = true;
  DataMap data;
  data.Add<BuiltinPolyfill::Config>(builtins);
  return data;
}

TEST_F(BuiltinPolyfillTest, ShouldRunCountTrailingZeros) {
  auto* src = R"(
fn f() {
  countTrailingZeros(0xf);
}
)";

  EXPECT_FALSE(ShouldRun<BuiltinPolyfill>(src));
  EXPECT_TRUE(ShouldRun<BuiltinPolyfill>(src, polyfillCountTrailingZeros()));
}

TEST_F(BuiltinPolyfillTest, CountTrailingZeros_i32) {
  auto* src = R"(
fn f() {
  let r : i32 = countTrailingZeros(15);
}
)";

  auto* expect = R"(
fn tint_count_trailing_zeros(v : i32) -> i32 {
  var x = u32(v);
  let b16 = select(16u, 0u, bool((x & 65535u)));
  x = (x >> b16);
  let b8 = select(8u, 0u, bool((x & 255u)));
  x = (x >> b8);
  let b4 = select(4u, 0u, bool((x & 15u)));
  x = (x >> b4);
  let b2 = select(2u, 0u, bool((x & 3u)));
  x = (x >> b2);
  let b1 = select(1u, 0u, bool((x & 1u)));
  let is_zero = select(0u, 1u, (x == 0u));
  return i32((((((b16 | b8) | b4) | b2) | b1) + is_zero));
}

fn f() {
  let r : i32 = tint_count_trailing_zeros(15);
}
)";

  auto got = Run<BuiltinPolyfill>(src, polyfillCountTrailingZeros());

  EXPECT_EQ(expect, str(got));
}

TEST_F(BuiltinPolyfillTest, CountTrailingZeros_u32) {
  auto* src = R"(
fn f() {
  let r : u32 = countTrailingZeros(15u);
}
)";

  auto* expect = R"(
fn tint_count_trailing_zeros(v : u32) -> u32 {
  var x = u32(v);
  let b16 = select(16u, 0u, bool((x & 65535u)));
  x = (x >> b16);
  let b8 = select(8u, 0u, bool((x & 255u)));
  x = (x >> b8);
  let b4 = select(4u, 0u, bool((x & 15u)));
  x = (x >> b4);
  let b2 = select(2u, 0u, bool((x & 3u)));
  x = (x >> b2);
  let b1 = select(1u, 0u, bool((x & 1u)));
  let is_zero = select(0u, 1u, (x == 0u));
  return u32((((((b16 | b8) | b4) | b2) | b1) + is_zero));
}

fn f() {
  let r : u32 = tint_count_trailing_zeros(15u);
}
)";

  auto got = Run<BuiltinPolyfill>(src, polyfillCountTrailingZeros());

  EXPECT_EQ(expect, str(got));
}

TEST_F(BuiltinPolyfillTest, CountTrailingZeros_vec3_i32) {
  auto* src = R"(
fn f() {
  let r : vec3<i32> = countTrailingZeros(vec3<i32>(15));
}
)";

  auto* expect = R"(
fn tint_count_trailing_zeros(v : vec3<i32>) -> vec3<i32> {
  var x = vec3<u32>(v);
  let b16 = select(vec3<u32>(16u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(65535u))));
  x = (x >> b16);
  let b8 = select(vec3<u32>(8u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(255u))));
  x = (x >> b8);
  let b4 = select(vec3<u32>(4u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(15u))));
  x = (x >> b4);
  let b2 = select(vec3<u32>(2u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(3u))));
  x = (x >> b2);
  let b1 = select(vec3<u32>(1u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(1u))));
  let is_zero = select(vec3<u32>(0u), vec3<u32>(1u), (x == vec3<u32>(0u)));
  return vec3<i32>((((((b16 | b8) | b4) | b2) | b1) + is_zero));
}

fn f() {
  let r : vec3<i32> = tint_count_trailing_zeros(vec3<i32>(15));
}
)";

  auto got = Run<BuiltinPolyfill>(src, polyfillCountTrailingZeros());

  EXPECT_EQ(expect, str(got));
}

TEST_F(BuiltinPolyfillTest, CountTrailingZeros_vec3_u32) {
  auto* src = R"(
fn f() {
  let r : vec3<u32> = countTrailingZeros(vec3<u32>(15u));
}
)";

  auto* expect = R"(
fn tint_count_trailing_zeros(v : vec3<u32>) -> vec3<u32> {
  var x = vec3<u32>(v);
  let b16 = select(vec3<u32>(16u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(65535u))));
  x = (x >> b16);
  let b8 = select(vec3<u32>(8u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(255u))));
  x = (x >> b8);
  let b4 = select(vec3<u32>(4u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(15u))));
  x = (x >> b4);
  let b2 = select(vec3<u32>(2u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(3u))));
  x = (x >> b2);
  let b1 = select(vec3<u32>(1u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(1u))));
  let is_zero = select(vec3<u32>(0u), vec3<u32>(1u), (x == vec3<u32>(0u)));
  return vec3<u32>((((((b16 | b8) | b4) | b2) | b1) + is_zero));
}

fn f() {
  let r : vec3<u32> = tint_count_trailing_zeros(vec3<u32>(15u));
}
)";

  auto got = Run<BuiltinPolyfill>(src, polyfillCountTrailingZeros());

  EXPECT_EQ(expect, str(got));
}

////////////////////////////////////////////////////////////////////////////////
// firstTrailingBit
////////////////////////////////////////////////////////////////////////////////
DataMap polyfillFirstTrailingBit() {
  BuiltinPolyfill::Builtins builtins;
  builtins.first_trailing_bit = true;
  DataMap data;
  data.Add<BuiltinPolyfill::Config>(builtins);
  return data;
}

TEST_F(BuiltinPolyfillTest, ShouldRunFirstTrailingBit) {
  auto* src = R"(
fn f() {
  firstTrailingBit(0xf);
}
)";

  EXPECT_FALSE(ShouldRun<BuiltinPolyfill>(src));
  EXPECT_TRUE(ShouldRun<BuiltinPolyfill>(src, polyfillFirstTrailingBit()));
}

TEST_F(BuiltinPolyfillTest, FirstTrailingBit_i32) {
  auto* src = R"(
fn f() {
  let r : i32 = firstTrailingBit(15);
}
)";

  auto* expect = R"(
fn tint_first_trailing_bit(v : i32) -> i32 {
  var x = u32(v);
  let b16 = select(16u, 0u, bool((x & 65535u)));
  x = (x >> b16);
  let b8 = select(8u, 0u, bool((x & 255u)));
  x = (x >> b8);
  let b4 = select(4u, 0u, bool((x & 15u)));
  x = (x >> b4);
  let b2 = select(2u, 0u, bool((x & 3u)));
  x = (x >> b2);
  let b1 = select(1u, 0u, bool((x & 1u)));
  let is_zero = select(0u, 4294967295u, (x == 0u));
  return i32((((((b16 | b8) | b4) | b2) | b1) | is_zero));
}

fn f() {
  let r : i32 = tint_first_trailing_bit(15);
}
)";

  auto got = Run<BuiltinPolyfill>(src, polyfillFirstTrailingBit());

  EXPECT_EQ(expect, str(got));
}

TEST_F(BuiltinPolyfillTest, FirstTrailingBit_u32) {
  auto* src = R"(
fn f() {
  let r : u32 = firstTrailingBit(15u);
}
)";

  auto* expect = R"(
fn tint_first_trailing_bit(v : u32) -> u32 {
  var x = u32(v);
  let b16 = select(16u, 0u, bool((x & 65535u)));
  x = (x >> b16);
  let b8 = select(8u, 0u, bool((x & 255u)));
  x = (x >> b8);
  let b4 = select(4u, 0u, bool((x & 15u)));
  x = (x >> b4);
  let b2 = select(2u, 0u, bool((x & 3u)));
  x = (x >> b2);
  let b1 = select(1u, 0u, bool((x & 1u)));
  let is_zero = select(0u, 4294967295u, (x == 0u));
  return u32((((((b16 | b8) | b4) | b2) | b1) | is_zero));
}

fn f() {
  let r : u32 = tint_first_trailing_bit(15u);
}
)";

  auto got = Run<BuiltinPolyfill>(src, polyfillFirstTrailingBit());

  EXPECT_EQ(expect, str(got));
}

TEST_F(BuiltinPolyfillTest, FirstTrailingBit_vec3_i32) {
  auto* src = R"(
fn f() {
  let r : vec3<i32> = firstTrailingBit(vec3<i32>(15));
}
)";

  auto* expect = R"(
fn tint_first_trailing_bit(v : vec3<i32>) -> vec3<i32> {
  var x = vec3<u32>(v);
  let b16 = select(vec3<u32>(16u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(65535u))));
  x = (x >> b16);
  let b8 = select(vec3<u32>(8u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(255u))));
  x = (x >> b8);
  let b4 = select(vec3<u32>(4u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(15u))));
  x = (x >> b4);
  let b2 = select(vec3<u32>(2u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(3u))));
  x = (x >> b2);
  let b1 = select(vec3<u32>(1u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(1u))));
  let is_zero = select(vec3<u32>(0u), vec3<u32>(4294967295u), (x == vec3<u32>(0u)));
  return vec3<i32>((((((b16 | b8) | b4) | b2) | b1) | is_zero));
}

fn f() {
  let r : vec3<i32> = tint_first_trailing_bit(vec3<i32>(15));
}
)";

  auto got = Run<BuiltinPolyfill>(src, polyfillFirstTrailingBit());

  EXPECT_EQ(expect, str(got));
}

TEST_F(BuiltinPolyfillTest, FirstTrailingBit_vec3_u32) {
  auto* src = R"(
fn f() {
  let r : vec3<u32> = firstTrailingBit(vec3<u32>(15u));
}
)";

  auto* expect = R"(
fn tint_first_trailing_bit(v : vec3<u32>) -> vec3<u32> {
  var x = vec3<u32>(v);
  let b16 = select(vec3<u32>(16u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(65535u))));
  x = (x >> b16);
  let b8 = select(vec3<u32>(8u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(255u))));
  x = (x >> b8);
  let b4 = select(vec3<u32>(4u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(15u))));
  x = (x >> b4);
  let b2 = select(vec3<u32>(2u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(3u))));
  x = (x >> b2);
  let b1 = select(vec3<u32>(1u), vec3<u32>(0u), vec3<bool>((x & vec3<u32>(1u))));
  let is_zero = select(vec3<u32>(0u), vec3<u32>(4294967295u), (x == vec3<u32>(0u)));
  return vec3<u32>((((((b16 | b8) | b4) | b2) | b1) | is_zero));
}

fn f() {
  let r : vec3<u32> = tint_first_trailing_bit(vec3<u32>(15u));
}
)";

  auto got = Run<BuiltinPolyfill>(src, polyfillFirstTrailingBit());

  EXPECT_EQ(expect, str(got));
}

}  // namespace
}  // namespace transform
}  // namespace tint
