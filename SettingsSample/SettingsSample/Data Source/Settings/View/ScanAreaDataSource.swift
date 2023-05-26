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

class ScanAreaDataSource: DataSource {

    weak var delegate: DataSourceDelegate?

    init(delegate: DataSourceDelegate) {
        self.delegate = delegate
    }

    // MARK: - Sections
    var sections: [Section] {
        [
            Section(title: "Location Selection", rows: [
                rectangularWidth,
                rectangularHeight
            ]),
            Section(rows: [
                shouldShowScanAreaGuides
            ])
        ]
    }

    // MARK: Section: Settings

    lazy var rectangularWidth: Row = {
        Row.valueWithUnit(
            title: "Width",
            getValue: getRectangularWidth,
            didChangeValue: setRectangularWidth,
            dataSourceDelegate: self.delegate)
    }()

    lazy var rectangularHeight: Row = {
        Row.valueWithUnit(
            title: "Height",
            getValue: getRectangularHeight,
            didChangeValue: setRectangularHeight,
            dataSourceDelegate: self.delegate)
    }()

    lazy var shouldShowScanAreaGuides: Row = {
        Row(title: "Show Scan Area Guides",
            kind: .switch,
            getValue: { SettingsManager.current.shouldShowScanAreaGuides },
            didChangeValue: {
                SettingsManager.current.shouldShowScanAreaGuides = $0
            })
    }()

    // MARK: Section: Setters and Getters

    func setRectangularWidth(width: FloatWithUnit) {
        SettingsManager.current.locationSelection =
            RectangularLocationSelection(
                size: SizeWithUnit(
                    width: width,
                    height: getRectangularHeight()
                ))
    }

    func setRectangularHeight(height: FloatWithUnit) {
        SettingsManager.current.locationSelection =
            RectangularLocationSelection(
                size: SizeWithUnit(
                    width: getRectangularWidth(),
                    height: height
                ))
    }

    func getRectangularHeight() -> FloatWithUnit {
        let currentHeight =
        (SettingsManager.current.locationSelection as? RectangularLocationSelection)?.sizeWithUnitAndAspect.widthAndHeight?.height

        let fullHeight = FloatWithUnit(value: 1, unit: .fraction)

        return currentHeight ?? fullHeight
    }

    func getRectangularWidth() -> FloatWithUnit {
        let currentWidth =
            (SettingsManager.current.locationSelection as? RectangularLocationSelection)?.sizeWithUnitAndAspect.widthAndHeight?.width

        let fullWidth = FloatWithUnit(value: 1, unit: .fraction)

        return currentWidth ?? fullWidth
    }
}
