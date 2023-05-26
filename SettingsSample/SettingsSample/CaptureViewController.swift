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

    var productCatalog: ProductCatalog?

    @IBOutlet private weak var titleLabel: UILabel!

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private var captureView: CaptureView?

    private var priceCheck: PriceCheck?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = storeName

        setupCaptureViewAndPriceCheck()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        priceCheck?.dispose()
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
        priceCheck.enable()

        SettingsManager.current.priceCheck = priceCheck

        self.priceCheck = priceCheck
        self.captureView = captureView

        let viewfinderConfiguration = ViewfinderConfiguration(
            viewfinder: RectangularViewfinder(
                style: .rounded,
                lineStyle: .bold
            )
        )
        priceCheck.setViewfinderConfiguration(viewfinderConfiguration)
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
        showNotification(text: "\(result.name ?? "N/A")\nCorrect price: \(result.capturedPrice)")
    }

    func onWrongPrice(result: PriceCheckResult) {
        showNotification(
            text: "\(result.name ?? "N/A")\nWrong price: \(result.capturedPrice), should be \(result.correctPrice ?? -1)"
        )
    }

    func onUnknownProduct(result: PriceCheckResult) {
        showNotification(text: "Unrecognized product - captured price: \(result.capturedPrice)")
    }

    private func showNotification(text: String) {
        showToast(message: text, attachToBottom: false)
    }
}
