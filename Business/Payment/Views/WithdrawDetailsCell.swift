//
//  WithdrawDetailsCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/28.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class WithdrawDetailsCell: UITableViewCell {

    lazy fileprivate var titleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var status1Label: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    lazy fileprivate var status2Label: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    lazy fileprivate var priceLabel: PriceLabel = {
        let label = PriceLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var statusValueLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.primaryGreen
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
        
        contentView.addSubviews([titleLabel, status1Label, status2Label, priceLabel, statusValueLabel])
        initConstraints()
        
        let line = CAShapeLayer()
        let linePath = UIBezierPath(arcCenter: CGPoint(x: 27.5+3.5, y: 45), radius: 3.5, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        line.path = linePath.cgPath
        line.strokeColor = UIConstants.Color.disable.cgColor
        line.fillColor = UIColor.clear.cgColor
        line.lineWidth = 1.0
        contentView.layer.addSublayer(line)
        
        let line2 = CAShapeLayer()
        let linePath2 = UIBezierPath()
        linePath2.move(to: CGPoint(x: 27.5+3.5, y: 45+3.5))
        linePath2.addLine(to: CGPoint(x: 27.5+3.5, y: 45+3.5+28))
        line2.path = linePath2.cgPath
        line2.strokeColor = UIConstants.Color.disable.cgColor
        line2.lineWidth = 1
        line2.lineDashPhase = 0
        line2.lineDashPattern = [NSNumber(value: 3), NSNumber(value: 2)]
        contentView.layer.addSublayer(line2)

        let line3 = CAShapeLayer()
        let linePath3 = UIBezierPath(arcCenter: CGPoint(x: 27.5+3.5, y: 45+7+28), radius: 3.5, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        line3.path = linePath3.cgPath
        line3.strokeColor = UIConstants.Color.disable.cgColor
        line3.fillColor = UIColor.clear.cgColor
        line3.lineWidth = 1.0
        contentView.layer.addSublayer(line3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func initConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(16)
        }
        status1Label.snp.makeConstraints { make in
            make.leading.equalTo(40)
            make.top.equalTo(40)
        }
        status2Label.snp.makeConstraints { make in
            make.leading.equalTo(40)
            make.top.equalTo(status1Label.snp.bottom).offset(22.5)
        }
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalTo(status1Label)
        }
        statusValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalTo(status2Label)
        }
    }
    
    func setup() {
        titleLabel.setParagraphText("微信提现-会飞的猪")
        status1Label.setParagraphText("申请时间：2018-12-12 11:12")
        status2Label.setParagraphText("到账时间：2018-12-12 11:12")
        priceLabel.setPriceText(text: "29.9")
        statusValueLabel.setParagraphText("审核中")
    }
}
