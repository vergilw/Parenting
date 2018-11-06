//
//  DPlayerViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/6.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import AVFoundation

class DPlayerViewController: BaseViewController {

    lazy fileprivate var controlCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        return view
    }()
    
    lazy fileprivate var audioSlider: UISlider = {
        let view = UISlider()
        view.minimumTrackTintColor = UIConstants.Color.primaryGreen
        view.maximumTrackTintColor = UIConstants.Color.disable
        view.setThumbImage(UIImage(named: "course_audioSliderThumb"), for: .normal)
        view.addTarget(self, action: #selector(sliderTouchBeganAction), for: .touchDown)
        view.addTarget(self, action: #selector(sliderTouchEndedAction), for: [.touchUpInside, .touchUpOutside, .touchCancel])
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
    
    lazy fileprivate var audioPreviousBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "course_audioPrevious")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(audioPreviousBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var audioNextBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "course_audioNext")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(audioNextBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var fullScreenBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "course_videoFullScreen")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(fullScreenBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var isSliderDragging: Bool = false
    
    fileprivate var observer: NSKeyValueObservation?
    
    fileprivate var timeObserverToken: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        
//        PlayListService.sharedInstance.playAudio(course: course, sections: sections, playingIndex: index)
        PlayListService.sharedInstance.play()
        let playerLayer = AVPlayerLayer(player: PlayListService.sharedInstance.player)
        playerLayer.videoGravity = .resize
        view.layer.addSublayer(playerLayer)
        playerLayer.frame = CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: 434/750.0*UIScreenWidth))
        
        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        view.addSubview(controlCoverView)
        controlCoverView.addSubviews([audioActionBtn, audioSlider, audioCurrentTimeLabel, audioDurationTimeLabel, audioPreviousBtn, audioNextBtn, fullScreenBtn])
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        controlCoverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        audioSlider.snp.makeConstraints { make in
            make.leading.equalTo(70)
            make.trailing.equalTo(-100)
            make.bottom.equalTo(-20)
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
            make.trailing.bottom.equalToSuperview()
            make.width.equalTo(UIConstants.Margin.trailing*2+15)
            make.height.equalTo(55)
        }
        audioActionBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        audioPreviousBtn.snp.makeConstraints { make in
            make.centerY.equalTo(audioActionBtn)
            make.trailing.equalTo(audioActionBtn.snp.leading).offset(-25)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        audioNextBtn.snp.makeConstraints { make in
            make.centerY.equalTo(audioActionBtn)
            make.leading.equalTo(audioActionBtn.snp.trailing).offset(25)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
    }
    
    //TODO: layout orientation
//    override func viewWillLayoutSubviews() {
//
//    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============
    @objc func audioActionBtnAction() {
        if PlayListService.sharedInstance.isPlaying == false  {
            
            guard let course = PlayListService.sharedInstance.playingCourseModel, let sections = PlayListService.sharedInstance.playingSectionModels, PlayListService.sharedInstance.playingIndex != -1 else {
                return
            }
            PlayListService.sharedInstance.playAudio(course: course, sections: sections, playingIndex: PlayListService.sharedInstance.playingIndex)
            audioActionBtn.setImage(UIImage(named: "course_borderPauseAction")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else {
            PlayListService.sharedInstance.pauseAudio()
            audioActionBtn.setImage(UIImage(named: "course_borderPlayAction")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    @objc func sliderTouchBeganAction() {
        isSliderDragging = true
    }
    
    @objc func sliderTouchEndedAction() {
        guard let _ = PlayListService.sharedInstance.playingCourseModel, let _ = PlayListService.sharedInstance.playingSectionModels, PlayListService.sharedInstance.playingIndex != -1 else {
            isSliderDragging = false
            return
        }
        PlayListService.sharedInstance.seek(audioSlider.value) {
            self.isSliderDragging = false
        }
    }
    
    @objc func audioPreviousBtnAction() {
        guard let course = PlayListService.sharedInstance.playingCourseModel,
            let sections = PlayListService.sharedInstance.playingSectionModels,
            PlayListService.sharedInstance.playingIndex > 0 else {
                return
        }
        PlayListService.sharedInstance.playAudio(course: course, sections: sections, playingIndex: PlayListService.sharedInstance.playingIndex-1)
    }
    
    @objc func audioNextBtnAction() {
        guard let course = PlayListService.sharedInstance.playingCourseModel,
            let sections = PlayListService.sharedInstance.playingSectionModels,
            PlayListService.sharedInstance.playingIndex < sections.count-1 else {
                return
        }
        PlayListService.sharedInstance.playAudio(course: course, sections: sections, playingIndex: PlayListService.sharedInstance.playingIndex+1)
    }
    
    @objc func fullScreenBtnAction() {
        
    }
}
