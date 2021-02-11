//
//  SpeedView.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 07/02/2021.
//

import UIKit

protocol SpeedViewDelegate: class {
    func speedViewDidTapCloseButton(_ view: SpeedView)
    func speedViewDidTapAddButton(_ view: SpeedView, rate: Double)
    func speedViewDidTapRemoveButton(_ view: SpeedView)
}

class SpeedView: UIView {
    
    @IBOutlet weak var outlet025X: UIButton!
    @IBOutlet weak var outlet05X: UIButton!
    @IBOutlet weak var outlet075X: UIButton!
    @IBOutlet weak var outlet1X: UIButton!
    @IBOutlet weak var outlet2X: UIButton!
    @IBOutlet weak var outlet3X: UIButton!
    @IBOutlet weak var outlet4X: UIButton!
    
    weak var delegate: SpeedViewDelegate?
    var rate: Double = 1
    
    func setupColorSpeedButton() {
        outlet025X.backgroundColor = .darkGray
        outlet05X.backgroundColor = .darkGray
        outlet075X.backgroundColor = .darkGray
        outlet1X.backgroundColor = .darkGray
        outlet2X.backgroundColor = .darkGray
        outlet3X.backgroundColor = .darkGray
        outlet4X.backgroundColor = .darkGray
    }
    
    @IBAction func speed025X(_ sender: UIButton) {
        setupColorSpeedButton()
        sender.backgroundColor = .systemPink
        rate = 0.25
    }
    
    @IBAction func speed05X(_ sender: UIButton) {
        setupColorSpeedButton()
        sender.backgroundColor = .systemPink
        rate = 0.5
    }
    
    @IBAction func speed075X(_ sender: UIButton) {
        setupColorSpeedButton()
        sender.backgroundColor = .systemPink
        rate = 0.75
    }
    
    @IBAction func speed1X(_ sender: UIButton) {
        setupColorSpeedButton()
        sender.backgroundColor = .systemPink
        rate = 1
    }
    
    @IBAction func speed2X(_ sender: UIButton) {
        setupColorSpeedButton()
        sender.backgroundColor = .systemPink
        rate = 2
    }
    
    @IBAction func speed3X(_ sender: UIButton) {
        setupColorSpeedButton()
        sender.backgroundColor = .systemPink
        rate = 3
    }
    
    @IBAction func speed4X(_ sender: UIButton) {
        setupColorSpeedButton()
        sender.backgroundColor = .systemPink
        rate = 4
    }
    
    @IBAction func closeSpeed(_ sender: UIButton) {
        setupColorSpeedButton()
        delegate?.speedViewDidTapCloseButton(self)
    }
    
    @IBAction func removeSpeed(_ sender: UIButton) {
        setupColorSpeedButton()
        delegate?.speedViewDidTapRemoveButton(self)
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        delegate?.speedViewDidTapAddButton(self, rate: rate)
    }
}
