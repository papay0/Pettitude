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

typealias Feeling = String

class FeelingsGenerator: FeelingsGeneratable {

    func getFeeling(for animal: Animal) -> Feeling {
        let feeling = feelings.randomElement() ?? defaultFeeling
        switch animal.type {
        case .cat:
            return feeling
        case .dog:
            return feeling
        case .bird:
            return feeling
        case .unknown:
            return "Unknown"
        }
    }

    private var feelings: [String] = [
        "Nostalgic",
        "In love",
        "Happy",
        "Sad",
        "Surprised",
        "Playful",
        "Calm",
        "Bored",
        "Arrogant",
        "Curious",
        "Disgusted",
        "Innocent",
        "Indifferent",
        "Satisfied",
        "Undecided",
        "Regretful",
        "Suspicious",
        "Perplexed",
        "Shocked",
        "Meditative",
        "Horrified",
        "Guilty",
        "Relaxed"
    ]

    private let defaultFeeling = "Happy"
}
