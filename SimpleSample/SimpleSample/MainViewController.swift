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

enum Credentials {
    // Enter your Scandit ShelfView credentials here.
    static let username: String = "-- ENTER YOUR SCANDIT SHELFVIEW USERNAME HERE --"
    static let password: String = "-- ENTER YOUR SCANDIT SHELFVIEW PASSWORD HERE --"
}

final class MainViewController: UIViewController {

    @IBOutlet private weak var textLabel: UILabel!

    private var productCatalog: ProductCatalog?
    private var priceCheck: PriceCheck?
    private var captureView: CaptureView?

    private var currency: Currency?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = .appName

        // Perform the initial steps required for the price checking process, including:
        // - ShelfView authentication,
        // - fetching the list of stores belonging to your organization,
        // - preparing the ProductCatalog
        authenticateUser()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Enables the price check, which will start the camera and begin processing the camera frames.
        // Should only be called after the priceCheck instance has been initialized,
        // otherwise the method will have no effect.
        priceCheck?.enable()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // Disables the price check, which will stop the camera and the processing of the camera frames.
        // Should only be called after the priceCheck instance has been initialized,
        // otherwise the method will have no effect.
        priceCheck?.disable()
    }

    private func authenticateUser() {
        // Use the PPLE Authentication singleton to log in the user to an organization.
        Authentication.shared.login(
            username: Credentials.username,
            password: Credentials.password) { [weak self] result in
                switch result {
                case .success:
                    self?.getStores()
                case .failure:
                    self?.updateStatus(message: .authenticationFailed)
                }
            }
    }

    private func getStores() {
        // Get/Update the list of stores by using the Catalog singleton object of the PPLE SDK.
        // Pass a CompletionHandler to the getStores method for handling API result.
        Catalog.shared.getStores { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let stores):
                    if stores.isEmpty {
                        self?.updateStatus(message: .storesEmpty)
                        return
                    }

                    // Get products for a selected store from your organization.
                    // For simplicity reasons, below we select the first store on the list.
                    self?.getProducts(for: stores[0])
                case .failure:
                    self?.updateStatus(message: .storeDownloadFailed)
                }
            }
        }
    }

    private func getProducts(for store: Store) {
        title = store.name
        currency = store.currency
        // Get/Update the Product items for a given Store.

        // First create the ProductCatalog object.
        //
        // If you are using the ShelfView backend as your product catalog provider, you only need to specify the Store,
        // for which you will perform the Price Check - just like in the code below.
        //
        // If on the other hand, you would like to use a different source of data for the ProductCatalog,
        // you should should pass your custom implementation of the ProductProvider interface, as the second argument
        // for the Catalog.shared.getProductCatalog method - check the docs for more details.
        productCatalog = Catalog.shared.getProductCatalog(storeID: store.id)
        productCatalog?.update { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.initializeCaptureViewAndPriceCheck()
                }
            case .failure:
                self?.updateStatus(message: .catalogDownloadFailed(storeName: store.name))
            }
        }
    }

    // Prepare the PriceCheck instance. Should only be called after the ProductCatalog is created,
    // otherwise the method will have no effect.
    private func initializeCaptureViewAndPriceCheck() {
        guard let productCatalog = productCatalog else { return }

        updateStatus(message: .empty)

        let captureView = CaptureView(frame: view.bounds)
        captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(captureView, at: 0)

        let priceCheck = PriceCheck(productCatalog: productCatalog, captureView: captureView)
        priceCheck.addListener(self)

        self.priceCheck = priceCheck
        self.captureView = captureView

        // Create an augmented overlay visual that will be shown over price labels.
        // By default, price labels are sought on the whole capture view. If you want to limit the scan area,
        // pass a non-nil LocationSelection to PriceCheckOverlay's constructor.
        let overlay = BasicPriceCheckOverlay(
            correctPriceBrush: Brush(
                fillColor: .green.withAlphaComponent(0.33),
                strokeColor: .clear,
                strokeWidth: 0),
            wrongPriceBrush: Brush(
                fillColor: .red.withAlphaComponent(0.33),
                strokeColor: .clear,
                strokeWidth: 0),
            unknownProductBrush: Brush(
                fillColor: .gray.withAlphaComponent(0.33),
                strokeColor: .clear,
                strokeWidth: 0)
        )
        priceCheck.addOverlay(overlay)

        let viewfinderConfiguration = ViewfinderConfiguration(
            viewfinder: RectangularViewfinder()
        )
        priceCheck.setViewfinderConfiguration(viewfinderConfiguration)

        priceCheck.enable()
    }

    private func updateStatus(message: String) {
        DispatchQueue.main.async {
            self.textLabel.text = message
        }
    }
}

extension MainViewController: PriceCheckListener {
    func onCorrectPrice(result: PriceCheckResult) {
        // Handle result that a Product label was scanned with correct price
        showToast(result: result)
    }

    func onWrongPrice(result: PriceCheckResult) {
        // Handle result that a Product label was scanned with wrong price
        showToast(result: result)
    }

    func onUnknownProduct(result: PriceCheckResult) {
        // Handle result that a Product label was scanned for an unknown Product
        showToast(result: result)
    }

    private func showToast(result: PriceCheckResult) {
        guard let currency else { return }

        showToast(message: result.message(currency: currency))
    }

    func onSessionUpdate(_ session: ScanditShelf.PriceLabelSession, frameData: FrameData) {
    }
}

private extension PriceCheckResult {
    func message(currency: Currency) -> String {
        switch correctPrice {
        case .none:
            return "Unrecognized product - captured price: \(capturedPrice.formattedPrice(currency: currency))"
        case capturedPrice:
            return [name, "Correct Price: \(capturedPrice.formattedPrice(currency: currency))"]
                .compactMap { $0 }.joined(separator: "\n")
        case let price?:
            return [name, "Wrong Price: \(capturedPrice.formattedPrice(currency: currency)), should be \(price.formattedPrice(currency: currency))"]
                .compactMap { $0 }.joined(separator: "\n")
        default:
            return ""
        }
    }
}

private extension Double {
    func formattedPrice(currency: Currency) -> String {
        String(format: "\(currency.symbol)%.\(currency.decimalPlaces)f", self)
    }
}
