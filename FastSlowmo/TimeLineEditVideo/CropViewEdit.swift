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
    public var leftBottomControllView: UIView!
    public var rightTopControllView: UIView!
    public var leftTopControllView: UIView!
    public var rightBottomControllView: UIView!
    public var gridCrop: GridCrop!
    
    public var cropPointLeftBottom = CGPoint(x: 0, y: 0)
    public var cropPointRightTop = CGPoint(x: 426, y: 320)
    
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
        leftBottomControllView = UIView(frame: self.frame)
        rightTopControllView = UIView(frame: self.frame)
        leftTopControllView = UIView(frame: self.frame)
        rightBottomControllView = UIView(frame: self.frame)
        
        leftControllView.backgroundColor = .systemYellow
        rightControllView.backgroundColor = .systemYellow
        topControllView.backgroundColor = .systemYellow
        bottomControllView.backgroundColor = .systemYellow
        leftBottomControllView.backgroundColor = .systemYellow
        rightTopControllView.backgroundColor = .systemYellow
        leftTopControllView.backgroundColor = .systemYellow
        rightBottomControllView.backgroundColor = .systemYellow
        
        leftControllView.translatesAutoresizingMaskIntoConstraints = false
        rightControllView.translatesAutoresizingMaskIntoConstraints = false
        topControllView.translatesAutoresizingMaskIntoConstraints = false
        bottomControllView.translatesAutoresizingMaskIntoConstraints = false
        leftBottomControllView.translatesAutoresizingMaskIntoConstraints = false
        rightTopControllView.translatesAutoresizingMaskIntoConstraints = false
        leftTopControllView.translatesAutoresizingMaskIntoConstraints = false
        rightBottomControllView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(leftControllView)
        self.addSubview(rightControllView)
        self.addSubview(topControllView)
        self.addSubview(bottomControllView)
        self.addSubview(leftBottomControllView)
        self.addSubview(rightTopControllView)
        self.addSubview(leftTopControllView)
        self.addSubview(rightBottomControllView)
        
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
        
        leftBottomControllView.bottomAnchor.constraint(equalTo: gridCrop.bottomAnchor).isActive = true
        leftBottomControllView.leftAnchor.constraint(equalTo: gridCrop.leftAnchor).isActive = true
        leftBottomControllView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        leftBottomControllView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        rightTopControllView.topAnchor.constraint(equalTo: gridCrop.topAnchor).isActive = true
        rightTopControllView.rightAnchor.constraint(equalTo: gridCrop.rightAnchor).isActive = true
        rightTopControllView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        rightTopControllView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        leftTopControllView.topAnchor.constraint(equalTo: gridCrop.topAnchor).isActive = true
        leftTopControllView.leftAnchor.constraint(equalTo: gridCrop.leftAnchor).isActive = true
        leftTopControllView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        leftTopControllView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        rightBottomControllView.bottomAnchor.constraint(equalTo: gridCrop.bottomAnchor).isActive = true
        rightBottomControllView.rightAnchor.constraint(equalTo: gridCrop.rightAnchor).isActive = true
        rightBottomControllView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        rightBottomControllView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let leftPan = UIPanGestureRecognizer(target: self, action: #selector(self.leftPanGesture(_: )))
        leftControllView.addGestureRecognizer(leftPan)
        let rightPan = UIPanGestureRecognizer(target: self, action: #selector(self.rightPanGesture(_: )))
        rightControllView.addGestureRecognizer(rightPan)
        let topPan = UIPanGestureRecognizer(target: self, action: #selector(self.topPanGesture(_: )))
        topControllView.addGestureRecognizer(topPan)
        let bottomPan = UIPanGestureRecognizer(target: self, action: #selector(self.bottomPanGesture(_:)))
        bottomControllView.addGestureRecognizer(bottomPan)
        let leftBottomPan = UIPanGestureRecognizer(target: self, action: #selector(self.leftBottomPanGesture(_:)))
        leftBottomControllView.addGestureRecognizer(leftBottomPan)
        let rightTopPan = UIPanGestureRecognizer(target: self, action: #selector(self.rightTopPanGesture(_:)))
        rightTopControllView.addGestureRecognizer(rightTopPan)
        let leftTopPan = UIPanGestureRecognizer(target: self, action: #selector(self.leftTopPanGesture(_:)))
        leftTopControllView.addGestureRecognizer(leftTopPan)
        let rightBottomPan = UIPanGestureRecognizer(target: self, action: #selector(self.rightBottomPanGesture(_:)))
        rightBottomControllView.addGestureRecognizer(rightBottomPan)
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
        print("LEFT - \(leftConstraint?.constant)")
        cropPointLeftBottom.x = leftConstraint!.constant
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
        print("RIGHT - \(point.x)")
        cropPointRightTop.x = point.x
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
        print("TOP - \(self.frame.height - point.y)")
        cropPointRightTop.y = self.frame.height - point.y
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
        print("BOTTOM - \(bottomConstraint?.constant)")
        cropPointLeftBottom.y = bottomConstraint!.constant
    }
    
    @objc func leftBottomPanGesture(_ sender: Any?) {
        let panGesture = sender as! UIPanGestureRecognizer
        let point = panGesture.location(in: self)
        let distanceX = point.x
        let distanceY = self.frame.height - point.y
        
        if distanceX < 0 {
            leftConstraint?.constant = 0
        }
        else {
            leftConstraint?.constant = distanceX
        }
        
        if distanceY < 0 {
            bottomConstraint?.constant = 0
        }
        else {
            bottomConstraint?.constant = distanceY
        }
        cropPointLeftBottom.x = leftConstraint!.constant
        cropPointLeftBottom.y = bottomConstraint!.constant
    }
    
    @objc func rightTopPanGesture(_ sender: Any?) {
        let panGesture = sender as! UIPanGestureRecognizer
        let point = panGesture.location(in: self)
        let distanceX = self.frame.width - point.x
        let distanceY = point.y
        
        if distanceX < 0 {
            rightConstraint?.constant = 0
        }
        else {
            rightConstraint?.constant = distanceX
        }
        
        if distanceY < 0 {
            topConstraint?.constant = 0
        }
        else {
            topConstraint?.constant = distanceY
        }
        cropPointRightTop.x = point.x
        cropPointRightTop.y = self.frame.height - point.y
    }
    
    @objc func leftTopPanGesture(_ sender: Any?) {
        let panGesture = sender as! UIPanGestureRecognizer
        let point = panGesture.location(in: self)
        let distanceX = point.x
        let distanceY = point.y
        
        if distanceX < 0 {
            leftConstraint?.constant = 0
        }
        else {
            leftConstraint?.constant = distanceX
        }
        
        if distanceY < 0 {
            topConstraint?.constant = 0
        }
        else {
            topConstraint?.constant = distanceY
        }
        cropPointLeftBottom.x = leftConstraint!.constant
        cropPointRightTop.y = self.frame.height - point.y
    }
    
    @objc func rightBottomPanGesture(_ sender: Any?) {
        let panGesture = sender as! UIPanGestureRecognizer
        let point = panGesture.location(in: self)
        let distanceX = self.frame.width - point.x
        let distanceY = self.frame.height - point.y
        
        if distanceX < 0 {
            rightConstraint?.constant = 0
        }
        else {
            rightConstraint?.constant = distanceX
        }
        
        if distanceY < 0 {
            bottomConstraint?.constant = 0
        }
        else {
            bottomConstraint?.constant = distanceY
        }
        cropPointRightTop.x = point.x
        cropPointLeftBottom.y = bottomConstraint!.constant
    }
}


