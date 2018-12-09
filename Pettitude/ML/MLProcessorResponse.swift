//
//  MLProcessorResponse.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

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

public enum AnimalType {
    case cat
    case dog
    case bird
    case unknown
}

public final class MLProcessorResponse {

    public let animalType: AnimalType

    public init(label: String) {
        print(label)
        animalType = AnimalTypeLabel(rawValue: label)?.animalType ?? .unknown
    }
}
