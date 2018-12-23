//
//  OnboardingBuilder.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import RIBs

protocol OnboardingDependency: Dependency {
    var animalStream: AnimalStream { get }
}

final class OnboardingComponent: Component<OnboardingDependency> {
    fileprivate var animalStream: AnimalStream {
        return dependency.animalStream
    }
}

// MARK: - Builder

protocol OnboardingBuildable: Buildable {
    func build(with listener: OnboardingListener) -> OnboardingRouting
}

final class OnboardingBuilder: Builder<OnboardingDependency>, OnboardingBuildable {

    override init(dependency: OnboardingDependency) {
        super.init(dependency: dependency)
    }

    func build(with listener: OnboardingListener) -> OnboardingRouting {
        let component = OnboardingComponent(dependency: dependency)
        let viewController = OnboardingViewController()
        let interactor = OnboardingInteractor(presenter: viewController,
                                          animalStream: component.animalStream)
        interactor.listener = listener
        return OnboardingRouter(interactor: interactor, viewController: viewController)
    }
}
