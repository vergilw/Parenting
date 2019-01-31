//
//  VideoCommentCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/9.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class VideoCommentCell: UITableViewCell {

    fileprivate var model: VideoCommentModel?
    
    lazy fileprivate var avatarBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
//        button.setImage(UIImage(named: <#T##String#>)?.withRenderingMode(.alwaysTemplate), for: .normal)
//        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    lazy fileprivate var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.head
        label.numberOfLines = 0
        return label
    }()
    
    lazy fileprivate var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    fileprivate lazy var likeBtn: ActionButton = {
        let button = ActionButton()
        button.setIndicatorStyle(style: .gray)
        button.addTarget(self, action: #selector(commentLikeRequest), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    fileprivate lazy var likeImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_commentLikeNormal")
        return imgView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubviews([avatarBtn, nameLabel, contentLabel, timeLabel, likeImgView, likeCountLabel, likeBtn])
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func initConstraints() {
        avatarBtn.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(25)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarBtn.snp.trailing).offset(10)
            make.top.equalTo(avatarBtn)
        }
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarBtn.snp.trailing).offset(10)
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
        }
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarBtn.snp.trailing).offset(10)
            make.top.equalTo(contentLabel.snp.bottom).offset(12)
            make.bottom.equalTo(-12)
        }
        likeCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalTo(likeImgView)
        }
        likeImgView.snp.makeConstraints { make in
            make.trailing.equalTo(likeCountLabel.snp.leading).offset(-4)
            make.centerY.equalTo(nameLabel).offset(1)
        }
        likeBtn.snp.makeConstraints { make in
            make.trailing.equalTo(likeCountLabel.snp.trailing).offset(15)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(40)
            make.leading.equalTo(likeImgView.snp.leading).offset(-15)
        }
    }
    
    func setup(model: VideoCommentModel) {
        self.model = model
        
        if let URLString = model.commenter?.avatar_url {
            avatarBtn.kf.setImage(with: URL(string: URLString), for: .normal, placeholder: UIImage(named: "public_avatarPlaceholder"))
        }
        
        nameLabel.text = "@\(model.commenter?.name ?? "")"
        
        contentLabel.text = model.content
        
        if let date = model.created_at {
            timeLabel.text = date.string(format: "yyyy-MM-yy HH:mm")
        }
        
        if model.liked ?? false {
            likeImgView.image = UIImage(named: "video_commentLikeSelected")
            likeCountLabel.textColor = UIConstants.Color.primaryRed
        } else {
            likeImgView.image = UIImage(named: "video_commentLikeNormal")
            likeCountLabel.textColor = UIConstants.Color.head
        }
        likeCountLabel.text = String(model.liked_count ?? 0)
    }
    
    @objc func commentLikeRequest() {
        guard AuthorizationService.sharedInstance.isSignIn() else {
            let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
            UIApplication.shared.keyWindow?.rootViewController?.present(authorizationNavigationController, animated: true, completion: nil)
            return
        }
        
        guard let commentID = model?.id, let liked = model?.liked else { return }
        
        likeCountLabel.isHidden = true
        likeImgView.isHidden = true
        likeBtn.startAnimating()
        
        VideoProvider.request(.video_comment_like(commentID, liked ? "like_canceled" : "liked"), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            self.likeBtn.stopAnimating()
            self.likeCountLabel.isHidden = false
            self.likeImgView.isHidden = false
            
            if code >= 0 {
                self.model?.liked = !(self.model?.liked ?? false)
                if let likedCount = self.model?.liked_count {
                    if self.model?.liked == false {
                        self.model?.liked_count = likedCount - 1
                        self.likeCountLabel.text = String(likedCount - 1)
                    } else {
                        self.model?.liked_count = likedCount + 1
                        self.likeCountLabel.text = String(likedCount + 1)
                    }
                    
                }
                
                if self.model?.liked == true {
                    self.likeImgView.image = UIImage(named: "video_commentLikeSelected")
                    self.likeCountLabel.textColor = UIConstants.Color.primaryRed
                } else {
                    self.likeImgView.image = UIImage(named: "video_commentLikeNormal")
                    self.likeCountLabel.textColor = UIConstants.Color.head
                }
                
            }
        }))
    }
}
