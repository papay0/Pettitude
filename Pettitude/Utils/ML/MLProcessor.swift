//
//  MLProcessor.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 09/12/2018.
//  Copyright © 2018 Arthur Papailhau. All rights reserved.
//

import Firebase

public enum MLProcessorError {
    case error(error: String)
    case emptyFeatures
    case animalNotRecognized
    case cannotSampleBuffer
}

class MLProcessor {

    init() {}

    func classify(pixelBuffer: CVPixelBuffer,
                  completionHandler: @escaping (MLProcessorResponse?, MLProcessorError?) -> Void) {

        guard let sampleBuffer = getCMSampleBuffer(pixelBuffer: pixelBuffer) else {
            completionHandler(nil, .cannotSampleBuffer)
            return
        }
        let image = VisionImage(buffer: sampleBuffer)
        let metadata = VisionImageMetadata()
        metadata.orientation = .bottomLeft

        image.metadata = metadata

        let labelDetector = getLabelDetector()
        labelDetector.detect(in: image) { features, error in
            guard error == nil else {
                completionHandler(nil, .error(error: error.debugDescription))
                return
            }
            guard let features = features, !features.isEmpty else {
                completionHandler(nil, .emptyFeatures)
                return
            }

            let sortedFeatures = features.sorted(by: { (image1, image2) -> Bool in
                return image1.confidence > image2.confidence
            })
            guard let feature = sortedFeatures.first else {
                completionHandler(nil, .emptyFeatures)
                return
            }
            let label = feature.label
            let response = MLProcessorResponse(label: label)
            if response.animal.isKnown {
                let confidence = Int(feature.confidence * 100)
                print("confidence = \(confidence)")
                Analytics.logEvent("animal_confidence", parameters: ["description": confidence])
            }
            completionHandler(response, nil)
        }
    }

    // MARK: - Private

    private func getLabelDetector() -> VisionLabelDetector {
        let confidenceThreshold = FirebaseRemoteConfig
            .shared
            .getValue(for: PettitudeConstants.confidenceThresholdKey)
            .numberValue?.floatValue
            ?? PettitudeConstants.confidenceThreshold
        let options = VisionLabelDetectorOptions(confidenceThreshold: confidenceThreshold)
        let vision = Vision.vision()
        return vision.labelDetector(options: options)
    }

    private func getCMSampleBuffer(pixelBuffer: CVPixelBuffer) -> CMSampleBuffer? {
        var info = CMSampleTimingInfo()
        info.presentationTimeStamp = CMTime.zero
        info.duration = CMTime.invalid
        info.decodeTimeStamp = CMTime.invalid

        var formatDesc: CMFormatDescription?
        CMVideoFormatDescriptionCreateForImageBuffer(allocator: kCFAllocatorDefault,
                                                     imageBuffer: pixelBuffer,
                                                     formatDescriptionOut: &formatDesc)

        var sampleBuffer: CMSampleBuffer?

        CMSampleBufferCreateReadyWithImageBuffer(allocator: kCFAllocatorDefault,
                                                 imageBuffer: pixelBuffer,
                                                 // swiftlint:disable force_unwrapping
                                                formatDescription: formatDesc!,
                                                sampleTiming: &info,
                                                sampleBufferOut: &sampleBuffer)

        return sampleBuffer ?? nil
    }
}
