//
//  ExportVideoViewController.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 16/02/2021.
//

import UIKit
import AVFoundation

class ExportVideoViewController: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var playerLayer: AVPlayerLayer!
    
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url2 = url else {return}
        player = AVPlayer(url: url2)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        videoView.layer.addSublayer(playerLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoView.bounds
    }
    
    @IBAction func backPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playVideoPressed(_ sender: UIButton) {
        sender.isHidden = true
        player.play()
    }
    
}
