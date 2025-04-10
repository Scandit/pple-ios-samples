// SettingsManagerRectangularViewfinderSection.swift
//
// Copyright © 2023 Scandit. All rights reserved.

import Foundation
import ScanditShelf

final class SettingsManagerRectangularViewfinderSection: SettingsManagerViewfinderSection {

    var viewfinder: Viewfinder? {
        rectangularViewfinder
    }

    let defaultViewfinder = RectangularViewfinder()

    var rectangularViewfinder = RectangularViewfinder()

    var style: ScanditShelf.RectangularViewfinderStyle {
        get {
            rectangularViewfinder.style
        }
        set {
            rectangularViewfinder = RectangularViewfinder(style: newValue, lineStyle: lineStyle)
            updateViewfinder()
        }
    }

    var lineStyle: ScanditShelf.RectangularViewfinderLineStyle {
        get {
            rectangularViewfinder.lineStyle
        }
        set {
            rectangularViewfinder = RectangularViewfinder(style: style, lineStyle: newValue)
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
    var viewfinderSizeSpecification: RectangularSizeSpecification = .widthAndHeight {
        didSet {
            /// Update the viewfinder when we update the size specification.
            switch viewfinderSizeSpecification {
            case .shorterDimensionAndAspectRatio:
                rectangularViewfinder = .init(style: .rounded, lineStyle: .light)
                updateViewfinder()
            case .widthAndHeight:
                widthAndHeight = .init(
                    width: .defaultSizeWidth,
                    height: .defaultSizeHeight
                )
            case .widthAndHeightAspect:
                widthAndAspectRatio = SizeWithAspect(
                    size: .defaultSizeWidth,
                    aspect: 0.0)
            case .heightAndWidthAspect:
                heightAndAspectRatio = SizeWithAspect(
                    size: .defaultSizeHeight,
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

    init() {
        DispatchQueue.main.async { [self] in
            style = .rounded
            widthAndHeight = .init(
                width: .init(value: 0.9, unit: .fraction),
                height: .init(value: 0.3, unit: .fraction)
            )
            dimming = 0.6
        }
    }
}

private extension FloatWithUnit {
    static let defaultSizeWidth = FloatWithUnit(value: 0.8, unit: .fraction)
    static let defaultSizeHeight = FloatWithUnit(value: 0.325, unit: .fraction)
}
