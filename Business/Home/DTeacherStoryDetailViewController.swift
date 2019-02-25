//
//  DTeacherStoryDetailViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/20.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import HandyJSON

class DTeacherStoryDetailViewController: BaseViewController {

    var storyID: Int = 0
    
    fileprivate var storyModel: StoryModel?
    
    lazy fileprivate var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    fileprivate lazy var previewImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_coursePlaceholder")
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
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
        imgView.layer.cornerRadius = 23
        imgView.clipsToBounds = true
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
        label.lineBreakMode = .byCharWrapping
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
    
    init(storyID: Int) {
        super.init(nibName: nil, bundle: nil)
        self.storyID = storyID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "故事"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubview(scrollView)
        scrollView.addSubviews([previewImgView, titleLabel, teacherAvatarImgView, teacherNameLabel, teacherTagLabel, teacherBriefBgImgView, teacherBriefLabel, separatorImgView, containerView])
        
        
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        previewImgView.snp.makeConstraints { make in
            let width = UIScreenWidth - UIConstants.Margin.leading - UIConstants.Margin.trailing
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(width/16.0*9)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(previewImgView.snp.bottom).offset(10)
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
    fileprivate func fetchData() {
        HUDService.sharedInstance.showFetchingView(target: self.view)
        
        StoryProvider.request(.story(storyID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            HUDService.sharedInstance.hideFetchingView(target: self.view)
            if code >= 0 {
                if let data = JSON?["data"] as? [String: Any] {
                    self.storyModel = StoryModel.deserialize(from: data)
                    self.reload()
                }
                
            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: self.view) { [weak self] in
                    self?.fetchData()
                }
            }
        }))
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
        if let URLString = storyModel?.cover_image?.service_url {
            previewImgView.kf.setImage(with: URL(string: URLString), placeholder: UIImage(named: "public_coursePlaceholder"))
        }
        
        if let avatarURL = storyModel?.story_teller?.avatar {
//            avatarURL += "?imageMogr2/thumbnail/50x"
            teacherAvatarImgView.kf.setImage(with: URL(string: avatarURL), placeholder: UIImage(named: "public_avatarPlaceholder"))
        }
        
        titleLabel.setParagraphText(storyModel?.title ?? "")
        teacherNameLabel.setParagraphText(storyModel?.story_teller?.name ?? "")
        
        if let tags = storyModel?.story_teller?.tags, tags.count > 0 {
            let tagString = tags.joined(separator: " | ")
            teacherTagLabel.setParagraphText(tagString)
        }
        
        teacherBriefLabel.setParagraphText(storyModel?.story_teller?.description ?? "")
        
        containerView.removeAllSubviews()
        var containerHeight: CGFloat = 0
        for i in 0..<(storyModel?.content_images?.count ?? 0) {
            guard let model = storyModel?.content_images?[exist: i] else { break }
            guard let height = model.height, let width = model.width else { continue }
            guard let URLString = model.service_url else { continue }
            
            let imgView: UIImageView = {
                let imgView = UIImageView()
                imgView.kf.setImage(with: URL(string: URLString))
                imgView.contentMode = .scaleToFill
                return imgView
            }()
            containerView.addSubview(imgView)
            
            let layoutHeight = CGFloat(height)/CGFloat(width)*(UIScreenWidth)
            imgView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(containerHeight)
                make.height.equalTo(layoutHeight)
            }
            containerHeight += layoutHeight
        }
        containerView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(separatorImgView.snp.bottom).offset(32)
            make.bottom.equalTo(-UIConstants.Margin.bottom)
            make.height.equalTo(containerHeight)
        }
        
    }
    
    // MARK: - ============= Action =============

}
