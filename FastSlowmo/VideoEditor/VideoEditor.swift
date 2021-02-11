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
        var newAllComposition = AllComposition(mutableComposition: allComposition.mutableComposition, videoComposition: allComposition.videoComposition)
        for task in listCommand {
            newAllComposition = task.execute(allComposition: newAllComposition)
        }
        return newAllComposition
    }
}
