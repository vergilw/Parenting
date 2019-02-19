//
//  DMeSignatureViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/2/19.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class DMeSignatureViewController: BaseViewController {

    lazy fileprivate var textView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .done
        textView.layer.cornerRadius = 4
        textView.backgroundColor = UIConstants.Color.background
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textView.placeholder = "请输入您的签名..."
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubview(textView)
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        textView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(20)
            make.height.equalTo(110)
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
    
    // MARK: - ============= Public =============
    
    // MARK: - ============= Private =============

}
