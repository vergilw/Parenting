//
//  DFeedbackViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/22.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DFeedbackViewController: BaseViewController {

    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.text = "在使用过程中碰到了问题？"
        return label
    }()
    
    lazy fileprivate var textView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .default
        textView.layer.cornerRadius = 4
        textView.backgroundColor = UIConstants.Color.background
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textView.font = UIConstants.Font.body
        textView.placeholder = "输入反馈或建议..."
        textView.delegate = self
        return textView
    }()
    
    lazy fileprivate var footnoteLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing
        label.text = "非常感谢您的宝贵建议！氧育团队将及时查看并尽快与您取得联系，希望能为您提供更好的产品体验。 "
        return label
    }()
    
    lazy fileprivate var actionBtn: ActionButton = {
        let button = ActionButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIConstants.Font.h2
        button.setTitle("提交反馈", for: .normal)
        button.backgroundColor = UIConstants.Color.disable
        button.isEnabled = false
        button.layer.cornerRadius = 21
        button.addTarget(self, action: #selector(submitBtnAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "意见反馈"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubviews([titleLabel, textView, footnoteLabel, actionBtn])
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(60)
        }
        textView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(110)
        }
        footnoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(textView.snp.bottom).offset(15)
        }
        actionBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading+15)
            make.trailing.equalTo(-UIConstants.Margin.trailing-15)
            make.top.equalTo(footnoteLabel.snp.bottom).offset(15)
            make.height.equalTo(42)
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
    @objc func submitBtnAction() {
        view.endEditing(true)
        
        let text = textView.text ?? ""//.replacingOccurrences(of: "\\s", with: "", options: String.CompareOptions.regularExpression)
        
        guard text.count != 0 else {
            HUDService.sharedInstance.show(string: "内容不能为空")
            return
        }
        
        actionBtn.startAnimating()
        CommonProvider.request(.feedback(text), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            self.actionBtn.stopAnimating()
            
            if code >= 0 {
                self.textView.isEditable = false
                self.textView.textColor = UIConstants.Color.foot
                self.actionBtn.isEnabled = false
                self.actionBtn.backgroundColor = UIConstants.Color.disable
                
                let alertController = UIAlertController(title: nil, message: "感谢，我们已收到您的反馈信息", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }))
    }
}


extension DFeedbackViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text?.count ?? 0 > 0 {
            actionBtn.isEnabled = true
            actionBtn.backgroundColor = UIConstants.Color.primaryGreen
        } else {
            actionBtn.isEnabled = false
            actionBtn.backgroundColor = UIConstants.Color.disable
        }
        
    }
}
