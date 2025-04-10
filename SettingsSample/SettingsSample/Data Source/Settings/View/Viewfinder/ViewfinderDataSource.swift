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

class ViewfinderDataSource: DataSource {

    weak var delegate: DataSourceDelegate?

    init(delegate: DataSourceDelegate) {
        self.delegate = delegate
    }

    private var isRectangular: Bool { (rectangular.getValue?() as? Bool) == true }
    private var isAimer: Bool { (aimer.getValue?() as? Bool) == true }

    // MARK: - Sections
    var sections: [Section] {
        var sections = [viewfinderType]

        if isRectangular {
            sections.append(contentsOf: [rectangularSettings, animation, rectangularSizeType])
            switch SettingsManager.current.rectangularViewfinder.viewfinderSizeSpecification {
            case .widthAndHeight: sections.append(rectangularWidthAndHeight)
            case .widthAndHeightAspect: sections.append(rectangularWidthAndHeightAspect)
            case .heightAndWidthAspect: sections.append(rectangularHeightAndAspectRatio)
            case .shorterDimensionAndAspectRatio: break
            }
        } else if isAimer {
            sections.append(aimerSettings)
        }

        return sections
    }

    // MARK: Section: Type

    lazy var viewfinderType: Section = {
        return Section(title: "Type", rows: [none, rectangular, aimer])
    }()

    lazy var none: Row = {
        return Row.option(
            title: "None",
            getValue: { SettingsManager.current.viewfinderConfiguration.viewfinder == nil },
            didSelect: { _, _ in SettingsManager.current.viewfinderConfiguration.viewfinder = nil },
            dataSourceDelegate: self.delegate
        )
    }()

    lazy var rectangular: Row = {
        return Row.option(
            title: "Rectangular",
            getValue: { SettingsManager.current.viewfinderConfiguration.viewfinder is RectangularViewfinder },
            didSelect: { _, _ in SettingsManager.current.viewfinderConfiguration.viewfinder = RectangularViewfinder() },
            dataSourceDelegate: self.delegate
        )
    }()

    lazy var aimer: Row = {
        return Row.option(
            title: "Aimer",
            getValue: { SettingsManager.current.viewfinderConfiguration.viewfinder is AimerViewfinder },
            didSelect: { _, _ in SettingsManager.current.viewfinderConfiguration.viewfinder = AimerViewfinder() },
            dataSourceDelegate: self.delegate
        )
    }()

    // MARK: Section: Rectangular Viewfinder Settings

    lazy var rectangularSettings: Section = {
        return Section(
            title: "Rectangular", rows: [
                Row.choice(
                    title: "Style",
                    options: RectangularViewfinderStyle.allCases,
                    getValue: { SettingsManager.current.rectangularViewfinder.style },
                    didChangeValue: { value in
                        SettingsManager.current.rectangularViewfinder.style = value
                        switch value {
                        case .square, .rounded:
                            SettingsManager.current.rectangularViewfinder.viewfinderSizeSpecification = .widthAndHeightAspect
                            self.delegate?.didChangeData()

                        default:
                            break
                        }
                    },
                    dataSourceDelegate: self.delegate
                ),
                Row.choice(
                    title: "Line Style",
                    options: RectangularViewfinderLineStyle.allCases,
                    getValue: { SettingsManager.current.rectangularViewfinder.lineStyle },
                    didChangeValue: { SettingsManager.current.rectangularViewfinder.lineStyle = $0 },
                    dataSourceDelegate: self.delegate
                ),
                Row.init(
                    title: "Dimming (0.0 - 1.0)",
                    kind: .float,
                    getValue: { SettingsManager.current.rectangularViewfinder.dimming },
                    didChangeValue: { SettingsManager.current.rectangularViewfinder.dimming = $0 }),
                Row.init(
                    title: "Disabled Dimming (0.0 - 1.0)",
                    kind: .float,
                    getValue: { SettingsManager.current.rectangularViewfinder.disabledDimming },
                    didChangeValue: { SettingsManager.current.rectangularViewfinder.disabledDimming = $0 }),
                Row.choice(
                    title: "Color",
                    options: RectangularViewfinderColor.allCases,
                    getValue: { SettingsManager.current.rectangularViewfinder.color },
                    didChangeValue: { SettingsManager.current.rectangularViewfinder.color = $0 },
                    dataSourceDelegate: self.delegate
                ),
                Row.choice(
                    title: "Disabled Color",
                    options: RectangularViewfinderDisabledColor.allCases,
                    getValue: { SettingsManager.current.rectangularViewfinder.disabledColor },
                    didChangeValue: { SettingsManager.current.rectangularViewfinder.disabledColor = $0 },
                    dataSourceDelegate: self.delegate
                )
            ])
    }()

    lazy var rectangularSizeType: Section = {
        return Section(rows: [
            Row.choice(
                title: "Size Specification",
                options: RectangularSizeSpecification.allCases,
                getValue: { SettingsManager.current.rectangularViewfinder.viewfinderSizeSpecification },
                didChangeValue: { SettingsManager.current.rectangularViewfinder.viewfinderSizeSpecification = $0 },
                dataSourceDelegate: self.delegate
            )])
    }()

    lazy var rectangularWidthAndHeight: Section = {
        Section(rows: [
            Row.valueWithUnit(
                title: "Width",
                getValue: { SettingsManager.current.rectangularViewfinder.widthAndHeight.width },
                didChangeValue: {
                    let height = SettingsManager.current.rectangularViewfinder.widthAndHeight.height
                    let size = SizeWithUnit(width: $0, height: height)
                    SettingsManager.current.rectangularViewfinder.widthAndHeight = size
                },
                dataSourceDelegate: self.delegate
            ),
            Row.valueWithUnit(
                title: "Height",
                getValue: { SettingsManager.current.rectangularViewfinder.widthAndHeight.height },
                didChangeValue: {
                    let width = SettingsManager.current.rectangularViewfinder.widthAndHeight.width
                    let size = SizeWithUnit(width: width, height: $0)
                    SettingsManager.current.rectangularViewfinder.widthAndHeight = size
                },
                dataSourceDelegate: self.delegate
            )
        ])
    }()

    lazy var rectangularWidthAndHeightAspect: Section = {
        Section(rows: [
            Row.valueWithUnit(
                title: "Width",
                getValue: { SettingsManager.current.rectangularViewfinder.widthAndAspectRatio.size },
                didChangeValue: {
                    let aspect = SettingsManager.current.rectangularViewfinder.widthAndAspectRatio.aspect
                    let size = SizeWithAspect(size: $0, aspect: aspect)
                    SettingsManager.current.rectangularViewfinder.widthAndAspectRatio = size
                },
                dataSourceDelegate: self.delegate
            ),
            Row.init(
                title: "Height Aspect",
                kind: .float,
                getValue: { SettingsManager.current.rectangularViewfinder.widthAndAspectRatio.aspect },
                didChangeValue: {
                    let width = SettingsManager.current.rectangularViewfinder.widthAndAspectRatio.size
                    let size = SizeWithAspect(size: width, aspect: $0)
                    SettingsManager.current.rectangularViewfinder.widthAndAspectRatio = size
                })
        ])
    }()

    lazy var rectangularHeightAndAspectRatio: Section = {
        Section(rows: [
            Row.valueWithUnit(
                title: "Height",
                getValue: { SettingsManager.current.rectangularViewfinder.heightAndAspectRatio.size },
                didChangeValue: {
                    let aspect = SettingsManager.current.rectangularViewfinder.heightAndAspectRatio.aspect
                    let size = SizeWithAspect(size: $0, aspect: aspect)
                    SettingsManager.current.rectangularViewfinder.heightAndAspectRatio = size
                },
                dataSourceDelegate: self.delegate
            ),
            Row.init(
                title: "Width Aspect",
                kind: .float,
                getValue: { SettingsManager.current.rectangularViewfinder.heightAndAspectRatio.aspect },
                didChangeValue: {
                    let height = SettingsManager.current.rectangularViewfinder.heightAndAspectRatio.size
                    let size = SizeWithAspect(size: height, aspect: $0)
                    SettingsManager.current.rectangularViewfinder.heightAndAspectRatio = size
                })
        ])
    }()

    // MARK: Section: Aimer Viewfinder Settings

    lazy var aimerSettings: Section = {
        return Section(
            title: "Aimer", rows: [aimerFrameColor, aimerDotColor]
        )
    }()

    lazy var aimerFrameColor: Row = {
        return Row.choice(
            title: "Aimer Frame Color",
            options: AimerViewfinderFrameColor.allCases,
            getValue: { SettingsManager.current.aimerViewfinder.frameColor },
            didChangeValue: { SettingsManager.current.aimerViewfinder.frameColor = $0 },
            dataSourceDelegate: self.delegate
        )
    }()

    lazy var aimerDotColor: Row = {
        return Row.choice(
            title: "Aimer Dot Color",
            options: AimerViewfinderDotColor.allCases,
            getValue: { SettingsManager.current.aimerViewfinder.dotColor },
            didChangeValue: { SettingsManager.current.aimerViewfinder.dotColor = $0 },
            dataSourceDelegate: self.delegate
        )
    }()
}

extension ViewfinderDataSource {
    var animation: Section {
        let animationRow = Row(
            title: "Animation",
            kind: .switch,
            getValue: { SettingsManager.current.rectangularViewfinder.animation != nil },
            didChangeValue: { value in
                let animation = value ? RectangularViewfinderAnimation(isLooping: true) : nil
                SettingsManager.current.rectangularViewfinder.animation = animation
                self.delegate?.didChangeData()
            })
        var rows = [animationRow]
        if SettingsManager.current.rectangularViewfinder.animation != nil {
            rows.append(Row(
                title: "Looping",
                kind: .switch,
                getValue: {
                    guard let animation = SettingsManager.current.rectangularViewfinder.animation else {
                        return false
                    }
                    return animation.isLooping
                },
                didChangeValue: { value in
                    SettingsManager.current.rectangularViewfinder.animation =
                    RectangularViewfinderAnimation(isLooping: value)
                }))
        }
        return Section(rows: rows)
    }
}
