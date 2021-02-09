//
//  RotateVideo.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 08/02/2021.
//

import UIKit
import AVFoundation

class RotateVideo: Command {
    
    var rotateType: Int!
    
    init(rotateType: Int) {
        self.rotateType = rotateType
    }
    
    func execute(allComposition: AllComposition) -> AllComposition {
        let newAllComposition = AllComposition(mutableComposition: allComposition.mutableComposition, videoComposition: allComposition.videoComposition)
        
        let ratio = newAllComposition.mutableComposition.naturalSize.height / newAllComposition.mutableComposition.naturalSize.width
        
        let tranformer = AVMutableVideoCompositionLayerInstruction.init(assetTrack: newAllComposition.mutableComposition.tracks(withMediaType: .video).first!)
        var tranform1 = CGAffineTransform()
        
        if rotateType == 1 || rotateType == -3 {
            tranform1 = CGAffineTransform(rotationAngle: .pi / 2).translatedBy(x: 0, y: -newAllComposition.mutableComposition.naturalSize.width * ratio)
        }
        else if rotateType == 2 || rotateType == -2 {
            tranform1 = CGAffineTransform(rotationAngle: .pi).translatedBy(x: -newAllComposition.mutableComposition.naturalSize.width, y: -newAllComposition.mutableComposition.naturalSize.height)
        }
        else if rotateType == 3 || rotateType == -1 {
            tranform1 = CGAffineTransform(rotationAngle: .pi * 1.5).translatedBy(x: -newAllComposition.mutableComposition.naturalSize.height / ratio, y: 0)
        }
        else {
            tranform1 = CGAffineTransform(translationX: 0, y: 0.001)
        }
        
        tranformer.setTransform(tranform1, at: .zero)
        
        let layerInstruction = AVMutableVideoCompositionInstruction.init()
        layerInstruction.timeRange = CMTimeRangeMake(start: .zero, duration: newAllComposition.mutableComposition.duration)
        layerInstruction.layerInstructions = [tranformer]
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.frameDuration = CMTime(value: 1, timescale: 1000)
        videoComposition.instructions = [layerInstruction]
        
        if rotateType == 1 || rotateType == 3  || rotateType == -1 || rotateType == -3 {
            videoComposition.renderSize = CGSize(width: newAllComposition.mutableComposition.naturalSize.height, height: newAllComposition.mutableComposition.naturalSize.width)
        }
        else { // rotateType == 2 || rotateType == 4
            videoComposition.renderSize = CGSize(width: newAllComposition.mutableComposition.naturalSize.width, height: newAllComposition.mutableComposition.naturalSize.height)
        }
        
        newAllComposition.videoComposition = videoComposition
        
        return newAllComposition
    }
}
