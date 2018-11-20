//
//  DTeacherStoryDetailViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/20.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DTeacherStoryDetailViewController: BaseViewController {

    lazy fileprivate var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    lazy fileprivate var titleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h1
        label.textColor = UIConstants.Color.head
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing
        return label
    }()
    
    lazy fileprivate var teacherAvatarImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "public_avatarPlaceholder")
        return imgView
    }()
    
    lazy var teacherNameLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h3
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy var teacherTagLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    lazy fileprivate var teacherBriefBgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "course_chatBubble")?.resizableImage(withCapInsets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        return imgView
    }()
    
    lazy var teacherBriefLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.subhead
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-30
        return label
    }()
    
    lazy fileprivate var separatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.drawSeparator(startPoint: CGPoint(x: UIConstants.Margin.leading, y: 0), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.trailing, y: 0))
        return imgView
    }()
    
    lazy fileprivate var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "故事"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        reload()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubview(scrollView)
        scrollView.addSubviews([titleLabel, teacherAvatarImgView, teacherNameLabel, teacherTagLabel, teacherBriefBgImgView, teacherBriefLabel, separatorImgView, containerView])
        
        
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(UIConstants.Margin.top)
        }
        teacherAvatarImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.size.equalTo(CGSize(width: 46, height: 46))
        }
        teacherNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(teacherAvatarImgView.snp.trailing).offset(10)
            make.top.equalTo(teacherAvatarImgView.snp.top).offset(5)
        }
        teacherTagLabel.snp.makeConstraints { make in
            make.leading.equalTo(teacherAvatarImgView.snp.trailing).offset(10)
            make.top.equalTo(teacherNameLabel.snp.bottom).offset(8)
        }
        teacherBriefLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading+15)
            make.trailing.equalTo(-UIConstants.Margin.trailing-15)
            make.width.equalTo(UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-30)
            make.top.equalTo(teacherAvatarImgView.snp.bottom).offset(45)
        }
        teacherBriefBgImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(teacherBriefLabel.snp.top).offset(-32)
            make.bottom.equalTo(teacherBriefLabel.snp.bottom).offset(24)
        }
        separatorImgView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(teacherBriefBgImgView.snp.bottom).offset(32)
            make.height.equalTo(1)
        }
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(separatorImgView.snp.bottom).offset(32)
            make.bottom.equalTo(-UIConstants.Margin.bottom)
            make.height.equalTo(200)
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        titleLabel.setParagraphText("一个育儿专家，是怎么把教父母如何哄宝宝睡觉变成一门大生意的？")
        teacherNameLabel.setParagraphText("橙子老师")
        teacherTagLabel.setParagraphText("全职妈妈丨心理咨询")
        teacherBriefLabel.setParagraphText("沈从文是现代著名作家、历史文物研究家、京派小说代表人物。14岁时，他投身行伍，浪迹湘川黔边境地区。这里的介绍不超过100个中文字.")
        
    }
    
    // MARK: - ============= Action =============

}
