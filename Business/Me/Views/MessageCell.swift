//
//  MessageCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/2/27.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    fileprivate lazy var iconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .center
        imgView.layer.cornerRadius = 24
        imgView.clipsToBounds = true
        return imgView
    }()
    
    fileprivate lazy var markImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIConstants.Color.primaryRed
        imgView.layer.cornerRadius = 4
        imgView.layer.borderColor = UIColor.white.cgColor
        imgView.layer.borderWidth = 1
        imgView.clipsToBounds = true
        return imgView
    }()

    fileprivate lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.caption1
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h3
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    fileprivate lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.subhead
        return label
    }()
    
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot2
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        initContentView()
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        contentView.addSubviews([iconImgView, markImgView, typeLabel, titleLabel, bodyLabel, timeLabel])
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        iconImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(15)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        markImgView.snp.makeConstraints { make in
            make.trailing.equalTo(iconImgView).offset(-2)
            make.top.equalTo(iconImgView).offset(2)
            make.size.equalTo(CGSize(width: 8, height: 8))
        }
        typeLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImgView.snp.trailing).offset(10)
            make.top.equalTo(iconImgView).offset(-3)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(typeLabel)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(typeLabel.snp.bottom).offset(4)
        }
        bodyLabel.snp.makeConstraints { make in
            make.leading.equalTo(typeLabel)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalTo(typeLabel)
        }
    }
    
    // MARK: - ============= Setup Data =============
    func setup(model: MessageModel) {
        if model.official == true {
            iconImgView.image = UIImage(named: "message_systemType")
            iconImgView.backgroundColor = UIColor("#41a9ff")
            typeLabel.text = "系统消息"
        } else if model.notifiable_type == "Video" {
            iconImgView.image = UIImage(named: "message_videoType")
            iconImgView.backgroundColor = UIColor("#00cddd")
            typeLabel.text = "视频消息"
        } else if model.notifiable_type == "PraiseIncome" {
            iconImgView.image = UIImage(named: "message_giftType")
            iconImgView.backgroundColor = UIColor("#ffb701")
            typeLabel.text = "打赏消息"
        } else if model.notifiable_type == "Attitude" {
            iconImgView.image = UIImage(named: "message_likeType")
            iconImgView.backgroundColor = UIColor("#f26a44")
            typeLabel.text = "点赞消息"
        } else if model.notifiable_type == "Comment" {
            iconImgView.image = UIImage(named: "message_commentType")
            iconImgView.backgroundColor = UIColor("#89d350")
            typeLabel.text = "评论消息"
        }
        
        titleLabel.text = model.title
        bodyLabel.text = model.body
        
        timeLabel.text = model.created_at?.string(format: "yyyy.MM.dd HH:mm")
        
        if model.read_at == nil {
            markImgView.isHidden = false
        } else {
            markImgView.isHidden = true
        }
    }
}
