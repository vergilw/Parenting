//
//  MessageCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/2/27.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    var messageModel: MessageModel?

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
    
    fileprivate lazy var actionBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(actionBtnAction), for: .touchUpInside)
        return button
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
        contentView.addSubviews([iconImgView, markImgView, typeLabel, titleLabel, bodyLabel, timeLabel, actionBtn])
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
        actionBtn.snp.makeConstraints { make in
            make.leading.trailing.equalTo(bodyLabel)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - ============= Setup Data =============
    func setup(model: MessageModel) {
        messageModel = model
        
        if model.official == true {
            iconImgView.image = UIImage(named: "message_systemType")
            iconImgView.backgroundColor = UIColor("#41a9ff")
            typeLabel.text = "系统消息"
            
            actionBtn.isHidden = true
        } else if model.notifiable_type == "Video" {
            iconImgView.image = UIImage(named: "message_videoType")
            iconImgView.backgroundColor = UIColor("#00cddd")
            typeLabel.text = "视频消息"
            
            actionBtn.isHidden = true
        } else if model.notifiable_type == "PraiseIncome" {
            iconImgView.image = UIImage(named: "message_giftType")
            iconImgView.backgroundColor = UIColor("#ffb701")
            typeLabel.text = "打赏消息"
            
            actionBtn.isHidden = false
        } else if model.notifiable_type == "Attitude" {
            iconImgView.image = UIImage(named: "message_likeType")
            iconImgView.backgroundColor = UIColor("#f26a44")
            typeLabel.text = "点赞消息"
            
            actionBtn.isHidden = false
        } else if model.notifiable_type == "Comment" {
            iconImgView.image = UIImage(named: "message_commentType")
            iconImgView.backgroundColor = UIColor("#89d350")
            typeLabel.text = "评论消息"
            
            actionBtn.isHidden = false
        }
        
        let text = model.title ?? ""
        
        if model.notifiable_type == "PraiseIncome" {
            let attributedString = NSMutableAttributedString(string: text)
            if let expression = try? NSRegularExpression(pattern: "「.+」", options: NSRegularExpression.Options()) {
                let range = expression.rangeOfFirstMatch(in: text, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: text.count))
                attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIConstants.Color.primaryGreen], range: range)
                titleLabel.attributedText = attributedString
            } else {
                titleLabel.text = text
            }
        } else if model.notifiable_type == "Video" {
            
            let attributedString = NSMutableAttributedString(string: text)
            
            var expression = try! NSRegularExpression(pattern: "未通过", options: NSRegularExpression.Options())
            var range = expression.rangeOfFirstMatch(in: text, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: text.count))
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIConstants.Color.primaryRed], range: range)
            
            expression = try! NSRegularExpression(pattern: "已通过", options: NSRegularExpression.Options())
            range = expression.rangeOfFirstMatch(in: text, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: text.count))
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIConstants.Color.primaryGreen], range: range)
            
            titleLabel.attributedText = attributedString
            
        } else {
            titleLabel.text = text
        }
        
        
        bodyLabel.text = model.body
        
        timeLabel.text = model.created_at?.string(format: "yyyy.MM.dd HH:mm")
        
        if model.read_at == nil {
            markImgView.isHidden = false
        } else {
            markImgView.isHidden = true
        }
    }
    
    @objc fileprivate func actionBtnAction() {
        guard let userID = messageModel?.sender?.id else { return }
        
        let viewController = DVideoUserViewController()
        viewController.userID = userID
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
