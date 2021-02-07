//
//  TimeLineCutVideo.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 05/02/2021.
//

import UIKit

class TimeLineCoreGraphic: UIView {

    private var topStartPoint: CGPoint?
    private var bottomStartPoint: CGPoint?
    private var distance = CGPoint(x: 3, y: 0)
    private var colorStroke: UIColor?

    convenience init(frame: CGRect, backGroundColor: UIColor, colorStroke: UIColor) {
        self.init()
        self.topStartPoint = CGPoint(x: -frame.height, y: 0)
        self.bottomStartPoint = CGPoint(x: 0, y: frame.height)
        self.backgroundColor = backGroundColor
        self.colorStroke = colorStroke
    }

    override func draw(_ rect: CGRect) {
        let bezier = UIBezierPath()
        var topPoint = topStartPoint
        var bottomPoint = bottomStartPoint

        UIColor.init(cgColor: colorStroke!.cgColor).setStroke()
        
        while topPoint!.x <= rect.width {
            bezier.move(to: topPoint!)
            bezier.addLine(to: bottomPoint!)

            topPoint!.x += distance.x
            topPoint!.y += distance.y
            bottomPoint!.x += distance.x
            bottomPoint!.y += distance.y
        }
        bezier.stroke()
    }
}
