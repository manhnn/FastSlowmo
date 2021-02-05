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
    
    func execute(mutableComposition: AVMutableComposition) -> AVMutableComposition {
        let newMutableComposition = AVMutableComposition()
        mutableComposition.tracks.forEach { track in
            let trackComposition = newMutableComposition.addMutableTrack(withMediaType: track.mediaType, preferredTrackID: track.trackID)
            try? trackComposition?.insertTimeRange(timeRange, of: track, at: .zero)
        }
        return newMutableComposition
    }
}
