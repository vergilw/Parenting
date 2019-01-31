//
//  VideoCollectionCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/14.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class VideoCollectionCell: UICollectionViewCell {
    
    lazy fileprivate var previewImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy fileprivate var avatarImgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    lazy fileprivate var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = .white
        label.setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        return label
    }()
    
    lazy fileprivate var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Medium", size: 15)!
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    lazy fileprivate var viewsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        return label
    }()
    
    lazy fileprivate var viewsImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_viewsIcon")
        imgView.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        return imgView
    }()
    
    lazy fileprivate var markImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_rewardMark")
        imgView.isHidden = false
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor("#353535")
        contentView.addSubviews([previewImgView, avatarImgView, nameLabel, contentLabel, viewsCountLabel, viewsImgView, markImgView])
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func initConstraints() {
        previewImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        avatarImgView.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.bottom.equalTo(-10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImgView.snp.trailing).offset(7.5)
            make.centerY.equalTo(avatarImgView)
            make.trailing.lessThanOrEqualTo(viewsImgView.snp.leading).offset(-10)
        }
        viewsCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImgView)
            make.trailing.equalTo(-10)
        }
        viewsImgView.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImgView)
            make.trailing.equalTo(viewsCountLabel.snp.leading).offset(-4)
        }
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.bottom.equalTo(avatarImgView.snp.top).offset(-7.5)
        }
        markImgView.snp.makeConstraints { make in
            make.trailing.equalTo(-10)
            make.top.equalTo(10)
        }
    }
    
    func setup(model: VideoModel) {
        
        if let URLString = model.cover_url {
//            let width = (UIScreenWidth-1)/2.0
//            let processor = RoundCornerImageProcessor(cornerRadius: 0, targetSize: CGSize(width: width*2, height: width/9.0*16*2))
            previewImgView.kf.setImage(with: URL(string: URLString))
        }
        
        if let URLString = model.author?.avatar_url {
            avatarImgView.kf.setImage(with: URL(string: URLString), placeholder: UIImage(named: "public_avatarPlaceholder"))
        }
        
        nameLabel.text = model.author?.name
        
        viewsCountLabel.text = "\(model.view_count ?? "0")"
        
        contentLabel.text = model.title
        
        if model.rewardable == true {
            markImgView.isHidden = false
        } else {
            markImgView.isHidden = true
        }
    }
}
