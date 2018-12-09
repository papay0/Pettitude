//
//  MLProcessor.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import Firebase

class MLProcessor {

    init() {
        let options = VisionLabelDetectorOptions(confidenceThreshold: 0.5)
        let vision = Vision.vision()
        labelDetector = vision.labelDetector(options: options)
    }

    func classify(pixelBuffer: CVPixelBuffer, completionHandler: @escaping (String?) -> Void) {
        guard let sampleBuffer = getCMSampleBuffer(pixelBuffer: pixelBuffer) else {
            completionHandler(nil) // TODO: Make a better handler than just a Sting?
            return
        }

        let metadata = VisionImageMetadata()
        metadata.orientation = .bottomLeft
        let image = VisionImage(buffer: sampleBuffer)
        image.metadata = metadata

        labelDetector.detect(in: image) { features, error in
            guard error == nil, let features = features, !features.isEmpty else {
                completionHandler(nil)
                return
            }

            let sortedFeatures = features.sorted(by: { (image1, image2) -> Bool in
                return image1.confidence > image2.confidence
            })
            completionHandler(sortedFeatures.first?.label)
        }
    }

    // MARK: - Private

    private func getCMSampleBuffer(pixelBuffer: CVPixelBuffer) -> CMSampleBuffer? {
        var info = CMSampleTimingInfo()
        info.presentationTimeStamp = kCMTimeZero
        info.duration = kCMTimeInvalid
        info.decodeTimeStamp = kCMTimeInvalid

        var formatDesc: CMFormatDescription?
        CMVideoFormatDescriptionCreateForImageBuffer(kCFAllocatorDefault, pixelBuffer, &formatDesc)

        var sampleBuffer: CMSampleBuffer?

        CMSampleBufferCreateReadyWithImageBuffer(kCFAllocatorDefault,
                                                 pixelBuffer,
                                                 // swiftlint:disable force_unwrapping
                                                 formatDesc!,
                                                 &info,
                                                 &sampleBuffer)

        return sampleBuffer ?? nil
    }

    private let labelDetector: VisionLabelDetector

}
