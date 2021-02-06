//
//  TimeLineTrimView.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 05/02/2021.
//

import UIKit

class TimeLineTrimView: UIView {
    public var leftConstraint: NSLayoutConstraint?
    public var rightConstraint: NSLayoutConstraint?
    public var leftControllView: UIView!
    public var rightControllView: UIView!
    public var leftLabel: UILabel!
    public var rightLabel: UILabel!
    public var timeLineCutVideoLeft: TimeLineCutVideo!
    public var timeLineCutVideoRight: TimeLineCutVideo!
    public var images: Array<UIImage> = []
    
    public var leftStartTime: Float!
    public var rightEndTime: Float!
    
    init(frame: CGRect, images: Array<UIImage>) {
        super.init(frame: frame)
        self.images = images
        setupImagesTimeLine()
        setupLeftControllerView()
        setupRightControllerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImagesTimeLine() {
        var tempX: CGFloat = 0
        for image in images {
            let imageView = UIImageView.init(frame: CGRect(x: tempX, y: 0, width: self.frame.width / CGFloat(images.count), height: self.frame.height))
            imageView.image = image
            self.addSubview(imageView)
            tempX += self.frame.width / CGFloat(images.count)
        }
    }
    
    func setupLeftControllerView() {
        timeLineCutVideoLeft = TimeLineCutVideo(frame: CGRect(x: 0, y: 0, width: frame.width / 4, height: frame.height), backGroundColor: UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.5))
        timeLineCutVideoLeft.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(timeLineCutVideoLeft)
        
        leftConstraint = timeLineCutVideoLeft.rightAnchor.constraint(equalTo: self.leftAnchor)
        timeLineCutVideoLeft.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: timeLineCutVideoLeft.bottomAnchor).isActive = true
        timeLineCutVideoLeft.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        leftConstraint?.isActive = true
        
        leftControllView = UIView(frame: CGRect(x: 0, y: 0, width: 9, height: frame.height))
        leftControllView.backgroundColor = UIColor(patternImage: UIImage(named: "control")!)
        leftControllView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(leftControllView)
        
        leftControllView.leftAnchor.constraint(equalTo: timeLineCutVideoLeft.rightAnchor).isActive = true
        leftControllView.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        leftControllView.widthAnchor.constraint(equalToConstant: 9).isActive = true
        leftControllView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let leftPan = UIPanGestureRecognizer(target: self, action: #selector(self.leftPanGesture(_: )))
        leftControllView.addGestureRecognizer(leftPan)

        leftLabel = UILabel(frame: self.frame)
        leftStartTime = Float(leftConstraint!.constant / frame.width)
        leftLabel.text = String(format: "%.0f", leftStartTime * 100) + "%"
        leftLabel.textColor = .white
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        
        leftControllView.addSubview(leftLabel)
        
        leftLabel.topAnchor.constraint(equalTo: leftControllView.bottomAnchor, constant: 10).isActive = true
    }
    
    func setupRightControllerView() {
        timeLineCutVideoRight = TimeLineCutVideo(frame: CGRect(x: 0, y: 0, width: frame.width / 4, height: frame.height), backGroundColor: UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.5))
        timeLineCutVideoRight.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(timeLineCutVideoRight)
        
        rightConstraint = self.rightAnchor.constraint(equalTo: timeLineCutVideoRight.leftAnchor)
        self.rightAnchor.constraint(equalTo: timeLineCutVideoRight.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: timeLineCutVideoRight.bottomAnchor).isActive = true
        timeLineCutVideoRight.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        rightConstraint?.isActive = true
        
        rightControllView = UIView(frame: CGRect(x: 0, y: 0, width: 9, height: frame.height))
        rightControllView.backgroundColor = UIColor(patternImage: UIImage(named: "control")!)
        rightControllView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rightControllView)
        
        rightControllView.rightAnchor.constraint(equalTo: timeLineCutVideoRight.leftAnchor).isActive = true
        rightControllView.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        rightControllView.widthAnchor.constraint(equalToConstant: 9).isActive = true
        rightControllView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let rightPan = UIPanGestureRecognizer(target: self, action: #selector(self.rightPanGesture(_: )))
        rightControllView.addGestureRecognizer(rightPan)

        rightLabel = UILabel(frame: self.frame)
        rightEndTime = Float(1 - rightConstraint!.constant / frame.width)
        rightLabel.text = String(format: "%.0f", rightEndTime * 100) + "%"
        rightLabel.textColor = .white
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        rightControllView.addSubview(rightLabel)
        
        rightLabel.topAnchor.constraint(equalTo: rightControllView.bottomAnchor, constant: 10).isActive = true
    }
    
    @objc func leftPanGesture(_ sender: Any?) {
        let panGesture = sender as! UIPanGestureRecognizer
        let point = panGesture.location(in: self)
        let distance = point.x
        
        if distance < 0 {
            leftConstraint?.constant = 0
        }
        else {
            leftConstraint?.constant = (distance >= 0 && distance + rightConstraint!.constant + 2 * rightControllView.frame.width <= self.frame.width) ? distance : self.frame.width - rightConstraint!.constant - (leftControllView.frame.width + rightControllView.frame.width)
        }
        
        leftStartTime = Float(leftConstraint!.constant / frame.width)
        leftLabel.text = String(format: "%.0f", leftStartTime * 100) + "%"
    }
    
    @objc func rightPanGesture(_ sender: Any?) {
        let panGesture = sender as! UIPanGestureRecognizer
        let point = panGesture.location(in: self)
        let distance = self.frame.width - point.x
        
        if distance < 0 {
            rightConstraint?.constant = 0
        }
        else {
            rightConstraint?.constant = (distance >= 0 && distance + leftConstraint!.constant + 2 * leftControllView.frame.width <= self.frame.width) ? distance : self.frame.width - leftConstraint!.constant - (leftControllView.frame.width + rightControllView.frame.width)
        }
        
        rightEndTime = Float(1 - rightConstraint!.constant / frame.width)
        rightLabel.text = String(format: "%.0f", rightEndTime * 100) + "%"
    }
}
