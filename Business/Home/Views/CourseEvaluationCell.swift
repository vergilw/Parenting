//
//  CourseEvaluationCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/26.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class CourseEvaluationCell: UITableViewCell {

    lazy fileprivate var teacherAvatarImgView: UIImageView = {
        let imgView = UIImageView(frame: CGRect(origin: .zero, size: UIConstants.Size.avatar))
        imgView.contentMode = .scaleToFill
        imgView.image = UIImage(named: "public_avatarPlaceholder")
        imgView.layer.cornerRadius = 15
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy fileprivate var subProfileView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy fileprivate var teacherNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h3
        label.textColor = UIColor("#101010")
        return label
    }()
    
    lazy fileprivate var teacherTagLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIColor("#777")
        return label
    }()
    
    lazy fileprivate var evluationLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    lazy fileprivate var evluationBgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "course_chatBubble")?.resizableImage(withCapInsets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
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
        
        contentView.addSubviews([teacherAvatarImgView, teacherNameLabel, teacherTagLabel, evluationBgImgView, evluationLabel])
        
        
        contentView.layoutMargins = UIEdgeInsets(top: 16, left: 25, bottom: 16, right: 25)
        
        teacherAvatarImgView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp_leadingMargin)
            make.top.equalTo(contentView.snp_topMargin)
            make.size.equalTo(UIConstants.Size.avatar)
            make.bottom.equalTo(contentView.snp_bottomMargin)
        }
        teacherNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(teacherAvatarImgView.snp.trailing).offset(10)
            make.bottom.equalTo(teacherAvatarImgView.snp.centerY).offset(-1.5)
            make.trailing.greaterThanOrEqualTo(-25)
        }
        teacherTagLabel.snp.makeConstraints { make in
            make.leading.equalTo(teacherAvatarImgView.snp.trailing).offset(10)
            make.top.equalTo(teacherAvatarImgView.snp.centerY).offset(3.5)
        }
        evluationLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp_leadingMargin).offset(15)
            make.trailing.equalTo(contentView.snp_leadingMargin).offset(-15)
            make.top.equalTo(teacherAvatarImgView.snp.bottom).offset(45)
            make.bottom.equalTo(contentView.snp_topMargin).offset(24)
        }
        evluationBgImgView.snp.makeConstraints { make in
            make.top.equalTo(teacherAvatarImgView.snp.bottom).offset(-32)
            make.leading.equalTo(evluationLabel.snp.leading).offset(-15)
            make.trailing.equalTo(evluationLabel.snp.trailing).offset(15)
            make.bottom.equalTo(evluationLabel.snp.bottom).offset(24)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        teacherNameLabel.text = "Ndesw"//model.teacher?.name
        
//        if let avatarURL = model.teacher?.headshot_attribute?.service_url {
//            teacherAvatarImgView.kf.setImage(with: URL(string: avatarURL))
//        }
        
//        if let tags = model.teacher?.tags {
//            let tagString = tags.joined(separator: " | ")
//            teacherTagLabel.text = tagString
//        }
        
        let attributedString = NSMutableAttributedString(string: "信息量很大，都是干货，准备去逐条细化、实践。超赞～ 给了很多启发。信息量很大，都是干货，准备去逐条细化、实践。超赞～ 给了很多启发。" ?? "")
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 12
        attributedString.addAttributes([
            NSAttributedString.Key.paragraphStyle: paragraph], range: NSRange(location: 0, length: attributedString.length))
        evluationLabel.attributedText = attributedString
        
        let titleHeight = evluationLabel.systemLayoutSizeFitting(CGSize(width: UIScreenWidth-50-30, height: CGFloat.greatestFiniteMagnitude)).height
        if titleHeight < evluationLabel.font.lineHeight*2 {
            let attributedString = NSMutableAttributedString(string: "信息量很大，都是干货，准备去逐条细化、实践。超赞～ 给了很多启发。信息量很大，都是干货，准备去逐条细化、实践。超赞～ 给了很多启发。" ?? "")
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 0
            attributedString.addAttributes([
                NSAttributedString.Key.paragraphStyle: paragraph], range: NSRange(location: 0, length: attributedString.length))
            evluationLabel.attributedText = attributedString
            
            
            evluationLabel.snp.remakeConstraints { make in
                make.leading.equalTo(contentView.snp_leadingMargin).offset(15)
                make.trailing.equalTo(contentView.snp_leadingMargin).offset(-15)
                make.top.equalTo(teacherAvatarImgView.snp.bottom).offset(45)
                make.bottom.equalTo(contentView.snp_topMargin).offset(24)
                make.height.equalTo(evluationLabel.font.lineHeight)
            }
            
        } else {
            evluationLabel.snp.makeConstraints { make in
                make.leading.equalTo(contentView.snp_leadingMargin).offset(15)
                make.trailing.equalTo(contentView.snp_leadingMargin).offset(-15)
                make.top.equalTo(teacherAvatarImgView.snp.bottom).offset(45)
                make.bottom.equalTo(contentView.snp_topMargin).offset(24)
            }
        }
    }
}
