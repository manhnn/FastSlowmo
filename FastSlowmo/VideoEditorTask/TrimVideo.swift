//
//  TrimVideo.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 04/02/2021.
//

import UIKit
import AVFoundation

class TrimVideo: Command {
    var timeRange: CMTimeRange!
    
    init(timeRange: CMTimeRange) {
        self.timeRange = timeRange
    }
    
    func execute(allComposition: AllComposition) -> AllComposition {
        
        let newAllComposition = AllComposition()
        newAllComposition.mutableComposition = AVMutableComposition()
        if allComposition.videoComposition != nil {
            newAllComposition.videoComposition = allComposition.videoComposition!.mutableCopy() as? AVMutableVideoComposition
        }
        if allComposition.audioMix != nil {
            newAllComposition.audioMix = allComposition.audioMix!.mutableCopy() as? AVAudioMix
        }
        
        allComposition.mutableComposition.tracks.forEach { track in
            let trackComposition = newAllComposition.mutableComposition.addMutableTrack(withMediaType: track.mediaType, preferredTrackID: track.trackID)
            try? trackComposition?.insertTimeRange(timeRange, of: track, at: .zero)
        }
        
        return newAllComposition
    }
}
