//
//  VideoEditor.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 04/02/2021.
//

import AVKit

class VideoEditor {
    
    var listCommand = [Command]()
    
    func pushCommand(task: Command) {
        listCommand.append(task)
    }
    
    func popCommand() {
        listCommand.removeLast()
    }
    
    func undoCommand(countClick: Int) {
        listCommand.removeLast(countClick)
    }
    
    func redoCommand(task: Command) -> Command {
        return listCommand.first!
    }
    
    func executeTask(allComposition: AllComposition) -> AllComposition {
        var newAllComposition = AllComposition()
        
        newAllComposition.mutableComposition = allComposition.mutableComposition.mutableCopy() as? AVMutableComposition
        newAllComposition.videoComposition = allComposition.videoComposition?.mutableCopy() as? AVMutableVideoComposition
        newAllComposition.audioMix = allComposition.audioMix?.mutableCopy() as? AVAudioMix
        
        for task in listCommand {
            newAllComposition = task.execute(allComposition: newAllComposition)
        }
        return newAllComposition
    }
}
