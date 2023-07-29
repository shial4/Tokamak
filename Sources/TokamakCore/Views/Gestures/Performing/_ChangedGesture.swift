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

public struct _ChangedGesture<G>: Gesture where G: Gesture {
    public typealias Body = G
    
    public var gesture: G
    public let action: (G.Value) -> Void
    public var state: GestureValue<G.Value> {
        get {
            gesture.state
        }
        set {
            gesture.state = newValue
            
            // If gesture changed, trigger change action
            if case .changed = gesture.phase {
                action(gesture.value)
            }
        }
    }
    
    init(gesture: G, action: @escaping (Value) -> Void) {
        self.gesture = gesture
        self.action = action
    }
}
