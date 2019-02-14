//
//  DVideoPreviewViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/23.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

//FIXME: debug in simulator (uncomment all code)
import PLPlayerKit

class DVideoPreviewViewController: BaseViewController {

    fileprivate lazy var fileURL: URL? = nil
    
    fileprivate lazy var player: PLPlayer? = nil
    
    init(fileURL: URL) {
        super.init(nibName: nil, bundle: nil)
        
        self.fileURL = fileURL
        let option = PLPlayerOption.default()
        option.setOptionValue(NSNumber(value: 15), forKey: PLPlayerOptionKeyTimeoutIntervalForMediaPackets)
        option.setOptionValue(NSNumber(value: 2000), forKey: PLPlayerOptionKeyMaxL1BufferDuration)
        option.setOptionValue(NSNumber(value: 1000), forKey: PLPlayerOptionKeyMaxL2BufferDuration)
        option.setOptionValue(NSNumber(value: false), forKey: PLPlayerOptionKeyVideoToolbox)
        option.setOptionValue(NSNumber(value: PLLogLevel(rawValue: 3).rawValue), forKey: PLPlayerOptionKeyLogLevel)
        player = PLPlayer(url: fileURL, option: option)
        player?.loopPlay = true
        //FIXME: DEBUG horizontal video
        player?.playerView?.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "预览"
        
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
        
        guard let playerView = player?.playerView else { return }
        view.addSubview(playerView)
        player?.play()
        
        initBackBtn()
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
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        if let playerView = player?.playerView {
            playerView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
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
}
