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
        imgView.image = UIImage(named: "public_coursePlaceholder")
        return imgView
    }()
    
    lazy fileprivate var rewardMarkImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "course_rewardMark")
        imgView.isHidden = true
        return imgView
    }()
    
    lazy fileprivate var footnoteLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot3
        label.textColor = .white
        return label
    }()
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Regular", size: 14)!
        label.textColor = UIConstants.Color.head
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
    
    lazy fileprivate var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews([previewImgView, rewardMarkImgView, titleLabel, nameLabel])
        
        initPreviewFooterView()
        
        initConstraints()
    }
    
    fileprivate func initPreviewFooterView() {
        let stackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .center
            view.axis = .horizontal
            view.distribution = .fillProportionally
            view.spacing = 3
            return view
        }()
        
        let bgImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
            imgView.layer.cornerRadius = 7.5
            imgView.clipsToBounds = true
            return imgView
        }()
        
        let iconImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "course_usersCountMark")
            return imgView
        }()
        
        stackView.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: -8, bottom: 0, right: -8))
        }
        
        stackView.addArrangedSubview(iconImgView)
        stackView.addArrangedSubview(footnoteLabel)
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.trailing.equalTo(previewImgView.snp.trailing).offset(-5-8)
            make.bottom.equalTo(previewImgView.snp.bottom).offset(-5)
            make.height.equalTo(15)
        }
    }
    
    fileprivate func initConstraints() {
        let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
        previewImgView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(width/16.0*9)
        }
        rewardMarkImgView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(previewImgView.snp.bottom).offset(8)
            make.trailing.lessThanOrEqualToSuperview()
            make.height.equalTo(12)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(8-5.6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(model: CourseModel, mode: DisplayMode) {
        if mode != displayMode {
            if mode == .picked {
                titleLabel.snp.remakeConstraints { make in
                    make.leading.equalToSuperview()
                    make.trailing.lessThanOrEqualToSuperview()
                    make.top.equalTo(nameLabel.snp.bottom).offset(7)
                }
                nameLabel.snp.remakeConstraints { make in
                    make.leading.equalToSuperview()
                    make.top.equalTo(previewImgView.snp.bottom).offset(8)
                    make.trailing.lessThanOrEqualToSuperview()
                    make.height.equalTo(12)
                }
                
                
            } else if mode == .latest {
                titleLabel.snp.remakeConstraints { make in
                    make.leading.equalTo(10)
                    make.trailing.lessThanOrEqualTo(-10)
                    make.top.equalTo(previewImgView.snp.bottom).offset(7)
                }
                nameLabel.snp.remakeConstraints { make in
                    make.leading.equalTo(10)
                    make.trailing.lessThanOrEqualTo(-10)
                    make.top.equalTo(titleLabel.snp.bottom).offset(10)
                    make.height.equalTo(12)
                }
                
                layer.cornerRadius = 4
                layer.backgroundColor = UIColor.white.cgColor
                layer.shadowRadius = 4
                layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
                layer.shadowOpacity = 0.05
                layer.shadowColor = UIColor.black.cgColor
            }
            
            displayMode = mode
        }
        
        
        if model.rewardable == true {
            rewardMarkImgView.isHidden = false
        } else {
            rewardMarkImgView.isHidden = true
        }
        
        
        if let URLString = model.cover_attribute?.service_url {
            let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
            let processor = RoundCornerImageProcessor(cornerRadius: 8, targetSize: CGSize(width: width*2, height: width/16.0*9*2))
            previewImgView.kf.setImage(with: URL(string: URLString), placeholder: UIImage(named: "public_coursePlaceholder"), options: [.processor(processor)])
        }
        
        footnoteLabel.text = String((model.students_count ?? 0)).simplifiedNumber()
        
        var nameString = model.teacher?.name ?? ""
        if let tags = model.teacher?.tags, tags.count > 0 {
            let tagString = tags.joined(separator: " | ")
            nameString = nameString.appendingFormat(" : %@", tagString)
        }
        nameLabel.text = nameString
        
        
        
        
//        let paragraph = NSMutableParagraphStyle()
//        let lineHeight: CGFloat = 18.5
//        paragraph.maximumLineHeight = lineHeight
//        paragraph.minimumLineHeight = lineHeight
//        paragraph.lineBreakMode = .byTruncatingTail
//
//        let attributedString = NSMutableAttributedString(string: model.title ?? "")
//        attributedString.addAttributes([
//            NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.baselineOffset: (lineHeight-titleLabel.font.lineHeight)/4+1.25, NSAttributedString.Key.font: titleLabel.font], range: NSRange(location: 0, length: attributedString.length))
//        titleLabel.attributedText = attributedString
        
        titleLabel.text = model.title ?? ""
    }
    
    class func cellHeight(title: String) -> CGFloat {
        let maxWidth = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
        let size = NSString(string: title).boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : UIFont(name: "PingFangSC-Regular", size: 14)!], context: nil).size
        
        return maxWidth/16.0*9 + 8 + 12 + 3.4 + size.height
    }
}
