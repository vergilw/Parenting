//
//  DExchangeViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/24.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DExchangeViewController: BaseViewController {

    lazy fileprivate var advanceModels: [AdvanceModel]? = nil
    
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
        label.text = "金币余额"
        label.setSymbolText("金币余额（约1个氧育币）", symbolText: "（约1个氧育币）", symbolAttributes: [NSAttributedString.Key.font : UIConstants.Font.body, NSAttributedString.Key.foregroundColor: UIConstants.Color.foot])
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
        label.setParagraphText("注意事项：\n暂时仅支持提现的微信；\n金币可以进行提现，也可以兑换氧育币；\n虚拟币不可转赠；")
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
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        if let balance = AuthorizationService.sharedInstance.user?.balance {
            if Int(balance) != 0 {
                balanceValueLabel.textColor = UIConstants.Color.primaryOrange
            }
            balanceValueLabel.setPriceText(text: balance, discount: nil)
        }
        
        //FIXME: DEBUG
        balanceValueLabel.setPriceText(text: "11.0", discount: nil)
    }
    
    // MARK: - ============= Action =============

}


extension DExchangeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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

