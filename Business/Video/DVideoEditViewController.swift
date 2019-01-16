//
//  DVideoEditViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/15.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import PLShortVideoKit

class DVideoEditViewController: BaseViewController {

    fileprivate let editor: PLShortVideoEditor
    
    fileprivate let asset: AVAsset
    
    fileprivate lazy var composerMusicBtn: VerticallyButton = {
        let button = VerticallyButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIConstants.Font.foot
        button.setTitle("剪音乐", for: .normal)
        button.setImage(UIImage(named: "video_editComposeMusic"), for: .normal)
        button.padding = 4
        //            button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var videoSoundImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_editSelectSoundIcon")
        imgView.contentMode = .center
        return imgView
    }()
    
    init(settings: [String: Any]) {
        asset = settings[PLSAssetKey] as! AVAsset
        editor = PLShortVideoEditor(asset: asset)
        editor.loopEnabled = true
        editor.timeRange = CMTimeRange(start: CMTime(seconds: settings[PLSStartTimeKey] as! Double,
                                                     preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
                                       duration: CMTime(seconds: settings[PLSDurationKey] as! Double,
                                                        preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        editor.videoSize = asset.pls_videoSize
        editor.fillMode = PLSVideoFillModeType(rawValue: 1)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
        
        if !(navigationController?.isNavigationBarHidden ?? true) {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.backgroundColor = UIColor("#353535")
        
        view.addSubview(editor.previewView)
        editor.startEditing()
        
        initBackBtn()
        initTopView()
        initBottomView()
        initSubmitBtn()
    }
    
    fileprivate func initBackBtn() {
        let img = UIImage(named: "public_backBarItem")
        let backBarBtn: UIButton = {
            let button = UIButton()
            button.setImage(img?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = .white
            button.addTarget(self, action: #selector(backBarItemAction), for: .touchUpInside)
            return button
        }()
        view.addSubview(backBarBtn)
        backBarBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            if #available(iOS 11, *) {
                make.top.equalTo(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)
            } else {
                make.top.equalTo(0)
            }
            make.size.equalTo(CGSize(width: UIConstants.Margin.leading*2+12, height: 60+22))
        }
    }
    
    fileprivate func initTopView() {
        let stackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .bottom
            view.axis = .horizontal
            view.distribution = .equalSpacing
            view.spacing = 25
            return view
        }()
        
        let composerVideoBtn: VerticallyButton = {
            let button = VerticallyButton()
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIConstants.Font.foot
            button.setTitle("剪视频", for: .normal)
            button.setImage(UIImage(named: "video_editComposeVideo"), for: .normal)
            button.padding = 4.5
            button.addTarget(self, action: #selector(videoClipBtnAction), for: .touchUpInside)
            return button
        }()
        
        let volumeBtn: VerticallyButton = {
            let button = VerticallyButton()
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIConstants.Font.foot
            button.setTitle("音量", for: .normal)
            button.setImage(UIImage(named: "video_editVolume"), for: .normal)
            button.padding = 7.5
            //            button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
            return button
        }()
        
        let selectSoundBtn: VerticallyButton = {
            let button = VerticallyButton()
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIConstants.Font.foot
            button.setTitle("选音乐", for: .normal)
            button.setImage(UIImage(named: "video_editSelectSoundBg"), for: .normal)
            button.padding = 0
            //            button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
            return button
        }()
        
        selectSoundBtn.imageView?.addSubview(videoSoundImgView)
        videoSoundImgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 24.5, height: 24.5))
        }
        
        stackView.addArrangedSubview(composerVideoBtn)
        stackView.addArrangedSubview(composerMusicBtn)
        stackView.addArrangedSubview(volumeBtn)
        stackView.addArrangedSubview(selectSoundBtn)
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            if #available(iOS 11, *) {
                make.top.equalTo((UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) + 23)
            } else {
                make.top.equalTo(23)
            }
        }
    }
    
    fileprivate func initBottomView() {
        let stackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .bottom
            view.axis = .horizontal
            view.distribution = .equalSpacing
            view.spacing = 25
            return view
        }()
        
        let filtersBtn: VerticallyButton = {
            let button = VerticallyButton()
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIConstants.Font.foot
            button.setTitle("滤镜", for: .normal)
            button.setImage(UIImage(named: "video_editFilters"), for: .normal)
            button.padding = 4.5
            //            button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
            return button
        }()
        
        let selectCoverBtn: VerticallyButton = {
            let button = VerticallyButton()
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIConstants.Font.foot
            button.setTitle("选封面", for: .normal)
            button.setImage(UIImage(named: "video_editCover"), for: .normal)
            button.padding = 4.5
            //            button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
            return button
        }()
        
        let stickersBtn: VerticallyButton = {
            let button = VerticallyButton()
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIConstants.Font.foot
            button.setTitle("贴纸", for: .normal)
            button.setImage(UIImage(named: "video_editStickers"), for: .normal)
            button.padding = 4.5
            //            button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
            return button
        }()
        
        stackView.addArrangedSubview(filtersBtn)
        stackView.addArrangedSubview(selectCoverBtn)
        stackView.addArrangedSubview(stickersBtn)
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            if #available(iOS 11, *) {
                make.bottom.equalTo(-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) - 30)
            } else {
                make.bottom.equalTo(-30)
            }
        }
    }
    
    fileprivate func initSubmitBtn() {
        let submitBtn: UIButton = {
            let button = UIButton()
            button.setTitleColor(UIConstants.Color.primaryGreen, for: .normal)
            button.titleLabel?.font = UIConstants.Font.body
            button.setTitle("下一步", for: .normal)
            button.backgroundColor = .white
            button.layer.cornerRadius = 20
            button.clipsToBounds = true
//            button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
            return button
        }()
        
        view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            if #available(iOS 11, *) {
                make.bottom.equalTo(-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) - 33)
            } else {
                make.bottom.equalTo(-33)
            }
            make.size.equalTo(CGSize(width: 82.5, height: 40))
        }
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        editor.previewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    @objc func videoClipBtnAction() {
        let viewController = DVideoClipViewController(asset: asset)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        present(viewController, animated: true, completion: nil)
    }
}


// MARK: - ============= UIViewControllerTransitioningDelegate =============
extension DVideoEditViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = PresentationManager(presentedViewController: presented, presenting: presenting)
        if presented.isKind(of: DVideoClipViewController.self) {
            presentation.layoutHeight = 170
        }
        return presentation
    }
}
