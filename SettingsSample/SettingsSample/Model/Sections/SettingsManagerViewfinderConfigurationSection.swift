// SettingsManagerViewfinderConfigurationSection.swift
//
// Copyright © 2023 Scandit. All rights reserved.

import Foundation
import ScanditShelf

final class SettingsManagerViewfinderConfigurationSection: SettingsManagerSection {
    var viewfinderConfiguration = ViewfinderConfiguration() {
        didSet {
            updateConfiguration()
        }
    }

    var locationSelection: LocationSelection? {
        didSet {
            viewfinderConfiguration.locationSelection = locationSelection
        }
    }

    var viewfinder: ScanditShelf.Viewfinder? {
        didSet {
            viewfinderConfiguration.viewfinder = viewfinder
        }
    }

    init() {
        DispatchQueue.main.async { [self] in
            locationSelection = RectangularLocationSelection(size: .init(
                width: .init(value: 0.9, unit: .fraction),
                height: .init(value: 0.3, unit: .fraction)
            ))
        }
    }

    func updateConfiguration() {
        priceCheck.setViewfinderConfiguration(viewfinderConfiguration)
    }

    func updateViewfinder(_ viewfinder: Viewfinder?) {
        if let viewfinder {
            self.viewfinder = viewfinder
        }
        viewfinderConfiguration.viewfinder = self.viewfinder
    }
}
