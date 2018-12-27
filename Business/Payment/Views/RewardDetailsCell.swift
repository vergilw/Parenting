//
//  RewardDetailsCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/21.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class RewardDetailsCell: UITableViewCell {

    lazy fileprivate var titleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.head
        label.backgroundColor = UIConstants.Color.background
        label.textAlignment = .center
        return label
    }()
    
    lazy fileprivate var headnoteLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    lazy fileprivate var priceLabel: PriceLabel = {
        let label = PriceLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.primaryOrange
        return label
    }()
    
    lazy fileprivate var coinIconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "payment_coinIcon")
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
        
        contentView.addSubviews([titleLabel, headnoteLabel, descLabel, priceLabel, coinIconImgView])
        initConstraints()
    }
    
    fileprivate func initConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.lessThanOrEqualTo(headnoteLabel.snp.leading).offset(-12)
            make.top.equalTo(30)
        }
        headnoteLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
        }
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        coinIconImgView.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalTo(descLabel)
        }
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(coinIconImgView.snp.leading).offset(-4)
            make.centerY.equalTo(descLabel).offset(-1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(model: CoinLogModel) {
        
        titleLabel.setParagraphText(model.title ?? "")
        headnoteLabel.setParagraphText(model.created_at?.string(format: "yyyy.MM.dd HH:mm") ?? "")
        descLabel.text = "分享奖励"
        let size = descLabel.systemLayoutSizeFitting(CGSize(width: UIScreenWidth, height: UIScreenHeight))
        descLabel.snp.remakeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.size.equalTo(CGSize(width: size.width+10, height: 21))
        }
        
        if let amount = model.amount, let amountInt = Float(amount) {
            if amountInt > 0 {
                priceLabel.setPriceText(text: amount, symbol: "+")
            } else {
                priceLabel.setPriceText(text: String(abs(amountInt)), symbol: "-")
            }
        }
        
    }
    
}
