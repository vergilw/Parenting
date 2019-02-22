//
//  DVideoPreviewViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/23.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

//FIXME: debug in simulator (uncomment all code)
//import PLPlayerKit

class DVideoPreviewViewController: BaseViewController {

    fileprivate lazy var fileURL: URL? = nil
    
//    fileprivate lazy var player: PLPlayer? = nil
    
    init(fileURL: URL) {
        super.init(nibName: nil, bundle: nil)
        
        self.fileURL = fileURL
//        let option = PLPlayerOption.default()
//        option.setOptionValue(NSNumber(value: 15), forKey: PLPlayerOptionKeyTimeoutIntervalForMediaPackets)
//        option.setOptionValue(NSNumber(value: 2000), forKey: PLPlayerOptionKeyMaxL1BufferDuration)
//        option.setOptionValue(NSNumber(value: 1000), forKey: PLPlayerOptionKeyMaxL2BufferDuration)
//        option.setOptionValue(NSNumber(value: false), forKey: PLPlayerOptionKeyVideoToolbox)
//        option.setOptionValue(NSNumber(value: PLLogLevel(rawValue: 3).rawValue), forKey: PLPlayerOptionKeyLogLevel)
//        player = PLPlayer(url: fileURL, option: option)
//        player?.loopPlay = true
//        player?.playerView?.contentMode = .scaleAspectFit
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
        
//        guard let playerView = player?.playerView else { return }
//        view.addSubview(playerView)
//        player?.play()
        
        initBackBtn()
    }
    
    fileprivate func initBackBtn() {
        view.addSubview(backBarBtn)
        
        backBarBtn.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(backBarBtn.bounds.size)
        }
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
//        if let playerView = player?.playerView {
//            playerView.snp.makeConstraints { make in
//                make.edges.equalToSuperview()
//            }
//        }
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
