//
//  DExchangeViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/24.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DExchangeViewController: BaseViewController {

    lazy fileprivate var exchangeModels: [RewardExchangeModel]? = nil
    
    fileprivate var exchangeRatio: Float?
    
    lazy fileprivate var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    fileprivate lazy var bgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "payment_topBg")
        return imgView
    }()
    
    fileprivate lazy var backBarBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "public_backBarItem")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        if #available(iOS 11.0, *) {
            button.imageEdgeInsets = UIEdgeInsets(top: UIStatusBarHeight, left: 0, bottom: 0, right: 0)
        }
        button.addTarget(self, action: #selector(backBarItemAction), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h1
        label.textColor = .white
        label.textAlignment = .center
        label.text = "金币兑换"
        return label
    }()
    
    lazy fileprivate var balanceTitleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
        label.textColor = .white
        label.setParagraphText("金币余额")
        return label
    }()
    
    fileprivate lazy var balanceExchangLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = .white
        return label
    }()
    
    fileprivate lazy var balanceView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowOpacity = 0.05
        view.layer.shadowColor = UIColor.black.cgColor
        //        view.clipsToBounds = true
        return view
    }()
    
    fileprivate lazy var balanceIconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "payment_rewardCoinIcon")
        return imgView
    }()
    
    lazy fileprivate var balanceValueLabel: PriceLabel = {
        let label = PriceLabel()
        label.font = UIConstants.Font.largeTitle
        label.textColor = UIConstants.Color.disable
        return label
    }()
    
    lazy fileprivate var balanceNoteLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot2
        label.textColor = UIConstants.Color.foot
        label.setParagraphText("注：100金币约等于1氧育币")
        return label
    }()
    
    lazy fileprivate var topUpTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.text = "兑换氧育币"
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
        label.setParagraphText("注意事项：\n1. 目前仅支持金币兑换氧育币；\n2. 金币与氧育币的兑换关系：1氧育币约等于100金币；\n3.如果遇到其他问题，请和客服取得联系协同解决，客服微信：Yangyuqinzi1314    客服电话：027-87775828")
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

        navigationItem.title = "金币兑换"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubviews([scrollView])
        
        scrollView.drawSeparator(startPoint: CGPoint(x: UIConstants.Margin.leading, y: 150), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.trailing, y: 150))
        
        scrollView.addSubviews([bgImgView, backBarBtn, navigationTitleLabel, balanceTitleLabel, balanceExchangLabel, balanceView, balanceNoteLabel, topUpTitleLabel, collectionView, indicatorBtn, footnoteLabel])
        
        balanceView.addSubviews([balanceIconImgView, balanceValueLabel])
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
        
        bgImgView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(balanceView)
        }
        backBarBtn.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalTo(62.5)
            if #available(iOS 11.0, *) {
                var topHeight = (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)
                if topHeight == 0 {
                    topHeight = 20
                }
                make.height.equalTo(topHeight+(navigationController?.navigationBar.bounds.size.height ?? 0))
            } else {
                make.height.equalTo((navigationController?.navigationBar.bounds.size.height ?? 0))
            }
        }
        navigationTitleLabel.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(UIStatusBarHeight)
            } else {
                make.top.equalTo(0)
            }
            make.centerX.equalToSuperview()
            make.height.equalTo((navigationController?.navigationBar.bounds.size.height ?? 0))
        }
        
        balanceTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            if #available(iOS 11.0, *) {
                make.top.equalTo(38+(self.navigationController?.navigationBar.bounds.height ?? 0)+UIStatusBarHeight)
            } else {
                make.top.equalTo(38+(self.navigationController?.navigationBar.bounds.height ?? 0))
            }
        }
        balanceExchangLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.lastBaseline.equalTo(balanceTitleLabel)
        }
        
        balanceView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(balanceTitleLabel.snp.bottom).offset(18)
            make.height.equalTo(62)
        }
        
        balanceIconImgView.snp.makeConstraints { make in
            make.leading.equalTo(18)
            make.centerY.equalToSuperview()
        }
        balanceValueLabel.snp.makeConstraints { make in
            make.leading.equalTo(balanceIconImgView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        
        balanceNoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(balanceView.snp.bottom).offset(10)
        }
        topUpTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(balanceNoteLabel.snp.bottom).offset(45)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topUpTitleLabel.snp.bottom).offset(20)
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
        
        RewardCoinProvider.request(.reward_exchangeList, completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            HUDService.sharedInstance.hideFetchingView(target: self.view)
            
            if code >= 0 {
                if let data = JSON?["coin_wallets"] as? [[String: Any]] {
                    if let models = [RewardExchangeModel].deserialize(from: data) as? [RewardExchangeModel] {
                        self.exchangeModels = models
                    }
                    self.collectionView.reloadData()
                }
                if let ratio = JSON?["coin_to_wallet"] as? NSNumber, let balance = AuthorizationService.sharedInstance.user?.reward, let balanceFloat = Float(balance), balanceFloat > 0 {
                    self.exchangeRatio = ratio.floatValue
                    let string = String(format: "（约%.2f个氧育币）", floor(balanceFloat*ratio.floatValue*100)/100.0)
                    self.balanceExchangLabel.setSymbolText("\(string)", symbolText: string, symbolAttributes: nil)
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
                balanceValueLabel.textColor = UIConstants.Color.head
            }
            balanceValueLabel.setPriceText(text: balance, discount: nil)
            
            if let ratio = exchangeRatio, let balanceFloat = Float(balance), balanceFloat > 0 {
                let string = String(format: "（约%.2f个氧育币）", floor(balanceFloat*ratio*100)/100.0)
                self.balanceExchangLabel.setSymbolText("\(string)", symbolText: string, symbolAttributes: nil)
            }
        }
        
    }
    
    // MARK: - ============= Action =============

}


extension DExchangeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
            cell.setupExchange(model: model, isEnabled: rewardBalance >= amount)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let reward = AuthorizationService.sharedInstance.user?.reward, let rewardFloat = Float(reward) else { return }
        guard let model = exchangeModels?[exist: indexPath.row], let exchangeValue = model.coin_amount, let exchangeFloat = Float(exchangeValue) else { return }
        guard rewardFloat >= exchangeFloat else { return }

        
        let alertController = UIAlertController(title: nil, message: "确认用\(model.coin_amount ?? "")金币兑换\(model.wallet_amount ?? "")氧育币吗？", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
            self.indicatorBtn.startAnimating()
            self.indicatorBtn.isHidden = false
            
            RewardCoinProvider.request(.reward_exchange(exchangeFloat), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
                self.indicatorBtn.isHidden = true
                self.indicatorBtn.stopAnimating()
                
                if code >= 0 {
                    HUDService.sharedInstance.show(string: "已成功兑换")
                    AuthorizationService.sharedInstance.updateUserInfo()
                } else {
                    let alertController = UIAlertController(title: nil, message: "未能成功兑换，请稍后重试", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }))
        }))
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
}

