//
//  DPlayerViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/6.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class DPlayerViewController: BaseViewController {

    lazy fileprivate var controlCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        return view
    }()
    
    lazy fileprivate var captionView: UIView = {
        let view = UIView()
//        view.backgroundColor = .white
        return view
    }()
    
    lazy fileprivate var dismissBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "public_dismissBtn")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIConstants.Color.body
        button.addTarget(self, action: #selector(dismissBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var audioSlider: UISlider = {
        let view = UISlider()
        view.minimumTrackTintColor = UIConstants.Color.primaryGreen
        view.maximumTrackTintColor = .clear//UIConstants.Color.primaryRed
        view.setThumbImage(UIImage(named: "course_sliderThumbWhite"), for: .normal)
        view.addTarget(self, action: #selector(sliderTouchBeganAction), for: .touchDown)
        view.addTarget(self, action: #selector(sliderTouchEndedAction), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        return view
    }()
    
    lazy fileprivate var sliderBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIConstants.Color.disable
        view.layer.cornerRadius = 1
        view.isUserInteractionEnabled = false
        return view
    }()

    lazy fileprivate var sliderBufferView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 1
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy fileprivate var audioCurrentTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        label.text = "00:00"
        return label
    }()
    
    lazy fileprivate var audioDurationTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        label.text = "--:--"
        return label
    }()
    
    lazy fileprivate var audioActionBtn: UIButton = {
        let button = UIButton()
        //        button.backgroundColor = UIConstants.Color.primaryGreen
        button.setImage(UIImage(named: "course_videoPlay")?.withRenderingMode(.alwaysOriginal), for: .normal)
        //        button.layer.cornerRadius = 22.5
        button.addTarget(self, action: #selector(audioActionBtnAction), for: .touchUpInside)
        return button
    }()
    
//    lazy fileprivate var audioPreviousBtn: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "course_audioPrevious")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        button.tintColor = .white
//        button.addTarget(self, action: #selector(audioPreviousBtnAction), for: .touchUpInside)
//        return button
//    }()
//
//    lazy fileprivate var audioNextBtn: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "course_audioNext")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        button.tintColor = .white
//        button.addTarget(self, action: #selector(audioNextBtnAction), for: .touchUpInside)
//        return button
//    }()
    
    lazy fileprivate var fullScreenBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "course_videoZoomOut")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(fullScreenBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var avatarImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_avatarPlaceholder")
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 15
        return imgView
    }()
    
    lazy fileprivate var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    lazy fileprivate var courseNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    lazy fileprivate var tagLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    lazy fileprivate var sectionNameLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing
        return label
    }()
    
    lazy fileprivate var isSliderDragging: Bool = false
    
    fileprivate var observer: NSKeyValueObservation?
    
    fileprivate var timeObserverToken: Any?
    
    lazy fileprivate var player: AVPlayer = {
        let player = AVPlayer()
        return player
    }()
    
    lazy fileprivate var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        return playerLayer
    }()
    
    fileprivate var courseModel: CourseModel?
    
    fileprivate var sectionModel: CourseSectionModel?
    
    fileprivate var hideTimer: Timer?
    
    init(course: CourseModel, section: CourseSectionModel) {
        super.init(nibName: nil, bundle: nil)
        
        courseModel = course
        sectionModel = section
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        PlayListService.sharedInstance.pauseAudio()
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
//    override var shouldAutorotate: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.landscape]
//    }
//
//    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//        return .landscapeLeft
//    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        view.layer.addSublayer(playerLayer)
        
        view.addSubviews([captionView, controlCoverView, dismissBtn])
        captionView.addSubviews([avatarImgView, nameLabel, courseNameLabel, tagLabel, sectionNameLabel])
        controlCoverView.addSubviews([audioActionBtn, sliderBgView, sliderBufferView, audioSlider, audioCurrentTimeLabel, audioDurationTimeLabel, fullScreenBtn])
        
        let tapGesture = UITapGestureRecognizer { [weak self] (any) in
//            if let any = any as? UITapGestureRecognizer {
//                let point = any.location(ofTouch: 1, in: self?.view)
//                if self?.playerLayer.contains(point) ?? false {
//                    print("true")
//                }
//            }
            self?.controlCoverView.isHidden = !(self?.controlCoverView.isHidden ?? false)
            
            if self?.controlCoverView.isHidden == false, self?.player.rate != 0 {
                self?.hideTimer = Timer.scheduledTimer(withTimeInterval: 3, block: { [weak self] (timer) in
                    self?.controlCoverView.isHidden = true
                    }, repeats: false)
            } else {
                if let timer = self?.hideTimer {
                    timer.invalidate()
                    self?.hideTimer = nil
                }
            }
        }
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        controlCoverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        captionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        audioSlider.snp.makeConstraints { make in
            make.leading.equalTo(70)
            make.trailing.equalTo(-100)
            make.bottom.equalTo(-20)
        }
        sliderBgView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(audioSlider)
            make.centerY.equalTo(audioSlider).offset(1)
            make.height.equalTo(1.5)
        }
        sliderBufferView.snp.makeConstraints { make in
            make.leading.equalTo(audioSlider)
            make.centerY.equalTo(audioSlider).offset(1)
            make.height.equalTo(1.5)
            make.width.equalTo(0)
        }
        audioCurrentTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.centerY.equalTo(audioSlider)
        }
        audioDurationTimeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing-35)
            make.centerY.equalTo(audioSlider)
        }
        fullScreenBtn.snp.makeConstraints { make in
            make.centerY.equalTo(audioSlider)
            make.trailing.equalToSuperview()
            make.width.equalTo(UIConstants.Margin.trailing*2+15)
            make.height.equalTo(55)
        }
        audioActionBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
//        audioPreviousBtn.snp.makeConstraints { make in
//            make.centerY.equalTo(audioActionBtn)
//            make.trailing.equalTo(audioActionBtn.snp.leading).offset(-25)
//            make.width.equalTo(44)
//            make.height.equalTo(44)
//        }
//        audioNextBtn.snp.makeConstraints { make in
//            make.centerY.equalTo(audioActionBtn)
//            make.leading.equalTo(audioActionBtn.snp.trailing).offset(25)
//            make.width.equalTo(44)
//            make.height.equalTo(44)
//        }
        let size = dismissBtn.currentImage!.size
        dismissBtn.snp.makeConstraints { make in
            make.trailing.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(size.width+UIConstants.Margin.leading*2)
            make.height.equalTo(size.height+UIConstants.Margin.top*2)
        }
        
        avatarImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(UIScreenHeight/2-(9.0/16*UIScreenWidth)/2-20-30)
            make.size.equalTo(UIConstants.Size.avatar)
        }
        tagLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalTo(avatarImgView)
            make.width.equalTo(42)
            make.height.equalTo(17)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImgView.snp.trailing).offset(10)
            make.top.equalTo(avatarImgView.snp.top).offset(-2.5)
            make.trailing.greaterThanOrEqualTo(tagLabel.snp.leading).offset(-10)
            make.height.equalTo(12)
        }
        courseNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.trailing.greaterThanOrEqualTo(tagLabel.snp.leading).offset(-10)
            make.top.equalTo(nameLabel.snp.bottom).offset(9)
            make.height.equalTo(12)
        }
        sectionNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.greaterThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(UIScreenHeight/2+(9.0/16*UIScreenWidth)/2+20)
        }
    }
    
    override func viewWillLayoutSubviews() {
        if UIDevice.current.orientation.isLandscape {
            captionView.isHidden = true
            dismissBtn.isHidden = true
            
            fullScreenBtn.setImage(UIImage(named: "course_videoZoomIn")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
            playerLayer.frame = CGRect(origin: CGPoint(x: UIScreenHeight/2-(16.0/9*UIScreenWidth)/2, y: 0), size: CGSize(width: 16.0/9*UIScreenWidth, height: UIScreenWidth))
            
            audioSlider.snp.remakeConstraints { make in
                make.leading.equalTo(70)
                make.trailing.equalTo(-100)
                make.bottom.equalTo(-20)
            }
            
            let size = dismissBtn.currentImage!.size
            dismissBtn.snp.remakeConstraints { make in
                make.trailing.equalTo(0)
                make.top.equalTo(0)
                make.width.equalTo(size.width+UIConstants.Margin.leading*2)
                make.height.equalTo(size.height+UIConstants.Margin.top*2)
            }
        } else {
            
            fullScreenBtn.setImage(UIImage(named: "course_videoZoomOut")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
            playerLayer.frame = CGRect(origin: CGPoint(x: 0, y: UIScreenHeight/2-(9.0/16*UIScreenWidth)/2), size: CGSize(width: UIScreenWidth, height: 9.0/16*UIScreenWidth))
            
            audioSlider.snp.remakeConstraints { make in
                make.leading.equalTo(70)
                make.trailing.equalTo(-100)
                make.bottom.equalTo(-(UIScreenHeight/2-(9.0/16*UIScreenWidth)/2)-20)
            }
            
            let size = dismissBtn.currentImage!.size
            dismissBtn.snp.remakeConstraints { make in
                if #available(iOS 11.0, *) {
                    make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
                    make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                } else {
                    make.trailing.equalTo(0)
                    make.top.equalTo(0)
                }
                make.width.equalTo(size.width+UIConstants.Margin.leading*2)
                make.height.equalTo(size.height+UIConstants.Margin.top*2)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        if UIDevice.current.orientation.isPortrait {
            captionView.isHidden = false
            dismissBtn.isHidden = false
        }
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTimeAction), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
//        let manager = Alamofire.NetworkReachabilityManager(host: ServerHost)
//        manager?.listener = { status in
//            switch status {
//            case .reachable(.ethernetOrWiFi):
//
//            case .reachable(.wwan):
//
//            default:
//                <#code#>
//            }
//        }
//        manager?.startListening()
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        if let avatarURL = courseModel?.teacher?.headshot_attribute?.service_url {
            avatarImgView.kf.setImage(with: URL(string: avatarURL))
        }
        
        courseNameLabel.text = courseModel?.title
        
        nameLabel.text = courseModel?.teacher?.name ?? ""
        if let tags = courseModel?.teacher?.tags {
            let tagString = tags.joined(separator: " | ")
            nameLabel.text = nameLabel.text?.appendingFormat(" : %@", tagString)
        }
        
        sectionNameLabel.setParagraphText(sectionModel?.title ?? "")
        
        audioCurrentTimeLabel.text = "00:00"
        if let durationSeconds = sectionModel?.duration_with_seconds {
            let duration: TimeInterval = TimeInterval(durationSeconds)
            let durationDate = Date(timeIntervalSince1970: duration)
            audioDurationTimeLabel.text = CourseCatalogueCell.timeFormatter.string(from: durationDate)
        }
        
        let manager = Alamofire.NetworkReachabilityManager(host: ServerHost)
        if manager?.isReachableOnEthernetOrWiFi ?? false {
            reloadPlayer()
        } else if manager?.isReachableOnWWAN ?? false {
            let alertController = UIAlertController(title: nil, message: "当前为非WiFi网络，播放将产生流量费用", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "取消播放", style: .default, handler: { (alertAction) in
                self.dismissBtnAction()
            }))
            alertController.addAction(UIAlertAction(title: "继续播放", style: .default, handler: { (alertAction) in
                self.reloadPlayer()
            }))
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    func reloadPlayer() {
        if let videoURL = sectionModel?.media_attribute?.service_url, let playURL = URL(string: videoURL) {
            let playerItem = AVPlayerItem(url: playURL)
            player.replaceCurrentItem(with: playerItem)
            player.play()
            
            if let timeObserverToken = timeObserverToken {
                player.removeTimeObserver(timeObserverToken)
                self.timeObserverToken = nil
            }
            if let observer = observer {
                observer.invalidate()
                self.observer = nil
            }
            
            timeObserverToken = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { [weak self, weak player] (time) in
                
                guard let cmtime = player?.currentTime() else { return }
                guard player?.rate != 0 else {
                    let playImg = UIImage(named: "course_videoPlay")?.withRenderingMode(.alwaysOriginal)
                    if self?.audioActionBtn.currentImage != playImg {
                        self?.audioActionBtn.setImage(playImg, for: .normal)
                    }
                    return
                }
                let seconds = CMTimeGetSeconds(cmtime)
                guard seconds >= 0 else { return }
                let timeInterval: TimeInterval = TimeInterval(seconds)
                let date = Date(timeIntervalSince1970: timeInterval)
                self?.audioCurrentTimeLabel.text = CourseCatalogueCell.timeFormatter.string(from: date)
                
                let pauseImg = UIImage(named: "course_videoPause")?.withRenderingMode(.alwaysOriginal)
                if self?.audioActionBtn.currentImage != pauseImg {
                    self?.audioActionBtn.setImage(pauseImg, for: .normal)
                }
                
                guard self?.isSliderDragging == false else { return }
                guard let durationSeconds = self?.sectionModel?.duration_with_seconds else { return }
                self?.audioSlider.setValue(Float(seconds) / durationSeconds, animated: true)
            })
            
            observer = playerItem.observe(\.loadedTimeRanges) { [weak self] (item, changed) in
                guard let first = playerItem.loadedTimeRanges.first else {
                    return
                }
                let timeRange = first.timeRangeValue
                let startSeconds = CMTimeGetSeconds(timeRange.start)
                let durationSecound = CMTimeGetSeconds(timeRange.duration)
                let loadedTime = startSeconds + durationSecound
                
                let totalTime = CMTimeGetSeconds(playerItem.duration)
                
                //                self?.audioSlider.maximumValue = Float(loadedTime/totalTime)
                if let audioSlider = self?.audioSlider {
                    self?.sliderBufferView.snp.remakeConstraints { make in
                        make.leading.equalTo(audioSlider)
                        make.centerY.equalTo(audioSlider).offset(1)
                        make.height.equalTo(1.5)
                        make.width.equalTo(audioSlider.snp.width).multipliedBy(loadedTime/totalTime)
                    }
                }
                
            }
            
            if let timer = hideTimer {
                timer.invalidate()
                hideTimer = nil
            }
            hideTimer = Timer.scheduledTimer(withTimeInterval: 3, block: { [weak self] (timer) in
                self?.controlCoverView.isHidden = true
            }, repeats: false)
        }
    }
    
    // MARK: - ============= Action =============
    @objc func dismissBtnAction() {
        dismiss(animated: true, completion: {
            if UIDevice.current.orientation.isLandscape {
                UIDevice.current.setValue(UIDeviceOrientation.portrait.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
            }
        })
    }
    
    @objc func audioActionBtnAction() {
        if player.rate == 0  {
            audioActionBtn.setImage(UIImage(named: "course_videoPause")?.withRenderingMode(.alwaysOriginal), for: .normal)
            player.play()
            
            if hideTimer == nil || hideTimer?.isValid ?? false {
                hideTimer = Timer.scheduledTimer(withTimeInterval: 3, block: { [weak self] (timer) in
                    self?.controlCoverView.isHidden = true
                    }, repeats: false)
            }
            
        } else {
            audioActionBtn.setImage(UIImage(named: "course_videoPlay")?.withRenderingMode(.alwaysOriginal), for: .normal)
            player.pause()
            
            if let timer = hideTimer {
                timer.invalidate()
                hideTimer = nil
            }
        }
    }
    
    @objc func sliderTouchBeganAction() {
        isSliderDragging = true
    }
    
    @objc func sliderTouchEndedAction() {
        guard let durationSeconds = sectionModel?.duration_with_seconds, durationSeconds > 0 else {
            self.isSliderDragging = false
            return
        }
        
        player.seek(to: CMTime(seconds: Double(durationSeconds * audioSlider.value), preferredTimescale: CMTimeScale(NSEC_PER_SEC))) { (bool) in
            self.isSliderDragging = false
        }
    }
    
//    @objc func audioPreviousBtnAction() {
//        guard let course = PlayListService.sharedInstance.playingCourseModel,
//            let sections = PlayListService.sharedInstance.playingSectionModels,
//            PlayListService.sharedInstance.playingIndex > 0 else {
//                return
//        }
//        PlayListService.sharedInstance.playAudio(course: course, sections: sections, playingIndex: PlayListService.sharedInstance.playingIndex-1)
//    }
//
//    @objc func audioNextBtnAction() {
//        guard let course = PlayListService.sharedInstance.playingCourseModel,
//            let sections = PlayListService.sharedInstance.playingSectionModels,
//            PlayListService.sharedInstance.playingIndex < sections.count-1 else {
//                return
//        }
//        PlayListService.sharedInstance.playAudio(course: course, sections: sections, playingIndex: PlayListService.sharedInstance.playingIndex+1)
//    }
    
    @objc func fullScreenBtnAction() {
        if UIDevice.current.orientation.isLandscape {
            UIDevice.current.setValue(UIDeviceOrientation.portrait.rawValue, forKey: "orientation")
            
        } else {
            UIDevice.current.setValue(UIDeviceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            
        }
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
    @objc func playToEndTimeAction() {
        let playImg = UIImage(named: "course_videoPlay")?.withRenderingMode(.alwaysOriginal)
        if audioActionBtn.currentImage != playImg {
            audioActionBtn.setImage(playImg, for: .normal)
        }
        
        controlCoverView.isHidden = false
    }
    
    deinit {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        if let observer = observer {
            observer.invalidate()
            self.observer = nil
        }
        if let timer = hideTimer {
            timer.invalidate()
            self.hideTimer = nil
        }
    }

}
