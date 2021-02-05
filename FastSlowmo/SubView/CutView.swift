//
//  CutVideo.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 05/02/2021.
//

import UIKit

protocol CutVideoDelegate: class {
    func cutVideoDidCancelPressed(_ view: CutView)
    func cutVideoDidAceptedPressed(_ view: CutView)
    func cutVideoDidTrimPressed(_ view: CutView)
    func cutVideoDidCutOutPressed(_ view: CutView)
}

class CutView: UIView {
    @IBOutlet weak var trimButton: UIButton!
    @IBOutlet weak var cutoutButton: UIButton!
    
    weak var delegate: CutVideoDelegate?

    @IBAction func cancelPressed(_ sender: Any) {
        trimButton.setTitleColor(.darkGray, for: .normal)
        cutoutButton.setTitleColor(.darkGray, for: .normal)
        delegate?.cutVideoDidCancelPressed(self)
    }
    
    @IBAction func AceptedPressed(_ sender: Any) {
        trimButton.setTitleColor(.darkGray, for: .normal)
        cutoutButton.setTitleColor(.darkGray, for: .normal)
        delegate?.cutVideoDidAceptedPressed(self)
    }
    
    @IBAction func trimPressed(_ sender: Any) {
        trimButton.setTitleColor(.white, for: .normal)
        cutoutButton.setTitleColor(.darkGray, for: .normal)
        delegate?.cutVideoDidTrimPressed(self)
    }
    
    @IBAction func cutoutPressed(_ sender: Any) {
        trimButton.setTitleColor(.darkGray, for: .normal)
        cutoutButton.setTitleColor(.white, for: .normal)
        delegate?.cutVideoDidCutOutPressed(self)
    }
}
