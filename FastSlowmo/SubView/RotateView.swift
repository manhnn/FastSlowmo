//
//  RotateView.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 08/02/2021.
//

import UIKit

protocol RotateViewDelegate {
    func rotateViewDidTapRotateLeft(_ view: RotateView)
    func rotateViewDidTapRotateRight(_ view: RotateView)
    func rotateViewDidTapFlipHorizontally(_ view: RotateView)
    func rotateViewDidTapFlipVertically(_ view: RotateView)
    func rotateViewDidTapCancelPressed(_ view: RotateView)
    func rotateViewDidTapAceptedPressed(_ view: RotateView)
}

class RotateView: UIView {

    var delegate: RotateViewDelegate?
    var countClickRotate: Int = 0
    
    @IBAction func rotateLeft(_ sender: Any) {
        countClickRotate += 1
        delegate?.rotateViewDidTapRotateLeft(self)
    }
    
    @IBAction func rotateRight(_ sender: Any) {
        countClickRotate += 1
        delegate?.rotateViewDidTapRotateRight(self)
    }
    
    @IBAction func flipHorizontally(_ sender: Any) {
        delegate?.rotateViewDidTapFlipHorizontally(self)
    }
    
    @IBAction func flipVertically(_ sender: Any) {
        delegate?.rotateViewDidTapFlipVertically(self)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        delegate?.rotateViewDidTapCancelPressed(self)
        countClickRotate = 0
    }
    
    @IBAction func aceptedPressed(_ sender: Any) {
        delegate?.rotateViewDidTapAceptedPressed(self)
        countClickRotate = 0
    }
}
