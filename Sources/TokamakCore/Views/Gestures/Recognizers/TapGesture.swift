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

import Foundation

public struct TapGesture: Gesture {
    public typealias Body = Self
    
    /// The required number of taps to complete the tap gesture.
    private var count: Int
    /// The maximum duration between the taps
    private var delay: Double = 0.3
    private var touchTime = Date()
    
    public var state: Int = 0
    public var phase: GesturePhase = .none {
        didSet {
            print("🚀 phase", phase, oldValue)
            
            if case .began = phase {
                touchTime = Date()
            } else if case .ended = phase, case .began = oldValue {
                let touch = Date()
                let delayInSeconds = touch.timeIntervalSince(touchTime)
                
                if delayInSeconds > delay {
                    state = 0
                } else {
                    state += 1
                }
            } else {
                state = 0
            }
        }
    }
    
    /// Creates a tap gesture with the number of required taps.
    /// - Parameter count: The required number of taps to complete the tap gesture.
    public init(count: Int = 1) {
        self.count = count
    }
}

extension View {
    /// Adds an action to perform when this view recognizes a tap gesture.
    public func onTapGesture(count: Int = 1, perform action: @escaping () -> Void) -> some View {
        self.gesture(
            TapGesture(count: count)
                .onEnded { _ in
                    action()
                }
        )
    }
}
