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
    public typealias Ended = Bool
    public typealias Updating = Bool
    public typealias Body = Self
    
    private var minimumDuration: Double
    private var maximumDistance: Double = 0
    private var isPressed = false
    private var touchStartTime = Date()
    
    public var gestureValue: GestureValue<Bool> = .init(phase: .none, value: false) {
        didSet {
            // Recognise touch down with in a view
            if case .began = gestureValue.phase {
                gestureValue.value = false
                isPressed = true
                touchStartTime = Date()
                print("✅", gestureValue.phase, gestureValue.value)
            }
            
            let touch = Date()
            let delayInSeconds = touch.timeIntervalSince(touchStartTime)
            
            if isPressed, case .changed = gestureValue.phase {
                print("🟤", gestureValue.phase, gestureValue.value)
            }
            
            if isPressed, case .changed = gestureValue.phase, minimumDuration < delayInSeconds  {
                gestureValue.value = true
            }
            
            // If we ended touch and have desired count we complete gesture
            if case .ended = gestureValue.phase, minimumDuration < delayInSeconds  {
                print("✅", gestureValue.phase, gestureValue.value)
                isPressed = false
                gestureValue.phase = .completed
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


// MARK: Performing the gesture

extension LongPressGesture {
    /// Adds an action to perform when the gesture’s value changes.
    /// Available when Value conforms to Equatable.
    public func onChanged(_ action: @escaping (Updating) -> Void) -> _ChangedGesture<Self> {
        _ChangedGesture(gesture: self, action: action)
    }
}

// MARK: View Modifiers

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
