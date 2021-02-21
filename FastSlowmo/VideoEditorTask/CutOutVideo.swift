//
//  SoundVideo.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 04/02/2021.
//

import UIKit
import AVFoundation

class CutOutVideo: Command {
    
    var timeRange: CMTimeRange!
    
    init(timeRange: CMTimeRange) {
        self.timeRange = timeRange
    }
    
    func execute(allComposition: AllComposition) -> AllComposition {
        let newAllComposition = AllComposition()
        newAllComposition.mutableComposition = allComposition.mutableComposition.mutableCopy() as? AVMutableComposition
        if allComposition.videoComposition != nil {
            newAllComposition.videoComposition = allComposition.videoComposition!.mutableCopy() as? AVMutableVideoComposition
        }
        if allComposition.audioMix != nil {
            newAllComposition.audioMix = allComposition.audioMix!.mutableCopy() as? AVAudioMix
        }
        
        newAllComposition.mutableComposition.removeTimeRange(timeRange)
        
        return newAllComposition
    }
}
