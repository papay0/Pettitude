//
//  OnboardingViewController.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import BLTNBoard
import Firebase
import RIBs
import RxSwift
import UIKit

protocol OnboardingPresentableListener: class {
}

final class OnboardingViewController: UIViewController, OnboardingPresentable, OnboardingViewControllable {

    weak var listener: OnboardingPresentableListener?

    lazy var onboardingBulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = createOnboardingBulletin()
        return BLTNItemManager(rootItem: rootItem)
    }()

    private func createOnboardingBulletin() -> BLTNItem {
        let page = BLTNPageItem(title: titleBulletin)
        page.descriptionText = LS("onboarding_description")
        page.actionButtonTitle = LS("onboarding_acknowledgement")

        page.actionHandler = { item in
            self.onboardingBulletinManager.dismissBulletin()
            UserDefaultsManager.onboardingDone = true
        }

        return page
    }

    private var titleBulletin = LS("onboarding_title")

    var parentVC: UIViewController?

    private func presentOnboarding() {
        guard let parentVC = parentVC,
            !onboardingBulletinManager.isShowingBulletin else { return }
        onboardingBulletinManager.backgroundViewStyle = .dimmed
        DispatchQueue.main.async {
            self.onboardingBulletinManager.showBulletin(above: parentVC, animated: true, completion: nil)
        }
    }

    // MARK: - OnboardingViewControllable

    func setParentViewController(parentVC: ViewControllable) {
        self.parentVC = parentVC.uiviewController
    }

    func startOnboarding() {
        presentOnboarding()
    }
}
