// SettingsManagerBasicOverlaySection.swift
//
// Copyright © 2023 Scandit. All rights reserved.

import Foundation
import ScanditShelf

struct SettingsManagerBasicOverlaySection: SettingsManagerSection {
    var isEnabled: Bool = false {
        didSet {
            updateOverlay()
        }
    }

    var overlay = BasicPriceCheckOverlay()
    var correctBrush: BrushColor = .green {
        didSet {
            updateOverlay()
        }
    }
    var wrongBrush: BrushColor = .red {
        didSet {
            updateOverlay()
        }
    }
    var unknownBrush: BrushColor = .gray {
        didSet {
            updateOverlay()
        }
    }

    mutating func updateOverlay() {
        overlay.correctPriceBrush = correctBrush.brush
        overlay.wrongPriceBrush = wrongBrush.brush
        overlay.unknownProductBrush = unknownBrush.brush
        if isEnabled {
            priceCheck.addOverlay(overlay)
        } else {
            priceCheck.removeOverlay(overlay)
        }
    }
}
