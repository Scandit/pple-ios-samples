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

class SettingsManager {

    private lazy var settingsManagerProxyListener = SettingsManagerProxyListener(settingsManager: self)

    private let defaultLegacyViewFinderSize = RectangularViewfinder(
        style: .legacy,
        lineStyle: .light)
        .sizeWithUnitAndAspect.widthAndHeight!
    private let defaultNonLegacyViewFinderSize = RectangularViewfinder(
        style: .square,
        lineStyle: .light)
        .sizeWithUnitAndAspect.shorterDimensionAndAspectRatio!

    static let current = SettingsManager()

    var isContinuousModeEnabled = false

    var priceCheck: PriceCheck! {
        didSet {
            DispatchQueue.main.async { [self] in
                updateBasicOverlay()
                updateAdvancedOverlay()
                updatePriceCheckFeedback()
                priceCheck.setViewfinderConfiguration(viewfinderConfiguration)
            }
        }
    }

    var overlay: PriceCheckOverlay!

    init() {
        // nothing to do.
    }

    // MARK: Feedback

    var correctFeedback: Feedback? = Feedback(sound: nil, vibration: nil) {
        didSet {
            updatePriceCheckFeedback()
        }
    }
    var wrongFeedback: Feedback? = Feedback(sound: nil, vibration: nil) {
        didSet {
            updatePriceCheckFeedback()
        }
    }
    var unknownFeedback: Feedback? = Feedback(sound: nil, vibration: nil) {
        didSet {
            updatePriceCheckFeedback()
        }
    }

    func updatePriceCheckFeedback() {
        priceCheck.setFeedback(PriceCheckFeedback(
            correctPriceFeedback: correctFeedback,
            wrongPriceFeedback: wrongFeedback,
            unknownProductFeedback: unknownFeedback
        ))
    }

    // MARK: Viewfinder & Location selection

    var viewfinderConfiguration = ViewfinderConfiguration() {
        didSet {
            updateViewfinderConfiguration()
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

    private func updateViewfinderConfiguration() {
        priceCheck.setViewfinderConfiguration(viewfinderConfiguration)
    }

    var laserlineStyle: ScanditShelf.LaserlineViewfinderStyle {
        get {
            (viewfinder as! ScanditShelf.LaserlineViewfinder).style
        }
        set {
            viewfinder = LaserlineViewfinder(style: newValue)
        }
    }

    var rectangularStyle: ScanditShelf.RectangularViewfinderStyle {
        get {
            (viewfinder as! ScanditShelf.RectangularViewfinder).style
        }
        set {
            viewfinder = RectangularViewfinder(style: newValue, lineStyle: .light)
        }
    }

    var rectangularLineStyle: ScanditShelf.RectangularViewfinderLineStyle {
        get {
            (viewfinder as! ScanditShelf.RectangularViewfinder).lineStyle
        }
        set {
            viewfinder = RectangularViewfinder(style: rectangularStyle, lineStyle: newValue)
        }
    }

    var rectangularDimming: CGFloat {
        get {
            (viewfinder as! RectangularViewfinder).dimming
        }
        set {
            let rectangularViewfinder = (viewfinder as! RectangularViewfinder)
            rectangularViewfinder.dimming = newValue
            viewfinder = rectangularViewfinder
        }
    }

    var rectangularDisabledDimming: CGFloat {
        get {
            (viewfinder as! RectangularViewfinder).disabledDimming
        }
        set {
            let rectangularViewfinder = (viewfinder as! RectangularViewfinder)
            rectangularViewfinder.disabledDimming = newValue
            viewfinder = rectangularViewfinder
        }
    }

    lazy var defaultRectangularViewfinderColor = RectangularViewfinder().color
    lazy var defaultRectangularViewfinderDisabledColor = RectangularViewfinder().disabledColor

    /// Note: RectangularViewfinderColor is not part of the SDK, see RectangularViewfinderColor.swift
    var rectangularViewfinderColor: RectangularViewfinderColor {
        get {
            let color = (viewfinder as! RectangularViewfinder).color
            return RectangularViewfinderColor(color: color)
        }
        set {
            let rectangularViewfinder = (viewfinder as! RectangularViewfinder)
            rectangularViewfinder.color = newValue.uiColor
            viewfinder = rectangularViewfinder
        }
    }

    /// Note: RectangularViewfinderDisabledColor is not part of the SDK, see RectangularViewfinderColor.swift
    var rectangularViewfinderDisabledColor: RectangularViewfinderDisabledColor {
        get {
            let color = (viewfinder as! RectangularViewfinder).disabledColor
            return RectangularViewfinderDisabledColor(color: color)
        }
        set {
            let rectangularViewfinder = (viewfinder as! RectangularViewfinder)
            rectangularViewfinder.color = newValue.uiColor
            viewfinder = rectangularViewfinder
        }
    }

    var rectangularAnimation: RectangularViewfinderAnimation? {
        get {
            (viewfinder as! RectangularViewfinder).animation
        }
        set {
            let rectangularViewfinder = (viewfinder as! RectangularViewfinder)
            rectangularViewfinder.animation = newValue
            viewfinder = rectangularViewfinder
        }
    }

    lazy var defaultLaserlineViewfinderEnabledColor = LaserlineViewfinder().enabledColor

    /// Note: LaserlineViewfinderEnabledColor is not part of the SDK, see LaserlineViewfinderEnabledColor.swift
    var laserlineViewfinderEnabledColor: LaserlineViewfinderEnabledColor {
        get {
            let color = (viewfinder as! LaserlineViewfinder).enabledColor
            return LaserlineViewfinderEnabledColor(color: color)
        }
        set {
            var laserlineViewfinder = (viewfinder as! LaserlineViewfinder)
            laserlineViewfinder.enabledColor = newValue.uiColor
            viewfinder = laserlineViewfinder
        }
    }

    lazy var defaultLaserlineViewfinderDisabledColor = LaserlineViewfinder().disabledColor

    /// Note: LaserlineViewfinderDisabledColor is not part of the SDK, see LaserlineViewfinderDisabledColor.swift
    var laserlineViewfinderDisabledColor: LaserlineViewfinderDisabledColor {
        get {
            let color = (viewfinder as! LaserlineViewfinder).disabledColor
            return LaserlineViewfinderDisabledColor(color: color)
        }
        set {
            var laserlineViewfinder = (viewfinder as! LaserlineViewfinder)
            laserlineViewfinder.disabledColor = newValue.uiColor
            viewfinder = laserlineViewfinder
        }
    }

    lazy var defaultAimerViewfinderFrameColor = AimerViewfinder().frameColor

    /// Note: AimerViewfinderFrameColor is not part of the SDK, see LaserlineViewfinderDisabledColor.swift
    var aimerViewfinderFrameColor: AimerViewfinderFrameColor {
        get {
            let color = (viewfinder as! AimerViewfinder).frameColor
            return AimerViewfinderFrameColor(color: color)
        }
        set {
            var aimerViewfinder = (viewfinder as! AimerViewfinder)
            aimerViewfinder.frameColor = newValue.uiColor
            viewfinder = aimerViewfinder
        }
    }

    lazy var defaultAimerViewfinderDotColor = AimerViewfinder().dotColor

    /// Note: AimerViewfinderDotColor is not part of the SDK, see LaserlineViewfinderDisabledColor.swift
    var aimerViewfinderDotColor: AimerViewfinderDotColor {
        get {
            let color = (viewfinder as! AimerViewfinder).dotColor
            return AimerViewfinderDotColor(color: color)
        }
        set {
            var aimerViewfinder = (viewfinder as! AimerViewfinder)
            aimerViewfinder.dotColor = newValue.uiColor
            viewfinder = aimerViewfinder
        }
    }

    var viewfinderSizeSpecification: RectangularSizeSpecification = .widthAndHeight {
        didSet {
            /// Update the viewfinder when we update the size specification.
            switch viewfinderSizeSpecification {
            case .widthAndHeight:
                rectangularWidthAndHeight = defaultLegacyViewFinderSize
            case .widthAndHeightAspect:
                rectangularWidthAndAspectRatio = SizeWithAspect(
                    size: .init(value: defaultLegacyViewFinderSize.width.value, unit: .fraction),
                    aspect: 0.0)
            case .heightAndWidthAspect:
                rectangularHeightAndAspectRatio = SizeWithAspect(
                    size: .init(value: defaultLegacyViewFinderSize.height.value, unit: .fraction),
                    aspect: 0.0)
            }
        }
    }

    var rectangularWidthAndHeight: SizeWithUnit {
        get {
            let sizeWithUnitAndAspect = (viewfinder as! RectangularViewfinder).sizeWithUnitAndAspect
            return sizeWithUnitAndAspect.widthAndHeight ?? .zero
        }
        set {
            let rectangular = viewfinder as! RectangularViewfinder
            rectangular.setSize(newValue)
            viewfinder = rectangular
        }
    }

    var rectangularWidthAndAspectRatio: SizeWithAspect {
        get {
            let sizeWithUnitAndAspect = (viewfinder as! RectangularViewfinder).sizeWithUnitAndAspect
            return sizeWithUnitAndAspect.widthAndAspectRatio ?? .zero
        }
        set {
            let rectangular = viewfinder as! RectangularViewfinder
            rectangular.setWidth(newValue.size, heightToWidthAspectRatio: newValue.aspect)
            viewfinder = rectangular
        }
    }

    var rectangularHeightAndAspectRatio: SizeWithAspect {
        get {
            let sizeWithUnitAndAspect = (viewfinder as! RectangularViewfinder).sizeWithUnitAndAspect
            return sizeWithUnitAndAspect.heightAndAspectRatio ?? .zero
        }
        set {
            let rectangular = viewfinder as! RectangularViewfinder
            rectangular.setHeight(newValue.size, widthToHeightAspectRatio: newValue.aspect)
            viewfinder = rectangular
        }
    }

    // MARK: Overlays

    var basicOverlayEnabled: Bool = false {
        didSet {
            updateBasicOverlay()
        }
    }

    var basicOverlay = BasicPriceCheckOverlay()
    var basicOverlayCorrectBrush: BrushColor = .green {
        didSet {
            updateBasicOverlay()
        }
    }
    var basicOverlayWrongBrush: BrushColor = .red {
        didSet {
            updateBasicOverlay()
        }
    }
    var basicOverlayUnknownBrush: BrushColor = .gray {
        didSet {
            updateBasicOverlay()
        }
    }

    var advancedOverlay = AdvancedPriceCheckOverlay(delegate: DefaultPriceCheckAdvancedOverlayDelegate())
    var advancedOverlayEnabled: Bool = true {
        didSet {
            updateAdvancedOverlay()
        }
    }

    func updateBasicOverlay() {
        basicOverlay.correctPriceBrush = basicOverlayCorrectBrush.brush
        basicOverlay.wrongPriceBrush = basicOverlayWrongBrush.brush
        basicOverlay.unknownProductBrush = basicOverlayUnknownBrush.brush
        if basicOverlayEnabled {
            priceCheck.addOverlay(basicOverlay)
        } else {
            priceCheck.removeOverlay(basicOverlay)
        }
    }

    func updateAdvancedOverlay() {
        if advancedOverlayEnabled {
            priceCheck.addOverlay(advancedOverlay)
        } else {
            priceCheck.removeOverlay(advancedOverlay)
        }
    }
}

// swiftlint:enable type_body_length

class SettingsManagerProxyListener: NSObject {

    weak var settingsManager: SettingsManager?

    init(settingsManager: SettingsManager) {
        super.init()
        self.settingsManager = settingsManager
    }
}

extension SettingsManager {

    private func updateViewFinder(_ updateBlock: (inout ViewfinderConfiguration)) {

    }
}
