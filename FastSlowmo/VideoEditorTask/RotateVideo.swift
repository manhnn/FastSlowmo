//
//  RotateVideo.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 08/02/2021.
//

import UIKit
import AVFoundation

class RotateVideo: Command {
    
    var rotateDirection: Int!
    var rotateType: Int!
    
    init(rotateDirection: Int, rotateType: Int) {
        self.rotateDirection = rotateDirection
        self.rotateType = rotateType
    }
    
    func execute(allComposition: AllComposition) -> AllComposition {
        let ratio = allComposition.mutableComposition.naturalSize.height / allComposition.mutableComposition.naturalSize.width
        
        let tranformer = AVMutableVideoCompositionLayerInstruction.init(assetTrack: allComposition.mutableComposition.tracks(withMediaType: .video).first!)
        var tranform1 = CGAffineTransform()
        
        if (rotateDirection == 1 && rotateType == 1) || (rotateDirection == 0 && rotateType == 3) {
            tranform1 = CGAffineTransform(rotationAngle: .pi / 2).translatedBy(x: 0, y: -allComposition.mutableComposition.naturalSize.width * ratio)
        }
        else if (rotateDirection == 1 && rotateType == 2) || (rotateDirection == 0 && rotateType == 2) {
            tranform1 = CGAffineTransform(rotationAngle: .pi).translatedBy(x: -allComposition.mutableComposition.naturalSize.width, y: -allComposition.mutableComposition.naturalSize.height)
        }
        else if (rotateDirection == 1 && rotateType == 3) || (rotateDirection == 0 && rotateType == 1) {
            tranform1 = CGAffineTransform(rotationAngle: .pi * 1.5).translatedBy(x: -allComposition.mutableComposition.naturalSize.height / ratio, y: 0)
        }
        else {
            tranform1 = CGAffineTransform(translationX: 0, y: 0.001)
        }
        
        tranformer.setTransform(tranform1, at: .zero)
        
        let layerInstruction = AVMutableVideoCompositionInstruction.init()
        layerInstruction.timeRange = CMTimeRangeMake(start: .zero, duration: allComposition.mutableComposition.duration)
        layerInstruction.layerInstructions = [tranformer]
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.frameDuration = CMTime(value: 1, timescale: 1000)
        videoComposition.instructions = [layerInstruction]
        
        if rotateType == 1 || rotateType == 3 {
            videoComposition.renderSize = CGSize(width: allComposition.mutableComposition.naturalSize.height, height: allComposition.mutableComposition.naturalSize.width)
        }
        else { // rotationIndex == RotationType.upsideDown.rawValue || rotationIndex == RotationType.portrait.rawValue
            videoComposition.renderSize = CGSize(width: allComposition.mutableComposition.naturalSize.width, height: allComposition.mutableComposition.naturalSize.height)
        }
        
        allComposition.videoComposition = videoComposition
        
        return allComposition
    }
}
