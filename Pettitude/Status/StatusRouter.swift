//
//  StatusRouter.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import RIBs

protocol StatusInteractable: Interactable {
    var router: StatusRouting? { get set }
    var listener: StatusListener? { get set }
}

protocol StatusViewControllable: ViewControllable {
}

final class StatusRouter: ViewableRouter<StatusInteractable, StatusViewControllable>, StatusRouting {

    override init(interactor: StatusInteractable, viewController: StatusViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
