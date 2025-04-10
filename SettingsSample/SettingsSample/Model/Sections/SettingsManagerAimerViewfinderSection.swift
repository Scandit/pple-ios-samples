// SettingsManagerAimerViewfinderSection.swift
//
// Copyright © 2023 Scandit. All rights reserved.

import Foundation
import ScanditShelf

final class SettingsManagerAimerViewfinderSection: SettingsManagerViewfinderSection {
    var viewfinder: Viewfinder? { aimerViewfinder }

    let defaultViewfinder = AimerViewfinder()

    var aimerViewfinder = AimerViewfinder()

    /// Note: AimerViewfinderFrameColor is not part of the SDK
    var frameColor: AimerViewfinderFrameColor {
        get {
            let color = aimerViewfinder.frameColor
            return AimerViewfinderFrameColor(color: color)
        }
        set {
            aimerViewfinder.frameColor = newValue.uiColor
            updateViewfinder()
        }
    }

    /// Note: AimerViewfinderDotColor is not part of the SDK
    var dotColor: AimerViewfinderDotColor {
        get {
            let color = aimerViewfinder.dotColor
            return AimerViewfinderDotColor(color: color)
        }
        set {
            aimerViewfinder.dotColor = newValue.uiColor
            updateViewfinder()
        }
    }
}
