//
//  HomeInteractor.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import RIBs
import RxSwift

protocol HomeRouting: ViewableRouting {
    func showError(message: String)
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
    func screenshot()
}

protocol HomeListener: class {}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable, HomePresentableListener {

    weak var router: HomeRouting?
    weak var listener: HomeListener?

    init(presenter: HomePresentable,
         mlProcessor: MLProcessor,
         feelingsGenerator: FeelingsGeneratable,
         mutableAnimalStream: MutableAnimalStream) {
        self.mlProcessor = mlProcessor
        self.mutableAnimalStream = mutableAnimalStream
        self.feelingsGenerator = feelingsGenerator
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    // MARK: - StatusListener

    func screenshot() {
        presenter.screenshot()
    }

    // MARK: - HomePresentableListener

    func classify(pixelBuffer: CVPixelBuffer, completionHandler: @escaping () -> Void) {
        mlProcessor.classify(pixelBuffer: pixelBuffer) { (mlProcessorResponse) in
            guard let mlProcessorResponse = mlProcessorResponse else {
                self.router?.showError(message: "Oups, something went wrong!\n\n🐒 is fixing it right now!")
                completionHandler()
                return
            }
            completionHandler()
            let animal = mlProcessorResponse.animal
            let feeling = self.feelingsGenerator.getFeeling(for: animal)
            self.mutableAnimalStream.updateAnimal(with: animal, feeling: feeling)
        }
    }

    func showError(message: String) {
        self.router?.showError(message: message)
    }

    // MARK: - Private

    private let mlProcessor: MLProcessor
    private let mutableAnimalStream: MutableAnimalStream
    private let feelingsGenerator: FeelingsGeneratable
}
