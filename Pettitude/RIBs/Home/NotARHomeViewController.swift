//
//  NotARHomeViewController.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 07/01/2019.
//  Copyright © 2019 Arthur Papailhau. All rights reserved.
//

import AVFoundation
import FirebaseAnalytics
import RevealingSplashView
import UIKit
import Vision

class NotARHomeViewController: UIViewController, HomePresentable, HomeViewControllable, HomeViewControllerDependency {
    var listener: HomePresentableListener?
    private var classificationDone = true

    func screenshot() {
        // N/A
    }

    var session: AVCaptureSession?

    lazy var previewLayer: AVCaptureVideoPreviewLayer? = {
        guard let session = self.session else { return nil }

        var previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill

        return previewLayer
    }()

    var backCamera: AVCaptureDevice? = {
        return AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                                       for: AVMediaType.video,
                                       position: .back)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.isIdleTimerDisabled = true
        sessionPrepare()
        launchSplashScreen()
        session?.startRunning()
        checkCameraAccess()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.frame
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let previewLayer = previewLayer else { return }

        view.layer.addSublayer(previewLayer)
    }

    func sessionPrepare() {
        session = AVCaptureSession()
        guard let session = session, let captureDevice = backCamera else { return }

        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            session.beginConfiguration()

            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
            }

            let output = AVCaptureVideoDataOutput()
            output.videoSettings = [
                String(kCVPixelBufferPixelFormatTypeKey): Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
            ]

            output.alwaysDiscardsLateVideoFrames = true

            if session.canAddOutput(output) {
                session.addOutput(output)
            }

            session.commitConfiguration()
            let queue = DispatchQueue(label: "output.queue")
            output.setSampleBufferDelegate(self, queue: queue)
        } catch {
            print("can't setup session")
        }
    }

    // MARK: - Private

    private func launchSplashScreen() {
        if let splashImage = UIImage(named: "Glyph") {
            let revealingSplashView = RevealingSplashView(iconImage: splashImage,
                                                          iconInitialSize: CGSize(width: 80, height: 88),
                                                          backgroundColor: UIColor(red: 0.0/255.0,
                                                                                   green: 99.0/255.0,
                                                                                   blue: 219.0/255.0,
                                                                                   alpha: 1.0)
            )
            self.view.addSubview(revealingSplashView)
            revealingSplashView.startAnimation()
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
}

extension NotARHomeViewController: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {

        guard classificationDone else { return }
        classificationDone = false
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        listener?.classify(pixelBuffer: pixelBuffer, completionHandler: {
            self.classificationDone = true
        })
    }
}
