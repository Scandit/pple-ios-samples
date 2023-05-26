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

class PriceCheckFeedbackDataSource: DataSource {

    var correctFeedbackAudio: Sound? {
        get {
            SettingsManager.current.correctFeedback?.sound
        }
        set {
            SettingsManager.current.correctFeedback = Feedback(
                sound: newValue,
                vibration: SettingsManager.current.correctFeedback?.vibration
            )
        }
    }

    var correctFeedbackVibration: Vibration? {
        get {
            SettingsManager.current.correctFeedback?.vibration
        }
        set {
            SettingsManager.current.correctFeedback = Feedback(
                sound: SettingsManager.current.correctFeedback?.sound,
                vibration: newValue
            )
        }
    }

    var wrongFeedbackAudio: Sound? {
        get {
            SettingsManager.current.wrongFeedback?.sound
        }
        set {
            SettingsManager.current.wrongFeedback = Feedback(
                sound: newValue,
                vibration: SettingsManager.current.wrongFeedback?.vibration
            )
        }
    }

    var wrongFeedbackVibration: Vibration? {
        get {
            SettingsManager.current.wrongFeedback?.vibration
        }
        set {
            SettingsManager.current.wrongFeedback = Feedback(
                sound: SettingsManager.current.wrongFeedback?.sound,
                vibration: newValue
            )
        }
    }

    var unknownFeedbackAudio: Sound? {
        get {
            SettingsManager.current.unknownFeedback?.sound
        }
        set {
            SettingsManager.current.unknownFeedback = Feedback(
                sound: newValue,
                vibration: SettingsManager.current.unknownFeedback?.vibration
            )
        }
    }

    var unknownFeedbackVibration: Vibration? {
        get {
            SettingsManager.current.unknownFeedback?.vibration
        }
        set {
            SettingsManager.current.unknownFeedback = Feedback(
                sound: SettingsManager.current.unknownFeedback?.sound,
                vibration: newValue
            )
        }
    }

    static var defaultFeedback = PriceCheckFeedback.defaultPriceCheckFeedback

    weak var delegate: DataSourceDelegate?

    init(delegate: DataSourceDelegate) {
        self.delegate = delegate

        SettingsManager.current.correctFeedback = Self.defaultFeedback.correctPriceFeedback
        SettingsManager.current.wrongFeedback = Self.defaultFeedback.wrongPriceFeedback
        SettingsManager.current.unknownFeedback = Self.defaultFeedback.unknownProductFeedback
    }

    // MARK: - Sections

       lazy var sections: [Section] = [
        correctFeedbackSection,
        wrongFeedbackSection,
        unknownFeedbackSection
       ]

    // MARK: Section: Camera Position

    lazy var correctFeedbackSection: Section = {
        return Section(title: "Correct Price Feedback", rows: [
         Row(title: "Sound",
             kind: .switch,
             getValue: { self.correctFeedbackAudio != nil },
             didChangeValue: {
                 self.correctFeedbackAudio = $0 ?
                    Self.defaultFeedback.correctPriceFeedback?.sound : nil
             }),
         Row(title: "Vibration",
             kind: .switch,
             getValue: { self.correctFeedbackVibration != nil },
             didChangeValue: {
                 self.correctFeedbackVibration = $0 ?
                    Self.defaultFeedback.correctPriceFeedback?.vibration : nil
             })
        ])
    }()

    lazy var wrongFeedbackSection: Section = {
        return Section(title: "Wrong Price Feedback", rows: [
         Row(title: "Sound",
             kind: .switch,
             getValue: { self.wrongFeedbackAudio != nil },
             didChangeValue: {
                 self.wrongFeedbackAudio =  $0 ?
                    Self.defaultFeedback.wrongPriceFeedback?.sound : nil
             }),
         Row(title: "Vibration",
             kind: .switch,
             getValue: { self.wrongFeedbackVibration != nil },
             didChangeValue: {
                 self.wrongFeedbackVibration = $0 ?
                    Self.defaultFeedback.wrongPriceFeedback?.vibration : nil
             })
        ])
    }()

    lazy var unknownFeedbackSection: Section = {
        return Section(title: "Unknown Product Feedback", rows: [
         Row(title: "Sound",
             kind: .switch,
             getValue: { self.unknownFeedbackAudio != nil },
             didChangeValue: {
                 self.unknownFeedbackAudio = $0 ?
                    Self.defaultFeedback.correctPriceFeedback?.sound : nil
             }),
         Row(title: "Vibration",
             kind: .switch,
             getValue: { self.unknownFeedbackVibration != nil },
             didChangeValue: {
                 self.unknownFeedbackVibration = $0 ?
                    Self.defaultFeedback.correctPriceFeedback?.vibration : nil
             })
        ])
    }()
}
