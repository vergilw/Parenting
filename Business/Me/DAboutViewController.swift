//
//  DAboutViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/22.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DAboutViewController: BaseViewController {

    lazy fileprivate var titleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h1
        label.textColor = UIConstants.Color.head
        label.setParagraphText("关于氧育")
        return label
    }()
    
    lazy fileprivate var paragraphALabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing
        label.setParagraphText("基于犹太教育和德国教育，整理出适合中国的教育理念和模式，线下具有直营十三家门店，年营收近五千万左右。现在项目组归属公司整体运营策略，进行线上教育资源整合和开发布局。\n\n武汉壹叁壹肆教育科技有限公司致力于教育行业资源整合，并提供教育行业所需管理咨询服务。本公司是基于早教全产业链，集合行业信息互通、知识分享、线上教育、电子商务的专业平台，由武汉大学精英团队联合创立。")
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "关于"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubviews([titleLabel, paragraphALabel])
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(60)
            make.leading.equalTo(UIConstants.Margin.leading)
        }
        paragraphALabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
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
