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
        return subject
            .asObservable()
    }

    func updateAnimal(with animal: Animal) {
        let newAnimal: Animal = {
            return animal
        }()
        if newAnimal.type != .unknown {
            subject.onNext(newAnimal)
        }
    }

    // MARK: - Private

    private let subject = PublishSubject<Animal>()
}
