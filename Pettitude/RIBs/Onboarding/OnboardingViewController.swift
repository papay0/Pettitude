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
        page.descriptionText = "feeling"
        page.actionButtonTitle = "Compris"

        page.actionHandler = { item in
            self.onboardingBulletinManager.dismissBulletin()
        }

        return page
    }

    private var titleBulletin = "title here"

    var parentVC: UIViewController?

    private func presentOnboarding() {
        guard let parentVC = parentVC,
            !onboardingBulletinManager.isShowingBulletin else { return }
        onboardingBulletinManager.backgroundViewStyle = .dimmed
        DispatchQueue.main.async {
            self.onboardingBulletinManager.showBulletin(above: parentVC, animated: true, completion: nil)
        }
    }

    // MARK: - OnboardingPresentable

    func startOnboarding() {
        presentOnboarding()
    }

    // MARK: - OnboardingViewControllable

    func setParentViewController(parentVC: ViewControllable) {
        self.parentVC = parentVC.uiviewController
    }
}
