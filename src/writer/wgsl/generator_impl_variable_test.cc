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

#include "gtest/gtest.h"
#include "src/ast/binding_decoration.h"
#include "src/ast/builtin_decoration.h"
#include "src/ast/constant_id_decoration.h"
#include "src/ast/location_decoration.h"
#include "src/ast/set_decoration.h"
#include "src/ast/type/f32_type.h"
#include "src/ast/variable.h"
#include "src/ast/variable_decoration.h"
#include "src/writer/wgsl/generator_impl.h"
#include "src/writer/wgsl/test_helper.h"

namespace tint {
namespace writer {
namespace wgsl {
namespace {

using WgslGeneratorImplTest = TestHelper;

TEST_F(WgslGeneratorImplTest, EmitVariable) {
  ast::type::F32 f32;
  ast::Variable v(Source{}, "a", ast::StorageClass::kNone, &f32, false, nullptr,
                  ast::VariableDecorationList{});

  ASSERT_TRUE(gen.EmitVariable(&v)) << gen.error();
  EXPECT_EQ(gen.result(), R"(var a : f32;
)");
}

TEST_F(WgslGeneratorImplTest, EmitVariable_StorageClass) {
  ast::type::F32 f32;
  ast::Variable v(Source{}, "a", ast::StorageClass::kInput, &f32, false,
                  nullptr, ast::VariableDecorationList{});

  ASSERT_TRUE(gen.EmitVariable(&v)) << gen.error();
  EXPECT_EQ(gen.result(), R"(var<in> a : f32;
)");
}

TEST_F(WgslGeneratorImplTest, EmitVariable_Decorated) {
  ast::type::F32 f32;

  ast::Variable v(Source{}, "a", ast::StorageClass::kNone, &f32, false, nullptr,
                  ast::VariableDecorationList{
                      create<ast::LocationDecoration>(2, Source{}),
                  });

  ASSERT_TRUE(gen.EmitVariable(&v)) << gen.error();
  EXPECT_EQ(gen.result(), R"([[location(2)]] var a : f32;
)");
}

TEST_F(WgslGeneratorImplTest, EmitVariable_Decorated_Multiple) {
  ast::type::F32 f32;

  ast::Variable v(
      Source{}, "a", ast::StorageClass::kNone, &f32, false, nullptr,
      ast::VariableDecorationList{
          create<ast::BuiltinDecoration>(ast::Builtin::kPosition, Source{}),
          create<ast::BindingDecoration>(0, Source{}),
          create<ast::SetDecoration>(1, Source{}),
          create<ast::LocationDecoration>(2, Source{}),
          create<ast::ConstantIdDecoration>(42, Source{}),
      });

  ASSERT_TRUE(gen.EmitVariable(&v)) << gen.error();
  EXPECT_EQ(
      gen.result(),
      R"([[builtin(position), binding(0), set(1), location(2), constant_id(42)]] var a : f32;
)");
}

TEST_F(WgslGeneratorImplTest, EmitVariable_Constructor) {
  auto* ident = create<ast::IdentifierExpression>(
      mod.RegisterSymbol("initializer"), "initializer");

  ast::type::F32 f32;
  ast::Variable v(Source{}, "a", ast::StorageClass::kNone, &f32, false, ident,
                  ast::VariableDecorationList{});

  ASSERT_TRUE(gen.EmitVariable(&v)) << gen.error();
  EXPECT_EQ(gen.result(), R"(var a : f32 = initializer;
)");
}

TEST_F(WgslGeneratorImplTest, EmitVariable_Const) {
  auto* ident = create<ast::IdentifierExpression>(
      mod.RegisterSymbol("initializer"), "initializer");

  ast::type::F32 f32;
  ast::Variable v(Source{}, "a", ast::StorageClass::kNone, &f32, true, ident,
                  ast::VariableDecorationList{});

  ASSERT_TRUE(gen.EmitVariable(&v)) << gen.error();
  EXPECT_EQ(gen.result(), R"(const a : f32 = initializer;
)");
}

}  // namespace
}  // namespace wgsl
}  // namespace writer
}  // namespace tint
