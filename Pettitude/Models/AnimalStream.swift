//
//  AnimalType.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 11/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import RxSwift

//struct Score {
//    let player1Score: Int
//    let player2Score: Int
//
//    static func equals(lhs: Score, rhs: Score) -> Bool {
//        return lhs.player1Score == rhs.player1Score && lhs.player2Score == rhs.player2Score
//    }
//}

private enum AnimalTypeLabel: String {
    // swiftlint:disable identifier_name
    case Cat
    // swiftlint:disable identifier_name
    case Dog
    // swiftlint:disable identifier_name
    case Bird

    var animalType: AnimalType {
        switch self {
        case .Cat:
            return .cat
        case .Dog:
            return .dog
        case .Bird:
            return .bird
        }
    }
}

public struct Animal {
    let type: AnimalType

    static func equals(lhs: Animal, rhs: Animal) -> Bool {
        return lhs.type == rhs.type
    }
}

enum AnimalType {
    case cat
    case dog
    case bird
    case unknown
}

protocol AnimalStream: class {
    var animal: Observable<Animal> { get }
}

protocol MutableAnimalStream: AnimalStream {
    func updateAnimal(with animal: Animal)
}

class AnimalStreamImpl: MutableAnimalStream {

    var animal: Observable<Animal> {
        return variable
            .asObservable()
            .distinctUntilChanged { (lhs: Animal, rhs: Animal) -> Bool in
                Animal.equals(lhs: lhs, rhs: rhs)
        }
    }

    func updateAnimal(with animal: Animal) {
        let newAnimal: Animal = {
            return variable.value
        }()
        variable.value = newAnimal
    }

    // MARK: - Private

    private let variable = Variable<Animal>(Animal(type: .unknown))
}
