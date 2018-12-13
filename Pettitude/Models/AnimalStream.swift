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

    static func equals(lhs: Animal, rhs: Animal) -> Bool {
        return lhs.type == rhs.type
    }
}

enum AnimalType: String {
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
            .skipWhile({ (animal) -> Bool in
                return animal.type != .unknown
            })
            .distinctUntilChanged { (lhs: Animal, rhs: Animal) -> Bool in
                Animal.equals(lhs: lhs, rhs: rhs)
        }
    }

    func updateAnimal(with animal: Animal) {
        let newAnimal: Animal = {
            return animal
        }()
        variable.value = newAnimal
    }

    // MARK: - Private

    private let variable = Variable<Animal>(Animal(type: .unknown))
}
