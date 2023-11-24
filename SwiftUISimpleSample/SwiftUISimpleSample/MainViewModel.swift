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

enum Credentials {
    // Enter your Scandit ShelfView credentials here.
    static let username: String = "-- ENTER YOUR SCANDIT SHELFVIEW USERNAME HERE --"
    static let password: String = "-- ENTER YOUR SCANDIT SHELFVIEW PASSWORD HERE --"
}

@MainActor
final class MainViewModel: ObservableObject {

    @Published var title = String.appName
    @Published var text = String.initial
    @Published var captureView = CaptureView()
    @Published var toast: ToastViewModel?

    private var productCatalog: ProductCatalog?
    private var priceCheck: PriceCheck?

    private var currency: Currency?

    private let delegate = DefaultPriceCheckAdvancedOverlayDelegate()

    private var timer: Timer? {
        willSet {
            timer?.invalidate()
        }
    }

    func onAppear() {
        Task {
            await self.authenticateUser()
        }
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

        captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

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
            self.text = message
        }
    }
}

extension MainViewModel: PriceCheckListener {
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

    private func showToast(message: String, color: ToastColor) {
        toast = ToastViewModel(message: message, color: color)
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [unowned self] _ in
            self.toast = nil
        })
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
