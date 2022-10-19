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

    private let authentication = Authentication.shared

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

    @IBAction private func onLogOut(_ sender: Any) {
        activityIndicator.startAnimating()
        authentication.logout { [weak self] result in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()

            switch result {
            case .failure(let error):
                self.showToast(message: error.localizedDescription)
                fallthrough
            case .success:
                self.perform(segue: .unwindToLogin)
            }
        }
    }

    private func setupCaptureViewAndPriceCheck() {
        priceCheck?.dispose()

        guard let productCatalog = productCatalog else { return }

        let captureView = CaptureView(frame: view.bounds)
        captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(captureView, at: 0)

        let feedback = PriceCheckFeedback(
            correctPriceFeedback: Feedback.default,
            wrongPriceFeedback: nil,
            unknownProductFeedback: nil
        )

        let priceCheck = PriceCheck(productCatalog: productCatalog, captureView: captureView)
        priceCheck.addListener(self)
        priceCheck.setFeedback(feedback)
        priceCheck.enable()

        self.priceCheck = priceCheck
        self.captureView = captureView

        // Create an augmented overlay visual that will
        // be shown over price labels.
        priceCheck.setOverlay(
            PriceCheckOverlay(
                viewfinder: RectangularViewfinder(
                    style: .rounded,
                    lineStyle: .bold
                ),
                correctPriceBrush: ScanditShelf.Brush(
                    fillColor: .green.withAlphaComponent(0.33),
                    strokeColor: .green,
                    strokeWidth: 2),
                wrongPriceBrush: ScanditShelf.Brush(
                    fillColor: .red.withAlphaComponent(0.33),
                    strokeColor: .red,
                    strokeWidth: 2),
                unknownProductBrush: ScanditShelf.Brush(
                    fillColor: .gray.withAlphaComponent(0.33),
                    strokeColor: .gray,
                    strokeWidth: 2)
            )
        )
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
        print("Correct Price: \(result)")
    }

    func onWrongPrice(result: PriceCheckResult) {
        print("Wrong Price: \(result)")
    }

    func onUnknownProduct(result: PriceCheckResult) {
        print("Unknown Product: \(result)")
    }
}
