//
//  HomeRouter.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import RIBs

protocol HomeInteractable: Interactable, StatusListener, OnboardingListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {

    init(interactor: HomeInteractable,
         viewController: HomeViewControllable,
         statusBuilder: StatusBuildable,
         onboardingBuilder: OnboardingBuildable) {
        self.statusBuilder = statusBuilder
        self.onboardingBuilder = onboardingBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    override func didLoad() {
        super.didLoad()
        attachStatus()
        attachOnboarding()
    }

    // MARK: - HomeRouting

    func showError(message: String, error: PettitudeErrorType) {
        guard statusRouter != nil else { return }
        statusRouter?.showError(message: message, error: error)
    }

    func startOnboarding() {
        guard onboardingRouter != nil else { return }
        onboardingRouter?.startOnboarding()
    }

    // MARK: - Private

    private let statusBuilder: StatusBuildable
    private var statusRouter: StatusRouting?

    private let onboardingBuilder: OnboardingBuildable
    private var onboardingRouter: OnboardingRouting?

    private func attachStatus() {
        let status = statusBuilder.build(with: interactor)
        statusRouter = status
        attachChild(status)
        status.setParentViewController(parentVC: viewController)
    }

    private func attachOnboarding() {
        let onboarding = onboardingBuilder.build(with: interactor)
        onboardingRouter = onboarding
        attachChild(onboarding)
        onboarding.setParentViewController(parentVC: viewController)
    }
}
