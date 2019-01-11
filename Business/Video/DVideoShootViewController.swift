//
//  DVideoShootViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/10.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class DVideoShootViewController: BaseViewController {

    lazy fileprivate var rateView: VideoRateView = {
        let view = VideoRateView()
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
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.backgroundColor = UIColor("#353535")
        
        view.addSubview(rateView)
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        rateView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-150)
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

}
