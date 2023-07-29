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

public struct LongPressGesture: Gesture {
    public typealias Body = Self
    
    private var minimumDuration: Double
    private var maximumDistance: Double = 0
    private var touchStartTime = Date()
    public var state: GestureValue<Bool> = .init(phase: .none, value: false) {
        didSet {
            // Recognise touch down with in a view
            if case .began = state.phase {
                state.value = false
                touchStartTime = Date()
                print("✅", state.phase, state.value)
            }
            
            let touch = Date()
            let delayInSeconds = touch.timeIntervalSince(touchStartTime)
            
            if case .changed = state.phase {
                print("🟤", state.phase, state.value)
            }
            
            if case .changed = state.phase, minimumDuration < delayInSeconds  {
                state.value = true
            }
            
            // If we ended touch and have desired count we complete gesture
            if case .ended = state.phase, minimumDuration < delayInSeconds  {
                print("✅", state.phase, state.value)
                state.phase = .completed
            }
        }
    }
    
    /// Creates a long-press gesture with a minimum duration
    /// - Parameter minimumDuration: The minimum duration of the long press that must elapse before the gesture succeeds.
    public init(minimumDuration: Double = 0.5) {
        self.minimumDuration = minimumDuration
    }
    
    /// Creates a long-press gesture with a minimum duration and a maximum distance that the interaction can move before the gesture fails.
    /// - Parameters:
    ///   - minimumDuration: The minimum duration of the long press that must elapse before the gesture succeeds.
    ///   - maximumDistance: The maximum distance that the long press can move before the gesture fails.
    public init(minimumDuration: Double, maximumDistance: Double) {
        self.minimumDuration = minimumDuration
        self.maximumDistance = maximumDistance
    }
    
    private func calculateDistance(xOffset: Double, yOffset: Double) -> Double {
        let xSquared = pow(xOffset, 2)
        let ySquared = pow(yOffset, 2)
        let sumOfSquares = xSquared + ySquared
        let distance = sqrt(sumOfSquares)
        return distance
    }
}

extension View {
    /// Adds an action to perform when this view recognizes a remote long touch gesture.
    /// A long touch gesture is when the finger is on the remote touch surface without actually pressing.
    public func onLongPressGesture(perform action: @escaping () -> Void) -> some View {
        self.modifier(LongPressGestureModifier(action: action))
    }
    
    /// Adds an action to perform when this view recognizes a long press gesture.
    public func onLongPressGesture(
        minimumDuration: Double,
        maximumDistance: Double,
        perform action: @escaping () -> Void,
        onPressingChanged: ((Bool) -> Void)?
    ) -> some View {
        self.modifier(
            LongPressGestureModifier(
                minimumDuration: minimumDuration,
                maximumDistance: maximumDistance,
                onPressingChanged: onPressingChanged,
                action: action
            )
        )
    }
    
    /// Adds an action to perform when this view recognizes a long press gesture.
    public func onLongPressGesture(
        minimumDuration: Double = 0.5,
        maximumDistance: Double = 10.0,
        pressing: ((LongPressGesture.Value) -> Void)? = nil,
        perform action: @escaping () -> Void
    ) -> some View {
        self.modifier(
            LongPressGestureModifier(minimumDuration: minimumDuration,
                                     maximumDistance: maximumDistance,
                                     onPressingChanged: pressing,
                                     action: action
                                    )
        )
    }
}

struct LongPressGestureModifier: ViewModifier {
    var minimumDuration: Double = 0.5
    var maximumDistance: Double = 10.0
    var onPressingChanged: ((LongPressGesture.Value) -> Void)? = nil
    let action: () -> Void
    
    @GestureState private var isPressing = false
    
    func body(content: Content) -> some View {
        content.gesture(
            LongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance)
                .updating($isPressing) { currentState, gestureState, _ in
                    gestureState = currentState
                    onPressingChanged?(currentState)
                }
                .onEnded { _ in
                    action()
                }
        )
    }
}
