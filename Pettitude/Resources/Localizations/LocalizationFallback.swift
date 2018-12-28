//
//  LocalizationFallback.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 23/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import Foundation

private func englishTranslation(for key: String, defaultValue: String) -> String {
    guard
        let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
        let bundle = Bundle(path: path)
        else { return defaultValue }
    return NSLocalizedString(key, bundle: bundle, comment: "")
}

public func LS(_ key: String, useEnglish: Bool = false) -> String {
    let value = NSLocalizedString(key, comment: "")
    if useEnglish {
        return englishTranslation(for: key, defaultValue: value)
    }
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
