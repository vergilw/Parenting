//
//  DVideoShootViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/10.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import PLShortVideoKit
import Photos
import MobileCoreServices

class DVideoShootViewController: BaseViewController {

    lazy fileprivate var recorder: PLShortVideoRecorder = {
        let recorder = PLShortVideoRecorder(videoConfiguration: PLSVideoConfiguration.default(), audioConfiguration: PLSAudioConfiguration.default())
        //FIXME: DEBUG maxDuration
        recorder.maxDuration = 60
        recorder.minDuration = 5
        recorder.setBeautifyModeOn(true)
        recorder.delegate = self
        return recorder
    }()
    
    fileprivate lazy var transcoder: PLShortVideoTranscoder? = nil
    
    fileprivate lazy var dismissBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "public_dismissBtn")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.layer.shadowOffset = CGSize(width: 0, height: 1.7)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 1.9
        button.layer.shadowColor = UIColor.black.cgColor
        button.clipsToBounds = false
        button.addTarget(self, action: #selector(dimissBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var rateView: VideoRateView = {
        let view = VideoRateView()
        return view
    }()
    
    lazy fileprivate var rightStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 30
        return view
    }()
    
    lazy fileprivate var beautifyBtn: VerticallyButton = {
        let button = VerticallyButton()
        button.setImage(UIImage(named: "video_beautifyOn"), for: .selected)
        button.setImage(UIImage(named: "video_beautifyOff"), for: .normal)
        button.isSelected = true
        button.setTitle("正常", for: .normal)
        button.setTitle("美颜", for: .selected)
        button.titleLabel?.font = UIConstants.Font.foot
        button.titleLabel?.textColor = .white
        button.padding = 6
        button.layer.shadowOffset = CGSize(width: 0, height: 1.7)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 1.9
        button.layer.shadowColor = UIColor.black.cgColor
        button.clipsToBounds = false
        button.addTarget(self, action: #selector(beautifyBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var flashlightBtn: VerticallyButton = {
        let button = VerticallyButton()
        button.setImage(UIImage(named: "video_flashOff"), for: .normal)
        button.setImage(UIImage(named: "video_flashOn"), for: .selected)
        button.setTitle("关闭", for: .normal)
        button.setTitle("闪光", for: .selected)
        button.titleLabel?.font = UIConstants.Font.foot
        button.titleLabel?.textColor = .white
        button.padding = 6
        button.layer.shadowOffset = CGSize(width: 0, height: 1.7)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 1.9
        button.layer.shadowColor = UIColor.black.cgColor
        button.clipsToBounds = false
        button.addTarget(self, action: #selector(flashlightBtnAction), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var shadowLayerView: UIView = {
        let view = UIView()
        return view
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
        button.addTarget(self, action: #selector(deleteFragmentBtnAction), for: .touchUpInside)
        button.layer.shadowOffset = CGSize(width: 0, height: 1.7)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 1.9
        button.layer.shadowColor = UIColor.black.cgColor
        button.clipsToBounds = false
        button.isHidden = true
        return button
    }()
    
    fileprivate lazy var albumsBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.backgroundColor = UIColor(white: 1, alpha: 0.65)
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(albumBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var submitBtn: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor(white: 1, alpha: 1.0).cgColor
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.setImage(UIImage(named: "video_submit"), for: .normal)
        button.addTarget(self, action: #selector(submitBtnAction), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy fileprivate var progressBar: VideoRecordProgress = {
        let view = VideoRecordProgress()
        view.layer.cornerRadius = 2.5
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate lazy var dispatchGroup: DispatchGroup? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchAlbumsCover()
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
        }
        
        view.addSubview(shadowLayerView)
        
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
        view.addSubviews([rateView, dismissBtn])
        
        initTopView()
        initRightView()
        initBottomShadowLayer()
        initBottomView()
    }
    
    fileprivate func initTopView() {
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            if #available(iOS 11, *) {
                make.top.equalTo((UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) + 10)
            } else {
                make.top.equalTo(10)
            }
            make.height.equalTo(5)
        }
    }
    
    fileprivate func initRightView() {
        
        let switchBtn: VerticallyButton = {
            let button = VerticallyButton()
            button.setImage(UIImage(named: "video_switch"), for: .normal)
            button.setTitle("反转", for: .normal)
            button.titleLabel?.font = UIConstants.Font.foot
            button.titleLabel?.textColor = .white
            button.padding = 6
            button.layer.shadowOffset = CGSize(width: 0, height: 1.7)
            button.layer.shadowOpacity = 0.2
            button.layer.shadowRadius = 1.9
            button.layer.shadowColor = UIColor.black.cgColor
            button.clipsToBounds = false
            button.addTarget(self, action: #selector(switchBtnAction), for: .touchUpInside)
            return button
        }()
        
        rightStackView.addArrangedSubview(switchBtn)
        rightStackView.addArrangedSubview(beautifyBtn)
        rightStackView.addArrangedSubview(flashlightBtn)
        
        view.addSubview(rightStackView)
        rightStackView.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            if #available(iOS 11, *) {
                make.top.equalTo((UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) + 35)
            } else {
                make.top.equalTo(35)
            }
        }
    }
    
    fileprivate func initBottomShadowLayer() {
        let gradientLayer: CAGradientLayer = {
            let layer = CAGradientLayer()
            layer.colors = [UIColor.clear.cgColor, UIColor(white: 0, alpha: 0.2).cgColor, UIColor(white: 0, alpha: 0.4).cgColor]
            layer.locations = [0.3, 0.6, 1.0]
            layer.startPoint = CGPoint.init(x: 0.0, y: 0.0)
            layer.endPoint = CGPoint.init(x: 0.0, y: 1.0)
            return layer
        }()
        
        shadowLayerView.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreenWidth, height: 400)
    }
    
    fileprivate func initBottomView() {
        view.addSubviews([recordBtn, deleteFragmentBtn, submitBtn, albumsBtn])
        
        
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
        albumsBtn.snp.makeConstraints { make in
            make.trailing.equalTo(recordBtn.snp.leading).offset(-50)
            make.centerY.equalTo(recordBtn)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        recorder.previewView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        shadowLayerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(400)
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
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchAlbumsCover() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            if PHPhotoLibrary.authorizationStatus() == .notDetermined {
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == .authorized {
                        self.fetchAlbumsCover()
                    } else {
                        HUDService.sharedInstance.show(string: "没有访问照片权限，获取相册失败")
                    }
                })
                return
                
            } else if PHPhotoLibrary.authorizationStatus() == .denied || PHPhotoLibrary.authorizationStatus() == .restricted {
                HUDService.sharedInstance.show(string: "没有访问照片权限，获取相册失败")
                return
            }
            
            let options = PHFetchOptions()
            options.includeHiddenAssets = false
            options.includeAllBurstAssets = false
            options.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false),
                                       NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let result = PHAsset.fetchAssets(with: PHAssetMediaType.video, options: options)
            
            var assets = [PHAsset]()
            result.enumerateObjects({ (asset, index, stop) in
                assets.append(asset)
            })
            
            guard let asset = assets.first else { return }
            
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 88, height: 88), contentMode: PHImageContentMode.aspectFill, options: nil, resultHandler: { (image, info) in
                DispatchQueue.main.async {
                    self.albumsBtn.setImage(image, for: UIControl.State.normal)
                }
                
            })
        }
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============
    @objc func recordBtnAction() {
        if albumsBtn.isHidden == false {
            albumsBtn.isHidden = true
        }
        
        if recorder.isRecording {
            recordBtn.setImage(nil, for: UIControl.State.normal)
            recordBtn.backgroundColor = UIColor(white: 1, alpha: 0.7)
            recorder.stopRecording()
        } else {
            recordBtn.setImage(UIImage(named: "video_shootPause"), for: UIControl.State.normal)
            recordBtn.backgroundColor = .clear
            recorder.startRecording()
        }
        
    }
    
    @objc func dimissBtnAction() {
        guard recorder.getTotalDuration() > 0 else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alertController.addAction(UIAlertAction(title: "重新拍摄", style: UIAlertAction.Style.destructive, handler: { (action) in
            self.progressBar.deleteAllFragment()
            self.recorder.deleteAllFiles()
        }))
        alertController.addAction(UIAlertAction(title: "退出", style: UIAlertAction.Style.default, handler: { (action) in
            self.recorder.cancelRecording()
            self.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func albumBtnAction() {
        let imgPicker = UIImagePickerController()
        imgPicker.sourceType = .photoLibrary
        imgPicker.mediaTypes = [kUTTypeMovie as String]
        imgPicker.videoQuality = .typeHigh
        imgPicker.allowsEditing = false
        imgPicker.delegate = self
        self.present(imgPicker, animated: true, completion: nil)
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
    
    @objc func deleteFragmentBtnAction() {
        let alertController = UIAlertController(title: nil, message: "确认删除上一段视频？", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
            self.progressBar.deleteLastFragment()
            self.recorder.deleteLastFile()
            
            if self.recorder.getTotalDuration() < self.recorder.minDuration {
                self.submitBtn.isHidden = true
            }
            
            if self.recorder.getFilesCount() == 0 {
                self.deleteFragmentBtn.isHidden = true
                self.albumsBtn.isHidden = false
            }
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func submitBtnAction() {
        //未暂停直接点击下一步，需要异步等待视频保存完成
        if recorder.isRecording {
            dispatchGroup = DispatchGroup()
            dispatchGroup?.enter()
            
            recordBtn.setImage(nil, for: UIControl.State.normal)
            recordBtn.backgroundColor = UIColor(white: 1, alpha: 0.7)
            recorder.stopRecording()
            
            dispatchGroup?.notify(queue: DispatchQueue.main, execute: {
                self.submitBtnAction()
                self.dispatchGroup = nil
            })
            
            return
        }
        
        var plsMovieSettings = [String: Any]()
        plsMovieSettings[PLSAssetKey] = recorder.assetRepresentingAllFiles()
        plsMovieSettings[PLSStartTimeKey] = NSNumber(value: 0.0)
        plsMovieSettings[PLSDurationKey] = NSNumber(value: recorder.assetRepresentingAllFiles().duration.seconds)
        plsMovieSettings[PLSVolumeKey] = NSNumber(value: 1.0)
        
        let outputSettings = [PLSMovieSettingsKey: plsMovieSettings]
        
        navigationController?.pushViewController(DVideoEditViewController(settings: outputSettings), animated: true)
    }
}


// MARK: - ============= PLShortVideoRecorderDelegate =============
extension DVideoShootViewController: PLShortVideoRecorderDelegate {
    
    func shortVideoRecorder(_ recorder: PLShortVideoRecorder, didStartRecordingToOutputFileAt fileURL: URL) {
        progressBar.addFragment()

        deleteFragmentBtn.alpha = 1.0
        dismissBtn.alpha = 1.0
        rightStackView.alpha = 1.0
        rateView.alpha = 1.0
        UIView.animate(withDuration: 0.25, animations: {
            self.deleteFragmentBtn.alpha = 0.0
            self.dismissBtn.alpha = 0.0
            self.rightStackView.alpha = 0.0
            self.rateView.alpha = 0.0
        }) { (bool) in
            self.deleteFragmentBtn.isHidden = true
            self.dismissBtn.isHidden = true
            self.rightStackView.isHidden = true
            self.rateView.isHidden = true
        }
    }
    
    func shortVideoRecorder(_ recorder: PLShortVideoRecorder, didRecordingToOutputFileAt fileURL: URL, fileDuration: CGFloat, totalDuration: CGFloat) {
        progressBar.updateLastFragmentWidth(width: fileDuration/recorder.maxDuration*progressBar.frame.width)
        
        if totalDuration >= recorder.minDuration && submitBtn.isHidden == true {
            submitBtn.isHidden = false
        }
    }
    
    func shortVideoRecorder(_ recorder: PLShortVideoRecorder, didFinishRecordingToOutputFileAt fileURL: URL, fileDuration: CGFloat, totalDuration: CGFloat) {
        progressBar.addSegmentationIndicator()
        
        deleteFragmentBtn.alpha = 0.0
        dismissBtn.alpha = 0.0
        rightStackView.alpha = 0.0
        rateView.alpha = 0.0
        self.deleteFragmentBtn.isHidden = false
        self.dismissBtn.isHidden = false
        self.rightStackView.isHidden = false
        self.rateView.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self.deleteFragmentBtn.alpha = 1.0
            self.dismissBtn.alpha = 1.0
            self.rightStackView.alpha = 1.0
            self.rateView.alpha = 1.0
        })
        
        //未暂停直接点击下一步，需要异步等待视频保存完成
        if let dispatchGroup = dispatchGroup {
            dispatchGroup.leave()
        }
        
        //录制到最大时间，自动暂停
        //TODO: 录制最大时间不精确 CGFloat(recorder.assetRepresentingAllFiles().duration.seconds)
        if recorder.isRecording == false && recorder.getTotalDuration() >= recorder.maxDuration {
            recordBtn.setImage(nil, for: UIControl.State.normal)
            recordBtn.backgroundColor = UIColor(white: 1, alpha: 0.7)
            submitBtnAction()
        }
    }
    
    //MARK: never callback
    func shortVideoRecorder(_ recorder: PLShortVideoRecorder, didFinishRecordingMaxDuration maxDuration: CGFloat) {
        submitBtnAction()
    }
    
    func shortVideoRecorder(_ recorder: PLShortVideoRecorder, didGetCameraAuthorizationStatus status: PLSAuthorizationStatus) {
        if status == .authorized {
            if !recorder.isRecording {
                recorder.startCaptureSession()
            }
            
        } else {
            HUDService.sharedInstance.show(string: "没有访问摄像头权限，拍摄失败")
        }
    }
    
    func shortVideoRecorder(_ recorder: PLShortVideoRecorder, didGetMicrophoneAuthorizationStatus status: PLSAuthorizationStatus) {
        if status == .authorized {
            if !recorder.isRecording {
                recorder.startCaptureSession()
            }
            
        } else {
            HUDService.sharedInstance.show(string: "没有访问麦克风权限，拍摄失败")
        }
    }
}


// MARK: - ============= UIImagePickerControllerDelegate, UINavigationControllerDelegate =============
extension DVideoShootViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        
        if let URL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            
            let progressView = MBProgressHUD(view: view)
            progressView.mode = .annularDeterminate
            progressView.label.text = "正在转码..."
            view.addSubview(progressView)
            progressView.show(animated: true)
            
            transcoder = PLShortVideoTranscoder(url: URL)
            transcoder?.outputFileType = .MPEG4
            transcoder?.outputFilePreset = .presetHighestQuality
            
            transcoder?.completionBlock = { [weak self] (URL) in
                DispatchQueue.main.async {
                    progressView.hide(animated: true)
                }
                
                
                guard let URL = URL else { return }
                let asset = AVAsset(url: URL)
                
                var plsMovieSettings = [String: Any]()
                plsMovieSettings[PLSAssetKey] = asset
                plsMovieSettings[PLSStartTimeKey] = NSNumber(value: 0.0)
                plsMovieSettings[PLSDurationKey] = NSNumber(value: min(asset.duration.seconds, 60))
                plsMovieSettings[PLSVolumeKey] = NSNumber(value: 1.0)
                
                let outputSettings = [PLSMovieSettingsKey: plsMovieSettings]
                
                DispatchQueue.main.async {
                    if asset.duration.seconds > 60 {
                        self?.navigationController?.pushViewController(DVideoImportViewController(settings: outputSettings), animated: true)
                    } else {
                        self?.navigationController?.pushViewController(DVideoEditViewController(settings: outputSettings), animated: true)
                    }
                }
                
            }
            
            transcoder?.failureBlock = { error in
                DispatchQueue.main.async {
                    progressView.hide(animated: true)
                }
                print(error)
            }
            
            transcoder?.processingBlock = { progress in
                print(progress)
                progressView.progress = progress
            }
            transcoder?.startTranscoding()
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
