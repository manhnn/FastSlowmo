//
//  ThumbnailCutVideoView.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 05/02/2021.
//

import UIKit

class ThumbnailCutVideoView: UIView {
    public var leftConstraint: NSLayoutConstraint?
    public var rightConstraint: NSLayoutConstraint?
    public var fileImage: UIImage!
    public var leftControllView: UIView!
    public var rightControllView: UIView!
    public var leftLabel: UILabel!
    public var rightLabel: UILabel!
    public var thumbnailCutVideoLeft: ThumbnailCutVideo!
    public var thumbnailCutVideoRight: ThumbnailCutVideo!
    
    public var leftStartTime: Float!
    public var rightEndTime: Float!
    
    init(frame: CGRect, fileImage: UIImage) {
        self.fileImage = fileImage
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if fileImage != nil {
            let imageView = UIImageView(frame: self.frame)
            imageView.image = fileImage
            imageView.contentMode = .scaleToFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(imageView)
            
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }
        configLeftControllerView()
        configRightControllerView()
    }
    
    func configLeftControllerView() {
        thumbnailCutVideoLeft = ThumbnailCutVideo(frame: CGRect(x: 0, y: 0, width: frame.width / 4, height: frame.height))
        thumbnailCutVideoLeft.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(thumbnailCutVideoLeft)
        
        leftConstraint = thumbnailCutVideoLeft.rightAnchor.constraint(equalTo: self.leftAnchor)
        thumbnailCutVideoLeft.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: thumbnailCutVideoLeft.bottomAnchor).isActive = true
        thumbnailCutVideoLeft.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        leftConstraint?.isActive = true
        
        leftControllView = UIView(frame: CGRect(x: 0, y: 0, width: 9, height: frame.height + 20))
        leftControllView.backgroundColor = .white
        leftControllView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(leftControllView)
        
        leftControllView.leftAnchor.constraint(equalTo: thumbnailCutVideoLeft.rightAnchor).isActive = true
        leftControllView.heightAnchor.constraint(equalToConstant: self.frame.height + 20).isActive = true
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
    
    func configRightControllerView() {
        thumbnailCutVideoRight = ThumbnailCutVideo(frame: CGRect(x: 0, y: 0, width: frame.width / 4, height: frame.height))
        thumbnailCutVideoRight.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(thumbnailCutVideoRight)
        
        rightConstraint = self.rightAnchor.constraint(equalTo: thumbnailCutVideoRight.leftAnchor)
        self.rightAnchor.constraint(equalTo: thumbnailCutVideoRight.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: thumbnailCutVideoRight.bottomAnchor).isActive = true
        thumbnailCutVideoRight.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        rightConstraint?.isActive = true
        
        rightControllView = UIView(frame: CGRect(x: 0, y: 0, width: 9, height: frame.height + 20))
        rightControllView.backgroundColor = .white
        rightControllView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rightControllView)
        
        rightControllView.rightAnchor.constraint(equalTo: thumbnailCutVideoRight.leftAnchor).isActive = true
        rightControllView.heightAnchor.constraint(equalToConstant: self.frame.height + 20).isActive = true
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
