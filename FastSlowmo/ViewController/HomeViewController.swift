//
//  HomeViewController.swift
//  FastSlowmo
//
//  Created by Manh Nguyen Ngoc on 04/02/2021.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {

    // MARK: - UI
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var soundSlider: UISlider!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var constraintBottomFunctionView: NSLayoutConstraint!
    @IBOutlet weak var functionView: UIView!
    @IBOutlet weak var cutView: UIView!
    
    @IBOutlet weak var trimButton: UIButton!
    @IBOutlet weak var cutoutButton: UIButton!
    
    
    // MARK: - Property
    var cutVideoView: ThumbnailCutVideoView!
    var originAssetVideo: AVAsset!
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var playerLayer: AVPlayerLayer!
    var mutableComposition: AVMutableComposition!
    
    var isPlayingVideo = false
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVideoBeforePlay()
        updateTimeForSeconds()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoView.bounds
    }
    
    func setupVideoBeforePlay() {
        mutableComposition = AVMutableComposition()
        originAssetVideo = AVAsset(url: URL(fileURLWithPath: Bundle.main.path(forResource: "VideoExample1", ofType: "mp4")!))
        player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "VideoExample1", ofType: "mp4")!))
        playerItem = player.currentItem
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        videoView.layer.addSublayer(playerLayer)
        
        timeLabel.text = "00:00/\(getTimeString(from: originAssetVideo.duration))"
    }
    
    func updateTimeForSeconds() {
        // moi 0.45s thi update lai frame quan sat thoi gian 1 lan
        let interval = CMTime(seconds: 0.45, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        _ = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] time in
            guard let currentItem = self!.player.currentItem else { return }
            self?.soundSlider.value = Float(self!.player.volume)
            self!.timeLabel.text = "\(self!.getTimeString(from: currentItem.currentTime()))/\(self!.getTimeString(from: self!.player.currentItem!.duration))"
        })
    }
    
    func getTimeString(from time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let hour = Int(totalSeconds / 3600)
        let minutes = Int(totalSeconds / 60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60.0))
        if hour > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hour, minutes, seconds])
        }
        return String(format: "%02i:%02i", arguments: [minutes, seconds])
    }
    
    func getThumbnailFrom(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 2, timescale: 10), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)

            return thumbnail
        }
        catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Video Player Controller
    @IBAction func playVideoPressed(_ sender: UIButton) {
        isPlayingVideo = !isPlayingVideo
        if isPlayingVideo {
            player.play()
            sender.setBackgroundImage(UIImage(named: "play"), for: .normal)
        }
        else {
            player.pause()
            sender.setBackgroundImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
    
    // MARK: - Cut Video
    @IBAction func cutVideoPressed(_ sender: Any) {
        navigationView.isHidden = true
        cutView.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
            self.constraintBottomFunctionView.constant = self.functionView.frame.height * 2
            self.view.layoutIfNeeded()
        })
        
        // Add Thumbnail Cut Audio View
        cutVideoView = ThumbnailCutVideoView(frame: CGRect(x: 40, y: 10, width: self.view.frame.width - 80, height: 42), fileImage: getThumbnailFrom(path: URL(fileURLWithPath: Bundle.main.path(forResource: "VideoExample1", ofType: "mp4")!))!)
        cutVideoView.backgroundColor = .clear
        cutVideoView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cutVideoView)

        cutVideoView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        cutVideoView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        cutVideoView.bottomAnchor.constraint(equalTo: self.cutView.topAnchor, constant: -102).isActive = true
        cutVideoView.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
    }
    
    @IBAction func aceptedPressed(_ sender: Any) {
        originAssetVideo.tracks.forEach { track in
            let trackComposition = self.mutableComposition.addMutableTrack(withMediaType: track.mediaType, preferredTrackID: track.trackID)
            try? trackComposition?.insertTimeRange(CMTimeRange(start: .zero, duration: originAssetVideo.duration), of: track, at: .zero)
        }
        
        let cmd = TrimVideo(timeRange: CMTimeRange(start: CMTime(value: 5, timescale: 1), end: CMTime(value: 20, timescale: 1)))
        let editor = VideoEditor()
        editor.pushCommand(task: cmd)
        mutableComposition = editor.executeTask(mutableComposition: mutableComposition)
        
        playerItem = AVPlayerItem(asset: mutableComposition)
        playerItem.audioTimePitchAlgorithm = .varispeed
        player.replaceCurrentItem(with: playerItem)
        
        timeLabel.text = "00:00/\(getTimeString(from: playerItem.duration))"
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        cutView.isHidden = true
        navigationView.isHidden = false
        cutVideoView.isHidden = true
        UIView.animate(withDuration: 0.4, animations: {
            self.constraintBottomFunctionView.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func trimPressed(_ sender: Any) {
        trimButton.setTitleColor(.white, for: .normal)
        cutoutButton.setTitleColor(.darkGray, for: .normal)
    }
    
    @IBAction func cutoutPressed(_ sender: Any) {
        trimButton.setTitleColor(.darkGray, for: .normal)
        cutoutButton.setTitleColor(.white, for: .normal)
    }
    
// ===========================================================================================================
    
    // MARK: - Speed Video
    @IBAction func speedVideoPressed(_ sender: Any) {
        
    }
    
    // MARK: - Sound Video
    @IBAction func soundVideoPressed(_ sender: Any) {
        soundSlider.isHidden = !soundSlider.isHidden
    }
    
    @IBAction func soundSliderChangeValue(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    // MARK: - Music Video
    @IBAction func musicVideoPressed(_ sender: Any) {
        
    }
    
    // MARK: - EffectVideo
    @IBAction func effectVideoPressed(_ sender: Any) {
        
    }
}
