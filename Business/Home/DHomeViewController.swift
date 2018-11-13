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
        layout.sectionInset = UIEdgeInsets(top: 30, left: 25, bottom: 0, right: 25)
        layout.minimumLineSpacing = 32
        layout.minimumInteritemSpacing = 12
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(HomeSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeader.className())
        view.register(PickedCourseCell.self, forCellWithReuseIdentifier: PickedCourseCell.className())
        view.dataSource = self
        view.delegate = self
        view.isScrollEnabled = false
        view.backgroundColor = .red
        view.alwaysBounceHorizontal = true
        view.allowsSelection = true
        return view
    }()
    
    lazy fileprivate var bottomBannerView: UIView = {
        let view = UIView()
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
        scrollView.addSubviews(carouselView, coursesCollectionView, bottomBannerView)
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        carouselView.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.trailing.equalTo(scrollView)
            make.top.equalTo(22)
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo(200)
        }
        coursesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView)
            make.top.equalTo(carouselView.snp.bottom).offset(50)
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo(697)
        }
        bottomBannerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView)
            make.top.equalTo(coursesCollectionView.snp.bottom)
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo(200)
            make.bottom.equalTo(-90)
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


extension DHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreenWidth, height: 81)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeader.className(), for: indexPath)
            return view
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PickedCourseCell.className(), for: indexPath) as! PickedCourseCell
//        cell.setup(attachment: attachments[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        navigationController?.pushViewController(DCourseDetailViewController(courseID: 2), animated: true)
        
        //FIXME: debug
        let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
        present(authorizationNavigationController, animated: true, completion: nil)
    }
    
}

class HomeSectionHeader: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
            label.textColor = .black
            label.text = "在家核心早教课"
            return label
        }()
        
        let footnoteLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = .black
            label.text = "品质和经过验证的精选课程"
            return label
        }()
        
        addSubviews(titleLabel, footnoteLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(0)
//            make.height.equalTo(24)
        }
        
        footnoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(titleLabel.snp.lastBaseline).offset(10)
//            make.height.equalTo(24)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
