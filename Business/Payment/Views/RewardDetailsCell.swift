//
//  RewardDetailsCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/21.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class RewardDetailsCell: UITableViewCell {

    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h4
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
    
    lazy fileprivate var headnoteLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot2
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
            make.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-12)
            make.top.equalTo(12)
        }
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(7.5)
        }
        coinIconImgView.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalTo(titleLabel)
        }
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(coinIconImgView.snp.leading).offset(-4)
            make.centerY.equalTo(titleLabel).offset(-1)
        }
        headnoteLabel.snp.makeConstraints { make in
            make.centerY.equalTo(descLabel)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(model: CoinLogModel) {
        
        titleLabel.text = model.title
        
        headnoteLabel.text = model.created_at?.string(format: "yyyy.MM.dd HH:mm")
        
        descLabel.text = model.tag_str
        let size = NSString(string: descLabel.text ?? "").boundingRect(with: CGSize(width: UIScreenWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesFontLeading, attributes: [NSAttributedString.Key.font : descLabel.font], context: nil).size
        descLabel.snp.remakeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(7.5)
            make.size.equalTo(CGSize(width: size.width+14, height: 20))
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
