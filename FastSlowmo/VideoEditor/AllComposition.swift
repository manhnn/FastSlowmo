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
    var audioMix: AVAudioMix!
    
    convenience init(mutableComposition: AVMutableComposition, videoComposition: AVMutableVideoComposition, audioMix: AVAudioMix) {
        self.init()
        self.mutableComposition = mutableComposition
        self.videoComposition = videoComposition
        self.audioMix = audioMix
    }
    
    init() {
        self.mutableComposition = AVMutableComposition()
        self.videoComposition = nil
        self.audioMix = nil
    }
}
