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
}

protocol OnboardingPresentable: Presentable {
    var listener: OnboardingPresentableListener? { get set }
    func startOnboarding()
}

protocol OnboardingListener: class {
}

final class OnboardingInteractor: PresentableInteractor<OnboardingPresentable>,
    OnboardingInteractable, OnboardingPresentableListener {

    weak var router: OnboardingRouting?
    weak var listener: OnboardingListener?

    init(presenter: OnboardingPresentable, animalStream: AnimalStream) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        updateAnimal()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    // MARK: - OnboardingPresentableListener

    // MARK: - Private

    private func updateAnimal() {
        presenter.startOnboarding()
    }
}
