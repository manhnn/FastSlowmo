//
//  CropView.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 13/02/2021.
//

import UIKit

protocol cropViewDelegate: class {
    func cropViewDidTapCancel(_ view: CropView)
    func cropViewDidTapAccepted(_ view: CropView)
}

class CropView: UIView {
    
    
    weak var delegate: cropViewDelegate?

    @IBAction func cancelPressed(_ sender: Any) {
        delegate?.cropViewDidTapCancel(self)
    }
    
    @IBAction func acceptedPressed(_ sender: Any) {
        delegate?.cropViewDidTapAccepted(self)
    }
}
