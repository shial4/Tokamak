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
    
    private var _state: Int = 0
    public var state: Int {
        get {
            return _state
        }
        set {
            print("🟢 TapGesture set state", newValue, _state, phase)
            guard newValue > 0 else { return }
            let touch = Date()
            let delayInSeconds = touch.timeIntervalSince(touchTime)
            phase = .changed
            touchTime = touch
            
            print("🟢 TapGesture delayInSeconds", delayInSeconds)
            _state = newValue
            if delayInSeconds > delay {
                _state = 0
            } else if newValue == count {
                phase = .ended
            }
        }
    }
    public var phase: GesturePhase = .none {
        didSet {
            print("🚀 phase", phase)
        }
    }
    private var count: Int
    private var delay: Double
    private var touchTime = Date()
    
    /// Creates a tap gesture with the number of required taps.
    /// - Parameter count: The required number of taps to complete the tap gesture.
    /// - Parameter delay: The maximum duration between the taps
    public init(count: Int = 1, delay: Double = 0.3) {
        self.count = count
        self.delay = delay
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
