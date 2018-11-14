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
    
//    lazy fileprivate var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.itemSize = UICollectionViewFlowLayout.automaticSize
//        layout.estimatedItemSize = CGSize(width: 80, height: 71)
//        layout.sectionInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
//        layout.minimumLineSpacing = 10
//        layout.minimumInteritemSpacing = 10
//        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        view.register(<#cell#>.self, forCellWithReuseIdentifier: <#cell#>.className())
//        view.dataSource = self
//        view.delegate = self
//        view.backgroundColor = .white
//        view.alwaysBounceHorizontal = true
//        view.allowsSelection = true
//        return view
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        
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
