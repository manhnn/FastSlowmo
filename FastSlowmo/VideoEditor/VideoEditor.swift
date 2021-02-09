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
    
    func popCommand(task: Command) {
        listCommand.removeLast()
    }
    
    func undoCommand(task: Command) -> Command {
        return listCommand[currentIndex - 1]
    }
    
    func redoCommand(task: Command) -> Command {
        return listCommand[currentIndex + 1]
    }
    
    func executeTask(allComposition: AllComposition) -> AllComposition {
        var newMutableComposition = allComposition
        for task in listCommand {
            newMutableComposition = task.execute(allComposition: allComposition)
        }
        return newMutableComposition
    }
}
