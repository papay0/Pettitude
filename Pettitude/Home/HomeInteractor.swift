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

    init(presenter: HomePresentable, mlProcessor: MLProcessor, mutableAnimalStream: MutableAnimalStream) {
        self.mlProcessor = mlProcessor
        self.mutableAnimalStream = mutableAnimalStream
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
        // Pause any business logic.
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
            self.mutableAnimalStream.updateAnimal(with: mlProcessorResponse.animal)
        }
    }

    // MARK: - Private

    private let mlProcessor: MLProcessor
    private let mutableAnimalStream: MutableAnimalStream
}
