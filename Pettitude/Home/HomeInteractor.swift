//
//  HomeInteractor.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import RIBs
import RxSwift

protocol HomeRouting: ViewableRouting {}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
}

protocol HomeListener: class {
}

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

    // MARK: - HomePresentableListener

    func classify(pixelBuffer: CVPixelBuffer, completionHandler: @escaping (Bool) -> Void) {
        mlProcessor.classify(pixelBuffer: pixelBuffer) { (mlProcessorResponse) in
            guard let mlProcessorResponse = mlProcessorResponse else {
                // TODO: Handle error here
                completionHandler(false)
                return
            }
            completionHandler(true)
            let animal = mlProcessorResponse.animal
            let feeling = self.feelingsGenerator.getFeeling(for: animal)
            self.mutableAnimalStream.updateAnimal(with: animal, feeling: feeling)
        }
    }

    // MARK: - Private

    private let mlProcessor: MLProcessor
    private let mutableAnimalStream: MutableAnimalStream
    private let feelingsGenerator: FeelingsGeneratable
}
