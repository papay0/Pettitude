//
//  OnboardingRouter.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import RIBs

protocol OnboardingInteractable: Interactable {
    var router: OnboardingRouting? { get set }
    var listener: OnboardingListener? { get set }
}

protocol OnboardingViewControllable: ViewControllable {
    func setParentViewController(parentVC: ViewControllable)
}

final class OnboardingRouter: ViewableRouter<OnboardingInteractable, OnboardingViewControllable>, OnboardingRouting {

    override init(interactor: OnboardingInteractable, viewController: OnboardingViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    // MARK: - OnboardingRouting

    func setParentViewController(parentVC: ViewControllable) {
        viewController.setParentViewController(parentVC: parentVC)
    }
}
