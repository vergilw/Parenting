//
//  DCourseEvaluationViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/5.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class DCourseEvaluationViewController: BaseViewController {

    fileprivate var courseID: Int = 0
    
    fileprivate var commentModel: CommentModel?
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.text = "请写下您的评价"
        return label
    }()
    
    lazy fileprivate var dismissBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "public_dismissBtn")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIConstants.Color.body
        button.addTarget(self, action: #selector(dismissBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var starsContainerView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 22
        return view
    }()
    
    lazy fileprivate var starsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        label.text = "请点击星星评价"
        return label
    }()
    
    lazy fileprivate var textView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .done
        textView.layer.cornerRadius = 5
        textView.font = UIConstants.Font.body
        textView.textColor = UIConstants.Color.body
        textView.backgroundColor = UIConstants.Color.background
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textView.placeholder = "请输入你想说的话..."
        textView.placeholderColor = UIConstants.Color.foot
        textView.delegate = self
        return textView
    }()
    
    lazy fileprivate var wordsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        label.text = "200"
        return label
    }()
    
    lazy fileprivate var actionBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIConstants.Font.h2
        button.setTitle("提交评价", for: .normal)
        button.backgroundColor = UIConstants.Color.primaryGreen
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(submitBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var selectedStarsCount: Int = 0
    
    fileprivate var completionBlock: ((CommentModel)->())?
    
    init(courseID: Int, model: CommentModel?, completion: @escaping (_ model: CommentModel)->()) {
        super.init(nibName: nil, bundle: nil)
        
        self.courseID = courseID
        commentModel = model
        
        completionBlock = completion
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
        
        reload()
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        
        view.addSubviews([titleLabel, dismissBtn, starsContainerView, starsTitleLabel, textView, wordsCountLabel, actionBtn])
        addStar(tag: 1)
        addStar(tag: 2)
        addStar(tag: 3)
        addStar(tag: 4)
        addStar(tag: 5)
    }
    
    func addStar(tag: Int) {
        let starBtn: UIButton = {
            let button = UIButton()
            button.tag = tag
            button.tintColor = UIConstants.Color.disable
            button.setImage(UIImage(named: "course_star")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.addTarget(self, action: #selector(starBtnAction(sender:)), for: .touchUpInside)
            return button
        }()
        starsContainerView.addArrangedSubview(starBtn)
        
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(UIConstants.Margin.top)
        }
        let size = dismissBtn.currentImage!.size
        dismissBtn.snp.makeConstraints { make in
            make.trailing.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(size.width+UIConstants.Margin.leading*2)
            make.height.equalTo(size.height+UIConstants.Margin.top*2)
        }
        
        starsContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(55)
        }
        starsTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(starsContainerView)
            make.top.equalTo(starsContainerView.snp.bottom).offset(13.5)
        }
        textView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(starsTitleLabel.snp.bottom).offset(40)
            make.height.equalTo(100)
        }
        wordsCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(textView.snp.trailing).offset(-15)
            make.bottom.equalTo(textView.snp.bottom).offset(-10)
        }
        actionBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading+25)
            make.trailing.equalTo(-UIConstants.Margin.trailing-25)
//            make.top.equalTo(textView.snp.bottom).offset(80)
            make.height.equalTo(50)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            } else {
                make.bottom.equalTo(-32)
            }
        }
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        guard let commentModel = commentModel else { return }
        
        let starBtn1 = starsContainerView.viewWithTag(1) as! UIButton
        starBtn1.isUserInteractionEnabled = false
        let starBtn2 = starsContainerView.viewWithTag(2) as! UIButton
        starBtn2.isUserInteractionEnabled = false
        let starBtn3 = starsContainerView.viewWithTag(3) as! UIButton
        starBtn3.isUserInteractionEnabled = false
        let starBtn4 = starsContainerView.viewWithTag(4) as! UIButton
        starBtn4.isUserInteractionEnabled = false
        let starBtn5 = starsContainerView.viewWithTag(5) as! UIButton
        starBtn5.isUserInteractionEnabled = false
        
        textView.isEditable = false
        
        wordsCountLabel.isHidden = true
        actionBtn.isHidden = true
        
        titleLabel.text = "我的评价"
        
        if let starsCount = commentModel.star {
            let starBtn = starsContainerView.viewWithTag(starsCount) as! UIButton
            starBtn.sendActions(for: .touchUpInside)
        }
        
        
        if let evaluationContent = commentModel.content, evaluationContent != "" {
            textView.text = evaluationContent
            textView.backgroundColor = .white
            
            textView.snp.remakeConstraints { make in
                make.leading.equalTo(UIConstants.Margin.leading)
                make.trailing.equalTo(-UIConstants.Margin.trailing)
                make.top.equalTo(starsTitleLabel.snp.bottom).offset(40)
                if #available(iOS 11.0, *) {
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40-32)
                } else {
                    make.bottom.equalTo(-32)
                }
            }
        } else {
            textView.isHidden = true
        }
    }
    
    func reloadStarsBtn(starsCount: Int) {
        let starBtn1 = starsContainerView.viewWithTag(1) as! UIButton
        starBtn1.tintColor = starsCount > 0 ? UIColor("#f6a500") : UIConstants.Color.disable
        
        let starBtn2 = starsContainerView.viewWithTag(2) as! UIButton
        starBtn2.tintColor = starsCount > 1 ? UIColor("#f6a500") : UIConstants.Color.disable
        
        let starBtn3 = starsContainerView.viewWithTag(3) as! UIButton
        starBtn3.tintColor = starsCount > 2 ? UIColor("#f6a500") : UIConstants.Color.disable
        
        let starBtn4 = starsContainerView.viewWithTag(4) as! UIButton
        starBtn4.tintColor = starsCount > 3 ? UIColor("#f6a500") : UIConstants.Color.disable
        
        let starBtn5 = starsContainerView.viewWithTag(5) as! UIButton
        starBtn5.tintColor = starsCount > 4 ? UIColor("#f6a500") : UIConstants.Color.disable
    }
    
    // MARK: - ============= Action =============
    
    @objc func dismissBtnAction() {
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func starBtnAction(sender: UIButton) {
        selectedStarsCount = sender.tag
        
        reloadStarsBtn(starsCount: sender.tag)
        
        if sender.tag == 1 {
            starsTitleLabel.text = "很不满意"
        } else if sender.tag == 2 {
            starsTitleLabel.text = "不太满意"
        } else if sender.tag == 3 {
            starsTitleLabel.text = "一般般"
        } else if sender.tag == 4 {
            starsTitleLabel.text = "比较满意"
        } else if sender.tag == 5 {
            starsTitleLabel.text = "非常满意"
        }
    }
    
    @objc func submitBtnAction() {
        guard selectedStarsCount != 0 else {
            let HUD = MBProgressHUD.showAdded(to: view, animated: true)
            HUD.mode = .text
            HUD.detailsLabel.text = "请先评星"
            HUD.hide(animated: true, afterDelay: 1.5)
            return
        }
        
        CourseProvider.request(.post_comment(courseID: courseID, starsCount: selectedStarsCount, content: textView.text), completion: ResponseService.sharedInstance.response(completion: { [weak self] (code, JSON) in
            if code != -1 {
                HUDService.sharedInstance.show(string: "您已成功提交评价")
                //let model = CommentModel.deserialize(from: JSON),
                if let block = self?.completionBlock {
                    let model = CommentModel()
                    model.star = self?.selectedStarsCount
                    model.content = self?.textView.text
                    block(model)
                }
                self?.dismissBtnAction()
            }
        }))
        
        
    }
}


extension DCourseEvaluationViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.length == 0 && text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        let resultString = NSString(string: textView.text).replacingCharacters(in: range, with: text)
        if resultString.count > 200 {
            return false
        }
        wordsCountLabel.text = String(format: "%d", 200-resultString.count)
        return true
    }
}
