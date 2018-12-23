//
//  AnimalType.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 11/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import RxSwift

public struct Animal {
    let type: AnimalType
}

typealias Emoji = String

enum AnimalType: String {
    case cat
    case dog
    case bird
    case unknown
}

protocol AnimalStream: class {
    var animalDisplayable: Observable<AnimalDisplayable> { get }
}

protocol MutableAnimalStream: AnimalStream {
    func updateAnimal(with animal: Animal, feeling: Feeling)
}

protocol AnimalDisplayable {
    var animal: Animal! { get }
    var feeling: Feeling! { get }
    var animalRepresentation: Emoji! { get }
}

class AnimalDisplayableImpl: AnimalDisplayable {
    var animal: Animal!
    var feeling: Feeling!
    var animalRepresentation: Emoji!

    init(animal: Animal, feeling: Feeling) {
        self.animal = animal
        self.feeling = feeling
        self.animalRepresentation = getAnimalRepresentation(animal: animal, feeling: feeling)
    }

    // MARK: - Private

    private func getAnimalRepresentation(animal: Animal, feeling: Feeling) -> Emoji {
        switch animal.type {
        case .cat:
            switch feeling.sentimentType {
            case .extraPositive:
                return "😻"
            case .positive:
                return "😺"
            case .neutral:
                return "😼"
            case .negative:
                return "😾"
            case .extraNegative:
                return "😿"
            }
        case .dog:
            return "🐶"
        case .bird:
            return "🕊"
        case .unknown:
            return "🤷‍♂️"
        }
    }
}

class AnimalStreamImpl: MutableAnimalStream {

    var animalDisplayable: Observable<AnimalDisplayable> {
        return subject
            .asObservable()
    }

    func updateAnimal(with animal: Animal, feeling: Feeling) {
        let animalDisplayable = AnimalDisplayableImpl(animal: animal, feeling: feeling)
        if animal.type != .unknown {
            subject.onNext(animalDisplayable)
        }
    }

    // MARK: - Private

    private let subject = PublishSubject<AnimalDisplayable>()
}
