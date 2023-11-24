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

struct MainView: View {

    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                CaptureViewRepresentable(captureView: viewModel.captureView)
                    .ignoresSafeArea(.container, edges: .all)

                VStack(spacing: 40) {
                    Text(viewModel.title)
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .medium))
                    if let viewModel = viewModel.toast {
                        ToastView(viewModel: viewModel)
                            .transition(.opacity)
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)
            }

            Text(viewModel.text)
                .foregroundColor(.black)
                .font(.system(size: 24))
                .padding(.horizontal, 20)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}
