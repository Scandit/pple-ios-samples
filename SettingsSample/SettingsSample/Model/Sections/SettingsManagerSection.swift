// SettingsManagerSection.swift
//
// Copyright © 2023 Scandit. All rights reserved.

import Foundation
import ScanditShelf

protocol SettingsManagerSection {}

extension SettingsManagerSection {
    var priceCheck: PriceCheck {
        SettingsManager.current.priceCheck
    }

    var overlay: PriceCheckOverlay {
        SettingsManager.current.overlay
    }
}

protocol SettingsManagerViewfinderSection: SettingsManagerSection {
    var viewfinder: Viewfinder? { get }
}

extension SettingsManagerViewfinderSection {

    var viewfinderConfiguration: SettingsManagerViewfinderConfigurationSection {
        SettingsManager.current.viewfinderConfiguration
    }

    func updateViewfinder() {
        viewfinderConfiguration.updateViewfinder(viewfinder)
    }
}
