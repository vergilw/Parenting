//
//  DPaymentViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/14.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DPaymentViewController: BaseViewController {

    lazy fileprivate var balanceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.text = "虚拟币余额"
        return label
    }()
    
    lazy fileprivate var balanceValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h1
        label.textColor = UIConstants.Color.disable
        label.text = "0.00"
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
    
    lazy fileprivate var footnoteLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        label.numberOfLines = 0
        label.setParagraphText("iOS与安卓设备因平台政策问题，充值后仅供苹果设备使用；\n虚拟币只能用于购买氧育APP内的商品；\n虚拟币充值后不可提现、转赠；")
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "支付中心"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        view.drawSeparator(startPoint: CGPoint(x: UIConstants.Margin.leading, y: 163), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.trailing, y: 163))
        
        view.addSubviews([balanceTitleLabel, balanceValueLabel, topUpTitleLabel, collectionView, footnoteLabel])
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
        footnoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.lessThanOrEqualTo(UIConstants.Margin.trailing)
            make.top.equalTo(collectionView.snp.bottom).offset(25)
        }
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============

}


extension DPaymentViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopUpItemCell.className(), for: indexPath) as! TopUpItemCell
        //        cell.setup(attachment: attachments[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
