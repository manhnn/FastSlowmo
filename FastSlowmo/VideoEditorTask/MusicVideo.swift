//
//  MusicVideo.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 12/02/2021.
//

import UIKit
import AVFoundation

class MusicVideo: Command {
    
    var originAssetMusic: AVAsset!
    var timeRange: CMTimeRange!
    
    init(originAssetMusic: AVAsset, timeRange: CMTimeRange) {
        self.originAssetMusic = originAssetMusic
        self.timeRange = timeRange
    }
    
    func execute(allComposition: AllComposition) -> AllComposition {
        
        let newAllComposition = AllComposition(mutableComposition: allComposition.mutableComposition, videoComposition: allComposition.videoComposition)
        
        newAllComposition.mutableComposition = AVMutableComposition()
        
        allComposition.mutableComposition.tracks.forEach { track in
            if track.mediaType == .video {
                let trackComposition = newAllComposition.mutableComposition.addMutableTrack(withMediaType: track.mediaType, preferredTrackID: track.trackID)
                try? trackComposition?.insertTimeRange(timeRange, of: track, at: .zero)
            }
        }
        
        originAssetMusic.tracks.forEach { track in
            if track.mediaType == .audio {
                let trackComposition = newAllComposition.mutableComposition.addMutableTrack(withMediaType: track.mediaType, preferredTrackID: track.trackID)
                try? trackComposition?.insertTimeRange(timeRange, of: track, at: .zero)
            }
        }
        return newAllComposition
    }
}
