// SettingsManagerRectangularViewfinderSection.swift
//
// Copyright © 2023 Scandit. All rights reserved.

import Foundation
import ScanditShelf

struct SettingsManagerRectangularViewfinderSection: SettingsManagerViewfinderSection {

    let defaultViewfinder = RectangularViewfinder()

    var rectangularViewfinder: RectangularViewfinder {
        viewfinder as! RectangularViewfinder
    }

    var style: ScanditShelf.RectangularViewfinderStyle {
        get {
            rectangularViewfinder.style
        }
        set {
            viewfinder = RectangularViewfinder(style: newValue, lineStyle: lineStyle)
            updateViewfinder()
        }
    }

    var lineStyle: ScanditShelf.RectangularViewfinderLineStyle {
        get {
            rectangularViewfinder.lineStyle
        }
        set {
            viewfinder = RectangularViewfinder(style: style, lineStyle: newValue)
            updateViewfinder()
        }
    }

    var dimming: CGFloat {
        get {
            rectangularViewfinder.dimming
        }
        set {
            rectangularViewfinder.dimming = newValue
            updateViewfinder()
        }
    }

    var disabledDimming: CGFloat {
        get {
            rectangularViewfinder.disabledDimming
        }
        set {
            rectangularViewfinder.disabledDimming = newValue
            updateViewfinder()
        }
    }

    /// Note: RectangularViewfinderColor is not part of the SDK, see RectangularViewfinderColor.swift
    var color: RectangularViewfinderColor {
        get {
            let color = rectangularViewfinder.color
            return RectangularViewfinderColor(color: color)
        }
        set {
            rectangularViewfinder.color = newValue.uiColor
            updateViewfinder()
        }
    }

    /// Note: RectangularViewfinderDisabledColor is not part of the SDK, see RectangularViewfinderColor.swift
    var disabledColor: RectangularViewfinderDisabledColor {
        get {
            let color = rectangularViewfinder.disabledColor
            return RectangularViewfinderDisabledColor(color: color)
        }
        set {
            rectangularViewfinder.disabledColor = newValue.uiColor
            updateViewfinder()
        }
    }

    var animation: RectangularViewfinderAnimation? {
        get {
            rectangularViewfinder.animation
        }
        set {
            rectangularViewfinder.animation = newValue
            updateViewfinder()
        }
    }

    // MARK: Size
    private let defaultLegacySize = RectangularViewfinder(
        style: .legacy,
        lineStyle: .light
    ).sizeWithUnitAndAspect.widthAndHeight!

    var viewfinderSizeSpecification: RectangularSizeSpecification = .widthAndHeight {
        didSet {
            /// Update the viewfinder when we update the size specification.
            switch viewfinderSizeSpecification {
            case .widthAndHeight:
                widthAndHeight = defaultLegacySize
            case .widthAndHeightAspect:
                widthAndAspectRatio = SizeWithAspect(
                    size: .init(value: defaultLegacySize.width.value, unit: .fraction),
                    aspect: 0.0)
            case .heightAndWidthAspect:
                heightAndAspectRatio = SizeWithAspect(
                    size: .init(value: defaultLegacySize.height.value, unit: .fraction),
                    aspect: 0.0)
            }
        }
    }

    var widthAndHeight: SizeWithUnit {
        get {
            let sizeWithUnitAndAspect = rectangularViewfinder.sizeWithUnitAndAspect
            return sizeWithUnitAndAspect.widthAndHeight ?? .zero
        }
        set {
            rectangularViewfinder.setSize(newValue)
            updateViewfinder()
        }
    }

    var widthAndAspectRatio: SizeWithAspect {
        get {
            let sizeWithUnitAndAspect = rectangularViewfinder.sizeWithUnitAndAspect
            return sizeWithUnitAndAspect.widthAndAspectRatio ?? .zero
        }
        set {
            rectangularViewfinder.setWidth(newValue.size, heightToWidthAspectRatio: newValue.aspect)
            updateViewfinder()
        }
    }

    var heightAndAspectRatio: SizeWithAspect {
        get {
            let sizeWithUnitAndAspect = rectangularViewfinder.sizeWithUnitAndAspect
            return sizeWithUnitAndAspect.heightAndAspectRatio ?? .zero
        }
        set {
            rectangularViewfinder.setHeight(newValue.size, widthToHeightAspectRatio: newValue.aspect)
            updateViewfinder()
        }
    }
}
