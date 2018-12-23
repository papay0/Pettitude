//
//  HomeInteractor.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import Firebase
import RIBs
import RxSwift

protocol HomeRouting: ViewableRouting {
    func showError(message: String, error: PettitudeErrorType)
    func startOnboarding()
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
        mlProcessor.classify(pixelBuffer: pixelBuffer) { (mlProcessorResponse, error) in
            if let error = error {
                switch error {
                case .cannotSampleBuffer:
                    self.showError(message: self.genericErrorMessage, error: .mLProcessorError)
                    Analytics.logEvent("error_cannotSampleBuffer", parameters: nil)
                case .error(let errorDescription):
                    self.showError(message: self.genericErrorMessage, error: .mLProcessorError)
                    Analytics.logEvent("error_cannotSampleBuffer", parameters: ["description": errorDescription])
                case .animalNotRecognized:
                    Analytics.logEvent("warning_animalNotRecognized", parameters: nil)
                case .emptyFeatures:
                    Analytics.logEvent("warning_emptyFeatures", parameters: nil)
                }
                completionHandler()
                return
            }
            guard let mlProcessorResponse = mlProcessorResponse else {
                self.showError(message: self.genericErrorMessage, error: .mLProcessorError)
                completionHandler()
                return
            }
            completionHandler()
            let animal = mlProcessorResponse.animal
            let feeling = self.feelingsGenerator.getFeeling(for: animal)
            self.mutableAnimalStream.updateAnimal(with: animal, feeling: feeling)
        }
    }

    func showError(message: String, error: PettitudeErrorType) {
        router?.showError(message: message, error: error)
    }

    func startOnboarding() {
        if !UserDefaultsManager.onboardingDone {
            router?.startOnboarding()
        }
    }
    
    func UITests_only_showCardFor(animal: Animal, feeling: Feeling) {
        self.mutableAnimalStream.updateAnimal(with: animal, feeling: feeling)
    }

    // MARK: - Private

    private let mlProcessor: MLProcessor
    private let mutableAnimalStream: MutableAnimalStream
    private let feelingsGenerator: FeelingsGeneratable

    private let genericErrorMessage = LS("generic_error_message")
}
