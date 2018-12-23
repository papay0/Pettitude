//
//  Mocks.swift
//  PettitudeTests
//
//  Created by Arthur Papailhau on 23/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

@testable import Pettitude
import RIBs
import RxSwift
import UIKit

class OnboardingViewControllableMock: OnboardingViewControllable {

    var setParentViewControllerHandler: ((_ viewController: ViewControllable) -> Void)?
    var setParentViewControllerCallCount: Int = 0
    var startOnboardingHandler: (() -> Void)?
    var startOnboardingCallCount: Int = 0

    init() {}

    func setParentViewController(parentVC: ViewControllable) {
        setParentViewControllerCallCount += 1
        if let setParentViewControllerHandler = setParentViewControllerHandler {
            return  setParentViewControllerHandler(parentVC)
        }
    }

    func startOnboarding() {
        startOnboardingCallCount += 1
        if let startOnboarderHandler = startOnboardingHandler {
            return startOnboarderHandler()
        }
    }

    var uiviewController: UIViewController =  UIViewController() { didSet { uiviewControllerSetCallCount += 1 } }
    var uiviewControllerSetCallCount = 0
}

class OnboardingInteractableMock: OnboardingInteractable {

    var router: OnboardingRouting? = nil { didSet { routerSetCallCount += 1 } }
    var routerSetCallCount = 0
    var listener: OnboardingListener? = nil { didSet { listenerSetCallCount += 1 } }
    var listenerSetCallCount = 0

    var activateHandler: (() -> Void)?
    var activateCallCount: Int = 0
    var deactivateHandler: (() -> Void)?
    var deactivateCallCount: Int = 0

    init() {}

    func activate() {
        activateCallCount += 1
        if let activateHandler = activateHandler {
            return activateHandler()
        }
    }

    func deactivate() {
        deactivateCallCount += 1
        if let deactivateHandler = deactivateHandler {
            return deactivateHandler()
        }
    }

    var isActive: Bool = false { didSet { isActiveSetCallCount += 1 } }
    var isActiveSetCallCount = 0

    var isActiveStreamSubject: PublishSubject<Bool> = PublishSubject<Bool>() {
        didSet { isActiveStreamSubjectSetCallCount += 1 }
    }
    var isActiveStreamSubjectSetCallCount = 0
    var isActiveStream: Observable<Bool> { return isActiveStreamSubject }
}

class ViewControllableMock: ViewControllable {
    var uiviewController: UIViewController =  UIViewController() { didSet { uiviewControllerSetCallCount += 1 } }
    var uiviewControllerSetCallCount = 0
}
