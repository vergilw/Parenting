//
//  DPaymentViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/14.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DPaymentViewController: BaseViewController {

    lazy fileprivate var advanceModels: [AdvanceModel]? = nil
    
    lazy fileprivate var balanceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.text = "氧育币余额"
        return label
    }()
    
    lazy fileprivate var balanceValueLabel: PriceLabel = {
        let label = PriceLabel()
        label.font = UIConstants.Font.h1
        label.textColor = UIConstants.Color.disable
        return label
    }()
    
    lazy fileprivate var topUpTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.text = "充值"
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
        label.setParagraphText("iOS与安卓设备因平台政策问题，充值后仅供苹果设备使用；\n氧育币只能用于购买氧育APP内的商品；\n氧育币充值后不可提现、转赠；")
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "支付中心"
        
        if presentingViewController != nil {
            initDismissBtn()
        }
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        reload()
        fetchData()
        AuthorizationService.sharedInstance.updateUserInfo()
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        view.drawSeparator(startPoint: CGPoint(x: UIConstants.Margin.leading, y: 163), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.trailing, y: 163))
        
        view.addSubviews([balanceTitleLabel, balanceValueLabel, topUpTitleLabel, collectionView, indicatorBtn, footnoteLabel])
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        balanceTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(60)
        }
        balanceValueLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(balanceTitleLabel.snp.bottom).offset(32)
        }
        topUpTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(balanceValueLabel.snp.bottom).offset(94)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topUpTitleLabel.snp.bottom).offset(32)
            make.height.equalTo(150)
        }
        indicatorBtn.snp.makeConstraints { make in
            make.edges.equalTo(collectionView)
        }
        footnoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.lessThanOrEqualTo(UIConstants.Margin.trailing)
            make.top.equalTo(collectionView.snp.bottom).offset(25)
        }
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.User.userInfoDidChange, object: nil)
    }
    
    // MARK: - ============= Request =============
    func fetchData() {
        HUDService.sharedInstance.showFetchingView(target: self.view)
        
        PaymentProvider.request(.advances, completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            HUDService.sharedInstance.hideFetchingView(target: self.view)
            if code >= 0 {
                if let data = JSON?["advances"] as? [[String: Any]] {
                    self.advanceModels = [AdvanceModel].deserialize(from: data) as? [AdvanceModel]
                    self.collectionView.reloadData()
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
        if let balance = AuthorizationService.sharedInstance.user?.balance {
            balanceValueLabel.textColor = UIConstants.Color.primaryOrange
            balanceValueLabel.setPriceText(text: balance, discount: nil)
        }
        
    }
    
    // MARK: - ============= Action =============
}


extension DPaymentViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return advanceModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopUpItemCell.className(), for: indexPath) as! TopUpItemCell
        if let model = advanceModels?[indexPath.row] {
            cell.setup(model: model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let models = advanceModels else { return }
        
        if let model = advanceModels?[exist: indexPath.row], let productID = model.apple_product_id {
            indicatorBtn.startAnimating()
            indicatorBtn.isHidden = false
            PaymentService.sharedInstance.purchaseProduct(productID: productID, models: models, complete: { (status) in
                self.indicatorBtn.isHidden = true
                self.indicatorBtn.stopAnimating()
                
                if status {
                    HUDService.sharedInstance.show(string: "已成功充值")
                    if self.presentingViewController != nil {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                } else {
//                    HUDService.sharedInstance.show(string: "充值失败")
                    let alertController = UIAlertController(title: nil, message: "未能成功充值，请稍后重试", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
}
