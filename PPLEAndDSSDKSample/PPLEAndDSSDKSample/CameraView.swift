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

struct CameraView: View {

    enum Tab {
        case pple
        case barcode
    }

    @StateObject var ppleViewModel: PPLEViewModel = .init()
    @StateObject var barcodeViewModel: BarcodeViewModel = .init()

    @State
    private var selectedTab = Tab.barcode

    var body: some View {
        VStack(spacing: 12) {
            Picker("Camera", selection: $selectedTab) {
                Text("PPLE").tag(Tab.pple)
                Text("Barcode").tag(Tab.barcode)
            }
            .pickerStyle(.segmented)

            if selectedTab == .pple {
                ppleCamera
            } else {
                barcodeCamera
            }
        }
    }

    private var ppleCamera: some View {
        ZStack {
            ZStack(alignment: .top) {
                CaptureViewRepresentable(captureView: ppleViewModel.captureView)
                    .ignoresSafeArea(.container, edges: .all)

                VStack(spacing: 40) {
                    Text(ppleViewModel.title)
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .medium))
                    if let viewModel = ppleViewModel.toast {
                        ToastView(viewModel: viewModel)
                            .transition(.opacity)
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)
            }

            Text(ppleViewModel.text)
                .foregroundColor(.black)
                .font(.system(size: 24))
                .padding(.horizontal, 20)
        }
        .onAppear {
            barcodeViewModel.onDisappear()
            ppleViewModel.onAppear()
        }
    }

    private var barcodeCamera: some View {
        ZStack(alignment: .top) {
            if let captureView = barcodeViewModel.dataCaptureView {
                CaptureViewRepresentable(captureView: captureView)
                    .ignoresSafeArea(.container, edges: .all)
            }

            if let viewModel = barcodeViewModel.toast {
                ToastView(viewModel: viewModel)
                    .padding(.top, 60)
                    .padding(.horizontal, 20)
                    .transition(.opacity)
            }
        }
        .onAppear {
            ppleViewModel.onDisappear()
            barcodeViewModel.onAppear()
        }
    }
}
