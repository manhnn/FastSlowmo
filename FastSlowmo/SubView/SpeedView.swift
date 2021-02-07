//
//  SpeedView.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 07/02/2021.
//

import UIKit

protocol SpeedViewDelegate {
    func speedViewDidTapCloseButton(_ view: SpeedView)
    func speedViewDidTapAddButton(_ view: SpeedView)
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
    
    var delegate: SpeedViewDelegate?
    
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
    }
    
    @IBAction func speed05X(_ sender: UIButton) {
        setupColorSpeedButton()
        sender.backgroundColor = .systemPink
    }
    
    @IBAction func speed075X(_ sender: UIButton) {
        setupColorSpeedButton()
        sender.backgroundColor = .systemPink
    }
    
    @IBAction func speed1X(_ sender: UIButton) {
        setupColorSpeedButton()
        sender.backgroundColor = .systemPink
    }
    
    @IBAction func speed2X(_ sender: UIButton) {
        setupColorSpeedButton()
        sender.backgroundColor = .systemPink
    }
    
    @IBAction func speed3X(_ sender: UIButton) {
        setupColorSpeedButton()
        sender.backgroundColor = .systemPink
    }
    
    @IBAction func speed4X(_ sender: UIButton) {
        setupColorSpeedButton()
        sender.backgroundColor = .systemPink
    }
    
    @IBAction func closeSpeed(_ sender: UIButton) {
        setupColorSpeedButton()
        delegate?.speedViewDidTapCloseButton(self)
    }
    
    @IBAction func removeSpeed(_ sender: UIButton) {
        setupColorSpeedButton()
        delegate?.speedViewDidTapRemoveButton(self)
    }
    
    @IBAction func addPressed(_ sender: Any) {
        delegate?.speedViewDidTapAddButton(self)
    }
}
