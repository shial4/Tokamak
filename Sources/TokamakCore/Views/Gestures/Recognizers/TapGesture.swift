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
    public typealias Ended = Void
    public typealias State = Bool
    public typealias Body = Self
    
    /// The required number of taps to complete the tap gesture.
    private var count: Int
    /// The maximum duration between the taps
    private var delay: Double = 0.3
    private var touchEndTime = Date()
    
    public var gestureValue: GestureValue<Int> = .init(phase: .none, value: 0) {
        didSet {
            // Recognise touch down with in a view
            if case .began = gestureValue.phase {
                // If current phase is completed start from the beginign
                if case .completed = oldValue.phase {
                    gestureValue.value = 0
                }
            }
            // Recognise touch up with in a view
            else if case .ended = gestureValue.phase, case .began = oldValue.phase {
                let touch = Date()
                let delayInSeconds = touch.timeIntervalSince(touchEndTime)
                touchEndTime = touch
            
                // If we have multi count tap gesture, handle it if the taps are with in desired delays
                if gestureValue.value > 0, delayInSeconds > delay {
                    gestureValue.value = 0
                } else {
                    gestureValue.value += 1
                }
            } else {
                gestureValue.value = 0
            }
            
            // If we ended touch and have desired count we complete gesture
            if case .ended = gestureValue.phase, count == gestureValue.value {
                gestureValue.phase = .completed
            }
        }
    }
    
    /// Creates a tap gesture with the number of required taps.
    /// - Parameter count: The required number of taps to complete the tap gesture.
    public init(count: Int = 1) {
        self.count = count
    }
}

// MARK: View Modifiers

extension View {
    /// Adds an action to perform when this view recognizes a tap gesture.
    public func onTapGesture(count: Int = 1, perform action: @escaping () -> Void) -> some View {
        self.gesture(
            TapGesture(count: count).onEnded(action)
        )
    }
}
