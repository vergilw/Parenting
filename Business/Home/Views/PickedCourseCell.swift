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
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy fileprivate var footnoteLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        return label
    }()
    
    lazy fileprivate var titleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.head
//        label.lineBreakMode = .byCharWrapping
//        label.numberOfLines = 1
//        label.preferredMaxLayoutWidth = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
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
        let height = width/16.0*9
        previewImgView.drawGradientBg(roundedRect: CGRect(origin: CGPoint(x: 0, y: height-10-12-10), size: CGSize(width: width, height: (10+12+10))), colors: [UIColor(white: 1.0, alpha: 0.0).cgColor, UIColor(white: 0.0, alpha: 0.2).cgColor])
        
        previewImgView.addSubview(footnoteLabel)
        
        initConstraints()
    }
    
    fileprivate func initConstraints() {
        let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
        previewImgView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(width/16.0*9)
        }
        footnoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.bottom.equalTo(-10)
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
    
    func setup(model: CourseModel) {
        
        if let URLString = model.cover_attribute?.service_url {
            let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
            let processor = RoundCornerImageProcessor(cornerRadius: 8, targetSize: CGSize(width: width*2, height: width/16.0*9*2))
            previewImgView.kf.setImage(with: URL(string: URLString), options: [.processor(processor)])
        }
        
        if let URLString = model.teacher?.headshot_attribute?.service_url {
            let processor = RoundCornerImageProcessor(cornerRadius: 20, targetSize: CGSize(width: 40, height: 40))
            avatarImgView.kf.setImage(with: URL(string: URLString), options: [.processor(processor)])
        }
        
        footnoteLabel.setParagraphText(String((model.students_count ?? 0)) + "人已学习")
        titleLabel.setParagraphText(model.title ?? "")
        
        nameLabel.text = model.teacher?.name ?? ""
        if let tags = model.teacher?.tags, tags.count > 0 {
            let tagString = tags.joined(separator: " | ")
            nameLabel.text = nameLabel.text?.appendingFormat(" : %@", tagString)
        }
    }
}
