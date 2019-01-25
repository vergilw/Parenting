//
//  DTopUpViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/14.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DTopUpViewController: BaseViewController {

    lazy fileprivate var advanceModels: [AdvanceModel]? = nil

    lazy fileprivate var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
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
        label.setParagraphText("1、因Apple政策原因，充值仅限Apple制定价格\n2、氧育币可用于直接购买APP内虚拟内容\n3、氧育币仅限iOS系统消费，无法在其他系统使用\n4、氧育币为虚拟币，充值后的氧育币不会过期，但无法提现或转赠他人\n5、如果遇到其他问题，请和客服取得联系协同解决，客服微信：Yangyuqinzi1314    客服电话：027-87775828")
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "氧育币充值"
        
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
        initNavigationItem()
        
        view.addSubview(scrollView)
        
        scrollView.drawSeparator(startPoint: CGPoint(x: UIConstants.Margin.leading, y: 163), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.trailing, y: 163))
        
        scrollView.addSubviews([balanceTitleLabel, balanceValueLabel, topUpTitleLabel, collectionView, indicatorBtn, footnoteLabel])
    }
    
    fileprivate func initNavigationItem() {
        let detailsBtn: ActionButton = {
            let button = ActionButton()
            button.frame = CGRect(origin: .zero, size: CGSize(width: 84, height: 44))
            button.setIndicatorColor(UIConstants.Color.primaryRed)
            button.setTitleColor(UIConstants.Color.primaryGreen, for: .normal)
            button.titleLabel?.font = UIConstants.Font.h2_regular
            button.setTitle("记录", for: .normal)
            button.addTarget(self, action: #selector(detailsBtnAction), for: .touchUpInside)
            return button
        }()
        
        let barBtnItem = UIBarButtonItem(customView: detailsBtn)
        barBtnItem.width = 34+50
        navigationItem.rightBarButtonItem = barBtnItem
        navigationItem.rightMargin = 0
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
    @objc func detailsBtnAction() {
        navigationController?.pushViewController(DCoinDetailsViewController(), animated: true)
    }
}


extension DTopUpViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
