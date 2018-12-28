//
//  FirestoreManager.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 27/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import Firebase

class FirestoreManager {
    static let shared = FirestoreManager()
    private lazy var functions = Functions.functions()

    private enum Fcts: String {
        case login
        case animalClassified
    }

    init() {}

    func login() {
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error as NSError? {
                Crashlytics.sharedInstance().recordError(error)
                Analytics.logEvent("error_signInAnonymously", parameters: ["description": error.description])
            }
            guard let userId = authResult?.user.uid else { return }
            self.functions.httpsCallable(Fcts.login.rawValue)
                .call(["userId": userId], completion: { (result, error) in
                if let error = error as NSError? {
                    Crashlytics.sharedInstance().recordError(error)
                    Analytics.logEvent("error_httpsCallable_login", parameters: ["description": error.description])
                }
                if let userCreated = (result?.data as? [String: Any])?["userCreated"] as? Bool, userCreated {
                    Analytics.logEvent("user_created", parameters: nil)
                    UserDefaultsManager.userId = userId
                }
                if let userLoggedIn = (result?.data as? [String: Any])?["userLoggedIn"] as? Bool, userLoggedIn {
                    Analytics.logEvent("user_logged_in", parameters: nil)
                } else {
                    Analytics.logEvent("error_userLoggedIn", parameters: nil)
                }
            })
        }
    }

    func animalClassified() {
        guard let userId = UserDefaultsManager.userId else {
            Analytics.logEvent("error_userId_null", parameters: nil)
            return
        }
        self.functions.httpsCallable(Fcts.animalClassified.rawValue)
            .call(["userId": userId], completion: { (result, error) in
            if let error = error as NSError? {
                Crashlytics.sharedInstance().recordError(error)
                Analytics.logEvent(
                    "error_httpsCallable_animalClassified",
                    parameters: ["description": error.description]
                )
            }
            if let updated = (result?.data as? [String: Any])?["updated"] as? Bool, updated {
                Analytics.logEvent("animalClassified_updated", parameters: nil)
            } else {
                Analytics.logEvent("error_animalClassified", parameters: nil)
            }
        })
    }
}
