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
        textView.font = UIConstants.Font.body
        textView.backgroundColor = UIConstants.Color.background
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.placeholder = "请输入您的签名..."
        textView.delegate = self
        return textView
    }()
    
    fileprivate lazy var saveBtn: ActionButton = {
        let button = ActionButton()
        button.frame = CGRect(origin: .zero, size: CGSize(width: 84, height: 44))
        button.setIndicatorColor(UIConstants.Color.primaryGreen)
        button.setTitleColor(UIConstants.Color.primaryGreen, for: .normal)
        button.titleLabel?.font = UIConstants.Font.h3
        button.setTitle("保存", for: .normal)
        button.addTarget(self, action: #selector(saveBtnAction), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var wordsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot1
        label.textColor = UIConstants.Color.body
        label.text = "0/20"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "编辑签名"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        reload()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubviews([textView, wordsCountLabel])
        
        let barBtnItem = UIBarButtonItem(customView: saveBtn)
        barBtnItem.width = 34+50
        navigationItem.rightBarButtonItem = barBtnItem
        navigationItem.rightMargin = 0
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        textView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(20)
            make.height.equalTo(110)
        }
        wordsCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(textView).offset(10)
            make.bottom.equalTo(textView).offset(-10)
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        if let signature = AuthorizationService.sharedInstance.user?.intro {
            textView.text = signature
            
            if let count = textView.text?.encodingCount() {
                wordsCountLabel.text = "\(20-count/2)/20"
            }
        }
    }
    
    // MARK: - ============= Action =============
    @objc fileprivate func saveBtnAction() {
        view.endEditing(true)

        let text = textView.text?.replacingOccurrences(of: "\\s", with: "", options: String.CompareOptions.regularExpression)

        guard text?.count ?? 0 != 0 else {
            HUDService.sharedInstance.show(string: "签名不能为空")
            return
        }

        guard text?.encodingCount() ?? 0 <= 40 else {
            HUDService.sharedInstance.show(string: "签名长度限制40字符")
            return
        }

        saveBtn.startAnimating()

        UserProvider.request(.updateUser(name: nil, avatar: nil, signature: text), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            self.saveBtn.stopAnimating()

            if code >= 0 {
                if let JSON = JSON, let name = JSON["intro"] as? String {

                    if let model = AuthorizationService.sharedInstance.user {
                        model.intro = name
                        AuthorizationService.sharedInstance.user = model
                        NotificationCenter.default.post(name: Notification.User.userInfoDidChange, object: nil)
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                    HUDService.sharedInstance.show(string: "签名修改成功")
                }
            }
        }))
    }
    
    // MARK: - ============= Public =============
    
    // MARK: - ============= Private =============

}


extension DMeSignatureViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        if let count = textView.text?.encodingCount() {
            wordsCountLabel.text = "\(20-count/2)/20"
        }
    }
}
