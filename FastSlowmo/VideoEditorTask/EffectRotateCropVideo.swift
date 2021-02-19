//
//  EffectVideo.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 10/02/2021.
//

import UIKit
import AVFoundation

class EffectRotateCropVideo: Command {
    
    var originAssetVideo: AVAsset!
    var rotateType: Int!
    var hueType: Int!
    var isCrop: Int!
    var cropPointLeftBottom: CGPoint!
    var cropPointRightTop: CGPoint!
    var natureSize = CGPoint(x: 426, y: 320)
    
    init(originAssetVideo: AVAsset, rotateType: Int, hueType: Int, isCrop: Int, cropPointLeftBottom: CGPoint, cropPointRightTop: CGPoint) {
        self.originAssetVideo = originAssetVideo
        self.rotateType = rotateType
        self.hueType = hueType
        self.isCrop = isCrop
        self.cropPointLeftBottom = cropPointLeftBottom
        self.cropPointRightTop = cropPointRightTop
    }
    
    func setCGAffineTransform(_ width: CGFloat, _ height: CGFloat) -> CGAffineTransform {
        var tranform = CGAffineTransform()
        if isCrop == 1 {
            tranform = CGAffineTransform.init(translationX: -cropPointLeftBottom.x, y: -cropPointLeftBottom.y)
        }
        else if isCrop == 2 {
            tranform = CGAffineTransform.init(translationX: -(natureSize.x - cropPointRightTop.x), y: -(natureSize.y - cropPointRightTop.y))
        }
        else {
            let ratio = height / width
            
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
        }
        return tranform
    }
    
    func setFilterComposition(_ width: CGFloat, _ height: CGFloat) -> AVMutableVideoComposition {
        if hueType == 0 {
            let videoComposition = AVMutableVideoComposition(asset: originAssetVideo, applyingCIFiltersWithHandler: { request in
                        
                let source = request.sourceImage
                
                let output = source.transformed(by: self.setCGAffineTransform(width, height))
                request.finish(with: output, context: nil)
            })
            return videoComposition
        }
        else if hueType == 1 {
            let filter = CIFilter(name: "CIPhotoEffectMono") // mau den trang
            let videoComposition = AVMutableVideoComposition(asset: originAssetVideo, applyingCIFiltersWithHandler: { request in
                
                let source = request.sourceImage
                filter?.setValue(source, forKey: kCIInputImageKey)
                
                let output = filter?.outputImage?.transformed(by: self.setCGAffineTransform(width, height))
                request.finish(with: output!, context: nil)
            })
            return videoComposition
        }
        else if hueType == 2 {
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
        else if hueType == 3 {
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
            
            let inputMinComponents = CIVector(x: 0.75, y: 0.45, z: 0.1, w: 1)
            filter?.setValue(inputMinComponents, forKey: "inputMinComponents")
            
            let inputMaxComponents = CIVector(x: 1, y: 1, z: 1, w: 1)
            filter?.setValue(inputMaxComponents, forKey: "inputMaxComponents")
            
            let output = filter?.outputImage?.transformed(by: self.setCGAffineTransform(width, height))
            request.finish(with: output!, context: nil)
        })
        
        return videoComposition
    }
    
    fileprivate func setRenderSizeComposition(_ videoComposition: AVMutableVideoComposition, _ newAllComposition: AllComposition) {
        if isCrop == 1 {
            videoComposition.renderSize = CGSize(width: newAllComposition.mutableComposition.naturalSize.width - cropPointLeftBottom.x, height: newAllComposition.mutableComposition.naturalSize.height - cropPointLeftBottom.y)
        }
        else if isCrop == 2 {
            videoComposition.renderSize = CGSize(width: cropPointRightTop.x - cropPointLeftBottom.x, height: cropPointRightTop.y - cropPointLeftBottom.y)
            print(videoComposition.renderSize)
        }
        else {
            if rotateType == 1 || rotateType == 3  || rotateType == -1 || rotateType == -3 {
                videoComposition.renderSize = CGSize(width: newAllComposition.mutableComposition.naturalSize.height, height: newAllComposition.mutableComposition.naturalSize.width)
            }
            else { // 0 2 4
                videoComposition.renderSize = CGSize(width: newAllComposition.mutableComposition.naturalSize.width, height: newAllComposition.mutableComposition.naturalSize.height)
            }
        }
    }
    
    func execute(allComposition: AllComposition) -> AllComposition {
        natureSize.x = allComposition.mutableComposition.naturalSize.width
        natureSize.y = allComposition.mutableComposition.naturalSize.height
        
        let newAllComposition = AllComposition(mutableComposition: allComposition.mutableComposition.mutableCopy() as! AVMutableComposition, videoComposition: allComposition.videoComposition.mutableCopy() as! AVMutableVideoComposition)
        
        let videoComposition = setFilterComposition(newAllComposition.mutableComposition.naturalSize.width, newAllComposition.mutableComposition.naturalSize.height)
        
        setRenderSizeComposition(videoComposition, newAllComposition)
        
        newAllComposition.videoComposition = videoComposition
        
        return newAllComposition
    }
}
