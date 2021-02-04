//
//  VideoEditor.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 04/02/2021.
//

import AVKit

class VideoEditor {
    
    var listCommand = [VideoEditorTask]()
    var currentIndex = 0
    
    func pushCommand(task: VideoEditorTask) {
        listCommand.append(task)
        currentIndex += 1
    }
    
    func popCommand(task: VideoEditorTask) {
        listCommand.removeLast()
    }
    
    func undoCommand(task: VideoEditorTask) -> VideoEditorTask {
        return listCommand[currentIndex - 1]
    }
    
    func redoCommand(task: VideoEditorTask) -> VideoEditorTask {
        return listCommand[currentIndex + 1]
    }
    
    func executeTask(mutableComposition: AVMutableComposition) -> AVMutableComposition {
        var newMutableComposition = mutableComposition
        for task in listCommand {
            newMutableComposition = task.execute(mutableComposition: mutableComposition)
        }
        return newMutableComposition
    }
}
