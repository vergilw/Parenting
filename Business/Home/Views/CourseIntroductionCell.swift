//
//  CourseIntroductionCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/24.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class CourseIntroductionCell: UITableViewCell {

    lazy var courseBriefLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing
        return label
    }()
    
    lazy var teacherTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.text = "讲师介绍"
        return label
    }()
    
    lazy fileprivate var profileView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy fileprivate var teacherAvatarImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "public_avatarPlaceholder")
        imgView.layer.cornerRadius = 22.5
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy fileprivate var subProfileView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var teacherNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h3
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy var teacherTagLabel: UILabel = {
        let label = UILabel()
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
        label.textColor = UIConstants.Color.body
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-30
        return label
    }()
    
    lazy var courseTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.text = "课程介绍"
        return label
    }()
    
    lazy fileprivate var courseImgContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var noteTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.text = "听课指南"
        return label
    }()
    
    lazy fileprivate var noteImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "course_noteImg")
        imgView.contentMode = .scaleToFill
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
        
        contentView.addSubviews(courseBriefLabel, teacherTitleLabel, profileView, teacherBriefBgImgView, teacherBriefLabel, courseTitleLabel, courseImgContainerView, noteTitleLabel, noteImgView)
        profileView.addSubviews(teacherAvatarImgView, subProfileView)
        subProfileView.addSubviews(teacherNameLabel, teacherTagLabel)
        
        courseBriefLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.top.equalTo(32)
        }
        teacherTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(courseBriefLabel.snp.bottom).offset(60)
        }
        profileView.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(teacherTitleLabel.snp.bottom).offset(32)
//            make.height.equalTo(35)
        }
        subProfileView.snp.makeConstraints { make in
            make.leading.equalTo(profileView.snp.trailing).offset(10)
            make.trailing.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(34)
        }
        teacherAvatarImgView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(profileView)
            make.height.equalTo(45)
            make.width.equalTo(45)
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
        teacherBriefLabel.snp.makeConstraints { make in
            make.leading.equalTo(40)
            make.trailing.equalTo(-40)
            make.top.equalTo(profileView.snp.bottom).offset(45)
        }
        teacherBriefBgImgView.snp.makeConstraints { make in
            make.leading.equalTo(teacherBriefLabel.snp.leading).offset(-15)
            make.trailing.equalTo(teacherBriefLabel.snp.trailing).offset(15)
            make.top.equalTo(teacherBriefLabel.snp.top).offset(-32)
            make.bottom.equalTo(teacherBriefLabel.snp.bottom).offset(24)
        }
        courseTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(teacherBriefLabel.snp.bottom).offset(84)
        }
        courseImgContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(courseTitleLabel.snp.bottom).offset(32)
        }
        noteTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(courseImgContainerView.snp.bottom).offset(60)
            
        }
        noteImgView.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(noteTitleLabel.snp.bottom).offset(32)
            make.height.equalTo(942.0/750*(UIScreenWidth))
            make.bottom.equalTo(-45)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(model: CourseModel) {
        
        courseBriefLabel.setParagraphText(model.sub_title ?? "")
        
        teacherNameLabel.text = model.teacher?.name
        
        if let avatarURL = model.teacher?.headshot_attribute?.service_url {
            teacherAvatarImgView.kf.setImage(with: URL(string: avatarURL))
        }
        
        if let tags = model.teacher?.tags {
            let tagString = tags.joined(separator: " | ")
            teacherTagLabel.text = tagString
        }
        
        courseImgContainerView.removeAllSubviews()
        var containerHeight: CGFloat = 0
        for imgAsset in model.content_images_attribute ?? [] {
            guard let height = imgAsset.height, let width = imgAsset.width else { continue }
            
            let imgView: UIImageView = {
                let imgView = UIImageView()
                imgView.kf.setImage(with: URL(string: imgAsset.service_url ?? ""))
                imgView.contentMode = .scaleToFill
                return imgView
            }()
            courseImgContainerView.addSubview(imgView)
            
            let layoutHeight = CGFloat(height)/CGFloat(width)*(UIScreenWidth)
            imgView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(containerHeight)
                make.height.equalTo(layoutHeight)
            }
            containerHeight += layoutHeight
        }
        courseImgContainerView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(courseTitleLabel.snp.bottom).offset(32)
            make.height.equalTo(containerHeight)
        }
        
        teacherBriefLabel.setParagraphText(model.teacher?.description ?? "")
    }
}
