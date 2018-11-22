//
//  OrderCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/16.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class OrderCell: UITableViewCell {

    lazy fileprivate var orderMode: DOrdersViewController.DOrdersMode = .nonpayment
    
    lazy fileprivate var panelView: UIView = {
        let view = UIView()
        view.drawRoundBg(roundedRect: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing, height: 160)), cornerRadius: 4)
        return view
    }()
    
    lazy fileprivate var previewImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        let processor = RoundCornerImageProcessor(cornerRadius: 8, targetSize: CGSize(width: 112*2, height: 63*2))
        imgView.kf.setImage(with: URL(string: "http://cloud.1314-edu.com/yVstTMQcm6uYCt5an9HpPxgJ"), options: [.processor(processor)])
        
        return imgView
    }()
    
    lazy fileprivate var timeIconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "course_timeDuration")
        return imgView
    }()
    
    lazy fileprivate var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        label.text = "2018.10.30 08:25"
        return label
    }()
    
    lazy fileprivate var titleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-160-30-112-12
        label.setParagraphText("如何规划幼儿英引导...")
        
        return label
    }()
    
    lazy fileprivate var orderNumberLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.head
        label.isHidden = true
        return label
    }()
    
    lazy fileprivate var priceLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIColor("#ef5226")
        label.text = "¥0.0"
        return label
    }()
    
    lazy fileprivate var actionBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.primaryRed, for: .normal)
        button.titleLabel?.font = UIConstants.Font.foot
        button.setTitle("去支付", for: .normal)
        button.isUserInteractionEnabled = false
//        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        
        let sublayer = CAShapeLayer()
        let circlePath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: CGSize(width: 66, height: 27)), cornerRadius: 13.5)
        sublayer.lineWidth = 0.5
        sublayer.path = circlePath.cgPath
        sublayer.strokeColor = UIConstants.Color.primaryRed.cgColor
        sublayer.fillColor = UIColor.clear.cgColor
        button.layer.addSublayer(sublayer)

        return button
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
        contentView.backgroundColor = UIConstants.Color.background
        contentView.addSubview(panelView)
        panelView.drawSeparator(startPoint: CGPoint(x: 15, y: 103), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-15, y: 103))
        panelView.addSubviews([previewImgView, titleLabel, orderNumberLabel, priceLabel, timeIconImgView, timeLabel, actionBtn])
        panelView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(UIConstants.Margin.top)
            make.bottom.equalTo(-UIConstants.Margin.bottom)
        }
        previewImgView.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.top.equalTo(20)
            make.size.equalTo(CGSize(width: 112, height: 63))
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(previewImgView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(-15)
            make.top.equalTo(previewImgView.snp.top).offset(5)
        }
        orderNumberLabel.snp.makeConstraints { make in
            make.leading.equalTo(previewImgView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(-15)
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.height.equalTo(12)
        }
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-15)
            make.centerY.equalTo(orderNumberLabel)
        }
        timeIconImgView.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.bottom.equalTo(-23.5)
        }
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeIconImgView.snp.trailing).offset(5)
            make.centerY.equalTo(timeIconImgView)
        }
        actionBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-15)
            make.centerY.equalTo(timeIconImgView)
            make.size.equalTo(CGSize(width: 66, height: 27))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(mode: DOrdersViewController.DOrdersMode) {
        if mode != orderMode {
            if mode == .nonpayment {
                actionBtn.isHidden = false
                
                orderNumberLabel.isHidden = true
                actionBtn.snp.remakeConstraints { make in
                    make.trailing.equalTo(-15)
                    make.centerY.equalTo(timeIconImgView)
                    make.size.equalTo(CGSize(width: 66, height: 27))
                }
                priceLabel.snp.remakeConstraints { make in
                    make.trailing.equalTo(-15)
                    make.centerY.equalTo(orderNumberLabel)
                }
                
            } else {
                actionBtn.isHidden = true
                
                priceLabel.snp.remakeConstraints { make in
                    make.trailing.equalTo(-15)
                    make.centerY.equalTo(timeIconImgView)
                }
                
                orderNumberLabel.isHidden = false
            }
            orderMode = mode
        }
        
        priceLabel.setPriceText("¥0.0", symbolFont: UIConstants.Font.body)
        orderNumberLabel.setSymbolText("订单号：236815484212", symbolText: "订单号：", symbolAttributes: [NSAttributedString.Key.foregroundColor : UIConstants.Color.body])
    }
}
