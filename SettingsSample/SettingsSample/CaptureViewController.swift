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
import ScanditShelf

final class CaptureViewController: UIViewController {

    var storeName: String?
    var currency: Currency?

    var productCatalog: ProductCatalog?

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!

    @IBOutlet weak var customOverlayView: CustomOverlayView!

    private var captureView: CaptureView?
    private var priceCheck: PriceCheck?
    private var isScanningEnabled = false

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = storeName
        customOverlayView.currency = currency

        setupCaptureViewAndPriceCheck()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        priceCheck?.dispose()
    }

    @IBAction func onViewTapAction(_ sender: Any) {
        guard !isScanningEnabled else { return }

        enableScanning()
    }

    private func setupCaptureViewAndPriceCheck() {
        priceCheck?.dispose()

        guard let productCatalog = productCatalog else { return }

        let captureView = CaptureView(frame: view.bounds)
        captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(captureView, at: 0)

        let feedback = PriceCheckFeedback(
            correctPriceFeedback: PriceCheckFeedback.defaultPriceCheckFeedback.correctPriceFeedback,
            wrongPriceFeedback: nil,
            unknownProductFeedback: nil
        )

        let priceCheck = PriceCheck(productCatalog: productCatalog, captureView: captureView)
        priceCheck.addListener(self)
        priceCheck.setFeedback(feedback)

        SettingsManager.current.priceCheck = priceCheck

        self.priceCheck = priceCheck
        self.captureView = captureView

        enableScanning()

        let viewfinderConfiguration = ViewfinderConfiguration(
            viewfinder: RectangularViewfinder(
                style: .rounded,
                lineStyle: .bold
            )
        )
        priceCheck.setViewfinderConfiguration(viewfinderConfiguration)
    }

    private func enableScanning() {
        isScanningEnabled = true
        priceCheck?.enable()
        messageLabel.isHidden = true
        tapGestureRecognizer.isEnabled = false
    }

    private func pauseScanning() {
        guard !SettingsManager.current.continuousPriceCheckEnabled else { return }

        isScanningEnabled = false
        priceCheck?.disable()
        messageLabel.isHidden = false
        tapGestureRecognizer.isEnabled = true
    }
}

extension CaptureViewController: AuthenticationEventListener {

    func onAuthenticationFailure(event: AuthenticationFailureEvent) {
        print(event)
    }

    func onUnsupportedVersionDetected(event: UnsupportedVersionEvent) {
        print(event)
    }
}

extension CaptureViewController: PriceCheckListener {

    func onCorrectPrice(result: PriceCheckResult) {
        guard let currency else { return }

        let capturedPrice = result.capturedPrice.formattedPrice(currency: currency)
        showNotification(text: "\(result.name ?? "N/A")\nCorrect price: \(capturedPrice)")
    }

    func onWrongPrice(result: PriceCheckResult) {
        guard let currency else { return }

        let capturedPrice = result.capturedPrice.formattedPrice(currency: currency)
        let correctPrice = result.correctPrice?.formattedPrice(currency: currency) ?? "N/A"
        showNotification(
            text: "\(result.name ?? "N/A")\nWrong price: \(capturedPrice), should be \(correctPrice)"
        )
    }

    func onUnknownProduct(result: PriceCheckResult) {
        guard let currency else { return }

        let capturedPrice = result.capturedPrice.formattedPrice(currency: currency)
        showNotification(text: "Unrecognized product - captured price: \(capturedPrice)")
    }

    func onSessionUpdate(_ session: PriceLabelSession, frameData: FrameData) {
        guard let captureView else { return }
        customOverlayView.updateOverlay(session: session, captureView: captureView)

        guard !session.trackedLabels.isEmpty else { return }
        pauseScanning()
    }

    private func showNotification(text: String) {
        showToast(message: text, attachToBottom: false)
    }
}

extension Double {
    func formattedPrice(currency: Currency) -> String {
        String(format: "\(currency.symbol)%.\(currency.decimalPlaces)f", self)
    }
}
