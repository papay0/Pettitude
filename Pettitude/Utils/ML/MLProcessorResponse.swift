//
//  MLProcessorResponse.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

private enum AnimalLabel: String {

    // swiftlint:disable identifier_name
    case Cat
    // swiftlint:disable identifier_name
    case Dog
    // swiftlint:disable identifier_name
    case Bird

    var animal: Animal {
        switch self {
        case .Cat:
            return Animal(type: .cat, isKnown: true)
        case .Dog:
            return Animal(type: .dog, isKnown: true)
        case .Bird:
            return Animal(type: .bird, isKnown: true)
        }
    }
}

public final class MLProcessorResponse {

    public let animal: Animal

    public init(label: String) {
        animal = AnimalLabel(rawValue: label)?.animal ?? Animal(type: .unknown, isKnown: false)
    }
}
