/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import SwiftUI

enum ToastColor {
    case green
    case red
    case gray
    case black

    var color: Color {
        switch self {
        case .green:
            return Color("green")
        case .red:
            return Color("red")
        case .gray:
            return Color("gray")
        case .black:
            return .black
        }
    }
}

struct ToastViewModel {
    let message: String
    let color: ToastColor
}

struct ToastView: View {

    let viewModel: ToastViewModel

    var body: some View {
        Text(viewModel.message)
            .foregroundColor(.white)
            .font(.system(size: 14))
            .frame(maxWidth: .infinity)
            .padding(10)
            .background { viewModel.color.color }
            .cornerRadius(10)
    }
}
