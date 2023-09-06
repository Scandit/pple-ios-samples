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
import UIKit

enum BrushColor: CaseIterable, CustomStringConvertible {
    case none, red, green, yellow, gray, blue

    var description: String {
        switch self {
        case .none: return "None"
        case .red: return "Red"
        case .green: return "Green"
        case .gray: return "Gray"
        case .yellow: return "Yellow"
        case .blue: return "Blue"
        }
    }

    var brush: Brush? {
        switch self {
        case .none:
            return nil
        case .red:
            return .red
        case .green:
            return .green
        case .gray:
            return .gray
        case .yellow:
            return .yellow
        case .blue:
            return .blue
        }
    }
}

extension Brush {
    static let red = Brush(fillColor: .red.withAlphaComponent(0.3), strokeColor: .clear, strokeWidth: 0)
    static let green = Brush(fillColor: .green.withAlphaComponent(0.3), strokeColor: .clear, strokeWidth: 0)
    static let gray = Brush(fillColor: .gray.withAlphaComponent(0.3), strokeColor: .clear, strokeWidth: 0)
    static let yellow = Brush(fillColor: .yellow.withAlphaComponent(0.3), strokeColor: .clear, strokeWidth: 0)
    static let blue = Brush(fillColor: .blue.withAlphaComponent(0.3), strokeColor: .clear, strokeWidth: 0)

    static let allBrushes: [Brush] = [
        .red, .green, .yellow, .gray, .blue
    ]
}

class OverlayDataSource: DataSource {

    static let brushes = [
        Brush.red,
        Brush.green
    ]

    // MARK: - Sections

    var sections: [Section] {
        [basicOverlaySection, advancedOverlaySection, customOverlaySection]
    }

    var basicOverlaySection: Section {
        let animationRow = Row(
            title: "Enabled",
            kind: .switch,
            getValue: { SettingsManager.current.basicOverlay.isEnabled },
            didChangeValue: {
                SettingsManager.current.basicOverlay.isEnabled = $0
                self.delegate?.didChangeData()
            })

        var rows = [animationRow]

        if SettingsManager.current.basicOverlay.isEnabled {
            rows.append(Row.choice(
                title: "Correct price brush",
                options: BrushColor.allCases,
                getValue: { SettingsManager.current.basicOverlay.correctBrush  },
                didChangeValue: {
                    SettingsManager.current.basicOverlay.correctBrush = $0
                },
                dataSourceDelegate: self.delegate)
            )
            rows.append(Row.choice(
                title: "Wrong price brush",
                options: BrushColor.allCases,
                getValue: { SettingsManager.current.basicOverlay.wrongBrush  },
                didChangeValue: {
                    SettingsManager.current.basicOverlay.wrongBrush = $0
                },
                dataSourceDelegate: self.delegate)
            )
            rows.append(Row.choice(
                title: "Unknown product price brush",
                options: BrushColor.allCases,
                getValue: { SettingsManager.current.basicOverlay.unknownBrush  },
                didChangeValue: {
                    SettingsManager.current.basicOverlay.unknownBrush = $0
                },
                dataSourceDelegate: self.delegate)
            )
        }

        return Section(title: "Basic Overlay", rows: rows)
    }

    var advancedOverlaySection: Section {
        return Section(title: "Advanced Overlay", rows: [
            Row(
                title: "Enabled",
                kind: .switch,
                getValue: { SettingsManager.current.advancedOverlay.isEnabled },
                didChangeValue: {
                    SettingsManager.current.advancedOverlay.isEnabled = $0
                    self.delegate?.didChangeData()
                })
        ])
    }

    var customOverlaySection: Section {
        return Section(title: "Custom Overlay", rows: [
            Row(
                title: "Enabled",
                kind: .switch,
                getValue: { SettingsManager.current.customOverlay.customOverlayEnabled },
                didChangeValue: {
                    SettingsManager.current.customOverlay.customOverlayEnabled = $0
                    self.delegate?.didChangeData()
                })
        ])
    }

    weak var delegate: DataSourceDelegate?

    init(delegate: DataSourceDelegate) {
        self.delegate = delegate
    }
}
