//
//  DVideoVolumeViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/17.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class DVideoVolumeViewController: BaseViewController {

    var editHandler: ((Float,Float)->Void)?
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Semibold", size: 15)!
        label.textColor = .white
        label.text = "调节音量"
        return label
    }()
    
    lazy fileprivate var videoVolumeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        label.text = "原声"
        return label
    }()
    
    lazy fileprivate var musicVolumeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        label.text = "配乐"
        return label
    }()
    
    lazy fileprivate var videoVolumeLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        label.text = "100%"
        return label
    }()
    
    lazy fileprivate var musicVolumeLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        label.text = "100%"
        return label
    }()
    
    fileprivate lazy var videoVolumeSlider: UISlider = {
        let view = UISlider()
        view.maximumTrackTintColor = UIColor(white: 1, alpha: 0.3)
        view.minimumTrackTintColor = .white
        view.addTarget(self, action: #selector(sliderValueChanged), for: UIControl.Event.valueChanged)
        return view
    }()
    
    fileprivate lazy var musicVolumeSlider: UISlider = {
        let view = UISlider()
        view.maximumTrackTintColor = UIColor(white: 1, alpha: 0.3)
        view.minimumTrackTintColor = .white
        view.addTarget(self, action: #selector(sliderValueChanged), for: UIControl.Event.valueChanged)
        return view
    }()
    
    init(videoVolume: Float, musicVolume: Float) {
        super.init(nibName: nil, bundle: nil)
        
        videoVolumeSlider.setValue(videoVolume, animated: false)
        musicVolumeSlider.setValue(musicVolume, animated: false)
        videoVolumeLabel.text = String(format: "%2.0f%%", videoVolumeSlider.value*100)
        musicVolumeLabel.text = String(format: "%2.0f%%", musicVolumeSlider.value*100)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(effectView)
        effectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubviews([titleLabel, videoVolumeSlider, musicVolumeSlider, videoVolumeLabel, musicVolumeLabel, videoVolumeTitleLabel, musicVolumeTitleLabel])
        
        view.drawSeparator(startPoint: CGPoint(x: 0, y: 56), endPoint: CGPoint(x: UIScreenWidth, y: 56))
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.height.equalTo(56)
        }
        videoVolumeTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(84)
        }
        videoVolumeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(84)
        }
        videoVolumeSlider.snp.makeConstraints { make in
            make.leading.equalTo(60)
            make.trailing.equalTo(-65)
            make.centerY.equalTo(videoVolumeTitleLabel)
        }
        musicVolumeTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(videoVolumeTitleLabel.snp.bottom).offset(25)
        }
        musicVolumeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(videoVolumeTitleLabel.snp.bottom).offset(25)
        }
        musicVolumeSlider.snp.makeConstraints { make in
            make.leading.equalTo(60)
            make.trailing.equalTo(-65)
            make.centerY.equalTo(musicVolumeTitleLabel)
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============
    @objc func sliderValueChanged() {
        if let closure = editHandler {
            closure(videoVolumeSlider.value, musicVolumeSlider.value)
        }
        
        videoVolumeLabel.text = String(format: "%2.0f%%", videoVolumeSlider.value*100)
        musicVolumeLabel.text = String(format: "%2.0f%%", musicVolumeSlider.value*100)
    }
}
