//
//  VideoEditorTask.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 04/02/2021.
//

import UIKit
import AVFoundation

protocol Command {
    func execute(allComposition: AllComposition) -> AllComposition
}
