//
//  Feelings.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 20/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import Foundation

protocol FeelingsGeneratable {
    func getFeeling(for animal: Animal) -> Feeling
}

enum SentimentType {
    case extraPositive
    case positive
    case neutral
    case negative
    case extraNegative
}

typealias FeelingDescription = String

struct Feeling {
    let feelingDescription: FeelingDescription
    let sentimentType: SentimentType
}

class FeelingsGenerator: FeelingsGeneratable {

    func getFeeling(for animal: Animal) -> Feeling {
        let sentimentType: SentimentType = generateSentimentType()
        let feelingDescription = feelings[sentimentType]?.randomElement() ?? defaultFeeling
        var feeling: Feeling
        switch animal.type {
        case .cat:
            feeling = Feeling(feelingDescription: feelingDescription, sentimentType: sentimentType)
        case .dog:
            feeling = Feeling(feelingDescription: feelingDescription, sentimentType: sentimentType)
        case .bird:
            feeling = Feeling(feelingDescription: feelingDescription, sentimentType: sentimentType)
        case .unknown:
            feeling = Feeling(feelingDescription: "unknown", sentimentType: .neutral)
        }
        return feeling
    }

    private var feelings: [
            SentimentType: [FeelingDescription]
        ] = [
            .extraPositive: [
                NSLocalizedString("in_love", comment: "")
            ],
            .positive: [
                NSLocalizedString("Happy", comment: ""),
                NSLocalizedString("Surprised", comment: ""),
                NSLocalizedString("Playful", comment: ""),
                NSLocalizedString("Curious", comment: ""),
                NSLocalizedString("Satisfied", comment: ""),
                NSLocalizedString("Meditative", comment: ""),
                NSLocalizedString("Relaxed", comment: "")
            ],
            .neutral: [
                NSLocalizedString("Nostalgic", comment: ""),
                NSLocalizedString("Calm", comment: ""),
                NSLocalizedString("Innocent", comment: ""),
                NSLocalizedString("Indifferent", comment: ""),
                NSLocalizedString("Undecided", comment: ""),
                NSLocalizedString("Suspicious", comment: ""),
                NSLocalizedString("Perplexed", comment: ""),
                NSLocalizedString("Shocked", comment: "")
            ],
            .negative: [
                NSLocalizedString("Bored", comment: ""),
                NSLocalizedString("Arrogant", comment: ""),
                NSLocalizedString("Regretful", comment: "")
            ],
            .extraNegative: [
                NSLocalizedString("Sad", comment: ""),
                NSLocalizedString("Horrified", comment: ""),
                NSLocalizedString("Guilty", comment: ""),
                NSLocalizedString("Disgusted", comment: "")
            ]
        ]

    /// 10% chance to have a positive feeling
    /// 50% chance to have a positive feeling
    /// 25% chance to have a neutral feeling
    /// 10% chance to have a negative feeling
    /// 5% chance to have a negative feeling
    private func generateSentimentType() -> SentimentType {
        let number = Int.random(in: 0 ... 100)
        switch number {
        case 0 ... 10:
            return .extraPositive
        case 11 ... 60:
            return .positive
        case 61 ... 85:
            return .neutral
        case 86 ... 95:
            return .negative
        case 96 ... 100:
            return .extraNegative
        default:
            return .positive
        }
    }

    private let defaultFeeling: FeelingDescription = NSLocalizedString("Happy", comment: "")
}
