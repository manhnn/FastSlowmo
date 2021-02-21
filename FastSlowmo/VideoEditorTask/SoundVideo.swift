//
//  SoundVideo.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 21/02/2021.
//

import UIKit
import AVFoundation

class SoundVideo: Command {
    var volume: Double
    
    init(volume: Double) {
        self.volume = volume
    }
    
    func execute(allComposition: AllComposition) -> AllComposition {
        let audioMix = AVMutableAudioMix()
        for track in allComposition.mutableComposition.tracks(withMediaType: .audio) {
            let inputParam = AVMutableAudioMixInputParameters(track: track)
            inputParam.setVolume(Float(volume/1), at: .zero)
            audioMix.inputParameters.append(inputParam)
        }
        
        allComposition.audioMix = audioMix
        return allComposition
    }
}
