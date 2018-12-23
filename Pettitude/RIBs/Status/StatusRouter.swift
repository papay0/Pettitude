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
    func setParentViewController(parentVC: ViewControllable)
    func showError(message: String, error: PettitudeErrorType)
}

final class StatusRouter: ViewableRouter<StatusInteractable, StatusViewControllable>, StatusRouting {

    override init(interactor: StatusInteractable, viewController: StatusViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    // MARK: - StatusRouting

    func setParentViewController(parentVC: ViewControllable) {
        viewController.setParentViewController(parentVC: parentVC)
    }

    func showError(message: String, error: PettitudeErrorType) {
        viewController.showError(message: message, error: error)
    }
}
