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

#ifndef SRC_TRANSFORM_TRANSFORM_H_
#define SRC_TRANSFORM_TRANSFORM_H_

#include <memory>
#include <unordered_map>
#include <utility>

#include "src/program.h"

namespace tint {
namespace transform {

/// Data is the base class for transforms that accept extra input or emit extra
/// output information along with a Program.
class Data : public Castable<Data> {
 public:
  /// Constructor
  Data();

  /// Copy constructor
  Data(const Data&);

  /// Destructor
  ~Data() override;

  /// Assignment operator
  /// @returns this Data
  Data& operator=(const Data&);
};

/// DataMap is a map of Data unique pointers keyed by the Data's ClassID.
class DataMap {
 public:
  /// Constructor
  DataMap();

  /// Move constructor
  DataMap(DataMap&&);

  /// Constructor
  /// @param data_unique_ptrs a variadic list of additional data unique_ptrs
  /// produced by the transform
  template <typename... DATA>
  explicit DataMap(DATA... data_unique_ptrs) {
    PutAll(std::forward<DATA>(data_unique_ptrs)...);
  }

  /// Destructor
  ~DataMap();

  /// Move assignment operator
  /// @param rhs the DataMap to move into this DataMap
  /// @return this DataMap
  DataMap& operator=(DataMap&& rhs);

  /// Adds the data into DataMap keyed by the ClassID of type T.
  /// @param data the data to add to the DataMap
  template <typename T>
  void Put(std::unique_ptr<T>&& data) {
    static_assert(std::is_base_of<Data, T>::value,
                  "T does not derive from Data");
    map_[&TypeInfo::Of<T>()] = std::move(data);
  }

  /// Creates the data of type `T` with the provided arguments and adds it into
  /// DataMap keyed by the ClassID of type T.
  /// @param args the arguments forwarded to the constructor for type T
  template <typename T, typename... ARGS>
  void Add(ARGS&&... args) {
    Put(std::make_unique<T>(std::forward<ARGS>(args)...));
  }

  /// @returns a pointer to the Data placed into the DataMap with a call to
  /// Put()
  template <typename T>
  T const* Get() const {
    auto it = map_.find(&TypeInfo::Of<T>());
    if (it == map_.end()) {
      return nullptr;
    }
    return static_cast<T*>(it->second.get());
  }

  /// Add moves all the data from other into this DataMap
  /// @param other the DataMap to move into this DataMap
  void Add(DataMap&& other) {
    for (auto& it : other.map_) {
      map_.emplace(it.first, std::move(it.second));
    }
    other.map_.clear();
  }

 private:
  template <typename T0>
  void PutAll(T0&& first) {
    Put(std::forward<T0>(first));
  }

  template <typename T0, typename... Tn>
  void PutAll(T0&& first, Tn&&... remainder) {
    Put(std::forward<T0>(first));
    PutAll(std::forward<Tn>(remainder)...);
  }

  std::unordered_map<const TypeInfo*, std::unique_ptr<Data>> map_;
};

/// The return type of Run()
class Output {
 public:
  /// Constructor
  Output();

  /// Constructor
  /// @param program the program to move into this Output
  explicit Output(Program&& program);

  /// Constructor
  /// @param program_ the program to move into this Output
  /// @param data_ a variadic list of additional data unique_ptrs produced by
  /// the transform
  template <typename... DATA>
  Output(Program&& program_, DATA... data_)
      : program(std::move(program_)), data(std::forward<DATA>(data_)...) {}

  /// The transformed program. May be empty on error.
  Program program;

  /// Extra output generated by the transforms.
  DataMap data;
};

/// Interface for Program transforms
class Transform {
 public:
  /// Constructor
  Transform();
  /// Destructor
  virtual ~Transform();

  /// Runs the transform on `program`, returning the transformation result.
  /// @param program the source program to transform
  /// @param data optional extra transform-specific input data
  /// @returns the transformation result
  virtual Output Run(const Program* program, const DataMap& data = {}) = 0;

 protected:
  /// Clones the function `in` adding `statements` to the beginning of the
  /// cloned function body.
  /// @param ctx the clone context
  /// @param in the function to clone
  /// @param statements the statements to prepend to `in`'s body
  /// @return the cloned function
  static ast::Function* CloneWithStatementsAtStart(
      CloneContext* ctx,
      ast::Function* in,
      ast::StatementList statements);

  /// Clones the decoration list `in`, removing decorations based on a filter.
  /// @param ctx the clone context
  /// @param in the decorations to clone
  /// @param should_remove the function to select which decorations to remove
  /// @return the cloned decorations
  static ast::DecorationList RemoveDecorations(
      CloneContext* ctx,
      const ast::DecorationList& in,
      std::function<bool(const ast::Decoration*)> should_remove);
};

}  // namespace transform
}  // namespace tint

#endif  // SRC_TRANSFORM_TRANSFORM_H_
