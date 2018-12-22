//
//  StatusInteractor.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import RIBs
import RxSwift

protocol StatusRouting: ViewableRouting {
    func setParentViewController(parentVC: ViewControllable)
    func showError(message: String)
}

protocol StatusPresentable: Presentable {
    var listener: StatusPresentableListener? { get set }
    func set(animalDisplayable: AnimalDisplayable)
    func showError(message: String)
}

protocol StatusListener: class {
    func screenshot()
}

final class StatusInteractor: PresentableInteractor<StatusPresentable>, StatusInteractable, StatusPresentableListener {

    weak var router: StatusRouting?
    weak var listener: StatusListener?

    init(presenter: StatusPresentable, animalStream: AnimalStream) {
        self.animalStream = animalStream
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        updateAnimal()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    // MARK: - StatusPresentableListener

    func screenshot() {
        listener?.screenshot()
    }

    // MARK: - Private

    private let animalStream: AnimalStream

    private func updateAnimal() {
        animalStream.animalDisplayable
            .subscribe(onNext: { (animalDisplayable: AnimalDisplayable) in
                self.presenter.set(animalDisplayable: animalDisplayable)
            })
            .disposeOnDeactivate(interactor: self)
    }
}
