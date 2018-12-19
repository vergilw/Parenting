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
    
    enum DisplayMode {
        case picked
        case latest
    }
    
    lazy fileprivate var displayMode: DisplayMode = .picked
    
    lazy fileprivate var previewImgView: UIImageView = {
        let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
        let imgView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: width/16.0*9)))
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy fileprivate var gradientShadowImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "me_courseGradientShadow")
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    
    lazy fileprivate var footnoteLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        return label
    }()
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.head
//        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        label.preferredMaxLayoutWidth = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
        return label
    }()

    lazy fileprivate var avatarImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_avatarPlaceholder")?.byResize(to: CGSize(width: 20, height: 20))
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy fileprivate var nameLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews([previewImgView, titleLabel, nameLabel])
        
//        let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
//        let height = width/16.0*9
//        previewImgView.drawGradientBg(roundedRect: CGRect(origin: CGPoint(x: 0, y: height-10-12-10), size: CGSize(width: width, height: (10+12+10))), colors: [UIColor(white: 1.0, alpha: 0.0).cgColor, UIColor(white: 0.0, alpha: 0.2).cgColor])
        
        previewImgView.addSubviews([gradientShadowImgView, footnoteLabel])
        
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
        gradientShadowImgView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(previewImgView)
        }
//        avatarImgView.snp.makeConstraints { make in
//            make.leading.equalToSuperview()
//            make.top.equalTo(titleLabel.snp.bottom).offset(8)
//            make.size.equalTo(CGSize(width: 20, height: 20))
//        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(previewImgView.snp.bottom).offset(10)
            make.trailing.lessThanOrEqualToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(7)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(model: CourseModel, mode: DisplayMode) {
        if mode != displayMode {
            if mode == .picked {
                nameLabel.isHidden = false
                
                titleLabel.snp.remakeConstraints { make in
                    make.leading.equalToSuperview()
                    make.trailing.lessThanOrEqualToSuperview()
                    make.top.equalTo(nameLabel.snp.bottom).offset(7)
                }
            } else if mode == .latest {
                nameLabel.isHidden = true
                
                titleLabel.snp.remakeConstraints { make in
                    make.leading.equalToSuperview()
                    make.trailing.lessThanOrEqualToSuperview()
                    make.top.equalTo(previewImgView.snp.bottom).offset(10)
                }
            }
            
        }
        
        
        if let URLString = model.cover_attribute?.service_url {
            let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
            let processor = RoundCornerImageProcessor(cornerRadius: 8, targetSize: CGSize(width: width*2, height: width/16.0*9*2))
            previewImgView.kf.setImage(with: URL(string: URLString), options: [.processor(processor)])
        }
        
//        if let URLString = model.teacher?.headshot_attribute?.service_url {
//            let processor = RoundCornerImageProcessor(cornerRadius: 20, targetSize: CGSize(width: 40, height: 40))
//            avatarImgView.kf.setImage(with: URL(string: URLString), placeholder: UIImage(named: "public_avatarPlaceholder"), options: [.processor(processor)])
//        }
        
        footnoteLabel.setParagraphText(String((model.students_count ?? 0)) + "人已学习")
        
        var nameString = model.teacher?.name ?? ""
        if let tags = model.teacher?.tags, tags.count > 0 {
            let tagString = tags.joined(separator: " | ")
            nameString = nameString.appendingFormat(" : %@", tagString)
        }
        nameLabel.setParagraphText(nameString)
        
        
        
        
        let paragraph = NSMutableParagraphStyle()
        let lineHeight: CGFloat = 18.5
        paragraph.maximumLineHeight = lineHeight
        paragraph.minimumLineHeight = lineHeight
        paragraph.lineBreakMode = .byTruncatingTail
        
        let attributedString = NSMutableAttributedString(string: model.title ?? "")
        attributedString.addAttributes([
            NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.baselineOffset: (lineHeight-titleLabel.font.lineHeight)/4+1.25, NSAttributedString.Key.font: titleLabel.font], range: NSRange(location: 0, length: attributedString.length))
        titleLabel.attributedText = attributedString
    }
}
