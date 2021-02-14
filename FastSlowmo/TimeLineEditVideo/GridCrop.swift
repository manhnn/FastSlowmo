//
//  GridCrop.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 14/02/2021.
//

import UIKit

class GridCrop: UIView {

    private var point: CGPoint?

    convenience init(frame: CGRect, point: CGPoint) {
        self.init()
        self.point = point
    }

    override func draw(_ rect: CGRect) {
        let bezier = UIBezierPath()

        UIColor.yellow.setStroke()

        bezier.move(to: point!)
        bezier.addLine(to: CGPoint(x: 0, y: frame.height))
        bezier.move(to: CGPoint(x: frame.width / 3, y: 0))
        bezier.addLine(to: CGPoint(x: frame.width / 3, y: frame.height))
        bezier.move(to: CGPoint(x: 2 * frame.width / 3, y: 0))
        bezier.addLine(to: CGPoint(x: 2 * frame.width / 3, y: frame.height))
        bezier.move(to: CGPoint(x: frame.width, y: 0))
        bezier.addLine(to: CGPoint(x: frame.width, y: frame.height))

        bezier.move(to: point!)
        bezier.addLine(to: CGPoint(x: frame.width, y: 0))
        bezier.move(to: CGPoint(x: 0, y: frame.height / 3))
        bezier.addLine(to: CGPoint(x: frame.width, y: frame.height / 3))
        bezier.move(to: CGPoint(x: 0, y: 2 * frame.height / 3))
        bezier.addLine(to: CGPoint(x: frame.width, y: 2 * frame.height / 3))
        bezier.move(to: CGPoint(x: 0, y: frame.height))
        bezier.addLine(to: CGPoint(x: frame.width, y: frame.height))

        bezier.lineWidth = 3
        bezier.stroke()
    }
}
