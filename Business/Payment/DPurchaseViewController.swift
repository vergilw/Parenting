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
    
    fileprivate lazy var bgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "payment_orderBg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
        return imgView
    }()
    
    fileprivate lazy var navigationTitleLabel: UILabel = {
        let label = UILabel()
        if let font = UINavigationBar.appearance().titleTextAttributes?[NSAttributedString.Key.font] as? UIFont {
            label.font = font
        }
        label.textColor = .white
        label.textAlignment = .center
        label.text = "支付订单"
        return label
    }()
    
    lazy fileprivate var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h1
        label.textColor = UIConstants.Color.primaryOrange
        return label
    }()
    
    lazy fileprivate var previewImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 4
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy fileprivate var courseNameLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h3
        label.textColor = UIConstants.Color.head
        label.numberOfLines = 2
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-previewImgWidth()-40-15
//        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    lazy fileprivate var courseTeacherLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot2
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    lazy fileprivate var priceLabel: PriceLabel = {
        let label = PriceLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIColor("#ef5226")
        label.textAlignment = .right
        return label
    }()
    
    lazy fileprivate var balanceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.text = "账户余额"
        return label
    }()
    
    lazy fileprivate var balanceValueLabel: PriceLabel = {
        let label = PriceLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.textAlignment = .right
        return label
    }()
    
    fileprivate lazy var orderNumberTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.text = "订单号"
        return label
    }()
    
    lazy fileprivate var orderNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h4
        label.textColor = UIConstants.Color.head
        label.textAlignment = .right
        return label
    }()
    
    lazy fileprivate var timeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.text = "生成时间"
        return label
    }()
    
    lazy fileprivate var timeValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.textAlignment = .right
        return label
    }()
    
    lazy fileprivate var timeFootnoteLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot2
        label.textColor = UIConstants.Color.foot
        label.textAlignment = .right
        label.text = "2小时未付款自动取消订单"
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
        button.titleLabel?.font = UIConstants.Font.h4
        button.setTitle("确认支付", for: .normal)
        button.backgroundColor = UIConstants.Color.primaryOrange
        button.layer.cornerRadius = 17.5
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        
//        view.drawGradientBg(roundedRect: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: UIScreenHeight)), colors: [UIColor("#11D3E1").cgColor, UIColor("#00C8D7").cgColor])
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: UIScreenHeight))
        gradientLayer.colors = [UIColor("#11D3E1").cgColor, UIColor("#00C8D7").cgColor]
        gradientLayer.locations = [0.0, 0.5]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.addSublayer(gradientLayer)
        
        
        view.addSubviews([bgImgView, backBarBtn, navigationTitleLabel, statusLabel, previewImgView, courseNameLabel, courseTeacherLabel, orderNumberTitleLabel, orderNumberLabel, priceLabel, balanceTitleLabel, balanceValueLabel, timeTitleLabel, timeValueLabel, timeFootnoteLabel, actionBtn])
        
        bgImgView.drawSeparator(startPoint: CGPoint(x: 20+5, y: 80), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing+10-20, y: 80))
        bgImgView.drawSeparator(startPoint: CGPoint(x: 20+5, y: 216), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing+10-20, y: 216))
        bgImgView.drawSeparator(startPoint: CGPoint(x: 20+5, y: 342), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing+10-20, y: 342))
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        bgImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading-5)
            make.trailing.equalTo(-UIConstants.Margin.trailing+5)
            let navigationHeight = self.navigationController?.navigationBar.bounds.height ?? 0
            make.top.equalTo(UIStatusBarHeight+navigationHeight+20)
            make.bottom.equalTo(-30)
        }
        backBarBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(0)
            } else {
                make.top.equalTo(UIStatusBarHeight)
            }
            make.size.equalTo(backBarBtn.bounds.size)
        }
        navigationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(UIStatusBarHeight)
            make.centerX.equalToSuperview()
            make.height.equalTo((navigationController?.navigationBar.bounds.size.height ?? 0))
        }
        statusLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading+20)
            make.top.equalTo(bgImgView).offset(38)
        }
        previewImgView.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing-20)
            make.top.equalTo(statusLabel.snp.bottom).offset(42)
            make.size.equalTo(CGSize(width: previewImgWidth(), height: previewImgWidth()/12.0*9))
        }
        courseNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(statusLabel)
            make.trailing.lessThanOrEqualTo(previewImgView.snp.leading).offset(-15)
            make.top.equalTo(previewImgView)
        }
        courseTeacherLabel.snp.makeConstraints { make in
            make.leading.equalTo(statusLabel)
            make.trailing.lessThanOrEqualTo(previewImgView.snp.leading).offset(-15)
            make.top.equalTo(courseNameLabel.snp.bottom).offset(15)
        }
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(statusLabel)
            make.lastBaseline.equalTo(previewImgView.snp.bottom)
        }
        
        
        balanceTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(statusLabel)
            make.top.equalTo(previewImgView.snp.bottom).offset(42)
            make.height.equalTo(14)
        }
        balanceValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(previewImgView)
            make.centerY.equalTo(balanceTitleLabel)
        }
        orderNumberTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(statusLabel)
            make.top.equalTo(balanceTitleLabel.snp.bottom).offset(10)
            make.height.equalTo(14)
        }
        orderNumberLabel.snp.makeConstraints { make in
            make.trailing.equalTo(previewImgView)
            make.centerY.equalTo(orderNumberTitleLabel)
        }
        timeTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(statusLabel)
            make.top.equalTo(orderNumberTitleLabel.snp.bottom).offset(10)
            make.height.equalTo(14)
        }
        timeValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(previewImgView)
            make.centerY.equalTo(timeTitleLabel)
        }
        timeFootnoteLabel.snp.makeConstraints { make in
            make.top.equalTo(timeValueLabel.snp.bottom).offset(4)
            make.trailing.equalTo(previewImgView)
        }
//        footnoteLabel.snp.makeConstraints { make in
//            make.leading.equalTo(UIConstants.Margin.leading)
//            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
//            make.top.equalTo(timeFootnoteLabel.snp.bottom).offset(32)
//        }
        actionBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading+40)
            make.trailing.equalTo(-UIConstants.Margin.trailing-40)
            make.height.equalTo(35)
            make.bottom.equalTo(bgImgView).offset(-38)
        }
    }
    
    func previewImgWidth() -> CGFloat {
//        let titleWidth: CGFloat = UIScreenWidth - UIConstants.Margin.leading - UIConstants.Margin.trailing - 12 - 160
//        let offset: CGFloat = (titleWidth + 1).truncatingRemainder(dividingBy: 17+1)
//        let imgWidth: CGFloat = 160+offset-1
//        return imgWidth
        //TODO: round title width
        let height: CGFloat = 95
        return height/9.0*12
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
        statusLabel.text = orderModel?.payment_status_text
        
        if let URLString = orderModel?.order_items?[exist: 0]?.course?.cover_attribute?.service_url {
            let processor = RoundCornerImageProcessor(cornerRadius: 8, targetSize: CGSize(width: 160*2, height: 160/16.0*9*2))
            previewImgView.kf.setImage(with: URL(string: URLString), options: [.processor(processor)])
        }
        
//        courseNameLabel.setParagraphText(orderModel?.order_items?[exist: 0]?.course?.title ?? "")
        courseNameLabel.text = orderModel?.order_items?[exist: 0]?.course?.title
        
        var tagString = orderModel?.order_items?[exist: 0]?.course?.teacher?.name ?? ""
        if let tags = orderModel?.order_items?[exist: 0]?.course?.teacher?.tags, tags.count > 0 {
            let string = tags.joined(separator: " | ")
            tagString = tagString.appendingFormat(" : %@", string)
        }
        courseTeacherLabel.text = tagString
        
        orderNumberLabel.text = orderModel?.uuid
        
//        let balanceString: String = String.priceFormatter.string(from: (NSNumber(string: orderModel?.balance ?? "") ?? NSNumber())) ?? ""
//        balanceValueLabel.setParagraphText(balanceString)
        
        if let balance = AuthorizationService.sharedInstance.user?.balance {
            balanceValueLabel.setPriceText(text: balance, discount: nil)
        }
        
        if let price = orderModel?.amount {
            priceLabel.setPriceText(text: price, discount: orderModel?.market_price)
        }
        
        timeValueLabel.text = orderModel?.created_at?.string(format: "yyyy.MM.dd HH:mm")
        
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
                let navigationController = BaseNavigationController(rootViewController: DTopUpViewController())
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
                AuthorizationService.sharedInstance.updateUserInfo()
                
                HUDService.sharedInstance.show(string: "购买成功")

                NotificationCenter.default.post(name: Notification.Payment.payCourseDidSuccess, object: nil)

                if let closure = self.completeClosure {
                    closure()
                }
            }
        }))
    }
}
