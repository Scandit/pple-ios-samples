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

    private let delegate = DefaultPriceCheckAdvancedOverlayDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = .appName
        textLabel.text = .initial

        // Perform the initial steps required for the price checking process, including:
        // - ShelfView authentication,
        // - fetching the list of stores belonging to your organization,
        // - preparing the ProductCatalog
        Task { @MainActor in
            await self.authenticateUser()
        }
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

    private func authenticateUser() async {
        // Use the PPLE Authentication singleton to log in the user to an organization.
        do {
            try await Authentication.shared.login(username: Credentials.username, password: Credentials.password)
            await getStores()
        } catch {
            updateStatus(message: .authenticationFailed)
        }
    }

    private func getStores() async {
        // Get/Update the list of stores by using the Catalog singleton object of the PPLE SDK.
        // Pass a CompletionHandler to the getStores method for handling API result.
        do {
            let stores = try await Catalog.shared.getStores()
            if stores.isEmpty {
                updateStatus(message: .storesEmpty)
                return
            }

            // Get products for a selected store from your organization.
            // For simplicity reasons, below we select the first store on the list.
            await getProducts(for: stores[0])
        } catch {
            updateStatus(message: .storeDownloadFailed)
        }
    }

    private func getProducts(for store: Store) async {
        title = store.name
        currency = store.currency

        // Create a ProductCatalog representing a collection of products available for the specified store.
        // By default, the ProductCatalog returned by this method, would use the data retrieved
        // from the ShelfView backend. In this case however, we are providing ExternalProductProvider,
        // as the optional second argument of the method.
        // As a result, the returned ProductCatalog will use the ExternalProductProvider as a custom
        // source of product information instead of fetching the data from the ShelfView backend.
        let provider = ExternalProductProvider(store: store)
        productCatalog = Catalog.shared.getProductCatalog(storeID: store.id, provider: provider)
        do {
            try await productCatalog?.update()
            initializeCaptureViewAndPriceCheck()
        } catch {
            updateStatus(message: .catalogDownloadFailed(storeName: store.name))
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
        let overlay = AdvancedPriceCheckOverlay(delegate: delegate)
        priceCheck.addOverlay(overlay)

        let viewfinder = RectangularViewfinder(style: .rounded, lineStyle: .light)
        viewfinder.setSize(.init(
            width: .init(value: 0.9, unit: .fraction),
            height: .init(value: 0.3, unit: .fraction)
        ))
        viewfinder.dimming = 0.6
        let viewfinderConfiguration = ViewfinderConfiguration(
            viewfinder: viewfinder,
            locationSelection: RectangularLocationSelection(size: .init(
                width: .init(value: 0.9, unit: .fraction),
                height: .init(value: 0.3, unit: .fraction)
            ))
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
        showToast(result: result, color: .green)
    }

    func onWrongPrice(result: PriceCheckResult) {
        // Handle result that a Product label was scanned with wrong price
        showToast(result: result, color: .red)
    }

    func onUnknownProduct(result: PriceCheckResult) {
        // Handle result that a Product label was scanned for an unknown Product
        showToast(result: result, color: .gray)
    }

    private func showToast(result: PriceCheckResult, color: ToastColor) {
        guard let currency else { return }

        showToast(message: result.message(currency: currency), color: color)
    }

    func onSessionUpdate(_ session: ScanditShelf.PriceLabelSession, frameData: FrameData) {}
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
