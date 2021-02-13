//
//  CropVideo.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 13/02/2021.
//

import UIKit
import AVFoundation

class CropVideo: Command {
    
    var originAssetMusic: AVAsset!
    var timeRange: CMTimeRange!
    
    init(originAssetMusic: AVAsset, timeRange: CMTimeRange) {
        self.originAssetMusic = originAssetMusic
        self.timeRange = timeRange
    }
    
    func execute(allComposition: AllComposition) -> AllComposition {
        
        let newAllComposition = AllComposition(mutableComposition: allComposition.mutableComposition, videoComposition: allComposition.videoComposition)
        
        
        return newAllComposition
    }
}
