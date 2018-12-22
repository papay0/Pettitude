//
//  LocalizationFallback.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 23/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import Foundation

public func LS(_ key: String) -> String {
    let value = NSLocalizedString(key, comment: "")
    if value != key || NSLocale.preferredLanguages.first == "en" {
        return value
    }
    
    // Fall back to en
    guard
        let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
        let bundle = Bundle(path: path)
        else { return value }
    return NSLocalizedString(key, bundle: bundle, comment: "")
}
