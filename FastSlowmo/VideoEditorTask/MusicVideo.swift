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
        originAssetMusic.tracks.forEach { track in
            if track.mediaType == .audio {
                let trackComposition = newAllComposition.mutableComposition.addMutableTrack(withMediaType: track.mediaType, preferredTrackID: track.trackID)
                try? trackComposition?.insertTimeRange(CMTimeRange(start: CMTime(seconds: 0, preferredTimescale: 1), duration: CMTime(seconds: 60, preferredTimescale: 1)), of: track, at: .zero)
                trackComposition?.scaleTimeRange(CMTimeRange(start: CMTime(seconds: 0, preferredTimescale: 1), duration: CMTime(seconds: 60, preferredTimescale: 1)), toDuration: CMTime(seconds: 25, preferredTimescale: 1))
            }
        }
        return newAllComposition
    }
}
