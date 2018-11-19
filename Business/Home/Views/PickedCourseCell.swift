//
//  PickedCourseCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/24.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class PickedCourseCell: UICollectionViewCell {
    
    lazy fileprivate var previewImgView: UIImageView = {
        let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
        let imgView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: width/16.0*9)))
//        imgView.image = UIImage(named: <#T##String#>)
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy fileprivate var titleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.head
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
        return label
    }()

    lazy fileprivate var avatarImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_avatarPlaceholder")?.byResize(to: CGSize(width: 20, height: 20))
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy fileprivate var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews([previewImgView, titleLabel, avatarImgView, nameLabel])
        
        let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
        previewImgView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(width/16.0*9)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.top.equalTo(previewImgView.snp.bottom).offset(12)
        }
        avatarImgView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImgView.snp.trailing).offset(4)
            make.centerY.equalTo(avatarImgView)
            make.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        
        let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2*2
        let processor = RoundCornerImageProcessor(cornerRadius: 8, targetSize: CGSize(width: width, height: width/16.0*9))
        previewImgView.kf.setImage(with: URL(string: "http://cloud.1314-edu.com/yVstTMQcm6uYCt5an9HpPxgJ"), options: [.processor(processor)])
        
        titleLabel.setParagraphText("科学护肤指南，找到你的专属护肤方案")
        nameLabel.text = "Acmde丨全职妈妈"
    }
}
