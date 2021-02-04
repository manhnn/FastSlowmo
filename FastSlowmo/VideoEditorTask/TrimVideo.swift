//
//  TrimVideo.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 04/02/2021.
//

import AVKit

class TrimVideo: VideoEditorTask {
    
    var startTime: CMTime!
    var endTime: CMTime!
    
    init(startTime: CMTime, endTime: CMTime) {
        self.startTime = startTime
        self.endTime = endTime
    }
    
    func execute(mutableComposition: AVMutableComposition) -> AVMutableComposition {
        print("trim video from start -> endTime")
        return mutableComposition
    }
    
}
