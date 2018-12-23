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

    // MARK: - HomeRouting

    func showError(message: String, error: PettitudeErrorType) {
        guard statusRouter != nil else { return }
        statusRouter?.showError(message: message, error: error)
    }

    // MARK: - Private

    private let statusBuilder: StatusBuildable
    private var statusRouter: StatusRouting?

    private func attachStatus() {
        let status = statusBuilder.build(with: interactor)
        statusRouter = status
        attachChild(status)
        status.setParentViewController(parentVC: viewController)
    }
}
