//
//  VideoUserHeaderView.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/10.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class VideoUserHeaderView: UICollectionReusableView {
    
    lazy fileprivate var avatarBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 34
        button.clipsToBounds = true
        button.setImage(UIImage(named: "public_avatarPlaceholder"), for: .normal)
        //        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h1
        label.textColor = UIConstants.Color.head
        label.setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        return label
    }()
    
    fileprivate lazy var badgeImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    
    lazy fileprivate var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    lazy fileprivate var videosCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.textAlignment = .center
        return label
    }()
    
    lazy fileprivate var likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.textAlignment = .center
        return label
    }()
    
    lazy fileprivate var commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //profiles view
        let profilesStackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .leading
            view.axis = .vertical
            view.distribution = .fillProportionally
            view.spacing = 7
            return view
        }()
        profilesStackView.addArrangedSubview(nameLabel)
        profilesStackView.addArrangedSubview(descriptionLabel)
        
        addSubviews([avatarBtn, profilesStackView])
        
        profilesStackView.addSubview(badgeImgView)
        
        avatarBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(UIConstants.Margin.leading)
            make.size.equalTo(CGSize(width: 68, height: 68))
        }
        profilesStackView.snp.makeConstraints { make in
            make.leading.equalTo(avatarBtn.snp.trailing).offset(15)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalTo(avatarBtn)
        }
        badgeImgView.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(5)
            make.centerY.equalTo(nameLabel)
            make.trailing.equalTo(-10).priority(.required)
        }
        
        
        
        //statistics view
        let statisticsStackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .fill
            view.axis = .horizontal
            view.distribution = .fillEqually
            return view
        }()
        statisticsStackView.addArrangedSubview(videosCountLabel)
        statisticsStackView.addArrangedSubview(likeCountLabel)
        statisticsStackView.addArrangedSubview(commentCountLabel)
        
        addSubview(statisticsStackView)
        statisticsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-15)
            make.height.equalTo(60)
        }
        
        drawSeparator(startPoint: CGPoint(x: 0, y: 164.5), endPoint: CGPoint(x: UIScreenWidth, y: 164.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(model: UserModel) {
        if let URLString = model.avatar_url {
            avatarBtn.kf.setImage(with: URL(string: URLString), for: .normal, placeholder: UIImage(named: "public_avatarPlaceholder"))
        }
        
        nameLabel.text = model.name
        
        descriptionLabel.text = model.intro
        
        if let URLString = model.badge {
            badgeImgView.kf.setImage(with: URL(string: URLString), placeholder: nil, options: nil, progressBlock: nil) { (image, error, type, url) in
                if let image = image {
                    self.badgeImgView.snp.remakeConstraints { make in
                        make.leading.equalTo(self.nameLabel.snp.trailing).offset(5)
                        make.centerY.equalTo(self.nameLabel)
                        make.size.equalTo(CGSize(width: 20/image.size.height*image.size.width, height: 20))
                    }
                    self.badgeImgView.image = image
                }
            }
        }
        
        var string = "\(model.videos_count ?? 0) 视频"
        var attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes([NSAttributedString.Key.font: UIConstants.Font.foot], range: NSString(string: string).range(of: "视频"))
        videosCountLabel.attributedText = attributedString
        
        string = "\(model.video_liked_count ?? 0) 点赞"
        attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes([NSAttributedString.Key.font: UIConstants.Font.foot], range: NSString(string: string).range(of: "点赞"))
        likeCountLabel.attributedText = attributedString
        
        string = "\(model.video_comments_count ?? 0) 评论"
        attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes([NSAttributedString.Key.font: UIConstants.Font.foot], range: NSString(string: string).range(of: "评论"))
        commentCountLabel.attributedText = attributedString
    }
}
