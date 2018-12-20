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
        let rootItem: BLTNItem = createBulletinStatusAnimal(feeling: "")
        return BLTNItemManager(rootItem: rootItem)
    }()

    private func createBulletinStatusAnimal(feeling: String) -> BLTNItem {
        let page = BLTNPageItem(title: titleBulletin)
        page.descriptionText = feeling
        page.actionButtonTitle = "OK"

        page.actionHandler = { item in
            item.manager?.dismissBulletin()
        }

        return page
    }

    private var titleBulletin = ""

    var parentVC: UIViewController? {
        didSet {
            print("parentVC set")
        }
    }

    private func presentAnimalCard(animal: Animal) {
        guard let parentVC = parentVC, !bulletinManager.isShowingBulletin else { return }
        bulletinManager = BLTNItemManager(rootItem: createBulletinStatusAnimal(feeling: "SAD 2"))
        bulletinManager.backgroundViewStyle = .dimmed
        bulletinManager.showBulletin(above: parentVC, animated: true, completion: nil)
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
