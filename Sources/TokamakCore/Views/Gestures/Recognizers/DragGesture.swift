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

public struct DragGesture: Gesture {
    public typealias Body = Self
    
    public struct Value: Equatable {
        /// The location of the drag gesture’s first event.
        public var startLocation: CGPoint = .zero
        
        /// The location of the drag gesture’s current event.
        public var location: CGPoint = .zero
        
        /// A prediction, based on the current drag velocity, of where the final location will be if dragging stopped now.
        public var predictedEndLocation: CGPoint = .zero
        
        /// The total translation from the start of the drag gesture to the current event of the drag gesture.
        public var translation: CGSize = .zero
        
        /// A prediction, based on the current drag velocity, of what the final translation will be if dragging stopped now.
        public var predictedEndTranslation: CGSize = .zero
    }
    
    public var gestureValue: GestureValue<Value> = .init(phase: .none, value: Value())
    
    public var minimumDistance: CGFloat
    /// Creates a dragging gesture with the minimum dragging distance before the gesture succeeds and the coordinate space of the gesture’s location.
    /// - Parameters:
    ///   - minimumDistance: The minimum dragging distance before the gesture succeeds.
    ///   - coordinateSpace: The coordinate space in which to receive location values.
    public init(minimumDistance: CGFloat) {
        self.minimumDistance = minimumDistance
    }
}
