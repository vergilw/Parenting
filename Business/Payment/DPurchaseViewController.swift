//
//  DPurchaseViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/16.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DPurchaseViewController: BaseViewController {

    lazy fileprivate var statusLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h1
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var previewImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 4
        return imgView
    }()
    
    lazy fileprivate var courseNameLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.numberOfLines = 2
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-160-12
        label.textAlignment = .right
        return label
    }()
    
    lazy fileprivate var courseTeacherLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    lazy fileprivate var orderNumberLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIColor("#ef5226")
        label.textAlignment = .right
        return label
    }()
    
    lazy fileprivate var balanceTitleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.setParagraphText("账户余额")
        return label
    }()
    
    lazy fileprivate var balanceValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h3
        label.textColor = UIConstants.Color.head
        label.textAlignment = .right
        return label
    }()
    
    lazy fileprivate var timeTitleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.setParagraphText("订单号生成时间：")
        return label
    }()
    
    lazy fileprivate var timeValueLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.textAlignment = .right
        return label
    }()
    
    lazy fileprivate var timeFootnoteLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        label.textAlignment = .right
        label.setParagraphText("24小时未付款自动取消订单")
        return label
    }()
    
    lazy fileprivate var footnoteLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing
        label.setParagraphText("您未设置安全支付密码，为保证您的支付安全请及时在【我的】-【支付中心】设置安全支付密码。")
        return label
    }()
    
    lazy fileprivate var actionBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIConstants.Font.h2
        button.setTitle("确认支付", for: .normal)
        button.backgroundColor = UIConstants.Color.primaryRed
        button.layer.cornerRadius = 26
//        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "订单"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        reload()
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        view.drawSeparator(startPoint: CGPoint(x: UIConstants.Margin.leading, y: 230), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.trailing, y: 230))
        view.drawSeparator(startPoint: CGPoint(x: UIConstants.Margin.leading, y: 338), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.trailing, y: 338))
        
        view.addSubviews([statusLabel, previewImgView, courseNameLabel, courseTeacherLabel, orderNumberLabel, priceLabel, balanceTitleLabel, balanceValueLabel, timeTitleLabel, timeValueLabel, timeFootnoteLabel, footnoteLabel, actionBtn])
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        statusLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(25)
        }
        previewImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(statusLabel.snp.bottom).offset(42)
            make.size.equalTo(CGSize(width: 160, height: 90))
        }
        courseNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(previewImgView.snp.trailing).offset(12)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(previewImgView)
        }
        courseTeacherLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(courseNameLabel.snp.bottom).offset(2.5)
        }
        orderNumberLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(previewImgView.snp.bottom).offset(12)
        }
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalTo(orderNumberLabel)
        }
        balanceTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(orderNumberLabel.snp.bottom).offset(40)
        }
        balanceValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalTo(balanceTitleLabel)
        }
        timeTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(balanceTitleLabel.snp.bottom).offset(20)
        }
        timeValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalTo(timeTitleLabel)
        }
        timeFootnoteLabel.snp.makeConstraints { make in
            make.top.equalTo(timeValueLabel.snp.bottom).offset(7)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
        }
        footnoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(timeFootnoteLabel.snp.bottom).offset(32)
        }
        actionBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading+25)
            make.trailing.equalTo(-UIConstants.Margin.trailing-25)
//            make.top.equalTo(footnoteLabel.snp.bottom).offset(105)
            make.height.equalTo(52)
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-48)
            } else {
                make.bottom.equalTo(-48)
            }
        }
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        statusLabel.setParagraphText("未支付")
        previewImgView.backgroundColor = .gray
        courseNameLabel.setParagraphText("如何规划幼儿英引导幼如引导幼如何幼...")
        courseTeacherLabel.setParagraphText("Gcide丨全职妈妈")
        
        let text = "订单号：236815484212"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIConstants.Color.body], range: NSRange(location: 0, length: "订单号：".count))
        orderNumberLabel.attributedText = attributedString
        
        balanceValueLabel.text = "¥29.9"
        priceLabel.text = "¥28.0"
        timeValueLabel.setParagraphText("2018.10.30 08:25")
        
        
    }
    
    // MARK: - ============= Action =============

}
