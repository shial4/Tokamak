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

import JavaScriptKit
import TokamakCore
import TokamakStaticHTML
import Foundation

extension LongPressGesture {
    public mutating func _makeGesture(content: Content) -> AnyView {
        content
    }
    
    /*
    func attach(gesture: TapGesture) -> some View {
        DynamicHTML("div", listeners: [
          "onclick": { event in
              guard let state = gesture.state else {
                  return
              }
              gesture.state = state - 1
          },
        ]) {
            content
        }
    }
    
    func attach(gesture: LongPressGesture) -> some View {
        DynamicHTML("input", listeners: [
          "onclick": { event in
              gesture.
          },
        ]) {
            content
        }
    }
    
    func attach(gesture: DragGesture) -> some View {
        DynamicHTML("input", listeners: [
            "mousemove": { event in
                guard
                    let x = event.offsetX.jsValue.number,
                    let y = event.offsetY.jsValue.number
                else { return }
                
                position = CGPoint(x: x, y: y)
            },
            "mousedown": { _ in isMouseButtonDown = true },
            "mouseup": { _ in isMouseButtonDown = false },
        ]) {
            content
        }
    }
     */
}
