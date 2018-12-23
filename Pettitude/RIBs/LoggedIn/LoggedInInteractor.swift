//
//  LoggedInInteractor.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import Firebase
import RIBs
import RxSwift

protocol LoggedInRouting: Routing {
    func cleanupViews()
}

protocol LoggedInListener: class {
}

final class LoggedInInteractor: Interactor, LoggedInInteractable {

    weak var router: LoggedInRouting?
    weak var listener: LoggedInListener?

    override init() {}

    override func didBecomeActive() {
        super.didBecomeActive()
        Auth.auth().signInAnonymously(completion: nil)
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
    }
}
