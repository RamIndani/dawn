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

#ifndef SRC_TINT_IR_BUILDER_H_
#define SRC_TINT_IR_BUILDER_H_

#include "src/tint/ir/constant.h"
#include "src/tint/ir/function.h"
#include "src/tint/ir/if.h"
#include "src/tint/ir/instruction.h"
#include "src/tint/ir/loop.h"
#include "src/tint/ir/module.h"
#include "src/tint/ir/switch.h"
#include "src/tint/ir/temp.h"
#include "src/tint/ir/terminator.h"
#include "src/tint/ir/value.h"

// Forward Declarations
namespace tint {
class Program;
}  // namespace tint
namespace tint::ast {
class CaseSelector;
}  // namespace tint::ast

namespace tint::ir {

/// Builds an ir::Module from a given Program
class Builder {
  public:
    /// Constructor
    /// @param prog the program this ir is associated with
    explicit Builder(const Program* prog);
    /// Constructor
    /// @param mod the ir::Module to wrap with this builder
    explicit Builder(Module&& mod);
    /// Destructor
    ~Builder();

    /// @returns a new block flow node
    Block* CreateBlock();

    /// @returns a new terminator flow node
    Terminator* CreateTerminator();

    /// Creates a function flow node for the given ast::Function
    /// @param func the ast::Function
    /// @returns the flow node
    Function* CreateFunction(const ast::Function* func);

    /// Creates an if flow node for the given ast::IfStatement or ast::BreakIfStatement
    /// @param stmt the ast::IfStatement or ast::BreakIfStatement
    /// @returns the flow node
    If* CreateIf(const ast::Statement* stmt);

    /// Creates a loop flow node for the given ast loop, while or for statement
    /// @param stmt the ast loop, while or for statement
    /// @returns the flow node
    Loop* CreateLoop(const ast::Statement* stmt);

    /// Creates a switch flow node for the given ast::SwitchStatement
    /// @param stmt the ast::SwitchStatment
    /// @returns the flow node
    Switch* CreateSwitch(const ast::SwitchStatement* stmt);

    /// Creates a case flow node for the given case branch.
    /// @param s the switch to create the case into
    /// @param selectors the case selectors for the case statement
    /// @returns the start block for the case flow node
    Block* CreateCase(Switch* s, const utils::VectorRef<const ast::CaseSelector*> selectors);

    /// Branches the given block to the given flow node.
    /// @param from the block to branch from
    /// @param to the node to branch too
    void Branch(Block* from, FlowNode* to);

    /// Creates a new Constant
    /// @param val the constant value
    /// @returns the new constant
    template <typename T>
    const ir::Constant* Constant(T val) {
        return ir.values.Create<ir::Constant>(val);
    }

    /// Creates a new Temporary
    /// @returns the new temporary
    const ir::Temp* Temp() { return ir.values.Create<ir::Temp>(AllocateTempId()); }

    /// Creates an op for `lhs kind rhs`
    /// @param kind the kind of operation
    /// @param lhs the left-hand-side of the operation
    /// @param rhs the right-hand-side of the operation
    /// @returns the operation
    Instruction CreateInstruction(Instruction::Kind kind, const Value* lhs, const Value* rhs);

    /// Creates an And operation
    /// @param lhs the lhs of the add
    /// @param rhs the rhs of the add
    /// @returns the operation
    Instruction And(const Value* lhs, const Value* rhs);

    /// Creates an Or operation
    /// @param lhs the lhs of the add
    /// @param rhs the rhs of the add
    /// @returns the operation
    Instruction Or(const Value* lhs, const Value* rhs);

    /// Creates an Xor operation
    /// @param lhs the lhs of the add
    /// @param rhs the rhs of the add
    /// @returns the operation
    Instruction Xor(const Value* lhs, const Value* rhs);

    /// Creates an LogicalAnd operation
    /// @param lhs the lhs of the add
    /// @param rhs the rhs of the add
    /// @returns the operation
    Instruction LogicalAnd(const Value* lhs, const Value* rhs);

    /// Creates an LogicalOr operation
    /// @param lhs the lhs of the add
    /// @param rhs the rhs of the add
    /// @returns the operation
    Instruction LogicalOr(const Value* lhs, const Value* rhs);

    /// Creates an Equal operation
    /// @param lhs the lhs of the add
    /// @param rhs the rhs of the add
    /// @returns the operation
    Instruction Equal(const Value* lhs, const Value* rhs);

    /// Creates an NotEqual operation
    /// @param lhs the lhs of the add
    /// @param rhs the rhs of the add
    /// @returns the operation
    Instruction NotEqual(const Value* lhs, const Value* rhs);

    /// Creates an LessThan operation
    /// @param lhs the lhs of the add
    /// @param rhs the rhs of the add
    /// @returns the operation
    Instruction LessThan(const Value* lhs, const Value* rhs);

    /// Creates an GreaterThan operation
    /// @param lhs the lhs of the add
    /// @param rhs the rhs of the add
    /// @returns the operation
    Instruction GreaterThan(const Value* lhs, const Value* rhs);

    /// Creates an LessThanEqual operation
    /// @param lhs the lhs of the add
    /// @param rhs the rhs of the add
    /// @returns the operation
    Instruction LessThanEqual(const Value* lhs, const Value* rhs);

    /// Creates an GreaterThanEqual operation
    /// @param lhs the lhs of the add
    /// @param rhs the rhs of the add
    /// @returns the operation
    Instruction GreaterThanEqual(const Value* lhs, const Value* rhs);

    /// Creates an ShiftLeft operation
    /// @param lhs the lhs of the add
    /// @param rhs the rhs of the add
    /// @returns the operation
    Instruction ShiftLeft(const Value* lhs, const Value* rhs);

    /// Creates an ShiftRight operation
    /// @param lhs the lhs of the add
    /// @param rhs the rhs of the add
    /// @returns the operation
    Instruction ShiftRight(const Value* lhs, const Value* rhs);

    /// Creates an Add operation
    /// @param lhs the lhs of the add
    /// @param rhs the rhs of the add
    /// @returns the operation
    Instruction Add(const Value* lhs, const Value* rhs);

    /// Creates an Subtract operation
    /// @param lhs the lhs of the add
    /// @param rhs the rhs of the add
    /// @returns the operation
    Instruction Subtract(const Value* lhs, const Value* rhs);

    /// Creates an Multiply operation
    /// @param lhs the lhs of the add
    /// @param rhs the rhs of the add
    /// @returns the operation
    Instruction Multiply(const Value* lhs, const Value* rhs);

    /// Creates an Divide operation
    /// @param lhs the lhs of the add
    /// @param rhs the rhs of the add
    /// @returns the operation
    Instruction Divide(const Value* lhs, const Value* rhs);

    /// Creates an Modulo operation
    /// @param lhs the lhs of the add
    /// @param rhs the rhs of the add
    /// @returns the operation
    Instruction Modulo(const Value* lhs, const Value* rhs);

    /// @returns a unique temp id
    Temp::Id AllocateTempId();

    /// The IR module.
    Module ir;

    /// The next temporary number to allocate
    Temp::Id next_temp_id = 1;
};

}  // namespace tint::ir

#endif  // SRC_TINT_IR_BUILDER_H_
