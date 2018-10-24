//
//  DHomeViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/23.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DHomeViewController: BaseViewController {
    
    lazy fileprivate var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    lazy fileprivate var mainStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.axis = .vertical
        view.distribution = .fillProportionally
        return view
    }()
    
    lazy fileprivate var carouselView: iCarousel = {
        let view = iCarousel(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.size.width, height: 300)))
        view.backgroundColor = .green
        return view
    }()
    
    lazy fileprivate var coursesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 80, height: 122)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let view = UICollectionView(frame: CGRect(origin: CGPoint(x: 0, y: 300), size: CGSize(width: UIScreen.main.bounds.size.width, height: 300)), collectionViewLayout: layout)
//        view.register(<#cell#>.self, forCellWithReuseIdentifier: <#cell#>.className())
//        view.dataSource = self
//        view.delegate = self
        view.backgroundColor = .red
        view.alwaysBounceHorizontal = true
        view.allowsSelection = true
        return view
    }()
    
    lazy fileprivate var bottomBannerView: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 600), size: CGSize(width: UIScreen.main.bounds.size.width, height: 300)))
        view.backgroundColor = .yellow
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(carouselView)
        mainStackView.addArrangedSubview(coursesCollectionView)
        mainStackView.addArrangedSubview(bottomBannerView)
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo(900)
        }
        
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        tableView.reloadData()
    }
    
    // MARK: - ============= Action =============
}
