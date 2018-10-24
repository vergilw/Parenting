//
//  CourseIntroductionCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/24.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class CourseIntroductionCell: UITableViewCell {

    lazy var courseBriefLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 50
        return label
    }()
    
    lazy var teacherTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "讲师介绍"
        return label
    }()
    
    lazy fileprivate var profileView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 10
        return view
    }()
    
    lazy fileprivate var teacherAvatarImgView: UIImageView = {
        let imgView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 35, height: 35)))
        imgView.backgroundColor = .gray
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "public_shareBarItem")
        return imgView
    }()
    
    lazy fileprivate var subProfileView: UIStackView = {
        let view = UIStackView()
        view.alignment = .leading
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 10
        return view
    }()
    
    lazy var teacherNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    lazy var teacherTagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    lazy var teacherBriefLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 50
        return label
    }()
    
    lazy var courseTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "课程介绍"
        return label
    }()
    
    lazy var noteTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "听课指南"
        return label
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
        
        contentView.addSubviews(courseBriefLabel, teacherTitleLabel, profileView, teacherBriefLabel, courseTitleLabel, noteTitleLabel)
        profileView.addArrangedSubview(teacherAvatarImgView)
        profileView.addArrangedSubview(subProfileView)
        subProfileView.addArrangedSubview(teacherNameLabel)
        subProfileView.addArrangedSubview(teacherTagLabel)
        
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
//        teacherAvatarImgView.snp.makeConstraints { make in
//            make.leading.top.bottom.equalToSuperview()
//            make.height.equalTo(teacherAvatarImgView.snp.width)
//        }
        teacherBriefLabel.snp.makeConstraints { make in
            make.leading.equalTo(40)
            make.trailing.equalTo(-40)
            make.top.equalTo(profileView.snp.bottom).offset(45)
        }
        courseTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(teacherBriefLabel.snp.bottom).offset(84)
        }
        noteTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(courseTitleLabel.snp.bottom).offset(60)
            make.bottom.equalTo(-45)
        }
        
        var attributedString = NSMutableAttributedString(string: "小孩子吵着肚子饿的时候，拿出一颗蛋就能快速变成美味料理。但是，如果天天都是简单的煮鸡蛋或荷包蛋，孩子肯定会感到烦腻。")
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 12
        attributedString.addAttributes([
            NSAttributedString.Key.paragraphStyle: paragraph], range: NSRange(location: 0, length: attributedString.length))
        courseBriefLabel.attributedText = attributedString
        
        teacherNameLabel.text = "vergilw"
        teacherTagLabel.text = "全职妈妈 | 心理咨询"
        
        attributedString = NSMutableAttributedString(string: "沈从文是现代著名作家、历史文物研究家、京派小说代表人物。14岁时，他投身行伍，浪迹湘川黔边境地区。这里的介绍不超过100个中文字。")
        attributedString.addAttributes([
            NSAttributedString.Key.paragraphStyle: paragraph], range: NSRange(location: 0, length: attributedString.length))
        teacherBriefLabel.attributedText = attributedString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
