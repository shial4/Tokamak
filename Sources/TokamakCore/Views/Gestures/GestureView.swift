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

public struct _GestureView<Content: View, G: Gesture>: View {
    @State public var gesture: G
    public let content: Content

    public init(_ content: Content, gesture: G) {
        self.content = content
        self._gesture = State(wrappedValue: gesture)
    }
    
    public var body: some View {
        G._makeGesture(gesture: $gesture, content: AnyView(content))
    }
}

extension View {
    /// Attaches a single gesture to the view.
    ///
    /// - Parameter gesture: The gesture to attach.
    /// - Returns: A modified version of the view with the gesture attached.
    public func gesture<T>(_ gesture: T) -> some View where T: Gesture {
        _GestureView(self, gesture: gesture)
    }
    
    /// Attaches a gesture to the view to process simultaneously with gestures defined by the view.
    /// - Parameter gesture: The gesture to attach.
    /// - Returns: A modified version of the view with the gesture attached.
    public func simultaneousGesture<T>(_ gesture: T) -> some View where T : Gesture {
        _GestureView(self, gesture: gesture)
    }
}

//public struct _GestureView<G: Gesture>: View {
//    @State public var gesture: AnyGesture<G>
//    public let content: AnyView
//
//    public init(_ content: AnyView, gesture: AnyGesture<G>) {
//        print("🟢 init _GestureView")
//        self.content = content
//        self._gesture = State(wrappedValue: gesture)
//    }
//
//    public var body: some View {
//        print("🟢 body _GestureView")
//        return gesture.makeGestureFn(content)
//    }
//}
//
//extension View {
//    /// Attaches a single gesture to the view.
//    ///
//    /// - Parameter gesture: The gesture to attach.
//    /// - Returns: A modified version of the view with the gesture attached.
//    public func gesture<T: Gesture>(_ gesture: T) -> some View where T: Gesture {
//        _GestureView(AnyView(self), gesture: AnyGesture(gesture))
//    }
//
//    /// Attaches a gesture to the view to process simultaneously with gestures defined by the view.
//    /// - Parameter gesture: The gesture to attach.
//    /// - Returns: A modified version of the view with the gesture attached.
//    public func simultaneousGesture<T: Gesture>(_ gesture: T) -> some View where T : Gesture {
//        _GestureView(AnyView(self), gesture: AnyGesture(gesture))
//    }
//}
