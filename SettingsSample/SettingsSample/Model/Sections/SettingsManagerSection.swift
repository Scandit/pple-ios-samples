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

protocol SettingsManagerViewfinderSection: SettingsManagerSection {}

extension SettingsManagerViewfinderSection {
    var viewfinderConfiguration: SettingsManagerViewfinderConfigurationSection {
        SettingsManager.current.viewfinderConfiguration
    }

    var viewfinder: Viewfinder? {
        get { viewfinderConfiguration.viewfinder }
        set { viewfinderConfiguration.viewfinder = newValue }
    }

    func updateViewfinder(_ viewfinder: Viewfinder? = nil) {
        viewfinderConfiguration.updateViewfinder(viewfinder)
    }
}
