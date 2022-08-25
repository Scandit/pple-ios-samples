//
//  This file is part of the Scandit ShelfView Sample
//
//  Copyright (C) 2022- Scandit AG. All rights reserved.
//

import UIKit
import ScanditBarcodeCapture
import ScanditShelf

final class CaptureViewController: UIViewController {

    var store: Store?

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private let authentication = Authentication.shared
    private var captureView: CaptureView?
    private var priceCheck: PriceCheck?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = store?.name

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
                print(error)
                fallthrough
            case .success:
                self.perform(segue: .unwindToLogin)
            }
        }
    }

    private func setupCaptureViewAndPriceCheck() {
        priceCheck?.dispose()

        guard let store = store else { return }

        let catalog = Catalog.shared
        let productCatalog = catalog.productCatalog(storeID: store.id)

        let captureView = CaptureView(frame: view.bounds)
        captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(captureView, at: 0)

        let priceCheck = PriceCheck(productCatalog: productCatalog, captureView: captureView)
        priceCheck.addListener(self)
        priceCheck.enable()

        productCatalog.update(completion: { _ in })

        self.priceCheck = priceCheck
        self.captureView = captureView
    }
}

extension CaptureViewController: AuthenticationListener {

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
