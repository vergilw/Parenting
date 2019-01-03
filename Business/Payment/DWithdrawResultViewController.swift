//
//  DWithdrawResultViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/27.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DWithdrawResultViewController: BaseViewController {

    var withdrawValue: Float?
    
    lazy fileprivate var status1ImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .center
        imgView.image = UIImage(named: "payment_withdrawStatus1")
        imgView.backgroundColor = UIConstants.Color.primaryGreen
        imgView.layer.cornerRadius = 9
        return imgView
    }()
    
    lazy fileprivate var status2ImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .center
        imgView.image = UIImage(named: "payment_withdrawStatus2")
        imgView.backgroundColor = UIConstants.Color.separator
        imgView.layer.cornerRadius = 9
        return imgView
    }()
    
    lazy fileprivate var status1Label: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.text = "提现申请已提交"
        return label
    }()
    
    lazy fileprivate var status1FootnoteLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        label.text = "预计1-3个工作日内到账"
        return label
    }()
    
    lazy fileprivate var status2Label: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.head
        label.text = "努力提现中"
        return label
    }()
    
    lazy fileprivate var status2FootnoteLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        label.text = "客服小姐姐在加急处理中，请耐心等待哟～"
        return label
    }()
    
    lazy fileprivate var amountTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.head
        label.text = "提现金额"
        return label
    }()
    
    lazy fileprivate var amountValueLabel: PriceLabel = {
        let label = PriceLabel()
        label.font = UIFont(name: "PingFangSC-Semibold", size: 15)!
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var methodTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.head
        label.text = "提现方式"
        return label
    }()
    
    lazy fileprivate var methodValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.head
        label.text = "微信"
        return label
    }()
    
    lazy fileprivate var accountTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.head
        label.text = "提现账号"
        return label
    }()
    
    lazy fileprivate var accountValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var actionBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIConstants.Font.h2_regular
        button.setTitle("知道了", for: .normal)
        button.backgroundColor = UIConstants.Color.primaryGreen
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(notedBtnAction), for: .touchUpInside)
        return button
    }()
    
    init(withdrawValue: Float) {
        super.init(nibName: nil, bundle: nil)
        self.withdrawValue = withdrawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "金币提现结果"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        reload()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubviews([status1ImgView, status2ImgView, status1Label, status1FootnoteLabel, status2Label, status2FootnoteLabel, amountTitleLabel, amountValueLabel, methodTitleLabel, methodValueLabel, accountTitleLabel, accountValueLabel, actionBtn])
        
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: UIConstants.Margin.leading+9, y: 30+18))
        linePath.addLine(to: CGPoint(x: UIConstants.Margin.leading+9, y: 30+18+36))
        line.path = linePath.cgPath
        line.strokeColor = UIConstants.Color.primaryGreen.cgColor
        line.lineWidth = 2
        view.layer.addSublayer(line)
        
        let line2 = CAShapeLayer()
        let linePath2 = UIBezierPath()
        linePath2.move(to: CGPoint(x: UIConstants.Margin.leading+9, y: 30+18+36))
        linePath2.addLine(to: CGPoint(x: UIConstants.Margin.leading+9, y: 30+18+72))
        line2.path = linePath2.cgPath
        line2.strokeColor = UIConstants.Color.separator.cgColor
        line2.lineWidth = 2
        view.layer.addSublayer(line2)
        
        view.drawSeparator(startPoint: CGPoint(x: UIConstants.Margin.leading, y: 185), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.trailing, y: 185))
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        status1ImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(30)
            make.size.equalTo(CGSize(width: 18, height: 18))
        }
        
        status2ImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(status1ImgView.snp.bottom).offset(72)
            make.size.equalTo(CGSize(width: 18, height: 18))
        }
        status1Label.snp.makeConstraints { make in
            make.leading.equalTo(status1ImgView.snp.trailing).offset(16)
            make.top.equalTo(status1ImgView).offset(-3)
        }
        status1FootnoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(status1Label)
            make.top.equalTo(status1Label.snp.bottom).offset(6)
        }

        status2Label.snp.makeConstraints { make in
            make.leading.equalTo(status1Label)
            make.top.equalTo(status2ImgView).offset(-2)
        }
        status2FootnoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(status1Label)
            make.top.equalTo(status2Label.snp.bottom).offset(6)
        }
        
        amountTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(status2ImgView.snp.bottom).offset(70)
        }
        amountValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalTo(amountTitleLabel)
        }
        methodTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(amountTitleLabel.snp.bottom).offset(30)
        }
        methodValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalTo(methodTitleLabel)
        }
        accountTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(methodTitleLabel.snp.bottom).offset(30)
        }
        accountValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalTo(accountTitleLabel)
        }
        actionBtn.snp.makeConstraints { make in
            if #available(iOS 11, *) {
                make.bottom.equalTo(-15-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
            } else {
                make.bottom.equalTo(-15)
            }
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.height.equalTo(50)
        }
        
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        if let withdrawValue = withdrawValue {
            amountValueLabel.setPriceText(text: String(withdrawValue), symbol: "¥", discount: nil)
        }
        if let account = AuthorizationService.sharedInstance.user?.wechat_name {
            accountValueLabel.text = account
        }
        
    }
    
    // MARK: - ============= Action =============
    @objc func notedBtnAction() {
        if let viewControllers = navigationController?.viewControllers, viewControllers.count > 2 {
            navigationController?.setViewControllers(Array(viewControllers[0...viewControllers.count-3]), animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
}
