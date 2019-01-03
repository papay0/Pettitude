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

    init() {
        let options = VisionLabelDetectorOptions(confidenceThreshold: 0.80)
        let vision = Vision.vision()
        labelDetector = vision.labelDetector(options: options)
    }

    func classify(pixelBuffer: CVPixelBuffer,
                  completionHandler: @escaping (MLProcessorResponse?, MLProcessorError?) -> Void) {
        guard let sampleBuffer = getCMSampleBuffer(pixelBuffer: pixelBuffer) else {
            completionHandler(nil, .cannotSampleBuffer)
            return
        }

        let metadata = VisionImageMetadata()
        metadata.orientation = .bottomLeft
        let image = VisionImage(buffer: sampleBuffer)
        image.metadata = metadata

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
            guard let label = sortedFeatures.first?.label else {
                completionHandler(nil, .emptyFeatures)
                return
            }
            print("label: \(sortedFeatures.first?.label)")
            print("confidence: \(sortedFeatures.first?.confidence)")
            let response = MLProcessorResponse(label: label)
            completionHandler(response, nil)
        }
    }

    // MARK: - Private

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

    private let labelDetector: VisionLabelDetector

}
