// SettingsManagerFeedbackSection.swift
//
// Copyright © 2023 Scandit. All rights reserved.

import Foundation
import ScanditShelf

struct SettingsManagerFeedbackSection: SettingsManagerSection {

    var correct: Feedback? = PriceCheckFeedback.defaultPriceCheckFeedback.correctPriceFeedback {
        didSet {
            updateFeedback()
        }
    }
    var wrong: Feedback? = PriceCheckFeedback.defaultPriceCheckFeedback.wrongPriceFeedback {
        didSet {
            updateFeedback()
        }
    }
    var unknown: Feedback? = PriceCheckFeedback.defaultPriceCheckFeedback.unknownProductFeedback {
        didSet {
            updateFeedback()
        }
    }

    func updateFeedback() {
        priceCheck.setFeedback(PriceCheckFeedback(
            correctPriceFeedback: correct,
            wrongPriceFeedback: wrong,
            unknownProductFeedback: unknown
        ))
    }
}
