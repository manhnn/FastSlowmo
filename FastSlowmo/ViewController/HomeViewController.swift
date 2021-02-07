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
    @IBOutlet weak var cutViewXib: UIView!
    
    
    // MARK: - Property
    var speedViewXib: SpeedView!
    
    var trimTimeLineView: TimeLineTrimView!
    var cutoutTimeLineView: TimeLineCutOutView!
    var speedTimeLineView: TimeLineSpeedView!
    var originAssetVideo: AVAsset!
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var playerLayer: AVPlayerLayer!
    var mutableComposition: AVMutableComposition!
    
    var isPlayingVideo = false
    var isSelectTypeOfCutVideo = CutType.empty.rawValue
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVideoBeforePlay()
        updateTimeForSeconds()
        setupMutableCompositionBeforeEdit()
        showSubCutViewXib()
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
    
    func setupMutableCompositionBeforeEdit() {
        if mutableComposition.duration.seconds == 0 {
            originAssetVideo.tracks.forEach { track in
                let trackComposition = self.mutableComposition.addMutableTrack(withMediaType: track.mediaType, preferredTrackID: track.trackID)
                try? trackComposition?.insertTimeRange(CMTimeRange(start: .zero, duration: originAssetVideo.duration), of: track, at: .zero)
            }
        }
    }
    
    func showSubCutViewXib() {
        let nib = UINib(nibName: "CutView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! CutView
        view.frame = cutViewXib.bounds
        cutViewXib.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: cutViewXib.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: cutViewXib.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: cutViewXib.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: cutViewXib.trailingAnchor).isActive = true
        view.delegate = self
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
    
    func getThumbnailFromComposition(mutableComposition: AVMutableComposition) -> Array<UIImage> {
        var images: Array<UIImage> = []
        let generator = AVAssetImageGenerator(asset: mutableComposition)
        for index in 0 ..< Int(mutableComposition.duration.seconds / 30) {
            let cgimage = try? generator.copyCGImage(at: CMTime(seconds: Double(index * 30), preferredTimescale: 600), actualTime: nil)
            images.append(UIImage(cgImage: cgimage!))
        }
        return images
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
        cutViewXib.isHidden = false
        UIView.animate(withDuration: 0.75, animations: {
            self.constraintBottomFunctionView.constant = self.functionView.frame.height * 2
            self.view.layoutIfNeeded()
        })
    }
   
    // MARK: - Speed Video
    @IBAction func speedVideoPressed(_ sender: Any) {
        navigationView.isHidden = true
        UIView.animate(withDuration: 0.75, animations: {
            self.constraintBottomFunctionView.constant = self.functionView.frame.height * 2
            self.view.layoutIfNeeded()
        })
        
        let nib = UINib(nibName: "SpeedView", bundle: nil)
        speedViewXib = nib.instantiate(withOwner: self, options: nil)[0] as? SpeedView
        speedViewXib.frame = self.view.frame
        self.view.addSubview(speedViewXib)
        speedViewXib.translatesAutoresizingMaskIntoConstraints = false
        speedViewXib.heightAnchor.constraint(equalToConstant: 150).isActive = true
        speedViewXib.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        speedViewXib.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        speedViewXib.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        speedViewXib.delegate = self
        
        // Add Timeline CutOut View Because it same to Speed Change
        speedTimeLineView = TimeLineSpeedView(frame: CGRect(x: 40, y: 10, width: self.view.frame.width - 80, height: 52), images: getThumbnailFromComposition(mutableComposition: mutableComposition))
        speedTimeLineView.backgroundColor = .clear
        speedTimeLineView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(speedTimeLineView)

        speedTimeLineView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        speedTimeLineView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        speedTimeLineView.bottomAnchor.constraint(equalTo: self.speedViewXib.topAnchor, constant: -102).isActive = true
        speedTimeLineView.heightAnchor.constraint(equalToConstant: 52).isActive = true
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

// MARK: - Extension CutVideoDelegate
extension HomeViewController: CutVideoDelegate {
    func cutVideoDidCancelPressed(_ view: CutView) {
        cutViewXib.isHidden = true
        navigationView.isHidden = false
        if isSelectTypeOfCutVideo == CutType.trimVideo.rawValue {
            trimTimeLineView.isHidden = true
        }
        else if isSelectTypeOfCutVideo == CutType.cutoutVideo.rawValue {
            cutoutTimeLineView.isHidden = true
        }
        UIView.animate(withDuration: 0.75, animations: {
            self.constraintBottomFunctionView.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    func cutVideoDidAceptedPressed(_ view: CutView) {
        cutViewXib.isHidden = true
        navigationView.isHidden = false
        if isSelectTypeOfCutVideo == CutType.trimVideo.rawValue {
            trimTimeLineView.isHidden = true
        }
        else if isSelectTypeOfCutVideo == CutType.cutoutVideo.rawValue {
            cutoutTimeLineView.isHidden = true
        }
        UIView.animate(withDuration: 0.75, animations: {
            self.constraintBottomFunctionView.constant = 0
            self.view.layoutIfNeeded()
        })
        
        if isSelectTypeOfCutVideo == CutType.trimVideo.rawValue {
            let startTime = CGFloat(trimTimeLineView.leftStartTime)
            let endTime = CGFloat(trimTimeLineView.rightEndTime)
            let duration = CGFloat((player.currentItem?.duration.seconds)!) * 1000
            
            let cmd = TrimVideo(timeRange: CMTimeRange(start: CMTime(value: CMTimeValue(startTime * duration), timescale: 1000), end: CMTime(value: CMTimeValue(endTime * duration), timescale: 1000)))
            let editor = VideoEditor()
            editor.pushCommand(task: cmd)
            mutableComposition = editor.executeTask(mutableComposition: mutableComposition)
        }
        else if isSelectTypeOfCutVideo == CutType.cutoutVideo.rawValue {
            let startTime = CGFloat(cutoutTimeLineView.leftStartTime)
            let endTime = CGFloat(cutoutTimeLineView.rightEndTime)
            let duration = CGFloat((player.currentItem?.duration.seconds)!) * 1000
            
            let cmd = CutOutVideo(timeRange: CMTimeRange(start: CMTime(value: CMTimeValue(startTime * duration), timescale: 1000), end: CMTime(value: CMTimeValue(endTime * duration), timescale: 1000)))
            let editor = VideoEditor()
            editor.pushCommand(task: cmd)
            mutableComposition = editor.executeTask(mutableComposition: mutableComposition)
        }
        
        playerItem = AVPlayerItem(asset: mutableComposition)
        playerItem.audioTimePitchAlgorithm = .spectral
        player.replaceCurrentItem(with: playerItem)
        
        timeLabel.text = "00:00/\(getTimeString(from: playerItem.duration))"
    }
    
    func cutVideoDidTrimPressed(_ view: CutView) {
        if isSelectTypeOfCutVideo == CutType.trimVideo.rawValue {
            trimTimeLineView.isHidden = true
        }
        else if isSelectTypeOfCutVideo == CutType.cutoutVideo.rawValue {
            cutoutTimeLineView.isHidden = true
        }
        isSelectTypeOfCutVideo = CutType.trimVideo.rawValue
        
        // Add Thumbnail Trim View
        trimTimeLineView = TimeLineTrimView(frame: CGRect(x: 40, y: 10, width: self.view.frame.width - 80, height: 52), images: getThumbnailFromComposition(mutableComposition: mutableComposition))
        trimTimeLineView.backgroundColor = .clear
        trimTimeLineView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(trimTimeLineView)

        trimTimeLineView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        trimTimeLineView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        trimTimeLineView.bottomAnchor.constraint(equalTo: self.cutViewXib.topAnchor, constant: -102).isActive = true
        trimTimeLineView.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    func cutVideoDidCutOutPressed(_ view: CutView) {
        if isSelectTypeOfCutVideo == CutType.trimVideo.rawValue {
            trimTimeLineView.isHidden = true
        }
        else if isSelectTypeOfCutVideo == CutType.cutoutVideo.rawValue {
            cutoutTimeLineView.isHidden = true
        }
        isSelectTypeOfCutVideo = CutType.cutoutVideo.rawValue
        
        // Add Thumbnail CutOut View
        cutoutTimeLineView = TimeLineCutOutView(frame: CGRect(x: 40, y: 10, width: self.view.frame.width - 80, height: 52), images: getThumbnailFromComposition(mutableComposition: mutableComposition))
        cutoutTimeLineView.backgroundColor = .clear
        cutoutTimeLineView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cutoutTimeLineView)

        cutoutTimeLineView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        cutoutTimeLineView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        cutoutTimeLineView.bottomAnchor.constraint(equalTo: self.cutViewXib.topAnchor, constant: -102).isActive = true
        cutoutTimeLineView.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
}

// MARK: - Extension SpeedVideoDelegate
extension HomeViewController: SpeedViewDelegate {
    func speedViewDidTapCloseButton(_ view: SpeedView) {
        speedViewXib.isHidden = true
        navigationView.isHidden = false
        speedTimeLineView.isHidden = true
        UIView.animate(withDuration: 0.75, animations: {
            self.constraintBottomFunctionView.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    func speedViewDidTapAddButton(_ view: SpeedView, rate: Double) {
        speedViewXib.isHidden = true
        navigationView.isHidden = false
        speedTimeLineView.isHidden = true
        UIView.animate(withDuration: 0.75, animations: {
            self.constraintBottomFunctionView.constant = 0
            self.view.layoutIfNeeded()
        })
        
        let startTime = CGFloat(speedTimeLineView.leftStartTime)
        let endTime = CGFloat(speedTimeLineView.rightEndTime)
        let duration = CGFloat((player.currentItem?.duration.seconds)!) * 1000
        let timeRange = CMTimeRange(start: CMTime(value: CMTimeValue(startTime * duration), timescale: 1000), end: CMTime(value: CMTimeValue(endTime * duration), timescale: 1000))
        
        let cmd = SpeedVideo(rate: rate, timeRange: timeRange)
        let editor = VideoEditor()
        editor.pushCommand(task: cmd)
        mutableComposition = editor.executeTask(mutableComposition: mutableComposition)
        
        playerItem = AVPlayerItem(asset: mutableComposition)
        playerItem.audioTimePitchAlgorithm = .spectral
        player.replaceCurrentItem(with: playerItem)
    }
    
    func speedViewDidTapRemoveButton(_ view: SpeedView) {
        speedTimeLineView.resetLeftRightPanGesture()
    }
}
