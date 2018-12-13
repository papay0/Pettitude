//
//  StatusViewController.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import BLTNBoard
import RIBs
import RxSwift
import UIKit

protocol StatusPresentableListener: class {
}

final class StatusViewController: UIViewController, StatusPresentable, StatusViewControllable {

    weak var listener: StatusPresentableListener?

    lazy var bulletinManager: BLTNItemManager = {

        let rootItem: BLTNItem = createOnboarding()
        return BLTNItemManager(rootItem: rootItem)

    }()

    private func createOnboarding() -> BLTNItem {
        let page = BLTNPageItem(title: titleBulletin)
        page.descriptionText = "HAPPY"
        page.actionButtonTitle = "OK"

        page.actionHandler = { item in
            item.manager?.dismissBulletin()
        }

        return page
    }

    private var titleBulletin = "TEST STATUS RIB"

    var parentVC: UIViewController? {
        didSet {
            print("parentVC set")
        }
    }

    private func presentAnimalCard(animal: Animal) {
        guard let parentVC = parentVC else { return }
        bulletinManager.backgroundViewStyle = .dimmed
        bulletinManager.showBulletin(above: parentVC)
    }

    // MARK: - StatusPresentable

    func set(animal: Animal) {
        print("animal: \(animal)")
        titleBulletin = animal.type.rawValue
        presentAnimalCard(animal: animal)
    }

    // MARK: - StatusViewControllable

    func setParentViewController(parentVC: ViewControllable) { // TODO: Update to parentViewControllable
        self.parentVC = parentVC.uiviewController
    }
}
