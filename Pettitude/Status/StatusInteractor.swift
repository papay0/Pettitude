//
//  StatusInteractor.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import RIBs
import RxSwift

protocol StatusRouting: ViewableRouting {

}

protocol StatusPresentable: Presentable {
    var listener: StatusPresentableListener? { get set }
}

protocol StatusListener: class {
}

final class StatusInteractor: PresentableInteractor<StatusPresentable>, StatusInteractable, StatusPresentableListener {

    weak var router: StatusRouting?
    weak var listener: StatusListener?

    override init(presenter: StatusPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
