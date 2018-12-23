//
//  LoggedInRouter.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import RIBs

protocol LoggedInInteractable: Interactable, HomeListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

protocol LoggedInViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class LoggedInRouter: Router<LoggedInInteractable>, LoggedInRouting {

    init(interactor: LoggedInInteractable,
         viewController: LoggedInViewControllable,
         homeBuilder: HomeBuildable) {
        self.viewController = viewController
        self.homeBuilder = homeBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }

    override func didLoad() {
        super.didLoad()
        attachHome()
    }

    func cleanupViews() {
        // Since this router does not own its view, it needs to cleanup the views
        // it may have added to the view hierarchy, when its interactor is deactivated.
    }

    // MARK: - Private

    private let viewController: LoggedInViewControllable
    private let homeBuilder: HomeBuildable

    private var currentChild: ViewableRouting?

    private func attachHome() {
        let home = homeBuilder.build(with: interactor)
        self.currentChild = home
        attachChild(home)
        viewController.present(viewController: home.viewControllable)
    }
}
