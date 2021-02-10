//
//  EffectView.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 10/02/2021.
//

import UIKit

protocol EffectViewDelegate {
    func effectViewDidTapOriginal(_ view: EffectView)
    func effectViewDidTapHue1(_ view: EffectView)
    func effectViewDidTapHue2(_ view: EffectView)
    func effectViewDidTapHue3(_ view: EffectView)
    func effectViewDidTapHue4(_ view: EffectView)
    func effectViewDidTapCancel(_ view: EffectView)
    func effectViewDidTapAccepted(_ view: EffectView)
}

class EffectView: UIView {
    
    @IBOutlet weak var original: UILabel!
    @IBOutlet weak var hue1: UILabel!
    @IBOutlet weak var hue2: UILabel!
    @IBOutlet weak var hue3: UILabel!
    @IBOutlet weak var hue4: UILabel!
    
    var delegate: EffectViewDelegate?
    
    func changeColorImage() {
        original.backgroundColor = .clear
        hue1.backgroundColor = .clear
        hue2.backgroundColor = .clear
        hue3.backgroundColor = .clear
        hue4.backgroundColor = .clear
    }

    @IBAction func originalPressed(_ sender: UIButton) {
        changeColorImage()
        original.backgroundColor = .systemPink
        delegate?.effectViewDidTapOriginal(self)
    }
    
    @IBAction func hue1Pressed(_ sender: UIButton) {
        changeColorImage()
        hue1.backgroundColor = .systemPink
        delegate?.effectViewDidTapHue1(self)
    }
    
    @IBAction func hue2Pressed(_ sender: UIButton) {
        changeColorImage()
        hue2.backgroundColor = .systemPink
        delegate?.effectViewDidTapHue2(self)
    }
    
    @IBAction func hue3Pressed(_ sender: UIButton) {
        changeColorImage()
        hue3.backgroundColor = .systemPink
        delegate?.effectViewDidTapHue3(self)
    }
    
    @IBAction func hue4Pressed(_ sender: UIButton) {
        changeColorImage()
        hue4.backgroundColor = .systemPink
        delegate?.effectViewDidTapHue4(self)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        delegate?.effectViewDidTapCancel(self)
    }
    
    @IBAction func acceptedPressed(_ sender: UIButton) {
        delegate?.effectViewDidTapAccepted(self)
    }
}