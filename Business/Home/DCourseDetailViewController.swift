//
//  DCourseDetailViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/24.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher
import Presentr
import UITableView_FDTemplateLayoutCell

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
        button.setTitleColor(UIConstants.Color.head, for: .normal)
        button.titleLabel?.font = UIConstants.Font.h2
        button.setTitle("课程介绍", for: .normal)
        button.addTarget(self, action: #selector(categoryBtnAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var catalogueBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.body, for: .normal)
        button.titleLabel?.font = UIConstants.Font.body
        button.setTitle("课程目录", for: .normal)
        button.addTarget(self, action: #selector(categoryBtnAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var evaluationBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.body, for: .normal)
        button.titleLabel?.font = UIConstants.Font.body
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
    
    lazy fileprivate var favoriteBtn: ActionButton = {
        let button = ActionButton()
        button.setIndicatorStyle(style: UIActivityIndicatorView.Style.gray)
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
        button.layer.cornerRadius = 20
//        button.layer.masksToBounds = true
//        button.clipsToBounds = true
        
        
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIConstants.Font.h2
        button.setTitle("立即学习", for: .normal)
        button.backgroundColor = UIConstants.Color.primaryGreen
        button.addTarget(self, action: #selector(toolActionBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var isTrackingCategoryEnable: Bool = true
    
    fileprivate var observer: NSKeyValueObservation?
    
    let presenter: Presentr = {
        let width = ModalSize.full
        let height = ModalSize.full
        let center = ModalCenterPosition.customOrigin(origin: CGPoint.zero)
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVerticalFromTop
        customPresenter.dismissTransitionType = .coverVerticalFromTop
        customPresenter.roundCorners = true
        customPresenter.cornerRadius = 5
        customPresenter.backgroundColor = .black
        customPresenter.backgroundOpacity = 0.5
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissOnSwipeDirection = .top
        return customPresenter
    }()
    
    let evaluationPresenter: Presentr = {
        let width = ModalSize.full
        let height = ModalSize.custom(size: 440)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: UIScreenHeight-440))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVertical
        customPresenter.dismissTransitionType = .coverVertical
        customPresenter.roundCorners = true
        customPresenter.cornerRadius = 5
        customPresenter.backgroundColor = .black
        customPresenter.backgroundOpacity = 0.5
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissOnSwipeDirection = .bottom
        return customPresenter
    }()
    
    init(courseID: Int) {
        super.init(nibName: nil, bundle: nil)
        viewModel.courseID = courseID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationController?.setNavigationBarHidden(true, animated: true)
        
        navigationItem.title = "课程详情"
        reloadNavigationItem()
        
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if children.contains(where: { (viewController) -> Bool in
            return viewController.isKind(of: DPlayerViewController.self)
        }) {
            return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.landscape]
        } else {
            return [UIInterfaceOrientationMask.portrait]
        }
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
//        view.addSubviews(mainScrollView)
        
//        mainScrollView.addSubviews(categoryScrollView)
//        mainScrollView.addSubviews(introductionScrollView, catalogueTableView, evaluationTableView, bannerView)
        
        
        
        tableView.estimatedRowHeight = 0
        tableView.register(CourseIntroductionCell.self, forCellReuseIdentifier: CourseIntroductionCell.className())
        tableView.register(CourseCatalogueCell.self, forCellReuseIdentifier: CourseCatalogueCell.className())
        tableView.register(CourseCatalogueTitleCell.self, forCellReuseIdentifier: CourseCatalogueTitleCell.className())
        tableView.register(CourseEvaluationTitleCell.self, forCellReuseIdentifier: CourseEvaluationTitleCell.className())
        tableView.register(CourseEvaluationCell.self, forCellReuseIdentifier: CourseEvaluationCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.viewModel.fetchComments { (status, next) in
                if next || !status {
                    self?.tableView.mj_footer.endRefreshing()
                } else {
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                self?.reload()
            }
        })
        let footer = tableView.mj_footer as! MJRefreshAutoStateFooter
        footer.setTitle("以上为筛选后的用户课程体验", for: .noMoreData)
        
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

        observer = PlayListService.sharedInstance.observe(\.isPlaying) { [weak self] (service, changed) in
            self?.reloadNavigationItem()
            self?.tableView.reloadSection(1, with: .none)
        }
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchData() {
        //FIXME: debug no network
        
        HUDService.sharedInstance.showFetchingView(target: self.view)
        self.viewModel.fetchCourse { (status) in
            HUDService.sharedInstance.hideFetchingView(target: self.view)
            if status {
                self.reload()
                
            } else {
                HUDService.sharedInstance.showNoNetworkView(target: self.view) { [weak self] in
                    self?.fetchData()
                }
            }
        }
    }
    
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
            toolActionBtn.backgroundColor = UIConstants.Color.primaryGreen
            toolActionBtn.setTitle("立即学习", for: .normal)
            auditionBtn.isHidden = true
            toolActionBtn.snp.remakeConstraints { make in
                make.leading.equalTo(favoriteBtn.snp.trailing).offset(10)
                make.trailing.equalTo(-25)
                make.top.equalTo(7.5)
                make.height.equalTo(40)
            }
        } else {
            toolActionBtn.backgroundColor = UIConstants.Color.primaryRed
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
        
        reloadCategoryView()
    }
    
    func reloadNavigationItem() {
        var barBtnItems = [UIBarButtonItem]()
        
        let shareBarBtn: UIButton = {
            let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
            let img = UIImage(named: "public_shareBarItem")!.withRenderingMode(.alwaysOriginal)
            button.setImage(img, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: img.size.width/2-(UIConstants.Margin.trailing-navigationItem.rightMargin), bottom: 0, right: -img.size.width/2+(UIConstants.Margin.trailing-navigationItem.rightMargin))
            button.addTarget(self, action: #selector(shareBarItemAction), for: .touchUpInside)
            return button
        }()
        barBtnItems.append(UIBarButtonItem(customView: shareBarBtn))
        if PlayListService.sharedInstance.playingIndex != -1 {
            let spaceBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
            spaceBarItem.width = navigationItem.rightMargin
            barBtnItems.insert(spaceBarItem, at: 0)
            
            
            let audioBarBtn: UIButton = {
                let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
                button.addTarget(self, action: #selector(audioPanelBarItemAction), for: .touchUpInside)
                
                let img = YYImage(named: "public_audioAnimationItem")
                let imgView = YYAnimatedImageView(image: img)
                
                button.addSubview(imgView)
                imgView.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.width.equalTo(22)
                    make.height.equalTo(22)
                }
                
                if !PlayListService.sharedInstance.isPlaying {
                    imgView.autoPlayAnimatedImage = false
                    imgView.stopAnimating()
                }
                
                return button
            }()
            
            barBtnItems.append(UIBarButtonItem(customView: audioBarBtn))
        }
        navigationItem.rightBarButtonItems = barBtnItems
    }
    
    func reloadCategoryView() {
        var offsetY = (tableView.tableHeaderView?.bounds.size.height ?? 0) - 62 - tableView.contentOffset.y
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
            if tableView.contentOffset.y+62 >= rect3.origin.y {
                sender = evaluationBtn
            } else if tableView.contentOffset.y+62 >= rect2.origin.y {
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
        
        introductionBtn.titleLabel?.font = UIConstants.Font.body
        catalogueBtn.titleLabel?.font = UIConstants.Font.body
        evaluationBtn.titleLabel?.font = UIConstants.Font.body
        introductionBtn.setTitleColor(UIConstants.Color.body, for: .normal)
        catalogueBtn.setTitleColor(UIConstants.Color.body, for: .normal)
        evaluationBtn.setTitleColor(UIConstants.Color.body, for: .normal)
        
        sender.setTitleColor(UIConstants.Color.head, for: .normal)
        sender.titleLabel?.font = UIConstants.Font.h2
        
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
        guard let shareURL = viewModel.courseModel?.share_url else {
            HUDService.sharedInstance.show(string: "分享信息缺失")
            return
        }
        
        let title: String = self.viewModel.courseModel?.title ?? ""
        let descr: String = self.viewModel.courseModel?.sub_title ?? ""
        let imgURL: String = self.viewModel.courseModel?.cover_attribute?.service_url ?? ""
        
        let shareView = ShareView()
        shareView.shareClosure = { [weak shareView] shareType in
            if shareType == .wechatSession {
                
                let shareObj = UMShareWebpageObject.shareObject(withTitle: title, descr: descr, thumImage: imgURL)
                shareObj?.webpageUrl = shareURL
                let msgObj = UMSocialMessageObject(mediaObject: shareObj)
                UMSocialManager.default()?.share(to: UMSocialPlatformType.wechatSession, messageObject: msgObj, currentViewController: self, completion: { (result, error) in
                    if let response = result as? UMSocialShareResponse {
                        if let status = response.originalResponse as? Int, status == 0 {
                            HUDService.sharedInstance.show(string: "分享完成")
                        } else {
                            HUDService.sharedInstance.show(string: "分享失败")
                        }
                    } else {
                        HUDService.sharedInstance.show(string: "分享失败")
                    }
                    shareView?.removeFromSuperview()
                })
                
            } else if shareType == .wechatTimeLine {
                
                let shareObj = UMShareWebpageObject.shareObject(withTitle: title, descr: descr, thumImage: imgURL)
                shareObj?.webpageUrl = shareURL
                let msgObj = UMSocialMessageObject(mediaObject: shareObj)
                UMSocialManager.default()?.share(to: UMSocialPlatformType.wechatTimeLine, messageObject: msgObj, currentViewController: self, completion: { (result, error) in
                    if let response = result as? UMSocialShareResponse {
                        if let status = response.originalResponse as? Int, status == 0 {
                            HUDService.sharedInstance.show(string: "分享完成")
                        } else {
                            HUDService.sharedInstance.show(string: "分享失败")
                        }
                    } else {
                        HUDService.sharedInstance.show(string: "分享失败")
                    }
                    shareView?.removeFromSuperview()
                })
                
            } else if shareType.rawValue ==  1001 {
                UIPasteboard.general.string = shareURL
                HUDService.sharedInstance.show(string: "已将链接复制至剪贴板")
                shareView?.removeFromSuperview()
            }
        }
        view.addSubview(shareView)
        shareView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.layoutIfNeeded()
        shareView.present()
    }
    
    @objc func audioPanelBarItemAction() {
//        present(DPlayListViewController(), animated: true, completion: nil)
        
        let viewController = DPlayListViewController()
        viewController.selectedCourseBlock = { [weak self] (courseID) in
            self?.navigationController?.pushViewController(DCourseDetailViewController(courseID: courseID), animated: true)
        }
        viewController.selectedSectionBlock = { [weak self] (courseID, sectionID) in
            self?.navigationController?.pushViewController(DCourseSectionViewController(courseID: courseID, sectionID: sectionID), animated: true)
        }
//        viewController.modalPresentationStyle = .overCurrentContext
//        viewController.modalTransitionStyle = .coverVertical
//
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.type = .moveIn
//        transition.subtype = .fromBottom
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        view.window!.layer.add(transition, forKey: kCATransition)
//
//        present(viewController, animated: true, completion: nil)
        customPresentViewController(presenter, viewController: viewController, animated: true)
    }
    
    @objc func favoriteBtnAction() {
        guard AuthorizationService.sharedInstance.isSignIn() else {
            let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
            present(authorizationNavigationController, animated: true, completion: nil)
            return
        }
        
//        guard let isFavorite = viewModel.courseModel?.is_favorite else {
//            return
//        }
        
        self.favoriteImgView.isHidden = true
        self.favoriteLabel.isHidden = true
        favoriteBtn.startAnimating()
        
        viewModel.toggleFavorites { (code, status) in
            self.favoriteBtn.stopAnimating()
            
            self.viewModel.courseModel?.is_favorite = status
            
            if self.viewModel.courseModel?.is_favorite == true {
                self.favoriteImgView.image = UIImage(named: "course_favoriteSelected")
                self.favoriteLabel.text = "已收藏"
            } else {
                self.favoriteImgView.image = UIImage(named: "course_favoriteNormal")
                self.favoriteLabel.text = "收藏"
            }
            
            self.favoriteImgView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.favoriteImgView.isHidden = false
            self.favoriteLabel.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
                self.favoriteImgView.transform = CGAffineTransform.identity
            }, completion: { (bool) in
                
            })
        }
        
        /*
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            
            self.favoriteBtn.stopAnimating()
            
            self.viewModel.courseModel?.is_favorite = !isFavorite
            
            if self.viewModel.courseModel?.is_favorite == true {
                self.favoriteImgView.image = UIImage(named: "course_favoriteSelected")
                self.favoriteLabel.text = "已收藏"
            } else {
                self.favoriteImgView.image = UIImage(named: "course_favoriteNormal")
                self.favoriteLabel.text = "收藏"
            }
            
            self.favoriteImgView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.favoriteImgView.isHidden = false
            self.favoriteLabel.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
                self.favoriteImgView.transform = CGAffineTransform.identity
            }, completion: { (bool) in
                
            })
        }
        */
        
    }
    
    @objc func auditionBtnAction() {
        guard AuthorizationService.sharedInstance.isSignIn() else {
            let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
            present(authorizationNavigationController, animated: true, completion: nil)
            return
        }
        
    }
    
    @objc func toolActionBtnAction() {
        guard viewModel.courseModel?.is_bought == false else { return }
        
        PaymentProvider.request(.course_order(self.viewModel.courseID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if code >= 0 {
                if let order = JSON?["order"] as? [String: Any], let orderID = order["id"] as? Int {
                    
                    let viewController = DPurchaseViewController(orderID: orderID)
                    viewController.completeClosure = {
                        guard var viewControllers = self.navigationController?.viewControllers, let index = viewControllers.firstIndex(where: { (viewController) -> Bool in
                            return viewController.isKind(of: DPurchaseViewController.self)
                        }) else {
                            return
                        }
                        
                        viewControllers.remove(at: index)
                        self.navigationController?.setViewControllers(viewControllers, animated: true)
                        
                        self.fetchData()
                    }
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                
            }
        }))
        
        /*
        let alertController = UIAlertController(title: "是否购买？", message: nil, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "是", style: UIAlertAction.Style.default, handler: { (_) in
            
            
//            self.viewModel.courseModel?.is_bought = true
//            self.reload()
        }))
        alertController.addAction(UIAlertAction(title: "否", style: UIAlertAction.Style.cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
 */
    }
    
    @objc func displayMyEvaluation(button: ActionButton) {
        
        guard AuthorizationService.sharedInstance.isSignIn() else {
            let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
            present(authorizationNavigationController, animated: true, completion: nil)
            return
        }
        
        if viewModel.myCommentModel == nil {
            button.startAnimating()
            viewModel.fetchMyComment(completion: { (bool) in
                button.stopAnimating()
                if bool {
                    let viewController = DCourseEvaluationViewController(courseID: self.viewModel.courseID, model: self.viewModel.myCommentModel) { [weak self] (model) in
                        self?.viewModel.myCommentModel = model
                        self?.tableView.reloadRow(at: IndexPath(row: 0, section: 2), with: .none)
                    }
                    self.customPresentViewController(self.evaluationPresenter, viewController: viewController, animated: true)
                }
            })
            
        } else {
            let viewController = DCourseEvaluationViewController(courseID: self.viewModel.courseID, model: self.viewModel.myCommentModel) { [weak self] (model) in
                self?.viewModel.myCommentModel = model
                self?.tableView.reloadRow(at: IndexPath(row: 0, section: 2), with: .none)
            }
            self.customPresentViewController(self.evaluationPresenter, viewController: viewController, animated: true)
        }
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
        if observer != nil {
            observer?.invalidate()
            observer = nil
        }
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
        
        let titleLabel: ParagraphLabel = {
            let label = ParagraphLabel()
            label.font = UIConstants.Font.h1
            label.textColor = UIConstants.Color.head
            label.numberOfLines = 0
            label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing
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
        
        let tagLabel: ParagraphLabel = {
            let label = ParagraphLabel()
            label.font = UIConstants.Font.h2
            label.layer.cornerRadius = 2.5
            label.textAlignment = .center
            label.textColor = UIColor("#ef5226")
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
        
        titleLabel.setParagraphText(viewModel.courseModel?.title ?? "")
        
        descriptionLabel.text = "适合人群：" + (viewModel.courseModel?.suitable ?? "")
        footnoteLabel.text = String(viewModel.courseModel?.students_count ?? 0) + "人已学习"
        
        if viewModel.courseModel?.is_bought == true {
            tagLabel.text = "已购买"
            tagLabel.font = UIConstants.Font.body
            tagLabel.textColor = UIConstants.Color.disable
            tagLabel.backgroundColor = .white
            tagLabel.snp.remakeConstraints { make in
                make.trailing.equalTo(-25)
                make.centerY.equalTo(footnoteLabel)
            }
        } else if viewModel.courseModel?.audition == true {
            tagLabel.text = "免费试听"
            tagLabel.font = UIConstants.Font.body
            tagLabel.textColor = UIConstants.Color.primaryRed
            tagLabel.backgroundColor = UIColor(hex6: 0xf05053, alpha: 0.1)
            tagLabel.snp.remakeConstraints { make in
                make.trailing.equalTo(-35)
                make.centerY.equalTo(footnoteLabel)
                make.width.equalTo(80)
                make.height.equalTo(25)
            }
        } else if let price = viewModel.courseModel?.price {
            
            let string = String.priceFormatter.string(from: NSNumber(value: price))
            tagLabel.setParagraphText(string ?? "")
            tagLabel.textColor = UIColor("#ef5226")
            tagLabel.backgroundColor = .white
            tagLabel.snp.remakeConstraints { make in
                make.trailing.equalTo(-25)
                make.centerY.equalTo(footnoteLabel)
            }
        }
        
        headerView.frame = CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: kBannerHeight+20+titleLabel.intrinsicContentSize.height+20+12+10+12+25+62))
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.fd_heightForCell(withIdentifier: CourseIntroductionCell.className(), cacheBy: indexPath, configuration: { (cell) in
                if let cell = cell as? CourseIntroductionCell, let model = self.viewModel.courseModel {
                    cell.setup(model: model)
                }
            })
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return tableView.fd_heightForCell(withIdentifier: CourseCatalogueTitleCell.className(), cacheBy: indexPath, configuration: { (cell) in
                    
                })
            } else {
                return tableView.fd_heightForCell(withIdentifier: CourseCatalogueCell.className(), cacheBy: indexPath, configuration: { (cell) in
                    if let cell = cell as? CourseCatalogueCell, let model = self.viewModel.courseModel?.course_catalogues?[indexPath.row-1] {
                        cell.setup(model: model, isPlaying: false, isBought: false)
                    }
                })
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return tableView.fd_heightForCell(withIdentifier: CourseEvaluationTitleCell.className(), cacheBy: indexPath, configuration: { (cell) in
                    
                })
            } else {
                return tableView.fd_heightForCell(withIdentifier: CourseEvaluationCell.className(), cacheBy: indexPath, configuration: { (cell) in
                    if let cell = cell as? CourseEvaluationCell, let model = self.viewModel.commentModel?[indexPath.row-1] {
                        cell.setup(model: model)
                    }
                })
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return (viewModel.courseModel?.course_catalogues?.count ?? 0) + 1
        } else if section == 2 {
            return (viewModel.commentModel?.count ?? 0) + 1
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
                let cell = tableView.dequeueReusableCell(withIdentifier: CourseCatalogueTitleCell.className(), for: indexPath) as! CourseCatalogueTitleCell
                if let sections = viewModel.courseModel?.course_catalogues, sections.count > 0 {
                    let model = sections[0]
                    let isVideoCourse = model.media_attribute?.content_type?.hasPrefix("video") ?? false
                    cell.setup(isVideoCourse: isVideoCourse)
                }
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CourseCatalogueCell.className(), for: indexPath) as! CourseCatalogueCell
            if let model = viewModel.courseModel?.course_catalogues?[indexPath.row-1] {
                var isPlaying = false
                if let sections = PlayListService.sharedInstance.playingSectionModels,
                    PlayListService.sharedInstance.playingIndex != -1,
                    sections[PlayListService.sharedInstance.playingIndex].id == model.id {
                    isPlaying = true
                }
                cell.setup(model: model, isPlaying: isPlaying, isBought: viewModel.courseModel?.is_bought ?? false)
            }
            return cell
            
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CourseEvaluationTitleCell.className(), for: indexPath) as! CourseEvaluationTitleCell
                cell.evaluationBlock = { [weak self] (button) in
                    self?.displayMyEvaluation(button: button)
                }
                if viewModel.courseModel?.is_comment == true || viewModel.myCommentModel != nil {
                    cell.setup(isEvaluate: true)
                }
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: CourseEvaluationCell.className(), for: indexPath) as! CourseEvaluationCell
            if let model = viewModel.commentModel?[indexPath.row-1] {
                cell.setup(model: model)
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section == 1, indexPath.row > 0 else { return }
        
        if let model = viewModel.courseModel?.course_catalogues?[indexPath.row-1] {
            
            if let contentType = model.media_attribute?.content_type, contentType.hasPrefix("video") {
//                navigationController?.pushViewController(DPlayerViewController(), animated: true)
                if let courseModel = viewModel.courseModel {
                    let viewController = DPlayerViewController(course: courseModel, section: model)
                    present(viewController, animated: true, completion: nil)
                }
                
            } else {
                let viewController = DCourseSectionViewController(courseID: viewModel.courseID, sectionID: model.id ?? 0)
                navigationController?.pushViewController(viewController, animated: true)
            }
            
        }
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
        
        reloadCategoryView()
    }
}
