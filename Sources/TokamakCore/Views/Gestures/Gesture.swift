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

public protocol Gesture {
    associatedtype Value
    associatedtype Body: Gesture where Body.Value == Value

    var state: GestureValue<Value> { get set }
}

extension Gesture {
    public var value: Value {
        get {
            state.value
        }
        
        set {
            state.value = newValue
        }
    }

    public var phase: GesturePhase {
        get {
            state.phase
        }
        
        set {
            state.phase = newValue
        }
    }
}

// MARK: Performing the gesture

extension Gesture {
    /// Adds an action to perform when the gesture ends.
    func onEnded(_ action: @escaping (Value) -> Void) -> _EndedGesture<Self> {
        _EndedGesture(gesture: self, action: action)
    }
    
    /// Updates the provided gesture value property as the gesture’s value changes.
    func updating<State>(_ value: GestureState<State>, body: @escaping (Value, inout State, inout Transaction) -> Void) -> GestureStateGesture<Self, State> {
        GestureStateGesture(gesture: self, gestureState: value)
    }
}

extension Gesture where Value: Equatable {
    /// Adds an action to perform when the gesture’s value changes.
    /// Available when Value conforms to Equatable.
    func onChanged(_ action: @escaping (Value) -> Void) -> _ChangedGesture<Self> {
        _ChangedGesture(gesture: self, action: action)
    }
}

// MARK: Composing gestures

extension Gesture {
    /// Combines a gesture with another gesture to create a new gesture that recognizes both gestures at the same time.
    func simultaneously<Other>(with gesture: Other) -> SimultaneousGesture<Self, Other> {
        SimultaneousGesture(first: self, second: gesture)
    }
    
    /// Sequences a gesture with another one to create a new gesture, which results in the second gesture only receiving events after the first gesture succeeds.
    func sequenced<Other>(before gesture: Other) -> SequenceGesture<Self, Other> {
        SequenceGesture(first: self, second: gesture)
    }
    
    /// Combines two gestures exclusively to create a new gesture where only one gesture succeeds, giving precedence to the first gesture.
    func exclusively<Other>(before gesture: Other) -> ExclusiveGesture<Self, Other> {
        ExclusiveGesture(first: self, second: gesture)
    }
}

// MARK: Transforming a gesture

extension Gesture {
    
}
