//
//  EffectVideo.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 10/02/2021.
//

import UIKit
import AVFoundation

class EffectVideo: Command {
    
    var originAssetVideo: AVAsset!
    var rotateType: Int!
    var hue: Int!
    
    init(originAssetVideo: AVAsset, rotateType: Int, hue: Int) {
        self.originAssetVideo = originAssetVideo
        self.rotateType = rotateType
        self.hue = hue
    }
    
    func setCGAffineTransform(_ width: CGFloat, _ height: CGFloat) -> CGAffineTransform {
        let ratio = height / width
        
        var tranform = CGAffineTransform()
        
        if rotateType == -1 || rotateType == 3 {
            tranform = CGAffineTransform(rotationAngle: .pi / 2).translatedBy(x: 0, y: -width * ratio)
        }
        else if rotateType == -2 || rotateType == 2 {
            tranform = CGAffineTransform(rotationAngle: .pi).translatedBy(x: -width, y: -height)
        }
        else if rotateType == -3 || rotateType == 1 {
            tranform = CGAffineTransform(rotationAngle: .pi * 1.5).translatedBy(x: -height / ratio, y: 0)
        }
        else {
            tranform = CGAffineTransform(translationX: 0, y: 0.001)
        }
        return tranform
    }
    
    func setFilterComposition(_ width: CGFloat, _ height: CGFloat) -> AVMutableVideoComposition {
        if hue == 1 {
            let filter = CIFilter(name: "CIPhotoEffectMono") // mau den trang
            let videoComposition = AVMutableVideoComposition(asset: originAssetVideo, applyingCIFiltersWithHandler: { [self] request in
                
                let source = request.sourceImage
                filter?.setValue(source, forKey: kCIInputImageKey)
                
                let output = filter?.outputImage?.transformed(by: setCGAffineTransform(width, height))
                request.finish(with: output!, context: nil)
            })
            return videoComposition
        }
        else if hue == 2 {
            let filter = CIFilter(name: "CIColorControls") // do sang
            let videoComposition = AVMutableVideoComposition(asset: originAssetVideo, applyingCIFiltersWithHandler: { request in
                
                let source = request.sourceImage
                filter?.setValue(source, forKey: kCIInputImageKey)
                
                let inputSaturation = NSNumber(value: 1.00)
                filter?.setValue(inputSaturation, forKey: "inputSaturation")
                
                let inputBrightness = NSNumber(value: 0.25)
                filter?.setValue(inputBrightness, forKey: "inputBrightness")
                
                let inputContrast = NSNumber(value: 1.00)
                filter?.setValue(inputContrast, forKey: "inputContrast")
                
                let output = filter?.outputImage?.transformed(by: self.setCGAffineTransform(width, height))
                request.finish(with: output!, context: nil)
            })
            return videoComposition
        }
        else if hue == 3 {
            let filter = CIFilter(name: "CIGaussianBlur")! // blur
            let videoComposion = AVMutableVideoComposition(asset: originAssetVideo, applyingCIFiltersWithHandler: { request in
                
                let source = request.sourceImage.clampedToExtent()
                filter.setValue(source, forKey: kCIInputImageKey)
                
                let seconds = CMTimeGetSeconds(request.compositionTime)
                filter.setValue(seconds * 0.25, forKey: kCIInputRadiusKey)
                
                let output = filter.outputImage!.transformed(by: self.setCGAffineTransform(width, height))
                request.finish(with: output, context: nil)
            })
            return videoComposion
        }
        
        let filter = CIFilter(name: "CIColorClamp") // color
        let videoComposition = AVMutableVideoComposition(asset: originAssetVideo, applyingCIFiltersWithHandler: { request in
            
            let source = request.sourceImage
            filter?.setValue(source, forKey: kCIInputImageKey)
            
            let inputMinComponents = CIVector(x: 0.55, y: 0.45, z: 0.1, w: 1)
            filter?.setValue(inputMinComponents, forKey: "inputMinComponents")
            
            let inputMaxComponents = CIVector(x: 1, y: 1, z: 1, w: 1)
            filter?.setValue(inputMaxComponents, forKey: "inputMaxComponents")
            
            let output = filter?.outputImage?.transformed(by: self.setCGAffineTransform(width, height))
            request.finish(with: output!, context: nil)
        })
        
        return videoComposition
    }
    
    fileprivate func setRenderSizeComposition(_ videoComposition: AVMutableVideoComposition, _ newAllComposition: AllComposition) {
        if rotateType == 1 || rotateType == 3  || rotateType == -1 || rotateType == -3 {
            videoComposition.renderSize = CGSize(width: newAllComposition.mutableComposition.naturalSize.height, height: newAllComposition.mutableComposition.naturalSize.width)
        }
        else { // rotateType == 2 || rotateType == 4
            videoComposition.renderSize = CGSize(width: newAllComposition.mutableComposition.naturalSize.width, height: newAllComposition.mutableComposition.naturalSize.height)
        }
    }
    
    func execute(allComposition: AllComposition) -> AllComposition {
        
        let newAllComposition = AllComposition(mutableComposition: allComposition.mutableComposition, videoComposition: allComposition.videoComposition)
        
        let videoComposition = setFilterComposition(newAllComposition.mutableComposition.naturalSize.width, newAllComposition.mutableComposition.naturalSize.height)
        
        setRenderSizeComposition(videoComposition, newAllComposition)
        
        newAllComposition.videoComposition = videoComposition
        
        return newAllComposition
    }
}
