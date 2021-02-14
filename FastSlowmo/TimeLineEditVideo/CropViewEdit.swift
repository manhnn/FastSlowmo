//
//  CropViewEdit.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 13/02/2021.
//

import UIKit

class CropViewEdit: UIView {
    
    public var leftConstraint: NSLayoutConstraint?
    public var rightConstraint: NSLayoutConstraint?
    public var bottomConstraint: NSLayoutConstraint?
    public var topConstraint: NSLayoutConstraint?
    public var fileImage: UIImage!
    public var leftControllView: UIView!
    public var rightControllView: UIView!
    public var bottomControllView: UIView!
    public var topControllView: UIView!
//    public var leftLabel: UILabel!
//    public var rightLabel: UILabel!
    public var gridCrop: GridCrop!
    
    public var leftStartTime: Float!
    public var rightEndTime: Float!
    
    init(frame: CGRect, point: CGPoint) {
        super.init(frame: frame)
        setupControlLeftRight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupControlLeftRight() {
        gridCrop = GridCrop(frame: self.frame, point: CGPoint(x: 0, y: 0))
        gridCrop.backgroundColor = .clear
        gridCrop.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(gridCrop)
        
        leftConstraint = gridCrop.leftAnchor.constraint(equalTo: self.leftAnchor)
        rightConstraint = self.rightAnchor.constraint(equalTo: gridCrop.rightAnchor)
        bottomConstraint = self.bottomAnchor.constraint(equalTo: gridCrop.bottomAnchor)
        topConstraint = gridCrop.topAnchor.constraint(equalTo: self.topAnchor)

        leftConstraint?.isActive = true
        rightConstraint?.isActive = true
        bottomConstraint?.isActive = true
        topConstraint?.isActive = true
        
        leftControllView = UIView(frame: self.frame)
        rightControllView = UIView(frame: self.frame)
        topControllView = UIView(frame: self.frame)
        bottomControllView = UIView(frame: self.frame)
        
        leftControllView.backgroundColor = .systemYellow
        rightControllView.backgroundColor = .systemYellow
        topControllView.backgroundColor = .systemYellow
        bottomControllView.backgroundColor = .systemYellow
        
        leftControllView.translatesAutoresizingMaskIntoConstraints = false
        rightControllView.translatesAutoresizingMaskIntoConstraints = false
        topControllView.translatesAutoresizingMaskIntoConstraints = false
        bottomControllView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(leftControllView)
        self.addSubview(rightControllView)
        self.addSubview(topControllView)
        self.addSubview(bottomControllView)
        
        leftControllView.leftAnchor.constraint(equalTo: gridCrop.leftAnchor).isActive = true
        leftControllView.heightAnchor.constraint(equalToConstant: self.frame.height / 10).isActive = true
        leftControllView.widthAnchor.constraint(equalToConstant: 5).isActive = true
        leftControllView.centerYAnchor.constraint(equalTo: gridCrop.centerYAnchor).isActive = true
        
        rightControllView.rightAnchor.constraint(equalTo: gridCrop.rightAnchor).isActive = true
        rightControllView.heightAnchor.constraint(equalToConstant: self.frame.height / 10).isActive = true
        rightControllView.widthAnchor.constraint(equalToConstant: 5).isActive = true
        rightControllView.centerYAnchor.constraint(equalTo: gridCrop.centerYAnchor).isActive = true
        
        topControllView.topAnchor.constraint(equalTo: gridCrop.topAnchor).isActive = true
        topControllView.widthAnchor.constraint(equalToConstant: self.frame.width / 10).isActive = true
        topControllView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        topControllView.centerXAnchor.constraint(equalTo: gridCrop.centerXAnchor).isActive = true
        
        bottomControllView.bottomAnchor.constraint(equalTo: gridCrop.bottomAnchor).isActive = true
        bottomControllView.widthAnchor.constraint(equalToConstant: self.frame.width / 10).isActive = true
        bottomControllView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        bottomControllView.centerXAnchor.constraint(equalTo: gridCrop.centerXAnchor).isActive = true
        
        let leftPan = UIPanGestureRecognizer(target: self, action: #selector(self.leftPanGesture(_: )))
        leftControllView.addGestureRecognizer(leftPan)
        let rightPan = UIPanGestureRecognizer(target: self, action: #selector(self.rightPanGesture(_: )))
        rightControllView.addGestureRecognizer(rightPan)
        let topPan = UIPanGestureRecognizer(target: self, action: #selector(self.topPanGesture(_: )))
        topControllView.addGestureRecognizer(topPan)
        let bottomPan = UIPanGestureRecognizer(target: self, action: #selector(self.bottomPanGesture(_:)))
        bottomControllView.addGestureRecognizer(bottomPan)
        
        // MARK: - add new left right label
        //leftLabel = UILabel(frame: self.frame)
        //rightLabel = UILabel(frame: self.frame)
        
        leftStartTime = Float(leftConstraint!.constant / frame.width)
        //leftLabel.text = String(format: "%.0f", leftStartTime * 100) + "%"
        rightEndTime = Float(1 - rightConstraint!.constant / frame.width)
        //rightLabel.text = String(format: "%.0f", rightEndTime * 100) + "%"
        //leftLabel.textColor = .white
        //rightLabel.textColor = .white
        //leftLabel.translatesAutoresizingMaskIntoConstraints = false
        //rightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //leftControllView.addSubview(leftLabel)
        //rightControllView.addSubview(rightLabel)
        
        //leftLabel.topAnchor.constraint(equalTo: leftControllView.bottomAnchor, constant: 10).isActive = true
        //rightLabel.topAnchor.constraint(equalTo: rightControllView.bottomAnchor, constant: 10).isActive = true
    }
    
    
    @objc func leftPanGesture(_ sender: Any?) {
        let panGesture = sender as! UIPanGestureRecognizer
        let point = panGesture.location(in: self)
        let distance = point.x
        
        if distance < 0 {
            leftConstraint?.constant = 0
        }
        else {
            leftConstraint?.constant = distance
        }
        
        leftStartTime = Float(leftConstraint!.constant / frame.width)
        //leftLabel.text = String(format: "%.0f", leftStartTime * 100) + "%"
    }
    
    @objc func rightPanGesture(_ sender: Any?) {
        let panGesture = sender as! UIPanGestureRecognizer
        let point = panGesture.location(in: self)
        let distance = self.frame.width - point.x
        
        if distance < 0 {
            rightConstraint?.constant = 0
        }
        else {
            rightConstraint?.constant = distance
        }
        rightEndTime = Float(1 - rightConstraint!.constant / frame.width)
        //rightLabel.text = String(format: "%.0f", rightEndTime * 100) + "%"
    }
    
    @objc func topPanGesture(_ sender: Any?) {
        let panGesture = sender as! UIPanGestureRecognizer
        let point = panGesture.location(in: self)
        let distance = point.y
        
        if distance < 0 {
            topConstraint?.constant = 0
        }
        else {
            topConstraint?.constant = distance
        }
    }
    
    @objc func bottomPanGesture(_ sender: Any?) {
        let panGesture = sender as! UIPanGestureRecognizer
        let point = panGesture.location(in: self)
        let distance = self.frame.height - point.y
        
        if distance < 0 {
            bottomConstraint?.constant = 0
        }
        else {
            bottomConstraint?.constant = distance
        }
    }
}


