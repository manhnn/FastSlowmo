//
//  CropVideo.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 04/02/2021.
//

import UIKit
import AVFoundation

class SpeedVideo: Command {
    
    var rate: Double!
    var timeRange: CMTimeRange!
    
    init(rate: Double, timeRange: CMTimeRange) {
        self.rate = rate
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
        
        newAllComposition.mutableComposition.tracks.forEach { track in
            track.scaleTimeRange(timeRange, toDuration: CMTime(value: CMTimeValue(timeRange.duration.seconds / rate), timescale: 1))
        }
        
        return newAllComposition
    }
}
