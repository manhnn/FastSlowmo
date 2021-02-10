//
//  EffectVideo.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 10/02/2021.
//

import UIKit
import AVFoundation

class EffectVideo: Command {
    func execute(allComposition: AllComposition) -> AllComposition {
        let filter = CIFilter(name: "CIPhotoEffectMono")
        
        return allComposition
    }
}
