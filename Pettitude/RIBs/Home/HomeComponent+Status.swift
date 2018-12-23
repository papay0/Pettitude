//
//  File.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 11/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import RIBs

extension HomeComponent: StatusDependency {
    var animalStream: AnimalStream {
        return mutableAnimalStream
    }
}
