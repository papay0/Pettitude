//
//  Screenshot.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 07/01/2019.
//  Copyright © 2019 Arthur Papailhau. All rights reserved.
//

import Firebase
import Photos

class Screenshot {
    static func screenshot(view: UIView, completionHandler: @escaping (String, PettitudeErrorType) -> Void) {
        Analytics.logEvent("screenshot", parameters: nil)
        let takeScreenshotBlock = {
            DispatchQueue.main.async {
                // let flashOverlay = UIView(frame: self.sceneView.frame)
                let flashOverlay = UIView(frame: view.frame)
                flashOverlay.backgroundColor = UIColor.white
                // self.sceneView.addSubview(flashOverlay)
                view.addSubview(flashOverlay)
                UIView.animate(withDuration: 0.50, animations: {
                    flashOverlay.alpha = 0.0
                }, completion: { _ in
                    self.takeScreenshot(view: view)
                    flashOverlay.removeFromSuperview()
                })
            }
        }

        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            takeScreenshotBlock()
        case .restricted, .denied:
            let message = LS("access_photo_denied")
            completionHandler(message, .savingPhotoNotAuthorized)
            // listener?.showError(message: message, error: .savingPhotoNotAuthorized)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (authorizationStatus) in
                if authorizationStatus == .authorized {
                    takeScreenshotBlock()
                } else if authorizationStatus == .denied {
                    let message = LS("access_photo_denied")
                    completionHandler(message, .savingPhotoNotAuthorized)
                    // self.listener?.showError(message: message, error: .savingPhotoNotAuthorized)
                }
            })
        }
    }

    private static func takeScreenshot(view: UIView) {
        var screenshotImage: UIImage?
        guard let layer = UIApplication.shared.keyWindow?.layer else { return }
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        layer.render(in: context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}
