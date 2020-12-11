// Copyright 2020 The Tint Authors.
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

#include "src/ast/call_expression.h"

#include "src/ast/identifier_expression.h"
#include "src/ast/test_helper.h"

namespace tint {
namespace ast {
namespace {

using CallExpressionTest = TestHelper;

TEST_F(CallExpressionTest, Creation) {
  auto* func = create<IdentifierExpression>(mod.RegisterSymbol("func"), "func");
  ExpressionList params;
  params.push_back(
      create<IdentifierExpression>(mod.RegisterSymbol("param1"), "param1"));
  params.push_back(
      create<IdentifierExpression>(mod.RegisterSymbol("param2"), "param2"));

  CallExpression stmt(func, params);
  EXPECT_EQ(stmt.func(), func);

  const auto& vec = stmt.params();
  ASSERT_EQ(vec.size(), 2u);
  EXPECT_EQ(vec[0], params[0]);
  EXPECT_EQ(vec[1], params[1]);
}

TEST_F(CallExpressionTest, Creation_WithSource) {
  auto* func = create<IdentifierExpression>(mod.RegisterSymbol("func"), "func");
  CallExpression stmt(Source{Source::Location{20, 2}}, func, {});
  auto src = stmt.source();
  EXPECT_EQ(src.range.begin.line, 20u);
  EXPECT_EQ(src.range.begin.column, 2u);
}

TEST_F(CallExpressionTest, IsCall) {
  auto* func = create<IdentifierExpression>(mod.RegisterSymbol("func"), "func");
  CallExpression stmt(func, {});
  EXPECT_TRUE(stmt.Is<CallExpression>());
}

TEST_F(CallExpressionTest, IsValid) {
  auto* func = create<IdentifierExpression>(mod.RegisterSymbol("func"), "func");
  CallExpression stmt(func, {});
  EXPECT_TRUE(stmt.IsValid());
}

TEST_F(CallExpressionTest, IsValid_MissingFunction) {
  CallExpression stmt(nullptr, {});
  EXPECT_FALSE(stmt.IsValid());
}

TEST_F(CallExpressionTest, IsValid_NullParam) {
  auto* func = create<IdentifierExpression>(mod.RegisterSymbol("func"), "func");
  ExpressionList params;
  params.push_back(
      create<IdentifierExpression>(mod.RegisterSymbol("param1"), "param1"));
  params.push_back(nullptr);
  params.push_back(
      create<IdentifierExpression>(mod.RegisterSymbol("param2"), "param2"));

  CallExpression stmt(func, params);
  EXPECT_FALSE(stmt.IsValid());
}

TEST_F(CallExpressionTest, IsValid_InvalidFunction) {
  auto* func = create<IdentifierExpression>(mod.RegisterSymbol(""), "");
  ExpressionList params;
  params.push_back(
      create<IdentifierExpression>(mod.RegisterSymbol("param1"), "param1"));

  CallExpression stmt(func, params);
  EXPECT_FALSE(stmt.IsValid());
}

TEST_F(CallExpressionTest, IsValid_InvalidParam) {
  auto* func = create<IdentifierExpression>(mod.RegisterSymbol("func"), "func");
  ExpressionList params;
  params.push_back(create<IdentifierExpression>(mod.RegisterSymbol(""), ""));

  CallExpression stmt(func, params);
  EXPECT_FALSE(stmt.IsValid());
}

TEST_F(CallExpressionTest, ToStr_NoParams) {
  auto* func = create<IdentifierExpression>(mod.RegisterSymbol("func"), "func");
  CallExpression stmt(func, {});
  std::ostringstream out;
  stmt.to_str(out, 2);
  EXPECT_EQ(demangle(out.str()), R"(  Call[not set]{
    Identifier[not set]{func}
    (
    )
  }
)");
}

TEST_F(CallExpressionTest, ToStr_WithParams) {
  auto* func = create<IdentifierExpression>(mod.RegisterSymbol("func"), "func");
  ExpressionList params;
  params.push_back(
      create<IdentifierExpression>(mod.RegisterSymbol("param1"), "param1"));
  params.push_back(
      create<IdentifierExpression>(mod.RegisterSymbol("param2"), "param2"));

  CallExpression stmt(func, params);
  std::ostringstream out;
  stmt.to_str(out, 2);
  EXPECT_EQ(demangle(out.str()), R"(  Call[not set]{
    Identifier[not set]{func}
    (
      Identifier[not set]{param1}
      Identifier[not set]{param2}
    )
  }
)");
}

}  // namespace
}  // namespace ast
}  // namespace tint
