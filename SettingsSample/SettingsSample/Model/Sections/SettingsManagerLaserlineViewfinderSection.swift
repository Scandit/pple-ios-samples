// SettingsManagerLaserlineViewfinderSection.swift
//
// Copyright © 2023 Scandit. All rights reserved.

import Foundation
import ScanditShelf

final class SettingsManagerLaserlineViewfinderSection: SettingsManagerViewfinderSection {

    var viewfinder: Viewfinder? { laserlineViewfinder }

    let defaultViewfinder = LaserlineViewfinder()

    var laserlineViewfinder = LaserlineViewfinder()

    var style: LaserlineViewfinderStyle {
        get {
            laserlineViewfinder.style
        }
        set {
            laserlineViewfinder = LaserlineViewfinder(style: newValue)
            updateViewfinder()
        }
    }

    var width: FloatWithUnit {
        get {
            laserlineViewfinder.width
        }
        set {
            laserlineViewfinder.width = newValue
            updateViewfinder()
        }
    }

    /// Note: LaserlineViewfinderEnabledColor is not part of the SDK, see LaserlineViewfinderEnabledColor.swift
    var enabledColor: LaserlineViewfinderEnabledColor {
        get {
            let color = laserlineViewfinder.enabledColor
            return LaserlineViewfinderEnabledColor(color: color)
        }
        set {
            laserlineViewfinder.enabledColor = newValue.uiColor
            updateViewfinder()
        }
    }

    /// Note: LaserlineViewfinderDisabledColor is not part of the SDK, see LaserlineViewfinderDisabledColor.swift
    var disabledColor: LaserlineViewfinderDisabledColor {
        get {
            let color = laserlineViewfinder.disabledColor
            return LaserlineViewfinderDisabledColor(color: color)
        }
        set {
            laserlineViewfinder.disabledColor = newValue.uiColor
            updateViewfinder()
        }
    }
}
