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

public struct GestureStateGesture<G, Value>: Gesture where G: Gesture {
    public typealias Body = G.Body
    
    public var gesture: G
    public var gestureState: GestureState<Value>
    public var state: GestureValue<G.Value> {
        get {
            gesture.state
        }
        set {
            gesture.state = newValue
            if let value = gesture.value as? Value {
                gestureState.value = value
            }
        }
    }
    
    init(gesture: G, gestureState: GestureState<Value>) {
        self.gesture = gesture
        self.gestureState = gestureState
    }
}
