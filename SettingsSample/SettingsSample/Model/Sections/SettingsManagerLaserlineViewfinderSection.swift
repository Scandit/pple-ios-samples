// SettingsManagerLaserlineViewfinderSection.swift
//
// Copyright © 2023 Scandit. All rights reserved.

import Foundation
import ScanditShelf

struct SettingsManagerLaserlineViewfinderSection: SettingsManagerViewfinderSection {

    let defaultViewfinder = LaserlineViewfinder()

    var laserlineViewfinder: LaserlineViewfinder {
        viewfinder as! LaserlineViewfinder
    }

    var style: LaserlineViewfinderStyle {
        get {
            laserlineViewfinder.style
        }
        set {
            updateViewfinder(LaserlineViewfinder(style: newValue))
        }
    }

    var width: FloatWithUnit {
        get {
            laserlineViewfinder.width
        }
        set {
            var viewfinder = laserlineViewfinder
            viewfinder.width = newValue
            updateViewfinder(viewfinder)
        }
    }

    /// Note: LaserlineViewfinderEnabledColor is not part of the SDK, see LaserlineViewfinderEnabledColor.swift
    var enabledColor: LaserlineViewfinderEnabledColor {
        get {
            let color = laserlineViewfinder.enabledColor
            return LaserlineViewfinderEnabledColor(color: color)
        }
        set {
            var viewfinder = laserlineViewfinder
            viewfinder.enabledColor = newValue.uiColor
            updateViewfinder(viewfinder)
        }
    }

    /// Note: LaserlineViewfinderDisabledColor is not part of the SDK, see LaserlineViewfinderDisabledColor.swift
    var disabledColor: LaserlineViewfinderDisabledColor {
        get {
            let color = laserlineViewfinder.disabledColor
            return LaserlineViewfinderDisabledColor(color: color)
        }
        set {
            var viewfinder = laserlineViewfinder
            viewfinder.disabledColor = newValue.uiColor
            updateViewfinder(viewfinder)
        }
    }
}
