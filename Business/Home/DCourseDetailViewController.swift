//
//  DCourseDetailViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/24.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class DCourseDetailViewController: BaseViewController {

//    fileprivate enum CourseDisplayMode {
//        case introduction
//        case catalogue
//        case evaluation
//    }
//
//    fileprivate var courseDisplayMode: CourseDisplayMode = .introduction
    
    private let kBannerHeight: CGFloat = 434/750.0*UIScreenWidth
    
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
    
    lazy fileprivate var viewModel = DCourseDetailViewModel()
    
    lazy fileprivate var categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
//        view.setLayerShadow(UIColor(white: 0, alpha: 0.2), offset: CGSize(width: 0, height: 3), radius: 0.5)
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor(white: 0, alpha: 0.2).cgColor
        return view
    }()
    
    lazy fileprivate var introductionBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor("#101010"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("课程介绍", for: .normal)
        button.addTarget(self, action: #selector(categoryBtnAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var catalogueBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor("#777"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitle("课程目录", for: .normal)
        button.addTarget(self, action: #selector(categoryBtnAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var evaluationBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor("#777"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitle("互动", for: .normal)
        button.addTarget(self, action: #selector(categoryBtnAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var categoryIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor("#00a7a9")
        return imgView
    }()
    
    lazy fileprivate var toolView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
//        view.setLayerShadow(UIColor(white: 0, alpha: 0.2), offset: CGSize(width: 0, height: -2.5), radius: 2.5)
        view.layer.shadowOffset = CGSize(width: 0, height: -3)
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor(white: 0, alpha: 0.2).cgColor
        return view
    }()
    
    lazy fileprivate var favoriteBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.foot, for: .normal)
        button.titleLabel?.font = UIConstants.Font.foot
        button.addTarget(self, action: #selector(favoriteBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var favoriteImgView: UIImageView = {
        let imgView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 22, height: 20)))
        imgView.image = UIImage(named: "course_favoriteNormal")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy fileprivate var favoriteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor("#999")
        label.text = "收藏"
        return label
    }()
    
    lazy fileprivate var auditionBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.body, for: .normal)
        button.titleLabel?.font = UIConstants.Font.body
        button.addTarget(self, action: #selector(auditionBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var auditionImgView: UIImageView = {
        let imgView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 22, height: 20)))
        imgView.image = UIImage(named: "course_audition")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy fileprivate var auditionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor("#999")
        label.text = "试听"
        return label
    }()
    
    lazy fileprivate var toolActionBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 2.5
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIConstants.Font.h2
        button.setTitle("立即学习", for: .normal)
        button.backgroundColor = UIColor("#00a7a9")
        button.addTarget(self, action: #selector(toolActionBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var isTrackingCategoryEnable: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationController?.setNavigationBarHidden(true, animated: true)
        
        navigationItem.title = "课程详情"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "public_shareBarItem")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(shareBarItemAction))
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        viewModel.fetchCourse { (bool) in
            self.reload()
        }
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
//        view.addSubviews(mainScrollView)
        
//        mainScrollView.addSubviews(categoryScrollView)
//        mainScrollView.addSubviews(introductionScrollView, catalogueTableView, evaluationTableView, bannerView)
        
        
        
        tableView.estimatedRowHeight = 800
        tableView.register(CourseIntroductionCell.self, forCellReuseIdentifier: CourseIntroductionCell.className())
        tableView.register(CourseCatalogueCell.self, forCellReuseIdentifier: CourseCatalogueCell.className())
        tableView.register(CourseCatalogueTitleCell.self, forCellReuseIdentifier: CourseCatalogueTitleCell.className())
        tableView.register(CourseEvaluationTitleCell.self, forCellReuseIdentifier: CourseEvaluationTitleCell.className())
        tableView.register(CourseEvaluationCell.self, forCellReuseIdentifier: CourseEvaluationCell.className())
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubviews(tableView, toolView, categoryView)
        
        initCategoryContentView()
        initToolContentView()
        setupHeaderView()
    }
    
    func initCategoryContentView() {
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
        
        let separatorImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.backgroundColor = UIColor("#f3f4f6")
            return imgView
        }()
        categoryView.addSubviews(stackView, separatorImgView, categoryIndicatorImgView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        separatorImgView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        categoryIndicatorImgView.snp.makeConstraints { make in
            make.centerX.equalTo(introductionBtn)
            make.width.equalTo(27.5)
            make.height.equalTo(1.5)
            make.bottom.equalToSuperview()
        }
    }
    
    func initToolContentView() {
        toolView.addSubviews(favoriteBtn, auditionBtn, toolActionBtn)
        favoriteBtn.addSubviews(favoriteImgView, favoriteLabel)
        auditionBtn.addSubviews(auditionImgView, auditionLabel)
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        toolView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            if #available(iOS 11, *) {
                make.height.equalTo((navigationController?.view.safeAreaInsets.bottom ?? 0)+55)
            } else {
                make.height.equalTo(55)
            }
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(toolView.snp.top)
        }
        categoryView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo((tableView.tableHeaderView?.bounds.size.height ?? 0) - 62)
            make.height.equalTo(62)
        }
        favoriteBtn.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.top.equalToSuperview()
            if #available(iOS 11, *) {
                make.bottom.equalTo(-(navigationController?.view.safeAreaInsets.bottom ?? 0))
            } else {
                make.bottom.equalTo(55)
            }
            make.width.equalTo(52)
        }
        favoriteImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(12)
        }
        favoriteLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-6)
        }
        auditionBtn.snp.makeConstraints { make in
            make.leading.equalTo(favoriteBtn.snp.trailing)
            make.top.equalToSuperview()
            if #available(iOS 11, *) {
                make.bottom.equalTo(-(navigationController?.view.safeAreaInsets.bottom ?? 0))
            } else {
                make.bottom.equalTo(55)
            }
            make.width.equalTo(52)
        }
        auditionImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
        }
        auditionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-6)
        }

        toolActionBtn.snp.makeConstraints { make in
            make.leading.equalTo(auditionBtn.snp.trailing).offset(10)
            make.trailing.equalTo(-25)
            make.top.equalTo(7.5)
            make.height.equalTo(40)
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
        setupHeaderView()
        
        if viewModel.courseModel?.is_favorite == true {
            favoriteImgView.image = UIImage(named: "course_favoriteSelected")
            favoriteLabel.text = "已收藏"
        } else {
            favoriteImgView.image = UIImage(named: "course_favoriteNormal")
            favoriteLabel.text = "收藏"
        }
        
        if viewModel.courseModel?.audition == true || viewModel.courseModel?.is_bought == true {
            toolActionBtn.backgroundColor = UIColor("#00a7a9")
            toolActionBtn.setTitle("立即学习", for: .normal)
            auditionBtn.isHidden = true
            toolActionBtn.snp.remakeConstraints { make in
                make.leading.equalTo(favoriteBtn.snp.trailing).offset(10)
                make.trailing.equalTo(-25)
                make.top.equalTo(7.5)
                make.height.equalTo(40)
            }
        } else {
            toolActionBtn.backgroundColor = UIColor("#f05053")
            toolActionBtn.setTitle("立即购买", for: .normal)
            
            let isFound = viewModel.courseModel?.course_catalogues?.contains(where: { (model) -> Bool in
                return model.audition ?? false
            }) ?? false
            if isFound {
                auditionBtn.isHidden = false
                toolActionBtn.snp.remakeConstraints { make in
                    make.leading.equalTo(auditionBtn.snp.trailing).offset(10)
                    make.trailing.equalTo(-25)
                    make.top.equalTo(7.5)
                    make.height.equalTo(40)
                }
            } else {
                auditionBtn.isHidden = true
                toolActionBtn.snp.remakeConstraints { make in
                    make.leading.equalTo(favoriteBtn.snp.trailing).offset(10)
                    make.trailing.equalTo(-25)
                    make.top.equalTo(7.5)
                    make.height.equalTo(40)
                }
            }
        }
        
    }
    
    // MARK: - ============= Action =============
    
    @objc func categoryBtnAction(sender: UIButton) {
        isTrackingCategoryEnable = false
        
        categoryIndicatorImgView.snp.remakeConstraints { make in
            make.centerX.equalTo(sender)
            make.width.equalTo(27.5)
            make.height.equalTo(1.5)
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.35, animations: {
            self.categoryView.layoutIfNeeded()
        }) { (bool) in
            self.isTrackingCategoryEnable = true
        }
        
        introductionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        catalogueBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        evaluationBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        introductionBtn.setTitleColor(UIColor("#777"), for: .normal)
        catalogueBtn.setTitleColor(UIColor("#777"), for: .normal)
        evaluationBtn.setTitleColor(UIColor("#777"), for: .normal)
        
        sender.setTitleColor(UIColor("#101010"), for: .normal)
        sender.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        if sender == introductionBtn {
//            courseDisplayMode = .introduction
            
//            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
            let rect = tableView.rectForRow(at: IndexPath(row: 0, section: 0))
            if rect.origin.y + tableView.bounds.size.height - 62 < tableView.contentSize.height {
                tableView.setContentOffset(CGPoint(x: 0, y: rect.origin.y-62), animated: true)
            } else {
                tableView.scrollToBottom()
            }
            
        } else if sender == catalogueBtn {
//            courseDisplayMode = .catalogue
//            tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: UITableView.ScrollPosition.top, animated: true)
            let rect = tableView.rectForRow(at: IndexPath(row: 0, section: 1))
            if rect.origin.y + tableView.bounds.size.height - 62 < tableView.contentSize.height {
                tableView.setContentOffset(CGPoint(x: 0, y: rect.origin.y-62), animated: true)
            } else {
                tableView.scrollToBottom()
            }
            
        } else if sender == evaluationBtn {
//            courseDisplayMode = .evaluation
//            tableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: UITableView.ScrollPosition.top, animated: true)
            let rect = tableView.rectForRow(at: IndexPath(row: 0, section: 2))
            if rect.origin.y + tableView.bounds.size.height - 62 < tableView.contentSize.height {
                tableView.setContentOffset(CGPoint(x: 0, y: rect.origin.y-62), animated: true)
            } else {
                tableView.scrollToBottom()
            }
        }
//        tableView.reloadData()
        
        
    }
    
    @objc func shareBarItemAction() {
        
    }
    
    @objc func favoriteBtnAction() {
        guard let isFavorite = viewModel.courseModel?.is_favorite else {
            return
        }
        viewModel.courseModel?.is_favorite = !isFavorite
        
        if viewModel.courseModel?.is_favorite == true {
            favoriteImgView.image = UIImage(named: "course_favoriteSelected")
            favoriteLabel.text = "已收藏"
        } else {
            favoriteImgView.image = UIImage(named: "course_favoriteNormal")
            favoriteLabel.text = "收藏"
        }
    }
    
    @objc func auditionBtnAction() {
        
    }
    
    @objc func toolActionBtnAction() {
        guard viewModel.courseModel?.is_bought == false else { return }
        
        let alertController = UIAlertController(title: "是否购买？", message: nil, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "true", style: UIAlertAction.Style.default, handler: { (_) in
            self.viewModel.courseModel?.is_bought = true
            self.reload()
        }))
        alertController.addAction(UIAlertAction(title: "false", style: UIAlertAction.Style.cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
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
            view.clipsToBounds = true
            return view
        }()
        let bannerImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.contentMode = .scaleAspectFill
            return imgView
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 25)
            label.textColor = UIColor("#222")
            label.numberOfLines = 5
            return label
        }()
        
        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor("#777")
            return label
        }()
        
        let footnoteLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor("#f26a44")
            return label
        }()
        
        let tagLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 15)
            label.layer.cornerRadius = 2.5
            label.textAlignment = .center
            label.textColor = UIColor("#ccc")
            return label
        }()
        
        headerView.addSubviews(bannerView, titleLabel, descriptionLabel, footnoteLabel, tagLabel)
        bannerView.addSubview(bannerImgView)
        
        bannerView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(kBannerHeight)
        }
        bannerImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        
        if let URLString = viewModel.courseModel?.cover_attribute?.service_url {
            bannerImgView.kf.setImage(with: URL(string: URLString))
        }
        
        
        let attributedString = NSMutableAttributedString(string: viewModel.courseModel?.title ?? "")
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 10
        attributedString.addAttributes([
            NSAttributedString.Key.paragraphStyle: paragraph], range: NSRange(location: 0, length: attributedString.length))
        titleLabel.attributedText = attributedString
        
        descriptionLabel.text = "适合人群：" + (viewModel.courseModel?.suitable ?? "")
        footnoteLabel.text = String(viewModel.courseModel?.students_count ?? 0) + "人已学习"
        
        if viewModel.courseModel?.is_bought == true {
            tagLabel.text = "已购买"
            tagLabel.textColor = UIColor("#ccc")
            tagLabel.backgroundColor = .white
            tagLabel.snp.remakeConstraints { make in
                make.trailing.equalTo(-25)
                make.centerY.equalTo(footnoteLabel)
            }
        } else if viewModel.courseModel?.audition == true {
            tagLabel.text = "免费试听"
            tagLabel.textColor = UIColor("#f05053")
            tagLabel.backgroundColor = UIColor(hex6: 0xf05053, alpha: 0.1)
            tagLabel.snp.remakeConstraints { make in
                make.trailing.equalTo(-35)
                make.centerY.equalTo(footnoteLabel)
                make.width.equalTo(80)
                make.height.equalTo(25)
            }
        } else if let price = viewModel.courseModel?.price {
            tagLabel.text = String(format: "¥ %.0f", price)
            tagLabel.textColor = UIColor("#ef5226")
            tagLabel.backgroundColor = .white
            tagLabel.snp.remakeConstraints { make in
                make.trailing.equalTo(-25)
                make.centerY.equalTo(footnoteLabel)
            }
        }
        
        var titleHeight = titleLabel.systemLayoutSizeFitting(CGSize(width: UIScreenWidth-50, height: CGFloat.greatestFiniteMagnitude)).height
        if titleHeight < titleLabel.font.lineHeight*2 {
            let attributedString = NSMutableAttributedString(string: viewModel.courseModel?.title ?? "")
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 0
            attributedString.addAttributes([
                NSAttributedString.Key.paragraphStyle: paragraph], range: NSRange(location: 0, length: attributedString.length))
            titleLabel.attributedText = attributedString
            
            
            titleLabel.snp.remakeConstraints { make in
                make.leading.equalTo(25)
                make.trailing.equalTo(-25)
                make.top.equalTo(bannerView.snp.bottom).offset(20)
                make.height.equalTo(25)
            }
            titleHeight = 25
        }
        headerView.frame = CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: kBannerHeight+20+titleHeight+20+12+10+12+25+62))
        tableView.tableHeaderView = headerView
        
        categoryView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo((tableView.tableHeaderView?.bounds.size.height ?? 0) - 62)
            make.height.equalTo(62)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            //FIXME: test model
            guard let catalogues = viewModel.courseModel?.course_catalogues else { return 1 }
            return catalogues.count + 8
//            return (viewModel.courseModel?.course_catalogues?.count ?? 0) + 1
        } else if section == 2 {
            return 1 + 4
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CourseIntroductionCell.className(), for: indexPath) as! CourseIntroductionCell
            if let model = viewModel.courseModel {
                cell.setup(model: model)
            }
            return cell
            
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CourseCatalogueTitleCell.className(), for: indexPath)
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CourseCatalogueCell.className(), for: indexPath) as! CourseCatalogueCell
            if let model = viewModel.courseModel {
                //FIXME: index 0
                cell.setup(model: model.course_catalogues![0], isPlayed: indexPath.row == 1 ? true : false, isBought: model.is_bought ?? false)
            }
            return cell
            
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CourseEvaluationTitleCell.className(), for: indexPath)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: CourseEvaluationCell.className(), for: indexPath) as! CourseEvaluationCell
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(DCourseSectionViewController(), animated: true)
    }
}

extension DCourseDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == mainScrollView {
//            if scrollView.contentOffset.y > 453 {
//                catalogueTableView.isScrollEnabled = true
//                evaluationTableView.isScrollEnabled = true
//            } else {
//                catalogueTableView.isScrollEnabled = false
//                evaluationTableView.isScrollEnabled = false
//            }
//        }
        
        var offsetY = (tableView.tableHeaderView?.bounds.size.height ?? 0) - 62 - scrollView.contentOffset.y
        if offsetY < 0 {
            offsetY = 0
            navigationItem.title = viewModel.courseModel?.title ?? "课程详情"
        } else {
            navigationItem.title = "课程详情"
        }
        
        if isTrackingCategoryEnable {
    //        let rect1 = tableView.rectForRow(at: IndexPath(row: 0, section: 0))
            let rect2 = tableView.rectForRow(at: IndexPath(row: 0, section: 1))
            let rect3 = tableView.rectForRow(at: IndexPath(row: 0, section: 2))

            var sender: UIButton
            if scrollView.contentOffset.y+62 >= rect3.origin.y {
                sender = evaluationBtn
            } else if scrollView.contentOffset.y+62 >= rect2.origin.y {
                sender = catalogueBtn
            } else  {
                sender = introductionBtn
            }
            categoryIndicatorImgView.snp.remakeConstraints { make in
                make.centerX.equalTo(sender)
                make.width.equalTo(27.5)
                make.height.equalTo(1.5)
                make.bottom.equalToSuperview()
            }
            
    //        UIView.animate(withDuration: 0.25) {
    //            self.categoryView.layoutIfNeeded()
    //        }
            
            introductionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            catalogueBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            evaluationBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            introductionBtn.setTitleColor(UIColor("#777"), for: .normal)
            catalogueBtn.setTitleColor(UIColor("#777"), for: .normal)
            evaluationBtn.setTitleColor(UIColor("#777"), for: .normal)
            
            sender.setTitleColor(UIColor("#101010"), for: .normal)
            sender.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        }
        
        categoryView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(offsetY)
            make.height.equalTo(62)
        }
    }
}
