//
//  VideoGiftRankCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/3/1.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class VideoGiftRankCell: UITableViewCell {

    lazy fileprivate var sequenceLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.disable
        label.textAlignment = .center
        return label
    }()
    
    lazy fileprivate var sequenceImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "payment_ranking0")
        imgView.isHidden = true
        return imgView
    }()
    
    lazy fileprivate var avatarImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 17.5
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: "public_avatarPlaceholder")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    fileprivate lazy var avatarBorderImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_giftRankBorder")
        imgView.isHidden = true
        return imgView
    }()
    
    lazy fileprivate var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h4
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var valueLabel: PriceLabel = {
        let label = PriceLabel()
        label.font = UIConstants.Font.caption1
        label.textColor = UIConstants.Color.body
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
        
        contentView.addSubviews([sequenceLabel, sequenceImgView, avatarImgView, avatarBorderImgView, nameLabel, valueLabel])
        
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func initConstraints() {
        sequenceLabel.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.centerY.equalToSuperview()
            make.width.equalTo(20+UIConstants.Margin.leading*2)
        }
        sequenceImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.centerY.equalToSuperview()
        }
        avatarImgView.snp.makeConstraints { make in
            make.leading.equalTo(65)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        avatarBorderImgView.snp.makeConstraints { make in
            make.leading.equalTo(avatarImgView).offset(-0.5)
            make.trailing.equalTo(avatarImgView).offset(0.5)
            make.top.equalTo(avatarImgView).offset(-0.5)
            make.bottom.equalTo(avatarImgView).offset(0.5)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImgView.snp.trailing).offset(8.5)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(valueLabel.snp.leading).offset(-12)
        }
        valueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalToSuperview()
        }
    }
    
    func setup(model: GiftRankModel) {
        if let position = model.position {
            if position < 4 {
                sequenceLabel.isHidden = true
                sequenceImgView.isHidden = false
                sequenceImgView.image = UIImage(named: "payment_ranking\(position)")
            } else {
                sequenceLabel.isHidden = false
                sequenceImgView.isHidden = true
                sequenceLabel.text = "\(position)"
            }
        }
        
        
        if let URLString = model.user?.avatar_url {
            avatarImgView.kf.setImage(with: URL(string: URLString), placeholder: UIImage(named: "public_avatarPlaceholder"))
        }
        
        if model.user?.id == AuthorizationService.sharedInstance.user?.id {
            avatarBorderImgView.isHidden = false
        } else {
            avatarBorderImgView.isHidden = true
        }
        
        nameLabel.text = model.user?.name
        
        valueLabel.text = "\(model.amount ?? "") 氧育币"
    }
}
