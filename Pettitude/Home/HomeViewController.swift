//
//  HomeViewController.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import ARKit
import Photos
import RIBs
import RxSwift
import UIKit

protocol HomePresentableListener: class {
    func classify(pixelBuffer: CVPixelBuffer, completionHandler: @escaping () -> Void)
    func showError(message: String)
}

protocol HomeViewControllerDependency: ARSKViewDelegate, ARSessionDelegate {}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable, HomeViewControllerDependency {

    weak var listener: HomePresentableListener?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHome()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }

    // MARK: - Protocol ARSessionDelegate

    // The pixel buffer being held for analysis; used to serialize Vision requests.
    private var currentBuffer: CVPixelBuffer?
    // Queue for dispatching vision classification requests
    private let visionQueue = DispatchQueue(label: "com.example.apple-samplecode.ARKitVision.serialVisionQueue")

    // TODO: Handle when the camera is not autorized
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard currentBuffer == nil, case .normal = frame.camera.trackingState else {
            return
        }
        self.currentBuffer = frame.capturedImage
        listener?.classify(pixelBuffer: frame.capturedImage, completionHandler: {
            self.currentBuffer = nil
        })
    }

    // MARK: - HomePresentable

    func screenshot() {
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
            let message = """
            Please enable Photos access for this application
            in Settings > Privacy to allow saving screenshots.
            """
            print(message)
        listener?.showError(message: message)
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
