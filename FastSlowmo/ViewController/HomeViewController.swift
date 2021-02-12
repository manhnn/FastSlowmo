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
    
    
    // MARK: - Property
    var cutViewXib: CutView!
    var speedViewXib: SpeedView!
    var rotateViewXib: RotateView!
    var effectViewXib: EffectView!
    var musicViewXib: MusicView!
    
    var trimTimeLineView: TimeLineTrimView!
    var cutoutTimeLineView: TimeLineCutOutView!
    var speedTimeLineView: TimeLineSpeedView!
    var originAssetVideo: AVAsset!
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var playerLayer: AVPlayerLayer!
    var mutableComposition: AVMutableComposition!
    var videoComposition: AVMutableVideoComposition!
    var headAllComposition: AllComposition!
    var nowAllComposition: AllComposition!
    
    var isPlayingVideo = false
    var isSelectTypeOfCutVideo = CutType.empty.rawValue
    var rotationDirectionIndex: Int = 0
    var isFlipHorizontally = false
    var isFlipVertically = false
    
    let editor = VideoEditor()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVideoBeforePlay()
        updateTimeForSeconds()
        setupAllCompositionBeforeEdit()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoView.bounds
    }
    
    func setupVideoBeforePlay() {
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
    
    func setupAllCompositionBeforeEdit() {
        let cmd = EffectAndRotateVideo(originAssetVideo: originAssetVideo, rotateType: rotationDirectionIndex, hueType: effectViewXib != nil ? effectViewXib.hueType : 0)
        editor.pushCommand(task: cmd)
        
        let mutableComposition1 = AVMutableComposition()
        let videoComposition1 = AVMutableVideoComposition()
        mutableComposition = AVMutableComposition()
        videoComposition = AVMutableVideoComposition()
        headAllComposition = AllComposition(mutableComposition: mutableComposition1, videoComposition: videoComposition1)
        nowAllComposition = AllComposition(mutableComposition: mutableComposition, videoComposition: videoComposition)
        
        if nowAllComposition.mutableComposition.duration.seconds == 0 {
            originAssetVideo.tracks.forEach { track in
                let trackComposition = self.nowAllComposition.mutableComposition.addMutableTrack(withMediaType: track.mediaType, preferredTrackID: track.trackID)
                try? trackComposition?.insertTimeRange(CMTimeRange(start: .zero, duration: originAssetVideo.duration), of: track, at: .zero)
            }
        }
        if headAllComposition.mutableComposition.duration.seconds == 0 {
            originAssetVideo.tracks.forEach { track in
                let trackComposition = self.headAllComposition.mutableComposition.addMutableTrack(withMediaType: track.mediaType, preferredTrackID: track.trackID)
                try? trackComposition?.insertTimeRange(CMTimeRange(start: .zero, duration: originAssetVideo.duration), of: track, at: .zero)
            }
        }
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
        for index in 0 ..< Int(mutableComposition.duration.seconds / 15) {
            let cgimage = try? generator.copyCGImage(at: CMTime(seconds: Double(index * 15), preferredTimescale: 1000), actualTime: nil)
            images.append(UIImage(cgImage: cgimage!))
        }
        return images
    }
    
    func updateConstraintOfFunctionViewUpDown(constant: CGFloat) {
        UIView.animate(withDuration: 0.75, animations: {
            self.constraintBottomFunctionView.constant = constant
            self.view.layoutIfNeeded()
        })
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
        updateConstraintOfFunctionViewUpDown(constant: self.functionView.frame.height * 2)
        
        let nib = UINib(nibName: "CutView", bundle: nil)
        cutViewXib = nib.instantiate(withOwner: self, options: nil)[0] as? CutView
        cutViewXib.frame = self.view.frame
        self.view.addSubview(cutViewXib)
        cutViewXib.translatesAutoresizingMaskIntoConstraints = false
        cutViewXib.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cutViewXib.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        cutViewXib.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        cutViewXib.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        cutViewXib.delegate = self
    }
   
    // MARK: - Speed Video
    @IBAction func speedVideoPressed(_ sender: Any) {
        navigationView.isHidden = true
        updateConstraintOfFunctionViewUpDown(constant: self.functionView.frame.height * 2)
        
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
        speedTimeLineView = TimeLineSpeedView(frame: CGRect(x: 40, y: 10, width: self.view.frame.width - 80, height: 52), images: getThumbnailFromComposition(mutableComposition: nowAllComposition.mutableComposition))
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
        navigationView.isHidden = !navigationView.isHidden
    }
    
    @IBAction func soundSliderChangeValue(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    // MARK: - Music Video
    @IBAction func musicVideoPressed(_ sender: Any) {
        navigationView.isHidden = true
        updateConstraintOfFunctionViewUpDown(constant: self.functionView.frame.height * 2)
        
        let nib = UINib(nibName: "MusicView", bundle: nil)
        musicViewXib = nib.instantiate(withOwner: self, options: nil)[0] as? MusicView
        musicViewXib.frame = self.view.frame
        self.view.addSubview(musicViewXib)
        musicViewXib.translatesAutoresizingMaskIntoConstraints = false
        musicViewXib.heightAnchor.constraint(equalToConstant: 100).isActive = true
        musicViewXib.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        musicViewXib.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        musicViewXib.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        musicViewXib.delegate = self
    }
    
    // MARK: - EffectVideo
    @IBAction func effectVideoPressed(_ sender: Any) {
        navigationView.isHidden = true
        updateConstraintOfFunctionViewUpDown(constant: self.functionView.frame.height * 2)
        
        let nib = UINib(nibName: "EffectView", bundle: nil)
        effectViewXib = nib.instantiate(withOwner: self, options: nil)[0] as? EffectView
        effectViewXib.frame = self.view.frame
        self.view.addSubview(effectViewXib)
        effectViewXib.translatesAutoresizingMaskIntoConstraints = false
        effectViewXib.heightAnchor.constraint(equalToConstant: 250).isActive = true
        effectViewXib.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        effectViewXib.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        effectViewXib.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        effectViewXib.delegate = self
    }
    
    // MARK: - Rotate Video
    @IBAction func rotateVideo(_ sender: Any) {
        navigationView.isHidden = true
        updateConstraintOfFunctionViewUpDown(constant: self.functionView.frame.height * 2)
        
        let nib = UINib(nibName: "RotateView", bundle: nil)
        rotateViewXib = nib.instantiate(withOwner: self, options: nil)[0] as? RotateView
        rotateViewXib.frame = self.view.frame
        self.view.addSubview(rotateViewXib)
        rotateViewXib.translatesAutoresizingMaskIntoConstraints = false
        rotateViewXib.heightAnchor.constraint(equalToConstant: 150).isActive = true
        rotateViewXib.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        rotateViewXib.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        rotateViewXib.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        rotateViewXib.delegate = self
    }
    
    // MARK: - Crop Video
    @IBAction func cropVideo(_ sender: Any) {
        
    }
}

// MARK: - Extension CutViewDelegate
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
        updateConstraintOfFunctionViewUpDown(constant: 0)
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
        updateConstraintOfFunctionViewUpDown(constant: 0)
        
        if isSelectTypeOfCutVideo == CutType.trimVideo.rawValue {
            let startTime = CGFloat(trimTimeLineView.leftStartTime)
            let endTime = CGFloat(trimTimeLineView.rightEndTime)
            let duration = CGFloat((player.currentItem?.duration.seconds)!) * 1000
            
            let cmd = TrimVideo(timeRange: CMTimeRange(start: CMTime(value: CMTimeValue(startTime * duration), timescale: 1000), end: CMTime(value: CMTimeValue(endTime * duration), timescale: 1000)))
            editor.pushCommand(task: cmd)
            nowAllComposition = editor.executeTask(allComposition: headAllComposition)
        }
        else if isSelectTypeOfCutVideo == CutType.cutoutVideo.rawValue {
            let startTime = CGFloat(cutoutTimeLineView.leftStartTime)
            let endTime = CGFloat(cutoutTimeLineView.rightEndTime)
            let duration = CGFloat((player.currentItem?.duration.seconds)!) * 1000
            
            let cmd = CutOutVideo(timeRange: CMTimeRange(start: CMTime(value: CMTimeValue(startTime * duration), timescale: 1000), end: CMTime(value: CMTimeValue(endTime * duration), timescale: 1000)))
            editor.pushCommand(task: cmd)
            nowAllComposition = editor.executeTask(allComposition: headAllComposition)
        }
        
        playerItem = AVPlayerItem(asset: nowAllComposition.mutableComposition)
        playerItem.videoComposition = nowAllComposition.videoComposition
        playerItem.audioTimePitchAlgorithm = .spectral
        player.replaceCurrentItem(with: playerItem)
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
        trimTimeLineView = TimeLineTrimView(frame: CGRect(x: 40, y: 10, width: self.view.frame.width - 80, height: 52), images: getThumbnailFromComposition(mutableComposition: nowAllComposition.mutableComposition))
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
        cutoutTimeLineView = TimeLineCutOutView(frame: CGRect(x: 40, y: 10, width: self.view.frame.width - 80, height: 52), images: getThumbnailFromComposition(mutableComposition: nowAllComposition.mutableComposition))
        cutoutTimeLineView.backgroundColor = .clear
        cutoutTimeLineView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cutoutTimeLineView)

        cutoutTimeLineView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        cutoutTimeLineView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        cutoutTimeLineView.bottomAnchor.constraint(equalTo: self.cutViewXib.topAnchor, constant: -102).isActive = true
        cutoutTimeLineView.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
}

// MARK: - Extension SpeedViewDelegate
extension HomeViewController: SpeedViewDelegate {
    func speedViewDidTapCloseButton(_ view: SpeedView) {
        speedViewXib.isHidden = true
        navigationView.isHidden = false
        speedTimeLineView.isHidden = true
        updateConstraintOfFunctionViewUpDown(constant: 0)
    }
    
    func speedViewDidTapAddButton(_ view: SpeedView, rate: Double) {
        speedViewXib.isHidden = true
        navigationView.isHidden = false
        speedTimeLineView.isHidden = true
        updateConstraintOfFunctionViewUpDown(constant: 0)
        
        let startTime = CGFloat(speedTimeLineView.leftStartTime)
        let endTime = CGFloat(speedTimeLineView.rightEndTime)
        let duration = CGFloat((player.currentItem?.duration.seconds)!) * 1000
        let timeRange = CMTimeRange(start: CMTime(value: CMTimeValue(startTime * duration), timescale: 1000), end: CMTime(value: CMTimeValue(endTime * duration), timescale: 1000))
        
        let cmd = SpeedVideo(rate: rate, timeRange: timeRange)
        editor.pushCommand(task: cmd)
        nowAllComposition = editor.executeTask(allComposition: headAllComposition)
        
        playerItem = AVPlayerItem(asset: nowAllComposition.mutableComposition)
        playerItem.videoComposition = nowAllComposition.videoComposition
        playerItem.audioTimePitchAlgorithm = .spectral
        player.replaceCurrentItem(with: playerItem)
    }
    
    func speedViewDidTapRemoveButton(_ view: SpeedView) {
        speedTimeLineView.resetLeftRightPanGesture()
    }
}

// MARK: - Extension RotateViewDelegate
extension HomeViewController: RotateViewDelegate {
    
    func rotateViewDidTapRotateLeft(_ view: RotateView) {
        rotationDirectionIndex = (rotationDirectionIndex - 1 <= -4) ? 0 : rotationDirectionIndex - 1
        
        let cmd = EffectAndRotateVideo(originAssetVideo: originAssetVideo, rotateType: rotationDirectionIndex, hueType: effectViewXib != nil ? effectViewXib.hueType : 0)
        editor.pushCommand(task: cmd)
        nowAllComposition = editor.executeTask(allComposition: headAllComposition)
        
        playerItem.videoComposition = nowAllComposition.videoComposition
        playerItem.audioTimePitchAlgorithm = .spectral
        player.replaceCurrentItem(with: playerItem)
    }
    
    func rotateViewDidTapRotateRight(_ view: RotateView) {
        rotationDirectionIndex = (rotationDirectionIndex + 1) % 4
        
        let cmd = EffectAndRotateVideo(originAssetVideo: originAssetVideo, rotateType: rotationDirectionIndex, hueType: effectViewXib != nil ? effectViewXib.hueType : 0)
        editor.pushCommand(task: cmd)
        nowAllComposition = editor.executeTask(allComposition: headAllComposition)
        
        playerItem.videoComposition = nowAllComposition.videoComposition
        playerItem.audioTimePitchAlgorithm = .spectral
        player.replaceCurrentItem(with: playerItem)
    }
    
    func rotateViewDidTapFlipHorizontally(_ view: RotateView) {
        isFlipHorizontally = !isFlipHorizontally
        videoView.layer.transform = CATransform3DRotate(videoView.layer.transform, .pi, 0, 1, 0)
    }
    
    func rotateViewDidTapFlipVertically(_ view: RotateView) {
        isFlipVertically = !isFlipVertically
        videoView.layer.transform = CATransform3DRotate(videoView.layer.transform, .pi, 1, 0, 0)
    }
    
    func rotateViewDidTapCancelPressed(_ view: RotateView) {
        rotateViewXib.isHidden = true
        navigationView.isHidden = false
        rotationDirectionIndex = 0
        updateConstraintOfFunctionViewUpDown(constant: 0)

        editor.undoCommand(countClick: rotateViewXib.countClickRotate)
        if editor.listCommand.count == 0 {
            let cmd = EffectAndRotateVideo(originAssetVideo: originAssetVideo, rotateType: 0, hueType: 0)
            editor.pushCommand(task: cmd)
        }
        nowAllComposition = editor.executeTask(allComposition: headAllComposition)

        playerItem.videoComposition = nowAllComposition.videoComposition
        playerItem.audioTimePitchAlgorithm = .spectral
        player.replaceCurrentItem(with: playerItem)
    }
    
    func rotateViewDidTapAceptedPressed(_ view: RotateView) {
        rotateViewXib.isHidden = true
        navigationView.isHidden = false
        updateConstraintOfFunctionViewUpDown(constant: 0)
    }
}

// MARK: - Extension EffectViewDelegate
extension HomeViewController: EffectViewDelegate {
    fileprivate func setFilterByHue(hueType: Int) {
        let cmd = EffectAndRotateVideo(originAssetVideo: originAssetVideo, rotateType: rotationDirectionIndex, hueType: hueType)
        editor.pushCommand(task: cmd)
        nowAllComposition = editor.executeTask(allComposition: headAllComposition)
        
        playerItem.videoComposition = nowAllComposition.videoComposition
        playerItem.audioTimePitchAlgorithm = .spectral
        player.replaceCurrentItem(with: playerItem)
    }
    
    func effectViewDidTapOriginal(_ view: EffectView) {
        setFilterByHue(hueType: effectViewXib.hueType)
    }
    
    func effectViewDidTapHue1(_ view: EffectView) {
        setFilterByHue(hueType: effectViewXib.hueType)
    }
    
    func effectViewDidTapHue2(_ view: EffectView) {
        setFilterByHue(hueType: effectViewXib.hueType)
    }
    
    func effectViewDidTapHue3(_ view: EffectView) {
        setFilterByHue(hueType: effectViewXib.hueType)
    }
    
    func effectViewDidTapHue4(_ view: EffectView) {
        setFilterByHue(hueType: effectViewXib.hueType)
    }
    
    func effectViewDidTapCancel(_ view: EffectView) {
        effectViewXib.isHidden = true
        navigationView.isHidden = false
        updateConstraintOfFunctionViewUpDown(constant: 0)
        
        editor.undoCommand(countClick: effectViewXib.countClickEffect)
        if editor.listCommand.count == 0 {
            let cmd = EffectAndRotateVideo(originAssetVideo: originAssetVideo, rotateType: 0, hueType: 0)
            editor.pushCommand(task: cmd)
        }
        nowAllComposition = editor.executeTask(allComposition: headAllComposition)

        playerItem.videoComposition = nowAllComposition.videoComposition
        playerItem.audioTimePitchAlgorithm = .spectral
        player.replaceCurrentItem(with: playerItem)
    }
    
    func effectViewDidTapAccepted(_ view: EffectView) {
        effectViewXib.isHidden = true
        navigationView.isHidden = false
        updateConstraintOfFunctionViewUpDown(constant: 0)
    }
}

// MARK: - Extension MusicViewDelegate
extension HomeViewController: MusicViewDelegate {
    func musicViewDidTapDelete(_ view: MusicView) {
        musicViewXib.isHidden = true
        navigationView.isHidden = false
        updateConstraintOfFunctionViewUpDown(constant: 0)
    }
    
    func musicViewDidTapVolumeAudio(_ view: MusicView) {
        player.volume = musicViewXib.playerVolume
    }
    
    func musicViewDidTapChangeMusic(_ view: MusicView) {
        print("load view controller")
    }
}
