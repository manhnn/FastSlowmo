//
//  TrimVideo.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 04/02/2021.
//

import AVKit

class TrimVideo: VideoEditorTask {
    
    var timeRange: CMTimeRange!
    
    init(timeRange: CMTimeRange) {
        self.timeRange = timeRange
    }
    
    func execute(mutableComposition: AVMutableComposition) -> AVMutableComposition {
        print("trim video from start -> endTime")
        return mutableComposition
    }
    
}
