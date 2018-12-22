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
    case positive
    case neutral
    case negative
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
            .positive: [
                "In love",
                "Happy",
                "Surprised",
                "Playful",
                "Curious",
                "Satisfied",
                "Meditative",
                "Relaxed"
            ],
            .neutral: [
                "Nostalgic",
                "Calm",
                "Innocent",
                "Indifferent",
                "Undecided",
                "Suspicious",
                "Perplexed",
                "Shocked"
            ],
            .negative: [
                "Sad",
                "Bored",
                "Arrogant",
                "Disgusted",
                "Regretful",
                "Horrified",
                "Guilty"
            ]
        ]

    /// 60% chance to have a positive feeling
    /// 25% chance to have a neutral feeling
    /// 15% chance to have a negative feeling
    private func generateSentimentType() -> SentimentType {
        let number = Int.random(in: 0 ... 100)
        switch number {
        case 0 ... 70:
            return .positive
        case 71 ... 85:
            return .neutral
        case 86 ... 100:
            return .negative
        default:
            return .positive
        }
    }

    private let defaultFeeling: FeelingDescription = "Happy"
}
