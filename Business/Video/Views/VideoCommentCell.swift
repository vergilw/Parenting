//
//  VideoCommentCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/9.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class VideoCommentCell: UITableViewCell {

    lazy fileprivate var avatarBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
//        button.setImage(UIImage(named: <#T##String#>)?.withRenderingMode(.alwaysTemplate), for: .normal)
//        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    lazy fileprivate var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.head
        label.numberOfLines = 0
        return label
    }()
    
    lazy fileprivate var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.head
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
        
        contentView.addSubviews([avatarBtn, nameLabel, contentLabel, timeLabel, likeCountLabel])
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func initConstraints() {
        avatarBtn.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(25)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarBtn.snp.trailing).offset(10)
            make.top.equalTo(avatarBtn)
        }
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarBtn.snp.trailing).offset(10)
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
        }
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarBtn.snp.trailing).offset(10)
            make.top.equalTo(contentLabel.snp.bottom).offset(12)
            make.bottom.equalTo(-12)
        }
        likeCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(nameLabel)
        }
    }
    
    func setup(model: VideoCommentModel) {
        if let URLString = model.commenter?.avatar_url {
            avatarBtn.kf.setImage(with: URL(string: URLString), for: .normal, placeholder: UIImage(named: "public_avatarPlaceholder"))
        }
        
        nameLabel.text = "@\(model.commenter?.name ?? "")"
        
        contentLabel.text = model.content
        
        if let date = model.created_at {
            timeLabel.text = date.string(format: "MM-yy HH:mm")
        }
        
        likeCountLabel.text = String(model.liked_count ?? 0)
    }
}
