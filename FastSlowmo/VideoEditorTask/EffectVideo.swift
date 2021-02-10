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
    
    init(originAssetVideo: AVAsset) {
        self.originAssetVideo = originAssetVideo
    }
    
    func execute(allComposition: AllComposition) -> AllComposition {
        
        let newAllComposition = AllComposition(mutableComposition: allComposition.mutableComposition, videoComposition: allComposition.videoComposition)
        
        let filter = CIFilter(name: "CIPhotoEffectMono") // mau den trang
                    
        let videoComposition = AVMutableVideoComposition(asset: originAssetVideo, applyingCIFiltersWithHandler: {request in
            
            let source = request.sourceImage.clampedToExtent()
            filter?.setValue(source, forKey: kCIInputImageKey)
            
            let output = filter?.outputImage?.cropped(to: request.sourceImage.extent)
            request.finish(with: output!, context: nil)
        })
        
        newAllComposition.videoComposition = videoComposition
        
        return newAllComposition
    }
}
