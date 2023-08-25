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

    private static let defaultFeedback = PriceCheckFeedback.defaultPriceCheckFeedback

    var correctFeedbackAudio: Sound? {
        get {
            manager.feedback.correct?.sound
        }
        set {
            manager.feedback.correct = Feedback(
                sound: newValue,
                vibration: manager.feedback.correct?.vibration
            )
        }
    }

    var correctFeedbackVibration: Vibration? {
        get {
            manager.feedback.correct?.vibration
        }
        set {
            manager.feedback.correct = Feedback(
                sound: manager.feedback.correct?.sound,
                vibration: newValue
            )
        }
    }

    var wrongFeedbackAudio: Sound? {
        get {
            manager.feedback.wrong?.sound
        }
        set {
            manager.feedback.wrong = Feedback(
                sound: newValue,
                vibration: manager.feedback.wrong?.vibration
            )
        }
    }

    var wrongFeedbackVibration: Vibration? {
        get {
            manager.feedback.wrong?.vibration
        }
        set {
            manager.feedback.wrong = Feedback(
                sound: manager.feedback.wrong?.sound,
                vibration: newValue
            )
        }
    }

    var unknownFeedbackAudio: Sound? {
        get {
            manager.feedback.unknown?.sound
        }
        set {
            manager.feedback.unknown = Feedback(
                sound: newValue,
                vibration: manager.feedback.unknown?.vibration
            )
        }
    }

    var unknownFeedbackVibration: Vibration? {
        get {
            manager.feedback.unknown?.vibration
        }
        set {
            manager.feedback.unknown = Feedback(
                sound: manager.feedback.unknown?.sound,
                vibration: newValue
            )
        }
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

    weak var delegate: DataSourceDelegate?

    private var manager: SettingsManager { SettingsManager.current }

    init(delegate: DataSourceDelegate) {
        self.delegate = delegate
    }
}
