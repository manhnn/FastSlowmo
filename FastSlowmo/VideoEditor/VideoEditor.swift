//
//  VideoEditor.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 04/02/2021.
//

import AVKit

class VideoEditor {
    
    var listCommand = [Command]()
    var currentIndex = 0
    
    func pushCommand(task: Command) {
        listCommand.append(task)
        currentIndex += 1
    }
    
    func popCommand() {
        listCommand.removeLast()
    }
    
    func undoCommand(task: Command) -> Command {
        return listCommand[currentIndex - 1]
    }
    
    func redoCommand(task: Command) -> Command {
        return listCommand[currentIndex + 1]
    }
    
    func executeTask(allComposition: AllComposition) -> AllComposition {
        var newAllComposition = AllComposition(mutableComposition: allComposition.mutableComposition, videoComposition: allComposition.videoComposition)
        for task in listCommand {
            newAllComposition = task.execute(allComposition: newAllComposition)
        }
        return newAllComposition
    }
}
