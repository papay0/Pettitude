//
//  UserDefaultManager.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 23/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import Foundation

class UserDefaultsManager {

    private static let onboardingDoneKey = "onboardingDone"
    private static let userIdKey = "userId"

    static var onboardingDone: Bool {
        get {
            return UserDefaults.standard.bool(forKey: onboardingDoneKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: onboardingDoneKey)
        }
    }

    static var userId: String? {
        get {
            return UserDefaults.standard.string(forKey: userIdKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userIdKey)
        }
    }
}
