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
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
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
        label.font = UIConstants.Font.h4
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var starsStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 5
        return view
    }()
    
    lazy fileprivate var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot2
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    lazy fileprivate var evluationLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.preferredMaxLayoutWidth = UIScreenWidth - contentView.layoutMargins.left - contentView.layoutMargins.right - 30
        label.numberOfLines = 0
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
        
        contentView.layoutMargins = UIEdgeInsets(top: 16, left: 25, bottom: 16, right: 25)
        
        contentView.addSubviews([teacherAvatarImgView, teacherNameLabel, starsStackView, timeLabel, evluationBgImgView, evluationLabel])
        
        teacherAvatarImgView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp_leadingMargin)
            make.top.equalTo(contentView.snp_topMargin)
            make.size.equalTo(UIConstants.Size.avatar)
        }
        teacherNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(teacherAvatarImgView.snp.trailing).offset(10)
            make.bottom.equalTo(teacherAvatarImgView.snp.centerY).offset(-1.5)
            make.trailing.lessThanOrEqualTo(-25)
        }
        starsStackView.snp.makeConstraints { make in
            make.leading.equalTo(teacherNameLabel)
            make.bottom.equalTo(teacherAvatarImgView).offset(1)
//            make.height.equalTo(12)
//            make.width.equalTo(80)
        }
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp_trailingMargin)
            make.centerY.equalTo(starsStackView)
        }
        evluationLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp_leadingMargin).offset(15)
            make.trailing.lessThanOrEqualTo(contentView.snp_trailingMargin).offset(-15)
            make.top.equalTo(teacherAvatarImgView.snp.bottom).offset(45)
            make.bottom.equalTo(contentView.snp_bottomMargin).offset(-24)
        }
        evluationBgImgView.snp.makeConstraints { make in
            make.top.equalTo(evluationLabel.snp.top).offset(-32)
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.bottom.equalTo(evluationLabel.snp.bottom).offset(24)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(model: CommentModel) {
        teacherNameLabel.text = model.user_name
        
        if let avatarURL = model.user_avatar {
            teacherAvatarImgView.kf.setImage(with: URL(string: avatarURL), placeholder: UIImage(named: "public_avatarPlaceholder"))
        }
        
        if let timestamp = model.created_at_timestamp {
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            timeLabel.text = date.string(format: "yyyy-MM-dd HH:mm")
        }
        
        starsStackView.removeAllSubviews()
        if let starCount = model.star {
            addStar(isHighlight: starCount > 0)
            addStar(isHighlight: starCount > 1)
            addStar(isHighlight: starCount > 2)
            addStar(isHighlight: starCount > 3)
            addStar(isHighlight: starCount > 4)
        }
        
        evluationLabel.setParagraphText(model.content ?? "")
    }
    
    func addStar(isHighlight: Bool) {
        let starImgView: UIImageView = {
            let imgView = UIImageView()
            if isHighlight {
                imgView.image = UIImage(named: "course_star")?.byResize(to: CGSize(width: 12, height: 12))?.withRenderingMode(.alwaysOriginal)
            } else {
                imgView.image = UIImage(named: "course_star")?.byResize(to: CGSize(width: 12, height: 12))?.withRenderingMode(.alwaysTemplate)
                imgView.tintColor = UIConstants.Color.disable
            }
            return imgView
        }()
        starsStackView.addArrangedSubview(starImgView)

    }
}
