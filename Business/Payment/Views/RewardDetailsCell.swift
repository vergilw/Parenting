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
    
    lazy fileprivate var descLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.body
        label.backgroundColor = UIConstants.Color.background
        return label
    }()
    
    lazy fileprivate var headnoteLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    lazy fileprivate var priceLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
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
        
        contentView.addSubviews([titleLabel, headnoteLabel, descLabel, priceLabel])
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
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalTo(descLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        
        titleLabel.setParagraphText("如何规划幼儿英引导引...")
        headnoteLabel.setParagraphText("2018.10.30 08.25")
        descLabel.setParagraphText("已有1342次学习")
        priceLabel.setParagraphText("29.9")
    }
    
    fileprivate func setPriceText(_ text: String) {
        if let originalFont = priceLabel.originalFont {
            priceLabel.font = originalFont
        }
        
        let attributedString = NSMutableAttributedString(string: text)
        
        let paragraph = NSMutableParagraphStyle()
        var lineHeight: CGFloat = 0
        if priceLabel.font == UIConstants.Font.h1 {
            lineHeight = UIConstants.LineHeight.h1
            
        } else if priceLabel.font == UIConstants.Font.h2 {
            lineHeight = UIConstants.LineHeight.h2
            
        } else if priceLabel.font == UIConstants.Font.h3 {
            lineHeight = UIConstants.LineHeight.h3
            
        } else if priceLabel.font == UIConstants.Font.body {
            lineHeight = UIConstants.LineHeight.body
            
        } else if priceLabel.font == UIConstants.Font.foot {
            lineHeight = UIConstants.LineHeight.foot
        } else {
            lineHeight = priceLabel.font.pointSize
        }
        paragraph.maximumLineHeight = lineHeight
        paragraph.minimumLineHeight = lineHeight
        paragraph.alignment = priceLabel.textAlignment
        
        attributedString.addAttributes([
            NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.baselineOffset: (lineHeight-priceLabel.font.lineHeight)/4, NSAttributedString.Key.font: priceLabel.font], range: NSRange(location: 0, length: attributedString.length))
        priceLabel.originalFont = priceLabel.font
        attributedString.addAttributes([NSAttributedString.Key.font : UIConstants.Font.body], range: NSString(string: text).range(of: "¥"))
        attributedString.addAttributes([NSAttributedString.Key.baselineOffset: (lineHeight-priceLabel.font.lineHeight)/4+1.25, NSAttributedString.Key.font: priceLabel.font], range: NSString(string: text).range(of: "+"))
        
        priceLabel.attributedText = attributedString
    }
}
