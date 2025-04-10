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

import SwiftUI
import ScanditShelf
import ScanditBarcodeCapture
import ScanditCaptureCore

enum DCSDKCredentials {
    // Enter your Scandit ShelfView credentials here.
    static let licenseKey: String = "-- ENTER YOUR DC SDK LICENSE KEY HERE --"
}

@MainActor
final class BarcodeViewModel: NSObject, ObservableObject {

    @Published var title = String.appName
    @Published var dataCaptureView: DataCaptureView?
    @Published var toast: ToastViewModel?

    private var dataCaptureContext: DataCaptureContext?
    private var barcodeCapture: BarcodeCapture?
    private var camera: Camera?

    private var timer: Timer? {
        willSet {
            timer?.invalidate()
        }
    }

    func onAppear() {
        Task {
            setupCamera()
        }
    }

    func onDisappear() {
        camera?.switch(toDesiredState: .off)
        barcodeCapture?.removeListener(self)
        if let barcodeCapture {
            dataCaptureContext?.removeMode(barcodeCapture)
        }
        barcodeCapture = nil
        dataCaptureContext = nil
        dataCaptureView = nil
    }

    private func setupCamera() {
        camera = Camera.default

        guard let camera else { return }

        dataCaptureContext = DataCaptureContext(licenseKey:
DCSDKCredentials.licenseKey)
        dataCaptureContext?.setFrameSource(camera)

        let settings = BarcodeCaptureSettings()
        settings.enableSymbologies([
            .ean13UPCA, .ean8, .upce, .code128, .interleavedTwoOfFive
        ])

        let barcodeCapture = BarcodeCapture(context: dataCaptureContext, settings:
settings)
        barcodeCapture.addListener(self)
        self.barcodeCapture = barcodeCapture

        dataCaptureView = DataCaptureView(context: dataCaptureContext, frame: .zero)

        let overlay = BarcodeCaptureOverlay(
            barcodeCapture: barcodeCapture, view: dataCaptureView, style: .frame
        )
        overlay.viewfinder = RectangularViewfinder(style: .square)

        let brush = Brush(fill: .clear, stroke: .white, strokeWidth: 3)
        overlay.brush = brush

        dataCaptureView?.addOverlay(overlay)
        camera.switch(toDesiredState: .on)
    }

    private func showToast(message: String, color: ToastColor) {
        toast = ToastViewModel(message: message, color: color)
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(3))

            self.toast = nil
            self.barcodeCapture?.isEnabled = true
        }
    }
}

extension BarcodeViewModel: BarcodeCaptureListener {
    @MainActor
    func barcodeCapture(
        _ barcodeCapture: BarcodeCapture,
        didScanIn session: BarcodeCaptureSession,
        frameData: ScanditBarcodeCapture.FrameData
    ) {
        guard let barcode = session.newlyRecognizedBarcode else { return }

        barcodeCapture.isEnabled = false
        let symbology = SymbologyDescription(symbology: barcode.symbology).readableName
        let result = #"Scanned: \#(barcode.data ?? "N/D") (" \#(symbology) + ")"#
        showToast(message: result, color: .green)
    }
}

private extension Double {
    func formattedPrice(currency: Currency) -> String {
        String(format: "\(currency.symbol)%.\(currency.decimalPlaces)f", self)
    }
}
