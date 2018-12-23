//
//  HomeViewController.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import ARKit
import Firebase
import Photos
import RIBs
import RxSwift
import UIKit

protocol HomePresentableListener: class {
    func classify(pixelBuffer: CVPixelBuffer, completionHandler: @escaping () -> Void)
    func showError(message: String, error: PettitudeErrorType)
    func startOnboarding()

    // UITests
    func UITests_only_showCardFor(animal: Animal, feeling: Feeling)
}

protocol HomeViewControllerDependency: ARSKViewDelegate, ARSessionDelegate {}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable, HomeViewControllerDependency {

    weak var listener: HomePresentableListener?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHome()
        setupUitests()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Protocol ARSessionDelegate

    // The pixel buffer being held for analysis; used to serialize Vision requests.
    private var currentBuffer: CVPixelBuffer?
    // Queue for dispatching vision classification requests
    private let visionQueue = DispatchQueue(label: "com.example.apple-samplecode.ARKitVision.serialVisionQueue")

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard currentBuffer == nil, case .normal = frame.camera.trackingState else {
            return
        }
        self.currentBuffer = frame.capturedImage
        let trace = Performance.startTrace(name: "classify image")
        listener?.classify(pixelBuffer: frame.capturedImage, completionHandler: {
            self.currentBuffer = nil
            trace?.stop()
        })
    }

    // MARK: - HomePresentable

    func screenshot() {
        Analytics.logEvent("screenshot", parameters: nil)
        let takeScreenshotBlock = {
            DispatchQueue.main.async {
                let flashOverlay = UIView(frame: self.sceneView.frame)
                flashOverlay.backgroundColor = UIColor.white
                self.sceneView.addSubview(flashOverlay)
                UIView.animate(withDuration: 0.50, animations: {
                    flashOverlay.alpha = 0.0
                }, completion: { _ in
                    self.takeScreenshot()
                    flashOverlay.removeFromSuperview()
                })
            }
        }

        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            takeScreenshotBlock()
        case .restricted, .denied:
            let message = LS("access_photo_denied")
            print(message)
        listener?.showError(message: message, error: .savingPhotoNotAuthorized)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (authorizationStatus) in
                if authorizationStatus == .authorized {
                    takeScreenshotBlock()
                }
            })
        }
    }

    // MARK: - Private

    private func setupHome() {
        setupVision()
        checkCameraAccess()
    }

    private func setupVision() {
        sceneView = ARSKView(frame: view.frame)
        view.addSubview(sceneView)

        let overlayScene = SKScene()
        overlayScene.scaleMode = .aspectFill
        sceneView.delegate = self
        sceneView.presentScene(overlayScene)
        sceneView.session.delegate = self
    }

    private func setupUitests() {
        if CommandLine.arguments.contains("uitests") {
            var animal: Animal!
            var feeling: Feeling!
            var imageAnimal: UIImage!
            if CommandLine.arguments.contains("cat") {
                imageAnimal = UIImage(named: "Cat")
                animal = Animal(type: .cat)
                feeling = Feeling(description: LS("Thoughtful"), sentimentType: .positive)
            } else if CommandLine.arguments.contains("dog") {
                imageAnimal = UIImage(named: "Dog")
                animal = Animal(type: .dog)
                feeling = Feeling(description: LS("Happy"), sentimentType: .positive)
            }
            let animalView = UIView(frame: UIScreen.main.bounds)
            let imageView = UIImageView(image: imageAnimal)
            imageView.frame = animalView.bounds
            animalView.addSubview(imageView)
            self.sceneView.addSubview(animalView)
            listener?.UITests_only_showCardFor(animal: animal, feeling: feeling)
        }
    }

    private func checkCameraAccess() {
        if AVCaptureDevice.authorizationStatus(for: .video) !=  .authorized {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if !granted {
                    Analytics.logEvent("access_camera_denied", parameters: nil)
                    self.listener?.showError(
                        message: LS("access_camera_denied"),
                        error: .cameraAccessDenied
                    )
                } else {
                    self.listener?.startOnboarding()
                }
            })
        }
    }

    private func takeScreenshot() {
        var screenshotImage: UIImage?
        guard let layer = UIApplication.shared.keyWindow?.layer else { return }
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        self.view.drawHierarchy(in: self.sceneView.bounds, afterScreenUpdates: true)
        layer.render(in: context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }

    private var sceneView: ARSKView!
}
