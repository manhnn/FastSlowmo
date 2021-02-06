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
    
    func execute(mutableComposition: AVMutableComposition) -> AVMutableComposition {
        mutableComposition.removeTimeRange(timeRange)
        return mutableComposition
    }
}
