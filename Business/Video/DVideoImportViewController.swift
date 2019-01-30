//
//  DVideoImportViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/29.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import PLShortVideoKit

class DVideoImportViewController: BaseViewController {

    fileprivate let editor: PLShortVideoEditor
    
    fileprivate let asset: AVAsset
    
    fileprivate var outputSettings: [AnyHashable: Any]
    
    fileprivate var movieSettings: [AnyHashable: Any]
    
    init(settings: [String: Any]) {
        outputSettings = settings
        movieSettings = settings[PLSMovieSettingsKey] as! [AnyHashable : Any]
        asset = movieSettings[PLSAssetKey] as! AVAsset
        
        editor = PLShortVideoEditor(asset: asset)
        editor.loopEnabled = true
        editor.timeRange = CMTimeRange(start: CMTime(seconds: movieSettings[PLSStartTimeKey] as! Double,
                                                     preferredTimescale: 600),
                                       duration: CMTime(seconds: movieSettings[PLSDurationKey] as! Double,
                                                        preferredTimescale: 600))
        
        editor.videoSize = asset.pls_videoSize
        editor.fillMode = PLSVideoFillModeType(rawValue: 1)
        
        super.init(nibName: nil, bundle: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        initSubmitBtn()
        initClipView()
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
    
    fileprivate func initSubmitBtn() {
        let submitBtn: ActionButton = {
            let button = ActionButton()
            button.setTitleColor(UIConstants.Color.primaryGreen, for: .normal)
            button.titleLabel?.font = UIConstants.Font.body
            button.setTitle("下一步", for: .normal)
            button.backgroundColor = .white
            button.layer.cornerRadius = 20
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(submitBtnAction(sender:)), for: .touchUpInside)
            return button
        }()
        
        view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            if #available(iOS 11, *) {
                make.top.equalTo((UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) + 20)
            } else {
                make.top.equalTo(20)
            }
            make.size.equalTo(CGSize(width: 82.5, height: 40))
        }
    }
    
    fileprivate func initClipView() {
        let viewController = DVideoClipViewController(asset: asset, settings: movieSettings)
        viewController.clipHandler = { [weak self] (startSeconds, endSeconds) in
            self?.movieSettings[PLSStartTimeKey] = NSNumber(value: startSeconds)
            self?.movieSettings[PLSDurationKey] = NSNumber(value: endSeconds-startSeconds)
            self?.outputSettings[PLSMovieSettingsKey] = self?.movieSettings
            
            self?.editor.timeRange = CMTimeRange(start: CMTime(seconds: startSeconds, preferredTimescale: 600), end: CMTime(seconds: endSeconds, preferredTimescale: 600))
            self?.editor.startEditing()
        }
        view.addSubview(viewController.view)
        self.addChild(viewController)
        
        viewController.view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(170)
        }
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============
    @objc func submitBtnAction(sender: ActionButton) {
        guard let duration = movieSettings[PLSDurationKey] as? NSNumber, duration.doubleValue <= 60 else {
            HUDService.sharedInstance.show(string: "视频不能超过60秒")
            return
        }
        
        navigationController?.pushViewController(DVideoEditViewController(settings: outputSettings), animated: true)
    }
}
