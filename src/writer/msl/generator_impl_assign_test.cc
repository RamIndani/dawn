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

#include <memory>
#include <vector>

#include "gtest/gtest.h"
#include "src/ast/assignment_statement.h"
#include "src/ast/identifier_expression.h"
#include "src/ast/module.h"
#include "src/writer/msl/generator_impl.h"
#include "src/writer/msl/test_helper.h"

namespace tint {
namespace writer {
namespace msl {
namespace {

using MslGeneratorImplTest = TestHelper;

TEST_F(MslGeneratorImplTest, Emit_Assign) {
  auto* lhs =
      create<ast::IdentifierExpression>(mod.RegisterSymbol("lhs"), "lhs");
  auto* rhs =
      create<ast::IdentifierExpression>(mod.RegisterSymbol("rhs"), "rhs");
  ast::AssignmentStatement assign(lhs, rhs);

  gen.increment_indent();

  ASSERT_TRUE(gen.EmitStatement(&assign)) << gen.error();
  EXPECT_EQ(gen.result(), "  lhs = rhs;\n");
}

}  // namespace
}  // namespace msl
}  // namespace writer
}  // namespace tint
