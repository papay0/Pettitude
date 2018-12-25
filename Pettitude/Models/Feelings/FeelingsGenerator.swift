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
    let description: FeelingDescription
    let sentimentType: SentimentType
}

class FeelingsGenerator: FeelingsGeneratable {

    init() {
        defaultFeelingDescription = LS("Happy")
        defaultFeeling = Feeling(description: defaultFeelingDescription, sentimentType: .positive)
        previousFeeling = defaultFeeling
        minimumTimeForSameFeeling = 10
    }

    func getFeeling(for animal: Animal) -> Feeling {
        if canGetPreviousFeeling(previousFeeling: previousFeeling, animal: animal) {
            previousDate = Date.timeIntervalSinceReferenceDate
            return previousFeeling
        }
        let sentimentType: SentimentType = generateSentimentType()
        let feelingDescription = feelings[sentimentType]?.randomElement() ?? defaultFeelingDescription
        var feeling: Feeling
        switch animal.type {
        case .cat:
            feeling = Feeling(description: feelingDescription, sentimentType: sentimentType)
        case .dog:
            feeling = Feeling(description: feelingDescription, sentimentType: sentimentType)
        case .bird:
            feeling = Feeling(description: feelingDescription, sentimentType: sentimentType)
        case .unknown:
            feeling = Feeling(description: "unknown", sentimentType: .neutral)
        }
        previousFeeling = feeling
        previousDate = Date.timeIntervalSinceReferenceDate
        previousAnimal = animal
        return feeling
    }

    private var feelings: [
            SentimentType: [FeelingDescription]
        ] = [
            .extraPositive: [
                LS("in_love")
            ],
            .positive: [
                LS("Happy"),
                LS("Surprised"),
                LS("Playful"),
                LS("Curious"),
                LS("Satisfied"),
                LS("Meditative"),
                LS("Relaxed")
            ],
            .neutral: [
                LS("Nostalgic"),
                LS("Calm"),
                LS("Innocent"),
                LS("Indifferent"),
                LS("Undecided"),
                LS("Suspicious"),
                LS("Perplexed"),
                LS("Shocked")
            ],
            .negative: [
                LS("Bored"),
                LS("Arrogant"),
                LS("Regretful")
            ],
            .extraNegative: [
                LS("Sad"),
                LS("Horrified"),
                LS("Guilty"),
                LS("Disgusted")
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

    private func canGetPreviousFeeling(previousFeeling: Feeling, animal: Animal) -> Bool {
        guard let previousAnimal = previousAnimal, previousAnimal == animal else { return false }
        guard let previousDate = previousDate else { return false }
        let currentDate = Date.timeIntervalSinceReferenceDate
        if Int(currentDate - previousDate) >= minimumTimeForSameFeeling {
            return false
        }
        return true
    }

    private var previousFeeling: Feeling
    private var previousAnimal: Animal?
    private let defaultFeelingDescription: FeelingDescription
    private let defaultFeeling: Feeling
    private var previousDate: TimeInterval?
    private let minimumTimeForSameFeeling: Int
}
