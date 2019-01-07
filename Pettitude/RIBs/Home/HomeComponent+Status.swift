//
//  File.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 11/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import Device_swift
import RIBs

extension HomeComponent: StatusDependency {
    var animalStream: AnimalStream {
        return mutableAnimalStream
    }

    var isARKitCapable: Bool {
        return !(UIDevice.current.deviceType == .iPhone5S
            || UIDevice.current.deviceType == .iPhone6
            || UIDevice.current.deviceType == .iPhone6Plus)
    }
}
