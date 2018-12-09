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
        let sampleBuffer = getCMSampleBuffer(pixelBuffer: pixelBuffer)
        
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
            // print(sortedFeatures.first?.label, sortedFeatures.first?.confidence)
        }
    }
    
    // MARK: - Private
    
    private func getCMSampleBuffer(pixelBuffer: CVPixelBuffer) -> CMSampleBuffer {
        var info = CMSampleTimingInfo()
        info.presentationTimeStamp = kCMTimeZero
        info.duration = kCMTimeInvalid
        info.decodeTimeStamp = kCMTimeInvalid
        
        
        var formatDesc: CMFormatDescription? = nil
        CMVideoFormatDescriptionCreateForImageBuffer(kCFAllocatorDefault, pixelBuffer, &formatDesc)
        
        var sampleBuffer: CMSampleBuffer? = nil
        
        CMSampleBufferCreateReadyWithImageBuffer(kCFAllocatorDefault,
                                                 pixelBuffer,
                                                 formatDesc!,
                                                 &info,
                                                 &sampleBuffer);
        
        return sampleBuffer!
    }
    
    private let labelDetector: VisionLabelDetector
    
}
