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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
