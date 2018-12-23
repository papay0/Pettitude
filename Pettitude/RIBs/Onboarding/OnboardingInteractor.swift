//
//  OnboardingInteractor.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import RIBs
import RxSwift

protocol OnboardingRouting: ViewableRouting {
    func setParentViewController(parentVC: ViewControllable)
    func startOnboarding()
}

protocol OnboardingPresentable: Presentable {
    var listener: OnboardingPresentableListener? { get set }
}

protocol OnboardingListener: class {
}

final class OnboardingInteractor: PresentableInteractor<OnboardingPresentable>,
    OnboardingInteractable, OnboardingPresentableListener {

    weak var router: OnboardingRouting?
    weak var listener: OnboardingListener?

    override init(presenter: OnboardingPresentable) {
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
