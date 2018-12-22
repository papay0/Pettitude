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

    lazy var animalBulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = createBulletinStatusAnimal(feeling: "")
        return BLTNItemManager(rootItem: rootItem)
    }()

    lazy var errorBulletinManager: BLTNItemManager = {
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

    private func createBulletinErrorMessage(message: String, error: PettitudeErrorType) -> BLTNItem {
        let page = BLTNPageItem(title: titleBulletin)
        page.descriptionText = message
        page.appearance.actionButtonColor = .red

        if error == .mLProcessorError {
            page.actionButtonTitle = "Ok"
            page.actionHandler = { item in
                self.animalBulletinManager.dismissBulletin()
            }
        } else if error == .savingPhotoNotAuthorized { // TODO: Improve the actioning system
            page.actionButtonTitle = "Go to Settings"
            page.actionHandler = { item in
                self.errorBulletinManager.dismissBulletin()
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
        }
        return page
    }

    private var titleBulletin = ""

    var parentVC: UIViewController?

    private func presentAnimalCard(animal: Animal, feeling: Feeling) {
        guard let parentVC = parentVC,
            !animalBulletinManager.isShowingBulletin,
            !errorBulletinManager.isShowingBulletin else { return }
        animalBulletinManager = BLTNItemManager(rootItem:
            createBulletinStatusAnimal(feeling: feeling.feelingDescription)
        )
        animalBulletinManager.backgroundViewStyle = .dimmed
        animalBulletinManager.showBulletin(above: parentVC, animated: true, completion: nil)
    }

    // MARK: - StatusPresentable

    func set(animalDisplayable: AnimalDisplayable) {
        print("animal: \(animalDisplayable.animal.type)")
        titleBulletin = animalDisplayable.animalRepresentation
        presentAnimalCard(animal: animalDisplayable.animal, feeling: animalDisplayable.feeling)
    }

    func showError(message: String, error: PettitudeErrorType) {
        guard let parentVC = parentVC, !errorBulletinManager.isShowingBulletin else { return }
        if animalBulletinManager.isShowingBulletin {
            animalBulletinManager.dismissBulletin()
        }
        titleBulletin = "🤷‍♂️"
        errorBulletinManager = BLTNItemManager(rootItem: createBulletinErrorMessage(message: message, error: error))
        errorBulletinManager.backgroundViewStyle = .dimmed
        errorBulletinManager.showBulletin(above: parentVC, animated: true, completion: nil)
    }

    // MARK: - StatusViewControllable

    func setParentViewController(parentVC: ViewControllable) {
        self.parentVC = parentVC.uiviewController
    }
}
