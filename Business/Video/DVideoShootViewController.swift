//
//  DVideoShootViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/10.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import PLShortVideoKit

class DVideoShootViewController: BaseViewController {

    lazy fileprivate var recorder: PLShortVideoRecorder = {
        let recorder = PLShortVideoRecorder(videoConfiguration: PLSVideoConfiguration.default(), audioConfiguration: PLSAudioConfiguration.default())
        recorder.maxDuration = 60
        recorder.minDuration = 5
        recorder.delegate = self
        return recorder
    }()
    
    lazy fileprivate var rateView: VideoRateView = {
        let view = VideoRateView()
        return view
    }()
    
    lazy fileprivate var beautifyBtn: VerticallyButton = {
        let button = VerticallyButton()
        button.setImage(UIImage(named: "video_beautifyOn"), for: .selected)
        button.setImage(UIImage(named: "video_beautifyOff"), for: .normal)
        button.isSelected = true
        button.setTitle("美颜", for: .normal)
        button.titleLabel?.font = UIConstants.Font.foot
        button.titleLabel?.textColor = .white
        button.padding = 6
        button.addTarget(self, action: #selector(beautifyBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var flashlightBtn: VerticallyButton = {
        let button = VerticallyButton()
        button.setImage(UIImage(named: "video_flashOff"), for: .normal)
        button.setImage(UIImage(named: "video_flashOn"), for: .selected)
        button.setTitle("闪光", for: .normal)
        button.titleLabel?.font = UIConstants.Font.foot
        button.titleLabel?.textColor = .white
        button.padding = 6
        button.addTarget(self, action: #selector(flashlightBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var recordBtn: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor
        button.layer.borderWidth = 5
        button.backgroundColor = UIColor(white: 1, alpha: 0.8)
        button.layer.cornerRadius = 28
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(recordBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var deleteFragmentBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "video_deleteFragment"), for: .normal)
//        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var submitBtn: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor(white: 1, alpha: 1.0).cgColor
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.setImage(UIImage(named: "video_submit"), for: .normal)
//        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var progressBar: VideoRecordProgress = {
        let view = VideoRecordProgress()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.backgroundColor = UIColor("#353535")
        
        if let recorderView = recorder.previewView {
            view.addSubview(recorderView)
            recorder.startCaptureSession()
            recorder.startRecording()
        }
        
        rateView.completionHandler = { [weak self] mode in
            switch mode {
            case .topfast:
                self?.recorder.recoderRate = .topFast
            case .fast:
                self?.recorder.recoderRate = .fast
            case .normal:
                self?.recorder.recoderRate = .normal
            case .slow:
                self?.recorder.recoderRate = .slow
            case .topslow:
                self?.recorder.recoderRate = .topSlow
            }
        }
        view.addSubview(rateView)
        
        initRightView()
        initBottomView()
        initBackBtn()
    }
    
    fileprivate func initRightView() {
        let stackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .center
            view.axis = .vertical
            view.distribution = .equalSpacing
            view.spacing = 30
            return view
        }()
        
        let switchBtn: VerticallyButton = {
            let button = VerticallyButton()
            button.setImage(UIImage(named: "video_switch"), for: .normal)
            button.setTitle("反转", for: .normal)
            button.titleLabel?.font = UIConstants.Font.foot
            button.titleLabel?.textColor = .white
            button.padding = 6
            button.addTarget(self, action: #selector(switchBtnAction), for: .touchUpInside)
            return button
        }()
        
        stackView.addArrangedSubview(switchBtn)
        stackView.addArrangedSubview(beautifyBtn)
        stackView.addArrangedSubview(flashlightBtn)
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            if #available(iOS 11, *) {
                make.top.equalTo((UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) + 35)
            } else {
                make.top.equalTo(35)
            }
        }
    }
    
    fileprivate func initBottomView() {
        view.addSubviews([recordBtn, deleteFragmentBtn, submitBtn])
        
        recordBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if #available(iOS 11, *) {
                make.bottom.equalTo(-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)-50)
            } else {
                make.bottom.equalTo(-50)
            }
            make.size.equalTo(CGSize(width: 56, height: 56))
        }
        deleteFragmentBtn.snp.makeConstraints { make in
            make.trailing.equalTo(recordBtn.snp.leading).offset(-50)
            make.centerY.equalTo(recordBtn)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        submitBtn.snp.makeConstraints { make in
            make.leading.equalTo(recordBtn.snp.trailing).offset(50)
            make.centerY.equalTo(recordBtn)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
    
    fileprivate func initBackBtn() {
        let dismissBtn: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "public_dismissBtn")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = .white
            button.addTarget(self, action: #selector(dimissBarItemAction), for: .touchUpInside)
            return button
        }()
        view.addSubview(dismissBtn)
        dismissBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            if #available(iOS 11, *) {
                make.top.equalTo(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)
            } else {
                make.top.equalTo(0)
            }
            make.size.equalTo(CGSize(width: 25+15+25, height: 35+15+35))
        }
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        recorder.previewView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        rateView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if #available(iOS 11, *) {
                make.bottom.equalTo(-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)-150)
            } else {
                make.bottom.equalTo(-150)
            }
            make.size.equalTo(CGSize(width: 851, height: 851))
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
    @objc func recordBtnAction() {
        
    }
    
    @objc func albumBtnAction() {
        
    }
    
    @objc func switchBtnAction() {
        recorder.toggleCamera()
    }
    
    @objc func beautifyBtnAction() {
        beautifyBtn.isSelected = !beautifyBtn.isSelected
        recorder.setBeautifyModeOn(beautifyBtn.isSelected)
    }
    
    @objc func flashlightBtnAction() {
        flashlightBtn.isSelected = !flashlightBtn.isSelected
        recorder.isTorchOn = flashlightBtn.isSelected
    }
}


// MARK: - ============= PLShortVideoRecorderDelegate =============
extension DVideoShootViewController: PLShortVideoRecorderDelegate {
    
    func shortVideoRecorder(_ recorder: PLShortVideoRecorder, didStartRecordingToOutputFileAt fileURL: URL) {
        progressBar.addFragment()
    }
    
    func shortVideoRecorder(_ recorder: PLShortVideoRecorder, didFinishRecordingToOutputFileAt fileURL: URL, fileDuration: CGFloat, totalDuration: CGFloat) {
        progressBar.setLastWidth(width: fileDuration/recorder.maxDuration*progressBar.frame.width)
    }
    
//    func shortVideoRecorder(_ recorder: PLShortVideoRecorder, didFinishRecordingMaxDuration maxDuration: CGFloat) {
//        <#code#>
//    }
}
