// CustomOverlayView.swift
//
// Copyright © 2023 Scandit. All rights reserved.

import UIKit
import ScanditShelf

class CustomOverlayView: UIView {

    private var augmentationViews: [Int: UIView] = [:]

    var currency: Currency?
    var captureView: CaptureView?

    override func awakeFromNib() {
        super.awakeFromNib()

        isUserInteractionEnabled = false
    }

    public func updateOverlay(session: PriceLabelSession, captureView: CaptureView) {
        session.removedLabels.forEach { priceLabel in
            let view = augmentationViews[priceLabel.trackingId]
            view?.removeFromSuperview()
            augmentationViews.removeValue(forKey: priceLabel.trackingId)
        }

        guard SettingsManager.current.customOverlay.customOverlayEnabled else { return }

        session.addedLabels.forEach { priceLabel in
            let view = createAugmentationView(for: priceLabel)
            augmentationViews[priceLabel.trackingId] = view
            addSubview(view)
            updateAugmentationPosition(view, predictedBounds: priceLabel.predictedBounds, captureView: captureView)
        }

        session.updatedLabels.forEach { priceLabel in
            guard let view = augmentationViews[priceLabel.trackingId] else {
                return
            }
            updateAugmentationPosition(view, predictedBounds: priceLabel.predictedBounds, captureView: captureView)
        }
    }

    private func createAugmentationView(for priceLabel: PriceLabel) -> UIView {
        let price = priceLabel.result.capturedPrice
        let text = currency.map { price.formattedPrice(currency: $0) } ?? "\(price)"
        let view = UILabel()
        view.text = text
        view.textColor = .black
        view.backgroundColor = .hexRGBA(0x00, 0x66, 0xff, 0x99)
        view.sizeToFit()
        view.textAlignment = .center
        view.frame.size = CGSize(
            width: view.frame.width + 8,
            height: view.frame.height + 8
        )
        return view
    }

    private func updateAugmentationPosition(
        _ view: UIView,
        predictedBounds: Quadrilateral,
        captureView: ScanditShelf.CaptureView
    ) {
        let pointInCaptureView = captureView.viewPoint(forFramePoint: predictedBounds.topRight)
        let point = convert(pointInCaptureView, from: captureView)
        view.center = point
    }
}

extension UIColor {

    static func hexRGBA(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Int = 255) -> UIColor {
        UIColor(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha) / 255.0
        )
    }
}
