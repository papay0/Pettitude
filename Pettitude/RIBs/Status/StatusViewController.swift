//
//  StatusViewController.swift
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
import SwiftEntryKit

protocol StatusPresentableListener: class {
    func screenshot()
    func dismissStatus()
}

final class StatusViewController: UIViewController, StatusPresentable, StatusViewControllable {

    weak var listener: StatusPresentableListener?

    lazy var errorBulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = createBulletinErrorMessage(message: "", error: .mLProcessorError)
        return BLTNItemManager(rootItem: rootItem)
    }()

    private func createBulletinErrorMessage(message: String, error: PettitudeErrorType) -> BLTNItem {
        let page = BLTNPageItem(title: titleBulletin)
        page.descriptionText = message
        page.appearance.actionButtonColor = .red

        if error == .mLProcessorError {
            page.actionButtonTitle = LS("Ok")
            page.actionHandler = { item in
                self.errorBulletinManager.dismissBulletin()
            }
            // TODO: Improve the actioning system
        } else if error == .savingPhotoNotAuthorized || error == .cameraAccessDenied {
            page.actionButtonTitle = LS("go_to_settings")
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
        guard !SwiftEntryKit.isCurrentlyDisplaying,
            !errorBulletinManager.isShowingBulletin,
            UserDefaultsManager.onboardingDone else { return }
            EntryManager.showPopupMessage(
                  title: titleBulletin,
                  description: feeling.description.localizedDescription,
                  buttonAction: listener?.screenshot
            ) {
                self.listener?.dismissStatus()
            }
        Analytics.logEvent("present_animal", parameters: nil)
        Analytics.logEvent("animal_type", parameters: ["description": animal.type.rawValue])
        Analytics.logEvent("animal_feeling", parameters: ["description": feeling.description.englishDescription])
        Analytics.setUserProperty(animal.type.rawValue, forName: "animal_type")
        Analytics.setUserProperty(feeling.description.englishDescription, forName: "animal_feeling")
        FirestoreManager.shared.animalClassified(
            animalType: animal.type.rawValue,
            feelingDescription: feeling.description.englishDescription
        )
    }

    // MARK: - StatusPresentable

    func set(animalDisplayable: AnimalDisplayable) {
        titleBulletin = animalDisplayable.animalRepresentation
        presentAnimalCard(animal: animalDisplayable.animal, feeling: animalDisplayable.feeling)
    }

    func showError(message: String, error: PettitudeErrorType) {
        guard let parentVC = parentVC, !errorBulletinManager.isShowingBulletin else { return }
        if SwiftEntryKit.isCurrentlyDisplaying {
            SwiftEntryKit.dismiss()
        }
        titleBulletin = "🤷‍♂️"
        errorBulletinManager = BLTNItemManager(rootItem: createBulletinErrorMessage(message: message, error: error))
        errorBulletinManager.backgroundViewStyle = .dimmed
        DispatchQueue.main.async {
            self.errorBulletinManager.showBulletin(above: parentVC, animated: true, completion: nil)
        }
    }

    // MARK: - StatusViewControllable

    func setParentViewController(parentVC: ViewControllable) {
        self.parentVC = parentVC.uiviewController
    }
}
