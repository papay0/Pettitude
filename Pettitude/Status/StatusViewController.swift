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
    func screenshot()
}

final class StatusViewController: UIViewController, StatusPresentable, StatusViewControllable {

    weak var listener: StatusPresentableListener?

    lazy var bulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = createBulletinStatusAnimal(feeling: "")
        return BLTNItemManager(rootItem: rootItem)
    }()

    private func createBulletinStatusAnimal(feeling: FeelingDescription) -> BLTNItem {
        let page = BLTNPageItem(title: titleBulletin)
        page.descriptionText = feeling
        page.actionButtonTitle = "Screenshot 📸"

        page.actionHandler = { item in
            self.listener?.screenshot()
        }

        return page
    }

    private func createBulletinErrorMessage(message: String) -> BLTNItem {
        let page = BLTNPageItem(title: titleBulletin)
        page.descriptionText = message
        page.actionButtonTitle = "Ok"
        page.appearance.actionButtonColor = .red

        page.actionHandler = { item in
            self.bulletinManager.dismissBulletin()
        }

        return page
    }

    private var titleBulletin = ""

    var parentVC: UIViewController?

    private func presentAnimalCard(animal: Animal, feeling: Feeling) {
        guard let parentVC = parentVC, !bulletinManager.isShowingBulletin else { return }
        bulletinManager = BLTNItemManager(rootItem: createBulletinStatusAnimal(feeling: feeling.feelingDescription))
        bulletinManager.backgroundViewStyle = .dimmed
        bulletinManager.showBulletin(above: parentVC, animated: true, completion: nil)
    }

    // MARK: - StatusPresentable

    func set(animalDisplayable: AnimalDisplayable) {
        print("animal: \(animalDisplayable.animal.type)")
        titleBulletin = animalDisplayable.animalRepresentation
        presentAnimalCard(animal: animalDisplayable.animal, feeling: animalDisplayable.feeling)
    }

    func showError(message: String) {
        guard let parentVC = parentVC, !bulletinManager.isShowingBulletin else { return }
        titleBulletin = "🤷‍♂️"
        bulletinManager = BLTNItemManager(rootItem: createBulletinErrorMessage(message: message))
        bulletinManager.backgroundViewStyle = .dimmed
        bulletinManager.showBulletin(above: parentVC, animated: true, completion: nil)
    }

    // MARK: - StatusViewControllable

    func setParentViewController(parentVC: ViewControllable) {
        self.parentVC = parentVC.uiviewController
    }
}
