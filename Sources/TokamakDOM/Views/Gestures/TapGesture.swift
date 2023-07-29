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

extension TapGesture {
    static func _makeGesture<Content: View>(gesture: Binding<Self>, content: Content) -> AnyView {
        print("🔵 TapGesture._makeGesture")
        return AnyView(
            DynamicHTML("div", [:], listeners: [
                "onclick": { event in
                    print("🟢 onclick", gesture.state)
                    gesture.state.wrappedValue = gesture.state.wrappedValue + 1
                }
            ]) {
                content.overlay(Text("X"))
            }
        )
    }
}
