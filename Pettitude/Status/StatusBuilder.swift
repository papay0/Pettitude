//
//  StatusBuilder.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import RIBs

protocol StatusDependency: Dependency {
}

final class StatusComponent: Component<StatusDependency> {
}

// MARK: - Builder

protocol StatusBuildable: Buildable {
    func build(withListener listener: StatusListener) -> StatusRouting
}

final class StatusBuilder: Builder<StatusDependency>, StatusBuildable {

    override init(dependency: StatusDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: StatusListener) -> StatusRouting {
        let component = StatusComponent(dependency: dependency)
        let viewController = StatusViewController()
        let interactor = StatusInteractor(presenter: viewController)
        interactor.listener = listener
        return StatusRouter(interactor: interactor, viewController: viewController)
    }
}
