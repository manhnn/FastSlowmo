//
//  Composition.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 09/02/2021.
//

import UIKit
import AVFoundation

class AllComposition {
    
    var mutableComposition: AVMutableComposition!
    var videoComposition: AVMutableVideoComposition!
    
    init(mutableComposition: AVMutableComposition, videoComposition: AVMutableVideoComposition) {
        self.mutableComposition = mutableComposition
        self.videoComposition = videoComposition
    }
    
}
