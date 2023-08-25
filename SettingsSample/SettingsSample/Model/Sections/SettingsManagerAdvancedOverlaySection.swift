// SettingsManagerAdvancedOverlaySection.swift
//
// Copyright © 2023 Scandit. All rights reserved.

import Foundation
import ScanditShelf

struct SettingsManagerAdvancedOverlaySection: SettingsManagerSection {
    var overlay = AdvancedPriceCheckOverlay(delegate: DefaultPriceCheckAdvancedOverlayDelegate())

    var isEnabled: Bool = true {
        didSet {
            updateOverlay()
        }
    }

    func updateOverlay() {
        if isEnabled {
            priceCheck.addOverlay(overlay)
        } else {
            priceCheck.removeOverlay(overlay)
        }
    }
}
