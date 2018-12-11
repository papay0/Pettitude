//
//  HomeViewController.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import ARKit

import RIBs
import RxSwift
import UIKit

protocol HomePresentableListener: class {
    // TODO: Check what's the best way to do completionHandler with error
    func classify(pixelBuffer: CVPixelBuffer, completionHandler: @escaping (Bool) -> Void)
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

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard currentBuffer == nil, case .normal = frame.camera.trackingState else {
            return
        }
        self.currentBuffer = frame.capturedImage
        listener?.classify(pixelBuffer: frame.capturedImage, completionHandler: { (success) in
            guard !success else {
                // TODO: Handle error correctly, showing something etc
                print("Error")
                self.currentBuffer = nil
                return
            }
            self.currentBuffer = nil
        })
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

    private var sceneView: ARSKView!
}
