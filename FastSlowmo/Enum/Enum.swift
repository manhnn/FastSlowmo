//
//  Enum.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 06/02/2021.
//

import Foundation

enum CutType: String {
    case empty = "nilVideo"
    case trimVideo = "trimVideo"
    case cutoutVideo = "cutoutVideo"
}

enum RotateVideoType: Int {
    case portrait = 0
    case landscapeRight = 1
    case upsideDown = 2
    case landscapeLeft = 3
}

enum RotateDirection: Int {
    case left = 0
    case right = 1
}
