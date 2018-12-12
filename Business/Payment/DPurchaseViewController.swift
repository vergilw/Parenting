//
//  DPurchaseViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/16.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class DPurchaseViewController: BaseViewController {

    public var orderID: Int = 0
    
    var orderModel: OrderModel?
    
    var completeClosure: (() -> Void)?
    
    lazy fileprivate var statusLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h1
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var previewImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy fileprivate var courseNameLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.numberOfLines = 2
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-previewImgWidth()-12
//        label.lineBreakMode = .byCharWrapping
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
        label.numberOfLines = 0
        return label
    }()
    
    lazy fileprivate var priceLabel: ParagraphLabel = {
        let label = ParagraphLabel()
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
    
    lazy fileprivate var balanceValueLabel: ParagraphLabel = {
        let label = ParagraphLabel()
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
        label.setParagraphText("2小时未付款自动取消订单")
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
    
    lazy fileprivate var actionBtn: ActionButton = {
        let button = ActionButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIConstants.Font.h2
        button.setTitle("确认支付", for: .normal)
        button.backgroundColor = UIConstants.Color.primaryRed
        button.layer.cornerRadius = 26
        button.addTarget(self, action: #selector(payBtnAction), for: .touchUpInside)
        return button
    }()
    
    init(orderID: Int) {
        super.init(nibName: nil, bundle: nil)
        self.orderID = orderID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "订单"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        view.drawSeparator(startPoint: CGPoint(x: UIConstants.Margin.leading, y: 230), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.trailing, y: 230))
        view.drawSeparator(startPoint: CGPoint(x: UIConstants.Margin.leading, y: 338), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.trailing, y: 338))
        
        view.addSubviews([statusLabel, previewImgView, courseNameLabel, courseTeacherLabel, orderNumberLabel, priceLabel, balanceTitleLabel, balanceValueLabel, timeTitleLabel, timeValueLabel, timeFootnoteLabel, actionBtn])
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
            make.size.equalTo(CGSize(width: previewImgWidth(), height: previewImgWidth()/160.0*90))
        }
        courseNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(previewImgView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(previewImgView)
//            make.height.lessThanOrEqualTo(62)
        }
        courseTeacherLabel.snp.makeConstraints { make in
//            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.leading.equalTo(previewImgView.snp.trailing).offset(12)
            make.top.equalTo(courseNameLabel.snp.bottom).offset(2.5)
        }
        orderNumberLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(previewImgView.snp.bottom).offset(12-5)
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
//        footnoteLabel.snp.makeConstraints { make in
//            make.leading.equalTo(UIConstants.Margin.leading)
//            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
//            make.top.equalTo(timeFootnoteLabel.snp.bottom).offset(32)
//        }
        actionBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading+25)
            make.trailing.equalTo(-UIConstants.Margin.trailing-25)
            make.height.equalTo(52)
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-48)
            } else {
                make.bottom.equalTo(-48)
            }
        }
    }
    
    func previewImgWidth() -> CGFloat {
        let titleWidth: CGFloat = UIScreenWidth - UIConstants.Margin.leading - UIConstants.Margin.trailing - 12 - 160
        let offset: CGFloat = (titleWidth + 1).truncatingRemainder(dividingBy: 17+1)
        let imgWidth: CGFloat = 160+offset-1
        return imgWidth
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.User.userInfoDidChange, object: nil)
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchData() {
        HUDService.sharedInstance.showFetchingView(target: self.view)
        
        PaymentProvider.request(.order(orderID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            HUDService.sharedInstance.hideFetchingView(target: self.view)
            if code >= 0 {
                if let data = JSON?["order"] as? [String: Any] {
                    self.orderModel = OrderModel.deserialize(from: data)
                    self.reload()
                }

            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: self.view) { [weak self] in
                    self?.fetchData()
                }
            }
        }))
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        statusLabel.setParagraphText(orderModel?.payment_status_text ?? "")
        
        if let URLString = orderModel?.order_items?[exist: 0]?.course?.cover_attribute?.service_url {
            let processor = RoundCornerImageProcessor(cornerRadius: 8, targetSize: CGSize(width: 160*2, height: 160/16.0*9*2))
            previewImgView.kf.setImage(with: URL(string: URLString), options: [.processor(processor)])
        }
        
        courseNameLabel.setParagraphText(orderModel?.order_items?[exist: 0]?.course?.title ?? "")
        
        var tagString = orderModel?.order_items?[exist: 0]?.course?.teacher?.name ?? ""
        if let tags = orderModel?.order_items?[exist: 0]?.course?.teacher?.tags, tags.count > 0 {
            let string = tags.joined(separator: " | ")
            tagString = tagString.appendingFormat(" : %@", string)
        }
        courseTeacherLabel.setParagraphText(tagString)
        
        let orderString = "订单号：" + (orderModel?.uuid ?? "")
        orderNumberLabel.setSymbolText(orderString, symbolText: "订单号：", symbolAttributes: [NSAttributedString.Key.foregroundColor : UIConstants.Color.body])
        
//        let balanceString: String = String.priceFormatter.string(from: (NSNumber(string: orderModel?.balance ?? "") ?? NSNumber())) ?? ""
//        balanceValueLabel.setParagraphText(balanceString)
        
        if let balance = AuthorizationService.sharedInstance.user?.balance {
            let string = String.priceFormatter.string(from: NSNumber(string: balance) ?? NSNumber())
            balanceValueLabel.setParagraphText(string ?? "0.00")
        }
        
        let priceString: String = String.priceFormatter.string(from: (NSNumber(string: orderModel?.amount ?? "") ?? NSNumber())) ?? ""
        priceLabel.setParagraphText(priceString)
        
        timeValueLabel.setParagraphText((orderModel?.created_at?.string(format: "yyyy.MM.dd hh:mm")) ?? "")
        
        if orderModel?.payment_status == "unpaid" || orderModel?.payment_status == "part_paid" {
            actionBtn.isHidden = false
        } else {
            actionBtn.isHidden = true
        }
    }
    
    // MARK: - ============= Action =============
    
    @objc func payBtnAction() {
        guard let balance = AuthorizationService.sharedInstance.user?.balance, let price = orderModel?.order_items?[exist: 0]?.course?.price, let orderID = orderModel?.id else {
            return
        }
        
        let balanceInt = NSString(string: balance).floatValue
        guard balanceInt > price else {
            let alertController = UIAlertController(title: nil, message: "您的余额不足，请先充值", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
                let navigationController = BaseNavigationController(rootViewController: DPaymentViewController())
                self.present(navigationController, animated: true, completion: nil)
//                self.navigationController?.pushViewController(DPaymentViewController(), animated: true)
            }))
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
    
        actionBtn.startAnimating()
        PaymentProvider.request(.order_pay(orderID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            self.actionBtn.stopAnimating()

            if code >= 0 {
                HUDService.sharedInstance.show(string: "购买成功")

                NotificationCenter.default.post(name: Notification.Payment.payCourseDidSuccess, object: nil)

                if let closure = self.completeClosure {
                    closure()
                }
            }
        }))
    }
}
