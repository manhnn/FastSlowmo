//
//  CropVideo.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 04/02/2021.
//

import AVKit

class CropVideo: VideoEditorTask {
    
    var cropRectangle: CGRect!
    
    init(cropRect: CGRect) {
        self.cropRectangle = cropRect
    }
    
    func execute(mutableComposition: AVMutableComposition) -> AVMutableComposition {
        print("crop video with frame cropRectangle")
        return mutableComposition
    }
}
