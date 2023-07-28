// Copyright 2020 Tokamak contributors
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
//
//  Created by Szymon on 16/7/2023.
//

@propertyWrapper
public struct GestureState<Value> {
    public var value: Value

    public init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    public var wrappedValue: Value {
        get { value }
        mutating set { value = newValue }
    }

    public var projectedValue: GestureState<Value> {
        self
    }

    struct Setter {
        private var _value: Value

        init(_ value: Value) {
            self._value = value
        }

        var wrappedValue: Value {
            get { _value }
            mutating set { _value = newValue }
        }
    }
}
