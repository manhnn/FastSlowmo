//
//  MusicView.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 12/02/2021.
//

import UIKit

protocol MusicViewDelegate: class {
    func musicViewDidTapDelete(_ view: MusicView)
    func musicViewDidTapVolumeAudio(_ view: MusicView)
    func musicViewDidTapChangeMusic(_ view: MusicView)
}

class MusicView: UIView {

    @IBOutlet weak var changeSlider: UISlider!
    @IBOutlet weak var volumeAudioButton: UIButton!
    
    weak var delegate: MusicViewDelegate?
    var playerVolume : Float = 1
    
    @IBAction func deletePressed(_ sender: Any) {
        delegate?.musicViewDidTapDelete(self)
    }
    
    @IBAction func changeMusicPressed(_ sender: Any) {
        delegate?.musicViewDidTapChangeMusic(self)
    }
    
    @IBAction func volumeAudioPressed(_ sender: UIButton) {
        changeSlider.isHidden = !changeSlider.isHidden
    }
    
    @IBAction func changeValueSlider(_ sender: UISlider) {
        playerVolume = sender.value
        volumeAudioButton.setTitle("\(Int(playerVolume * 100))", for: .normal)
        delegate?.musicViewDidTapVolumeAudio(self)
    }
}
