/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import ScanditShelf
import CoreGraphics
import UIKit

// swiftlint:disable type_body_length

final class SettingsManager {

    static let current = SettingsManager()

    var priceCheck: PriceCheck! {
        didSet {
            DispatchQueue.main.async { [self] in
                basicOverlay.updateOverlay()
                advancedOverlay.updateOverlay()
                feedback.updateFeedback()
                viewfinderConfiguration.updateConfiguration()
            }
        }
    }

    var overlay: PriceCheckOverlay!

    init() {
        // nothing to do.
    }

    var feedback = SettingsManagerFeedbackSection()

    // MARK: Viewfinder & Location selection

    var viewfinderConfiguration = SettingsManagerViewfinderConfigurationSection()

    var laserlineViewfinder = SettingsManagerLaserlineViewfinderSection()

    var rectangularViewfinder = SettingsManagerRectangularViewfinderSection()

    var aimerViewfinder = SettingsManagerAimerViewfinderSection()


    // MARK: Overlays

    var basicOverlay = SettingsManagerBasicOverlaySection()

    var advancedOverlay = SettingsManagerAdvancedOverlaySection()

    var customOverlay = SettingsManagerCustomOverlaySection()

    // MARK: Price Check Flow
    var continuousPriceCheckEnabled: Bool = true
}

// swiftlint:enable type_body_length
