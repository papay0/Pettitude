//
//  HomeRouter.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import RIBs

protocol HomeInteractable: Interactable, StatusListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {

    init(interactor: HomeInteractable,
         viewController: HomeViewControllable,
         statusBuilder: StatusBuildable) {
        self.statusBuilder = statusBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    override func didLoad() {
        super.didLoad()
        attachStatus()
    }

    // MARK: - Private

    private let statusBuilder: StatusBuildable
    private var currentChild: ViewableRouting?

    private func attachStatus() {
        let status = statusBuilder.build(with: interactor)
        currentChild = status
        attachChild(status)
        status.setParentViewController(parentVC: viewController)
    }
}
