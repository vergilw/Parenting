//
//  DAgreementViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/8.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DAgreementViewController: BaseViewController {

    lazy fileprivate var titleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.setParagraphText("如何规划幼儿英引")
        return label
    }()
    
    lazy fileprivate var paragraphALabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.body
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing
        label.setParagraphText("如何规划幼儿英引引导成长的历，如何规划幼儿英引引导成长，如何规划幼儿英引引导成长，如何规划幼儿英引引导成长，如何规划幼儿英引引导成长，如何规划幼儿英引引导成长，如何规划幼儿英引引导成长，如何规划幼儿英引引导成长，如何规划幼儿英引引导成长，如何规划幼儿英引引导成长，如何规划幼儿英引引导成长。")
        return label
    }()
    
    lazy fileprivate var subtitleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.setParagraphText("氧育协议")
        return label
    }()
    
    lazy fileprivate var paragraphBLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing
        label.setParagraphText("如何规划幼儿英引引导成长的历，如何规划幼儿英引引导成长，如何规划幼儿英引引导成长，如何规划幼儿英引引导成长，如何规划幼儿英引引导成长，如何规划幼儿英引引导成长，如何规划幼儿英引引导成长，如何规划幼儿英引引导成长，如何规划幼儿英引引导成长，如何规划幼儿英引引导成长，如何规划幼儿英引引导成长。")
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        
        view.addSubviews([titleLabel, paragraphALabel, subtitleLabel, paragraphBLabel])
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(35)
            make.centerX.equalToSuperview()
        }
        paragraphALabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(titleLabel.snp.bottom).offset(9.5)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(paragraphALabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
        paragraphBLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(12.5)
        }
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============

}
