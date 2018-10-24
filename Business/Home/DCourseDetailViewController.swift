//
//  DCourseDetailViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/24.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DCourseDetailViewController: BaseViewController {

    /*
    private let kBannerHeight: CGFloat = 400.0
    
    private var lastContentOffsetY: CGFloat = 0.0
    
    lazy fileprivate var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.backgroundColor = .gray
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    lazy fileprivate var categoryScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .green
        return scrollView
    }()
    
    lazy fileprivate var bannerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .orange
        return view
    }()
    
    lazy fileprivate var introductionScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.backgroundColor = .red
//        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        return scrollView
    }()
    
    lazy fileprivate var catalogueTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CourseCatalogueCell.self, forCellReuseIdentifier: CourseCatalogueCell.className())
        tableView.separatorStyle = .none
        tableView.rowHeight = 105 //UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        let header = UIView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: kBannerHeight)))
        tableView.tableHeaderView = header
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.estimatedRowHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
        }
        tableView.backgroundColor = .yellow
        tableView.alwaysBounceVertical = true
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        return tableView
    }()
    
    lazy fileprivate var evaluationTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CourseCatalogueCell.self, forCellReuseIdentifier: CourseCatalogueCell.className())
        tableView.separatorStyle = .none
        tableView.rowHeight = 105 // UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        let header = UIView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: kBannerHeight)))
        tableView.tableHeaderView = header
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.estimatedRowHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
        }
        tableView.backgroundColor = .blue
        tableView.alwaysBounceVertical = true
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        return tableView
    }()
    */
    
    lazy fileprivate var categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy fileprivate var introductionBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitle("课程介绍", for: .normal)
//        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var catalogueBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitle("课程目录", for: .normal)
        //        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var evaluationBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitle("互动", for: .normal)
        //        button.addTarget(self, action: #selector(BtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var toolView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationController?.setNavigationBarHidden(true, animated: true)
        
        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
//        view.addSubviews(mainScrollView)
        
//        mainScrollView.addSubviews(categoryScrollView)
//        mainScrollView.addSubviews(introductionScrollView, catalogueTableView, evaluationTableView, bannerView)
        
        setupHeaderView()
        tableView.estimatedRowHeight = 800
        tableView.register(CourseIntroductionCell.self, forCellReuseIdentifier: CourseIntroductionCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubviews(tableView, toolView)
        
        let stackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .fill
            view.axis = .horizontal
            view.distribution = .fillEqually
            return view
        }()
        stackView.addArrangedSubview(introductionBtn)
        stackView.addArrangedSubview(catalogueBtn)
        stackView.addArrangedSubview(evaluationBtn)
        
        let separatorView: SeparatorView = {
            let view = SeparatorView()
            return view
        }()
        categoryView.addSubviews(stackView, separatorView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        toolView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(55)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(toolView.snp.top)
        }
        categoryView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(390)
            make.height.equalTo(62)
        }
//        mainScrollView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        bannerView.snp.makeConstraints { make in
//            make.leading.top.trailing.equalToSuperview()
//            make.height.equalTo(kBannerHeight)
//        }
//        categoryScrollView.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalToSuperview()
//            make.top.equalTo(453)
//            make.height.equalTo(UIScreenHeight+453)
//            make.width.equalTo(UIScreenWidth)
//        }
//        introductionScrollView.snp.makeConstraints { make in
//            make.top.equalTo(0)
//            make.leading.bottom.equalToSuperview()
//            make.width.equalTo(UIScreenWidth)
//            make.height.equalTo(UIScreenHeight)
//        }
//        catalogueTableView.snp.makeConstraints { make in
//            make.top.equalTo(0)
//            make.leading.equalTo(introductionScrollView.snp.trailing)
//            make.bottom.equalToSuperview()
//            make.width.equalTo(introductionScrollView.snp.width)
//            make.height.equalTo(UIScreenHeight)
//        }
//        evaluationTableView.snp.makeConstraints { make in
//            make.top.equalTo(0)
//            make.leading.equalTo(catalogueTableView.snp.trailing)
//            make.bottom.equalToSuperview()
//            make.width.equalTo(introductionScrollView.snp.width)
//            make.trailing.equalToSuperview()
//            make.height.equalTo(UIScreenHeight)
//        }
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
    
    /*
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            if let object = object as? UIScrollView {
//                if bannerView.frame.origin.y + bannerView.frame.size.height > 0 {
//                    bannerView.centerY = -(lastContentOffsetY-object.contentOffset.y)
//                    lastContentOffsetY = object.contentOffset.y
                    bannerView.snp.remakeConstraints { make in
                        make.top.equalTo(-(object.contentOffset.y))
                        make.leading.trailing.equalToSuperview()
                        make.height.equalTo(kBannerHeight)
                    }
//                }
                
            }
            
        }
    }
 */
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        if scrollView == mainScrollView {
//            if mainScrollView.contentOffset.y > 453 {
//                catalogueTableView.isScrollEnabled = true
//                evaluationTableView.isScrollEnabled = true
//            } else {
//                catalogueTableView.isScrollEnabled = false
//                evaluationTableView.isScrollEnabled = false
//            }
////        }
//    }
    
    deinit {
//        introductionScrollView.removeObserver(self, forKeyPath: "contentOffset")
//        catalogueTableView.removeObserver(self, forKeyPath: "contentOffset")
//        evaluationTableView.removeObserver(self, forKeyPath: "contentOffset")
    }
}


extension DCourseDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func setupHeaderView() {
        let headerView: UIView = {
            let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: 390+62)))
            view.backgroundColor = .white
            return view
        }()
        
        let bannerView: UIView = {
            let view = UIView()
            view.backgroundColor = .green
            return view
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 25)
            label.textColor = .black
            label.numberOfLines = 5
            return label
        }()
        
        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .black
            return label
        }()
        
        let footnoteLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .black
            return label
        }()
        
        let tagLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 15)
            label.textColor = .black
            return label
        }()
        
        headerView.addSubviews(bannerView, titleLabel, descriptionLabel, footnoteLabel, tagLabel)
        
        //FIXME: category
        headerView.addSubview(categoryView)
        
        bannerView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.top.equalTo(bannerView.snp.bottom).offset(20)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(12)
        }
        footnoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.height.equalTo(12)
        }
        tagLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-25)
            make.centerY.equalTo(footnoteLabel)
        }
        
        let attributedString = NSMutableAttributedString(string: "如何规划幼儿英语教育前期的引导成长的历程.")
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 10
        attributedString.addAttributes([
            NSAttributedString.Key.paragraphStyle: paragraph], range: NSRange(location: 0, length: attributedString.length))
        titleLabel.attributedText = attributedString
        
        descriptionLabel.text = "适合人群：宝宝0-3岁"
        footnoteLabel.text = "560人已学习"
        tagLabel.text = "已购买"
        
        tableView.tableHeaderView = headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseIntroductionCell.className(), for: indexPath)
        return cell
    }
}

extension DCourseDetailViewController: UIScrollViewDelegate {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == mainScrollView {
//            if scrollView.contentOffset.y > 453 {
//                catalogueTableView.isScrollEnabled = true
//                evaluationTableView.isScrollEnabled = true
//            } else {
//                catalogueTableView.isScrollEnabled = false
//                evaluationTableView.isScrollEnabled = false
//            }
//        }
//    }
}
