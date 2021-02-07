//
//  TimeLineSpeedVideo.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 07/02/2021.
//

import UIKit

class TimeLineSpeedView: UIView {
    public var leftConstraint: NSLayoutConstraint?
    public var rightConstraint: NSLayoutConstraint?
    public var bottomConstraint: NSLayoutConstraint?
    public var topConstraint: NSLayoutConstraint?
    public var fileImage: UIImage!
    public var leftControllView: UIView!
    public var rightControllView: UIView!
    public var leftLabel: UILabel!
    public var rightLabel: UILabel!
    public var timeLineSpeedVideo: TimeLineCoreGraphic!
    public var images: Array<UIImage> = []
    
    public var leftStartTime: Float!
    public var rightEndTime: Float!
    
    init(frame: CGRect, images: Array<UIImage>) {
        super.init(frame: frame)
        self.images = images
        setupImagesTimeLine()
        setupControlLeftRight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImagesTimeLine() {
        var tempX: CGFloat = 0
        for image in images {
            let imageView = UIImageView.init(frame: CGRect(x: tempX, y: 0, width: self.frame.width / CGFloat(images.count), height: self.frame.height))
            imageView.image = image
            imageView.alpha = 0.35
            self.addSubview(imageView)
            tempX += self.frame.width / CGFloat(images.count)
        }
    }
    
    func setupControlLeftRight() {
        timeLineSpeedVideo = TimeLineCoreGraphic(frame: self.frame, backGroundColor: UIColor(displayP3Red: 234 / 255, green: 68 / 255, blue: 121 / 255, alpha: 0.4))
        timeLineSpeedVideo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(timeLineSpeedVideo)
        
        leftConstraint = timeLineSpeedVideo.leftAnchor.constraint(equalTo: self.leftAnchor)
        rightConstraint = self.rightAnchor.constraint(equalTo: timeLineSpeedVideo.rightAnchor)
        bottomConstraint = self.bottomAnchor.constraint(equalTo: timeLineSpeedVideo.bottomAnchor)
        topConstraint = timeLineSpeedVideo.topAnchor.constraint(equalTo: self.topAnchor)

        leftConstraint?.isActive = true
        rightConstraint?.isActive = true
        bottomConstraint?.isActive = true
        topConstraint?.isActive = true
        
        leftControllView = UIView(frame: self.frame)
        rightControllView = UIView(frame: self.frame)
        leftControllView.backgroundColor = UIColor(patternImage: UIImage(named: "control")!)
        rightControllView.backgroundColor = UIColor(patternImage: UIImage(named: "control")!)
        leftControllView.translatesAutoresizingMaskIntoConstraints = false
        rightControllView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(leftControllView)
        self.addSubview(rightControllView)
        
        leftControllView.leftAnchor.constraint(equalTo: timeLineSpeedVideo.leftAnchor).isActive = true
        leftControllView.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        leftControllView.widthAnchor.constraint(equalToConstant: 9).isActive = true
        leftControllView.centerYAnchor.constraint(equalTo: timeLineSpeedVideo.centerYAnchor).isActive = true
        
        rightControllView.rightAnchor.constraint(equalTo: timeLineSpeedVideo.rightAnchor).isActive = true
        rightControllView.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        rightControllView.widthAnchor.constraint(equalToConstant: 9).isActive = true
        rightControllView.centerYAnchor.constraint(equalTo: timeLineSpeedVideo.centerYAnchor).isActive = true
        
        let leftPan = UIPanGestureRecognizer(target: self, action: #selector(self.leftPanGesture(_: )))
        leftControllView.addGestureRecognizer(leftPan)
        let rightPan = UIPanGestureRecognizer(target: self, action: #selector(self.rightPanGesture(_: )))
        rightControllView.addGestureRecognizer(rightPan)
        
        // MARK: - add new left right label
        leftLabel = UILabel(frame: self.frame)
        rightLabel = UILabel(frame: self.frame)
        
        leftStartTime = Float(leftConstraint!.constant / frame.width)
        leftLabel.text = String(format: "%.0f", leftStartTime * 100) + "%"
        rightEndTime = Float(1 - rightConstraint!.constant / frame.width)
        rightLabel.text = String(format: "%.0f", rightEndTime * 100) + "%"
        leftLabel.textColor = .white
        rightLabel.textColor = .white
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        leftControllView.addSubview(leftLabel)
        rightControllView.addSubview(rightLabel)
        
        leftLabel.topAnchor.constraint(equalTo: leftControllView.bottomAnchor, constant: 10).isActive = true
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
    
    func resetleftRightPanGesture() {
        leftConstraint?.constant = 0
        rightConstraint?.constant = 0
        leftStartTime = Float(leftConstraint!.constant / frame.width)
        leftLabel.text = String(format: "%.0f", leftStartTime * 100) + "%"
        rightEndTime = Float(1 - rightConstraint!.constant / frame.width)
        rightLabel.text = String(format: "%.0f", rightEndTime * 100) + "%"
    }
}
