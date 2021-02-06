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
    @IBOutlet weak var imageView: UIView!
    
    
    // MARK: - Property
    var trimVideoView: ThumbnailTrimView!
    var cutoutVideoView: ThumbnailCutOutView!
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
    
    func getThumbnailImageFromVideoUrl(mutableComposition: AVMutableComposition, completion: @escaping ((_ imageView: UIView?)->Void)) {
        DispatchQueue.global().async { [self] in //1
            let avAssetImageGenerator = AVAssetImageGenerator(asset: mutableComposition) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 15, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbview = UIView(frame: CGRect(x: imageView.frame.width / 2, y: imageView.frame.height / 2, width: imageView.frame.width / 2, height: imageView.frame.height / 2))
                thumbview.backgroundColor = UIColor(patternImage: UIImage(cgImage: cgThumbImage))
                imageView.addSubview(thumbview)
                DispatchQueue.main.async { //8
                    completion(imageView) //9
                }
            }
            catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
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
        cutViewXib.isHidden = false
        UIView.animate(withDuration: 0.75, animations: {
            self.constraintBottomFunctionView.constant = self.functionView.frame.height * 2
            self.view.layoutIfNeeded()
        })
    }
   
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

// MARK: - Extension CutVideoDelegate
extension HomeViewController: CutVideoDelegate {
    func cutVideoDidCancelPressed(_ view: CutView) {
        cutViewXib.isHidden = true
        navigationView.isHidden = false
        if isSelectTypeOfCutVideo == CutType.trimVideo.rawValue {
            trimVideoView.isHidden = true
        }
        else if isSelectTypeOfCutVideo == CutType.cutoutVideo.rawValue {
            cutoutVideoView.isHidden = true
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
            trimVideoView.isHidden = true
        }
        else if isSelectTypeOfCutVideo == CutType.cutoutVideo.rawValue {
            cutoutVideoView.isHidden = true
        }
        UIView.animate(withDuration: 0.75, animations: {
            self.constraintBottomFunctionView.constant = 0
            self.view.layoutIfNeeded()
        })
        
        if mutableComposition.duration.seconds == 0 {
            originAssetVideo.tracks.forEach { track in
                let trackComposition = self.mutableComposition.addMutableTrack(withMediaType: track.mediaType, preferredTrackID: track.trackID)
                try? trackComposition?.insertTimeRange(CMTimeRange(start: .zero, duration: originAssetVideo.duration), of: track, at: .zero)
            }
        }
        
        if isSelectTypeOfCutVideo == CutType.trimVideo.rawValue {
            let startTime = CGFloat(trimVideoView.leftStartTime)
            let endTime = CGFloat(trimVideoView.rightEndTime)
            let duration = CGFloat((player.currentItem?.duration.seconds)!) * 1000
            
            let cmd = TrimVideo(timeRange: CMTimeRange(start: CMTime(value: CMTimeValue(startTime * duration), timescale: 1000), end: CMTime(value: CMTimeValue(endTime * duration), timescale: 1000)))
            let editor = VideoEditor()
            editor.pushCommand(task: cmd)
            mutableComposition = editor.executeTask(mutableComposition: mutableComposition)
        }
        else if isSelectTypeOfCutVideo == CutType.cutoutVideo.rawValue {
            let startTime = CGFloat(cutoutVideoView.leftStartTime)
            let endTime = CGFloat(cutoutVideoView.rightEndTime)
            let duration = CGFloat((player.currentItem?.duration.seconds)!) * 1000
            
            let cmd = CutOutVideo(timeRange: CMTimeRange(start: CMTime(value: CMTimeValue(startTime * duration), timescale: 1000), end: CMTime(value: CMTimeValue(endTime * duration), timescale: 1000)))
            let editor = VideoEditor()
            editor.pushCommand(task: cmd)
            mutableComposition = editor.executeTask(mutableComposition: mutableComposition)
        }
        
        playerItem = AVPlayerItem(asset: mutableComposition)
        playerItem.audioTimePitchAlgorithm = .varispeed
        player.replaceCurrentItem(with: playerItem)
        
        timeLabel.text = "00:00/\(getTimeString(from: playerItem.duration))"
    }
    
    func cutVideoDidTrimPressed(_ view: CutView) {
        isSelectTypeOfCutVideo = CutType.trimVideo.rawValue
        
        // Add Thumbnail Trim View
        trimVideoView = ThumbnailTrimView(frame: CGRect(x: 40, y: 10, width: self.view.frame.width - 80, height: 52), fileImage: getThumbnailFrom(path: URL(fileURLWithPath: Bundle.main.path(forResource: "VideoExample1", ofType: "mp4")!))!)
        trimVideoView.backgroundColor = .clear
        trimVideoView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(trimVideoView)

        trimVideoView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        trimVideoView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        trimVideoView.bottomAnchor.constraint(equalTo: self.cutViewXib.topAnchor, constant: -102).isActive = true
        trimVideoView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        self.getThumbnailImageFromVideoUrl(mutableComposition: mutableComposition) { (thumbImage) in
            self.imageView = thumbImage
        }
    }
    
    func cutVideoDidCutOutPressed(_ view: CutView) {
        isSelectTypeOfCutVideo = CutType.cutoutVideo.rawValue
        
        // Add Thumbnail CutOut View
        cutoutVideoView = ThumbnailCutOutView(frame: CGRect(x: 40, y: 10, width: self.view.frame.width - 80, height: 52), fileImage: getThumbnailFrom(path: URL(fileURLWithPath: Bundle.main.path(forResource: "VideoExample1", ofType: "mp4")!))!)
        cutoutVideoView.backgroundColor = .clear
        cutoutVideoView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cutoutVideoView)

        cutoutVideoView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        cutoutVideoView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        cutoutVideoView.bottomAnchor.constraint(equalTo: self.cutViewXib.topAnchor, constant: -102).isActive = true
        cutoutVideoView.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
}
