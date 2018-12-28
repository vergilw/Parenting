//
//  DWithdrawViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/27.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DWithdrawViewController: BaseViewController {

    lazy fileprivate var exchangeModels: [WithdrawModel]? = nil
    
    lazy fileprivate var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    lazy fileprivate var balanceTitleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.setParagraphText("金币余额")
        return label
    }()
    
    lazy fileprivate var balanceValueLabel: PriceLabel = {
        let label = PriceLabel()
        label.font = UIConstants.Font.h1
        label.textColor = UIConstants.Color.disable
        return label
    }()
    
    lazy fileprivate var balanceNoteLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        label.setParagraphText("注：100金币约等于1元约等于1氧育币")
        return label
    }()
    
    lazy fileprivate var topUpTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.text = "提现"
        return label
    }()
    
    lazy fileprivate var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-20)/3, height: 70)
        layout.sectionInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(TopUpItemCell.self, forCellWithReuseIdentifier: TopUpItemCell.className())
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        return view
    }()
    
    lazy fileprivate var indicatorBtn: ActionButton = {
        let button = ActionButton()
        button.setIndicatorColor(UIConstants.Color.primaryGreen)
        button.isHidden = true
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let effectView = UIVisualEffectView(effect: blurEffect)
        button.addSubview(effectView)
        button.sendSubviewToBack(effectView)
        effectView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
        }
        return button
    }()
    
    lazy fileprivate var footnoteLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        label.numberOfLines = 0
        label.setParagraphText("注意事项：\n1. 提现申请将在1-3个工作日内审批到账，如遇到高峰期，可能会有延迟到账，烦请耐心等待；\n2. 提现到账查询：微信->我->钱包->零钱->零钱明细，如果有名称为“企业付款：氧育亲子提现成功”的数据，既提现到账成功；")
        return label
    }()
    
    lazy fileprivate var bottomGradientImgView: UIImageView = {
        let imgView = UIImageView()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: 40))
        gradientLayer.colors = [UIColor(white: 1.0, alpha: 0.0).cgColor, UIColor(white: 1.0, alpha: 1.0).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        imgView.layer.addSublayer(gradientLayer)
        
        var height: CGFloat = 95-40
        if #available(iOS 11, *) {
            height += (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
        }
        
        let sublayer = CAShapeLayer()
        let circlePath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: 40), size: CGSize(width: UIScreenWidth, height: height)), cornerRadius: 0)
        sublayer.path = circlePath.cgPath
        sublayer.fillColor = UIColor.white.cgColor
        imgView.layer.addSublayer(sublayer)
        
        return imgView
    }()
    
    lazy fileprivate var actionBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIConstants.Font.h2_regular
        button.setTitle("立即兑换", for: .normal)
        button.backgroundColor = UIConstants.Color.primaryGreen
        button.layer.cornerRadius = 25
        //        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "金币提现"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
        reload()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubviews([scrollView])
        
        scrollView.drawSeparator(startPoint: CGPoint(x: UIConstants.Margin.leading, y: 150), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.trailing, y: 150))
        
        scrollView.addSubviews([balanceTitleLabel, balanceValueLabel, balanceNoteLabel, topUpTitleLabel, collectionView, indicatorBtn, footnoteLabel])
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        //        bottomGradientImgView.snp.makeConstraints { make in
        //            make.leading.trailing.bottom.equalToSuperview()
        //            make.top.equalTo(actionBtn.snp.top).offset(-30)
        //        }
        //        actionBtn.snp.makeConstraints { make in
        //            if #available(iOS 11, *) {
        //                make.bottom.equalTo(-15-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
        //            } else {
        //                make.bottom.equalTo(-15)
        //            }
        //            make.leading.equalTo(50)
        //            make.trailing.equalTo(-50)
        //            make.height.equalTo(50)
        //        }
        
        balanceTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(60)
        }
        balanceValueLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(balanceTitleLabel.snp.bottom).offset(32)
        }
        balanceNoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(balanceValueLabel.snp.bottom).offset(22)
        }
        topUpTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(balanceValueLabel.snp.bottom).offset(94)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topUpTitleLabel.snp.bottom).offset(32)
            make.height.equalTo(150)
            make.width.equalTo(UIScreenWidth)
        }
        indicatorBtn.snp.makeConstraints { make in
            make.edges.equalTo(collectionView)
        }
        footnoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(collectionView.snp.bottom).offset(25)
            make.bottom.equalTo(-25)
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.User.userInfoDidChange, object: nil)
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchData() {
        HUDService.sharedInstance.showFetchingView(target: self.view)
        
        PaymentProvider.request(.withdraw_list, completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            HUDService.sharedInstance.hideFetchingView(target: self.view)
            
            if code >= 0 {
                if let data = JSON?["coin_cashes"] as? [[String: Any]] {
                    if let models = [WithdrawModel].deserialize(from: data) as? [WithdrawModel] {
                        self.exchangeModels = models
                    }
                    self.collectionView.reloadData()
                }
                if let ratio = JSON?["coin_to_cash"] as? NSNumber, let balance = AuthorizationService.sharedInstance.user?.reward, let balanceFloat = Float(balance), balanceFloat > 0 {
                    let string = String(format: "（约¥%.0f）", floor(balanceFloat*ratio.floatValue))
                    self.balanceTitleLabel.setSymbolText("金币余额\(string)", symbolText: string, symbolAttributes: [NSAttributedString.Key.font : UIConstants.Font.body, NSAttributedString.Key.foregroundColor: UIConstants.Color.foot])
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
        if let balance = AuthorizationService.sharedInstance.user?.reward {
            if Int(balance) != 0 {
                balanceValueLabel.textColor = UIConstants.Color.primaryOrange
            }
            balanceValueLabel.setPriceText(text: balance, discount: nil)
        }
        
    }
    
    // MARK: - ============= Action =============
    
}


extension DWithdrawViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exchangeModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopUpItemCell.className(), for: indexPath) as! TopUpItemCell
        var rewardBalance: Float = 0
        if let reward = AuthorizationService.sharedInstance.user?.reward, let rewardFloat = Float(reward) {
            rewardBalance = rewardFloat
        }
        if let model = exchangeModels?[exist: indexPath.row], let amount = Float(model.coin_amount ?? "") {
            cell.setupWithdraw(model: model, isEnabled: rewardBalance >= amount)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //FIXME: DEBUG
        guard let reward = AuthorizationService.sharedInstance.user?.reward, let rewardFloat = Float(reward) else { return }
        guard let model = exchangeModels?[exist: indexPath.row], let exchangeValue = model.coin_amount, let exchangeFloat = Float(exchangeValue) else { return }
//        guard rewardFloat >= exchangeFloat else { return }
        
        guard AuthorizationService.sharedInstance.user?.wechat_name != nil else {
            let view = AssociateWechatView()
            navigationController?.view.addSubview(view)
            view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            view.present()
            
            return
        }
        
        let alertController = UIAlertController(title: nil, message: "确认用\(rewardFloat)金币兑换\(model.cash_amount ?? "")元吗？", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
            self.indicatorBtn.startAnimating()
            self.indicatorBtn.isHidden = false
            
            PaymentProvider.request(.withdraw(exchangeFloat), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
                self.indicatorBtn.isHidden = true
                self.indicatorBtn.stopAnimating()
                
                if code >= 0 {
                    AuthorizationService.sharedInstance.updateUserInfo()
                    if let JSON = JSON, let coin_cash = JSON["coin_cash"] as? [String: Any], let cash_amount = coin_cash["cash_amount"] as? String, let valueFloat = Float(cash_amount) {
                        self.navigationController?.pushViewController(DWithdrawResultViewController(withdrawValue: valueFloat), animated: true)
                    }
                    
                } else {
                    let alertController = UIAlertController(title: nil, message: "未能成功提现，请稍后重试", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }))
        }))
        self.present(alertController, animated: true, completion: nil)
        
        
        
        
    }
    
}
