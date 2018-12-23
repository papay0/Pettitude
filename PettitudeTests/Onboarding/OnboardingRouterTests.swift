//
//  OnboardingRouterTests.swift
//  PettitudeTests
//
//  Created by Arthur Papailhau on 23/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

@testable import Pettitude
import XCTest

final class OnboardingRouterTests: XCTestCase {

    private var router: OnboardingRouter!
    private var viewController: OnboardingViewControllableMock!
    private var interactor: OnboardingInteractableMock!

    override func setUp() {
        super.setUp()

        viewController = OnboardingViewControllableMock()
        interactor = OnboardingInteractableMock()
        router = OnboardingRouter(interactor: interactor, viewController: viewController)
    }

    // MARK: - Tests

    func test_setParentViewController_callsSetParentViewController() {
        let setParentViewControllerCallCount = viewController.setParentViewControllerCallCount
        router.setParentViewController(parentVC: ViewControllableMock())
        XCTAssertEqual(setParentViewControllerCallCount + 1, viewController.setParentViewControllerCallCount)
    }

    func test_startOnboarding_callsStartOnboarding() {
        let startOnboardingCallCount = viewController.startOnboardingCallCount
        router.startOnboarding()
        XCTAssertEqual(startOnboardingCallCount + 1, viewController.startOnboardingCallCount)
    }
}
