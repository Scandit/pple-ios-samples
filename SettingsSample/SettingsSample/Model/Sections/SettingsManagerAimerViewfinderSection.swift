// SettingsManagerAimerViewfinderSection.swift
//
// Copyright © 2023 Scandit. All rights reserved.

import Foundation
import ScanditShelf

struct SettingsManagerAimerViewfinderSection: SettingsManagerViewfinderSection {
    let defaultViewfinder = AimerViewfinder()

    var aimerViewfinder: AimerViewfinder {
        viewfinder as! AimerViewfinder
    }

    /// Note: AimerViewfinderFrameColor is not part of the SDK, see LaserlineViewfinderDisabledColor.swift
    var frameColor: AimerViewfinderFrameColor {
        get {
            let color = aimerViewfinder.frameColor
            return AimerViewfinderFrameColor(color: color)
        }
        set {
            var aimerViewfinder = aimerViewfinder
            aimerViewfinder.frameColor = newValue.uiColor
            updateViewfinder(aimerViewfinder)
        }
    }

    /// Note: AimerViewfinderDotColor is not part of the SDK, see LaserlineViewfinderDisabledColor.swift
    var dotColor: AimerViewfinderDotColor {
        get {
            let color = aimerViewfinder.dotColor
            return AimerViewfinderDotColor(color: color)
        }
        set {
            var aimerViewfinder = aimerViewfinder
            aimerViewfinder.dotColor = newValue.uiColor
            updateViewfinder(aimerViewfinder)
        }
    }
}
