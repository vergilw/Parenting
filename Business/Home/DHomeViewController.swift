//
//  DHomeViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/23.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher
import Presentr
import UserNotifications

class DHomeViewController: BaseViewController {
    
    lazy fileprivate var viewModel = DHomeViewModel()
    
    lazy fileprivate var section0HeaderHeight: CGFloat = 25 + 6 + 18 + 10
    lazy fileprivate var section0FooterHeight: CGFloat = 15 + 35
    lazy fileprivate var section1HeaderHeight: CGFloat = 25 + 10
    lazy fileprivate var itemWidth: CGFloat = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
    lazy fileprivate var item0Height: CGFloat = itemWidth/16.0*9 + 8 + 12 + 3.4 + 40
    lazy fileprivate var item1Height: CGFloat = itemWidth/16.0*9 + 7 + 40 + 10 + 12 + 15
    lazy fileprivate var item0Spacing: CGFloat = 15
    lazy fileprivate var collectionHeight: CGFloat = section0HeaderHeight + item0Height * 2 + item0Spacing + section0FooterHeight
    
    lazy fileprivate var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    fileprivate lazy var titleImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "course_homeTitle")
        imgView.contentMode = .center
        return imgView
    }()
    
    lazy fileprivate var searchBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 21
        button.backgroundColor = UIConstants.Color.background
        button.addTarget(self, action: #selector(searchBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var searchIconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_searchIcon")
        return imgView
    }()
    
    lazy fileprivate var searchTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.text = "培养孩子独立丨智力发育想..."
        return label
    }()
    
    let audioBarBtn: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.addTarget(self, action: #selector(audioPanelBarItemAction), for: .touchUpInside)
        
        let img = YYImage(named: "course_playingStatus")
        let animatedImgView = YYAnimatedImageView(image: img)
        
        animatedImgView.stopAnimating()
        
        button.addSubview(animatedImgView)
        animatedImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-5)
            make.width.equalTo(22)
            make.height.equalTo(22)
        }
        return button
    }()
    
    fileprivate lazy var topBannerBgView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var topBgFrontImgView: UIImageView = {
        let imgView = UIImageView()
        //FIXME: DEBUG banner
//        imgView.image = UIImage(named: "debug_homeBg")
        return imgView
    }()
    
    fileprivate lazy var topBgBackImgView: UIImageView = {
        let imgView = UIImageView()
        //FIXME: DEBUG banner
//        imgView.image = UIImage(named: "debug_homeBg1")
        return imgView
    }()
    
    lazy fileprivate var carouselScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    fileprivate lazy var carouselViews = [UIButton]()
    
//    lazy fileprivate var carouselView: TYCyclePagerView = {
//        let view = TYCyclePagerView()
//        view.isInfiniteLoop = false
//        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.className())
//        view.dataSource = self
//        view.delegate = self
//        return view
//    }()
    
    lazy fileprivate var pageControl: UIPageControl = {
        let view = UIPageControl()
        view.pageIndicatorTintColor = .white
        view.currentPageIndicatorTintColor = UIColor(white: 1, alpha: 0.3)
        return view
    }()
    
    lazy fileprivate var storyView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(teacherStoriesBtnAction), for: .touchUpInside)
        button.backgroundColor = .white
        button.roundCorners(corners: [.topLeft, .topRight], radius: 18)
        button.drawSeparator(startPoint: CGPoint(x: 0, y: 51.5), endPoint: CGPoint(x: UIScreenWidth, y: 51.5))
        return button
    }()
    
    fileprivate lazy var storyTitleImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "course_homeStoryTitle")
        return imgView
    }()
    
    lazy fileprivate var storyIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_borderIndicator")
        return imgView
    }()
    
    lazy fileprivate var storyAvatarsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy fileprivate var rewardCoursesBtn: UIButton = {
        let button = UIButton()
        let img = YYImage(named: "reward_courses")!
        let imgView = YYAnimatedImageView(image: img)
        button.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        button.addTarget(self, action: #selector(rewardCoursesBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var coursesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        layout.minimumLineSpacing = item0Spacing
        layout.minimumInteritemSpacing = 12
        let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
        layout.itemSize = CGSize(width: itemWidth, height: item0Height)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(HomeSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeader.className())
        view.register(MoreFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MoreFooterView.className())
        view.register(PickedCourseCell.self, forCellWithReuseIdentifier: PickedCourseCell.className())
        view.backgroundColor = .white
        view.dataSource = self
        view.delegate = self
        view.isScrollEnabled = false
        return view
    }()
    
    lazy fileprivate var teacherBannerBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(teacherRecommendedBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var bottomBannerView: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(bottomBannerBtnAction), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    fileprivate var observer: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "氧育亲子"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        storyView.roundCorners(corners: [.topLeft, .topRight], radius: 8)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        
        view.addSubview(scrollView)
        
        tableView.rowHeight = item1Height + 15
        tableView.register(TeacherCoursesCell.self, forCellReuseIdentifier: TeacherCoursesCell.className())
        tableView.alwaysBounceVertical = false
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        
        scrollView.mj_header = CustomMJHeader(refreshingBlock: { [weak self] in
            self?.fetchData()
        })
//        scrollView.addSubviews([searchBtn, audioBarBtn, carouselView, pageControl, storyView, coursesCollectionView, teacherBannerBtn, tableView, bottomBannerView])
        scrollView.addSubviews([topBannerBgView, titleImgView, audioBarBtn, carouselScrollView, pageControl, storyView, rewardCoursesBtn, coursesCollectionView, teacherBannerBtn, tableView, bottomBannerView])
//        searchBtn.addSubviews([searchIconImgView, searchTitleLabel])
        storyView.addSubviews([storyTitleImgView, storyIndicatorImgView, storyAvatarsView])
        
        topBannerBgView.addSubviews([topBgBackImgView, topBgFrontImgView])
    }
    
    func initNavigationItem() {
        
        if PlayListService.sharedInstance.playingIndex != -1 {
            
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
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: audioBarBtn)
            navigationItem.rightMargin = 25
        }
        
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        searchBtn.snp.makeConstraints { make in
//            make.leading.equalTo(UIConstants.Margin.leading)
//            make.trailing.equalTo(-UIConstants.Margin.trailing)
//            if #available(iOS 11, *) {
//                make.top.equalTo((UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)+7.5)
//            } else {
//                make.top.equalTo(7.5)
//            }
//            make.height.equalTo(42)
//        }
        
        topBannerBgView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalToSuperview()
            } else {
                make.top.equalTo(-UIStatusBarHeight)
            }
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(UIScreenWidth)
            var height: CGFloat = self.navigationController?.navigationBar.bounds.height ?? 0
            height += UIStatusBarHeight
            height += 5
            make.height.equalTo(height + (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)/16.0*9+50)
        }
        topBgBackImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        topBgFrontImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(UIStatusBarHeight)
            } else {
                make.top.equalTo(0)
            }
            if let height: CGFloat = self.navigationController?.navigationBar.bounds.height {
                make.height.equalTo(height)
            }
        }
        audioBarBtn.snp.remakeConstraints { make in
            make.centerY.equalTo(titleImgView)
            make.trailing.equalToSuperview()
            make.height.equalTo(titleImgView)
            make.width.equalTo(22+UIConstants.Margin.trailing*2)
        }
        carouselScrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(topBannerBgView.snp.bottom).offset(-50)
            make.width.equalTo(UIScreenWidth)
            make.height.equalTo((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)/16.0*9)
        }
        storyView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topBannerBgView.snp.bottom).offset(-35)
            make.height.equalTo(52)
        }
        
        rewardCoursesBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(storyView.snp.bottom).offset(20)
            make.height.equalTo((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)/325*82)
        }
        
        coursesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView)
            make.top.equalTo(rewardCoursesBtn.snp.bottom).offset(25)
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo(collectionHeight)
        }
        teacherBannerBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(coursesCollectionView.snp.bottom).offset(30)
            make.height.equalTo((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)/16.0*5)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView)
            make.top.equalTo(teacherBannerBtn.snp.bottom).offset(30)
            make.height.equalTo((section1HeaderHeight+item1Height+15))
        }
        bottomBannerView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(tableView.snp.bottom).offset(15)
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)/16.0*5)
            make.bottom.equalTo(-UIConstants.Margin.bottom)
        }
        
        //search view
//        searchIconImgView.snp.makeConstraints { make in
//            make.leading.equalTo(21)
//            make.centerY.equalToSuperview()
//        }
//        searchTitleLabel.snp.makeConstraints { make in
//            make.leading.equalTo(searchIconImgView.snp.trailing).offset(8)
//            make.trailing.lessThanOrEqualTo(-21)
//            make.centerY.equalToSuperview()
//        }
        
        //banner view
        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(carouselScrollView)
            make.bottom.equalTo(carouselScrollView.snp.bottom)
        }
        
        //story view
        storyTitleImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.centerY.equalToSuperview()
        }
        storyIndicatorImgView.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalToSuperview()
        }
        storyAvatarsView.snp.makeConstraints { make in
            make.trailing.equalTo(storyIndicatorImgView.snp.leading).offset(-10)
            make.top.bottom.equalToSuperview()
        }
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        observer = PlayListService.sharedInstance.observe(\.isPlaying) { [weak self] (service, changed) in
            self?.reloadPlayingStatus()
        }
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchData() {
        if !scrollView.mj_header.isRefreshing {
            HUDService.sharedInstance.showFetchingView(target: self.view)
        }
        viewModel.fetchHomeData { (code) in
            self.scrollView.mj_header.endRefreshing()
            HUDService.sharedInstance.hideFetchingView(target: self.view)
            if code >= 0 {
                self.reload()
            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: self.view) { [weak self] in
                    self?.fetchData()
                }
            }
        }
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
        pageControl.numberOfPages = viewModel.bannerModels?.count ?? 0
//        carouselView.reloadData()
        reloadCarouselView()
        
        if let model = viewModel.bannerModels?[exist: 0], let string = model.background_attribute?.service_url {
            topBgFrontImgView.kf.setImage(with: URL(string: string))
        }
        if let model = viewModel.bannerModels?[exist: 1], let string = model.background_attribute?.service_url {
            topBgBackImgView.kf.setImage(with: URL(string: string))
        }
        
        coursesCollectionView.reloadData()
        
        //重新排版精选课程高度
        var collectionHeight: CGFloat = section0HeaderHeight + item0Spacing + section0FooterHeight
        if let cellLayout1 = coursesCollectionView.layoutAttributesForItem(at: IndexPath(item: 0, section: 0)),
            let cellLayout2 = coursesCollectionView.layoutAttributesForItem(at: IndexPath(item: 2, section: 0)) {
            collectionHeight += cellLayout1.bounds.height + cellLayout2.bounds.height
        }
        coursesCollectionView.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(scrollView)
            make.top.equalTo(rewardCoursesBtn.snp.bottom).offset(35)
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo(collectionHeight)
        }
        
        
        if let teacherModel = viewModel.recommendedCourseModel, let URLString = teacherModel.recommended_cover_attribute?.service_url {
            let width = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing
            let processor = RoundCornerImageProcessor(cornerRadius: 8, targetSize: CGSize(width: width*2, height: width/16.0*5*2))
            teacherBannerBtn.kf.setImage(with: URL(string: URLString), for: .normal, options: [.processor(processor)])
        }
        
        tableView.reloadData()
        
        if let bannerModel = viewModel.bottomBannerModel, let URLString = bannerModel.image_attribute?.service_url {
            let width = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing
            let processor = RoundCornerImageProcessor(cornerRadius: 8, targetSize: CGSize(width: width*2, height: width/16.0*5*2))
            bottomBannerView.kf.setImage(with: URL(string: URLString), for: .normal, options: [.processor(processor)])
        }
        
        //setup story avatars
        storyAvatarsView.removeAllSubviews()
        var containerWidth: CGFloat = 0
        for i in 0..<(viewModel.storyModels?.count ?? 0) {
            guard let model = viewModel.storyModels?[exist: i] else { break }
            guard let URLString = model.avatar else { continue }
            
            let imgView: UIImageView = {
                let imgView = UIImageView()
                imgView.kf.setImage(with: URL(string: URLString))
                imgView.contentMode = .scaleAspectFill
                imgView.layer.cornerRadius = 15
                imgView.layer.borderWidth = 1.5
                imgView.layer.borderColor = UIColor.white.cgColor
                imgView.clipsToBounds = true
                return imgView
            }()
            storyAvatarsView.addSubview(imgView)
            
            imgView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.trailing.equalToSuperview().offset(-containerWidth)
                make.width.equalTo(30)
            }
            containerWidth += 30 - 10
        }
        storyAvatarsView.snp.remakeConstraints { make in
            make.trailing.equalTo(storyIndicatorImgView.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    func reloadPlayingStatus() {
        if PlayListService.sharedInstance.playingIndex != -1 {
            
            DispatchQueue.main.async {
                self.audioBarBtn.isHidden = false
                
                if let animatedImgView = self.audioBarBtn.subviews.first(where: { (subview) -> Bool in
                    return subview.isKind(of: YYAnimatedImageView.self)
                }) as? YYAnimatedImageView {
                    
                    if PlayListService.sharedInstance.isPlaying {
                        animatedImgView.startAnimating()
                    } else {
                        animatedImgView.autoPlayAnimatedImage = false
                        animatedImgView.stopAnimating()
                    }
                }
            }
            
        }
    }
    
    fileprivate func reloadCarouselView() {
        for view in carouselViews {
            view.superview?.removeFromSuperview()
        }
        
        carouselViews.removeAll()
        
        for i in 0..<(viewModel.bannerModels?.count ?? 0) {
            
            let contentView: UIView = {
                let view = UIView()
                view.backgroundColor = .clear
                return view
            }()
            carouselScrollView.addSubview(contentView)
            contentView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.leading.equalTo(CGFloat(i) * UIScreenWidth)
                make.width.equalTo(UIScreenWidth)
                make.height.equalTo((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)/16.0*9)
                if i == (viewModel.bannerModels?.count ?? 0)-1 {
                    make.trailing.equalToSuperview()
                }
            }
            
            let button: UIButton = {
                let button = UIButton()
//                button.adjustsImageWhenHighlighted = false
                button.layer.cornerRadius = 4
                button.imageView?.contentMode = .scaleAspectFill
                button.clipsToBounds = true
                button.addTarget(self, action: #selector(bannerBtnAction(sender:)), for: .touchUpInside)
                return button
            }()
            contentView.addSubview(button)
            button.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing))
            }
            
            carouselViews.append(button)
            
            if let URLString = viewModel.bannerModels?[exist: i]?.image_attribute?.service_url {
                button.kf.setImage(with: URL(string: URLString), for: .normal)
            }
        }
    }
    
    // MARK: - ============= Action =============
    @objc func searchBtnAction() {
        let navigationController = BaseNavigationController(rootViewController: DSearchViewController())
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func teacherStoriesBtnAction() {
        navigationController?.pushViewController(DTeacherStoriesViewController(), animated: true)
    }
    
    @objc func rewardCoursesBtnAction() {
        navigationController?.pushViewController(DRewardCoursesViewController(), animated: true)
    }
    
    @objc func teacherRecommendedBtnAction() {
        if let model = viewModel.recommendedCourseModel, let courseID = model.id {
            navigationController?.pushViewController(DCourseDetailViewController(courseID: courseID), animated: true)
        }
    }
    
    @objc func bottomBannerBtnAction() {
        if let model = viewModel.bottomBannerModel {
            if let courseID = model.target_id, model.target_type == "Course" {
                navigationController?.pushViewController(DCourseDetailViewController(courseID: courseID), animated: true)
            }
        }
    }
    
    @objc func audioPanelBarItemAction() {
        
        let viewController = DPlayListViewController()
        viewController.selectedCourseBlock = { [weak self] (courseID) in
            self?.navigationController?.pushViewController(DCourseDetailViewController(courseID: courseID), animated: true)
        }
        viewController.selectedSectionBlock = { [weak self] (courseID, sectionID) in
            self?.navigationController?.pushViewController(DCourseSectionViewController(courseID: courseID, sectionID: sectionID), animated: true)
        }
        customPresentViewController(PlayListService.sharedInstance.presenter, viewController: viewController, animated: true)
    }
    
    @objc fileprivate func bannerBtnAction(sender: UIButton) {
        guard let index = carouselViews.firstIndex(of: sender) else { return }
        
        if let model = viewModel.bannerModels?[exist: index] {
            if let courseID = model.target_id, model.target_type == "Course" {
                navigationController?.pushViewController(DCourseDetailViewController(courseID: courseID), animated: true)
            } else if let storyID = model.target_id, model.target_type == "Story" {
                navigationController?.pushViewController(DTeacherStoryDetailViewController(storyID: storyID), animated: true)
            }
        }
    }
    
    deinit {
        if observer != nil {
            observer?.invalidate()
            observer = nil
        }
    }
}


extension DHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == coursesCollectionView {
            return CGSize(width: UIScreenWidth, height: section0HeaderHeight)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == coursesCollectionView {
            return CGSize(width: UIScreenWidth, height: section0FooterHeight)
        }
        return .zero
    }
 
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == coursesCollectionView {
            if kind == UICollectionView.elementKindSectionHeader {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeader.className(), for: indexPath)
                return view
            } else if kind == UICollectionView.elementKindSectionFooter {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MoreFooterView.className(), for: indexPath) as! MoreFooterView
                view.actionBlock = { [weak self] in
                    self?.navigationController?.pushViewController(DCoursesViewController(), animated: true)
                }
                return view
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hottestCourseModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 || indexPath.row == 1 {
            if let model1 = viewModel.hottestCourseModels?[exist: 0], let model2 = viewModel.hottestCourseModels?[exist: 1] {
                let height = max(PickedCourseCell.cellHeight(title: model1.title ?? ""),
                                 PickedCourseCell.cellHeight(title: model2.title ?? ""))
                let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
                return CGSize(width: width, height: height)
            }
            
        } else if indexPath.row == 2 || indexPath.row == 3 {
            if let model1 = viewModel.hottestCourseModels?[exist: 2], let model2 = viewModel.hottestCourseModels?[exist: 3] {
                let height = max(PickedCourseCell.cellHeight(title: model1.title ?? ""),
                                 PickedCourseCell.cellHeight(title: model2.title ?? ""))
                let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
                return CGSize(width: width, height: height)
            }
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PickedCourseCell.className(), for: indexPath) as! PickedCourseCell
        if let model = viewModel.hottestCourseModels?[indexPath.row] {
            cell.setup(model: model, mode: .picked)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let model = viewModel.hottestCourseModels?[indexPath.row], let courseID = model.id {
            navigationController?.pushViewController(DCourseDetailViewController(courseID: courseID), animated: true)
        }
        
    }
    
}


extension DHomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section1HeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderViewID")
        if view == nil {
            view = UITableViewHeaderFooterView(reuseIdentifier: "HeaderViewID")
            view?.contentView.backgroundColor = .white
//            let headerView: TeacherHeaderView = {
//                let view = TeacherHeaderView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: 96)))
//                view.setup()
//                return view
//            }()
//            view?.addSubview(headerView)
//            headerView.snp.makeConstraints { make in
//                make.edges.equalToSuperview()
//            }
            let titleLabel: UILabel = {
                let label = UILabel()
                label.font = UIConstants.Font.h1
                label.textColor = UIConstants.Color.head
                label.text = "最新课程"
                
                let gradientLayer = CAGradientLayer()
                gradientLayer.frame = CGRect(origin: CGPoint(x: 0, y: 15), size: CGSize(width: 80, height: 10))
                gradientLayer.colors = [UIColor("#00cddd").cgColor, UIColor.white.cgColor]
                gradientLayer.locations = [0.0, 1.0]
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                label.layer.addSublayer(gradientLayer)
                
                return label
            }()
            view?.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.leading.equalTo(UIConstants.Margin.leading)
                make.top.equalTo(0)
            }
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeacherCoursesCell.className(), for: indexPath) as! TeacherCoursesCell
        if let models = viewModel.newestCourseModels {
            cell.setup(models: models)
        }
        cell.selectedClosure = { [weak self] courseID in
            self?.navigationController?.pushViewController(DCourseDetailViewController(courseID: courseID), animated: true)
        }
        return cell
    }
}


fileprivate class HomeSectionHeader: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.h1
            label.textColor = UIConstants.Color.head
            label.text = "精选课程"
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = CGRect(origin: CGPoint(x: 0, y: 15), size: CGSize(width: 80, height: 10))
            gradientLayer.colors = [UIColor("#00cddd").cgColor, UIColor.white.cgColor]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            label.layer.addSublayer(gradientLayer)
            
            return label
        }()
        
        let footnoteLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.body
            label.textColor = UIConstants.Color.foot
            label.text = "让孩子更优秀的秘密，百万家长的选择推荐"
            return label
        }()
        
        addSubviews(titleLabel, footnoteLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(0)
        }
        
        footnoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(titleLabel.snp.lastBaseline).offset(6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}


fileprivate class MoreFooterView: UICollectionReusableView {
    
    var actionBlock: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let moreBtn: UIButton = {
            let button = UIButton()
            button.setTitleColor(UIColor("#8e9197"), for: .normal)
            button.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)!
            button.setTitle("查看更多", for: .normal)
            button.layer.cornerRadius = 4
            button.backgroundColor = UIConstants.Color.background
            button.addTarget(self, action: #selector(actionBtnAction), for: .touchUpInside)
            return button
        }()
        
        addSubviews(moreBtn)
        
        moreBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(15)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.height.equalTo(35)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    @objc func actionBtnAction() {
        if let block = actionBlock {
            block()
        }
    }
}


fileprivate class TeacherHeaderView: UICollectionReusableView {
    
    lazy fileprivate var teacherAvatarImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "public_avatarPlaceholder")
        return imgView
    }()
    
    lazy var teacherNameLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h3
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy var teacherTagLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([teacherAvatarImgView, teacherNameLabel, teacherTagLabel])
        
        teacherAvatarImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        teacherNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(teacherAvatarImgView.snp.trailing).offset(10)
            make.top.equalTo(teacherAvatarImgView.snp.top).offset(-3)
        }
        teacherTagLabel.snp.makeConstraints { make in
            make.leading.equalTo(teacherAvatarImgView.snp.trailing).offset(10)
            make.top.equalTo(teacherNameLabel.snp.bottom).offset(8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        teacherNameLabel.setParagraphText("橙子老师")
        teacherTagLabel.setParagraphText("全职妈妈丨心理咨询")
    }
}


extension DHomeViewController: TYCyclePagerViewDataSource, TYCyclePagerViewDelegate {
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        return viewModel.bannerModels?.count ?? 0
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let view =  pagerView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.className(), for: index)
        var imgView: UIImageView? = view.viewWithTag(1) as? UIImageView
        if imgView == nil {
            let imgView: UIImageView = {
                let imgView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing, height: (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)/16.0*9)))
                imgView.contentMode = .scaleAspectFill
                imgView.layer.cornerRadius = 6
                imgView.clipsToBounds = true
                imgView.tag = 1
                return imgView
            }()
            view.contentView.addSubview(imgView)
            imgView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        if let URLString = viewModel.bannerModels?[index].image_attribute?.service_url {
            imgView = view.viewWithTag(1) as? UIImageView ?? nil
            let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)*2
            let processor = RoundCornerImageProcessor(cornerRadius: 8, targetSize: CGSize(width: width, height: width/16.0*9))
            imgView?.kf.setImage(with: URL(string: URLString), options: [.processor(processor)])
        }
        
        return view
    }
    
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSize(width: UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing, height: (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)/16.0*9)
        layout.itemSpacing = UIConstants.Margin.trailing
        layout.sectionInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        //        layout.layoutType = .normal
        return layout
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didScrollFrom fromIndex: Int, to toIndex: Int) {
        print(#function, toIndex)
//        if let model = viewModel.bannerModels?[exist: toIndex], let string = model.background_attribute?.service_url {
//            topBgFrontImgView.kf.setImage(with: URL(string: string))
//        }
        
//        var index: Int = 0
//        if pageView.contentOffset.x >= CGFloat(pageView.curIndex) * pageView.layout.itemSize.width + pageView.layout.itemSize.width/2 {
//            index = pageView.curIndex + 1
//        } else {
//            index = pageView.curIndex - 1
//        }
//        if let model = viewModel.bannerModels?[exist: index], let string = model.background_attribute?.service_url {
//            topBgBackImgView.kf.setImage(with: URL(string: string))
//        }
        
        pageControl.currentPage = toIndex
    }
    
    func pagerViewDidEndDecelerating(_ pageView: TYCyclePagerView) {
        print(#function, pageView.curIndex)
        if let model = viewModel.bannerModels?[exist: pageView.curIndex], let string = model.background_attribute?.service_url {
            topBgFrontImgView.kf.setImage(with: URL(string: string))
        }
    }
    
    func pagerViewDidScroll(_ pageView: TYCyclePagerView) {
        
//        print(pageView.contentOffset.x)
        
        var index: Int = 0
        if pageView.contentOffset.x >= CGFloat(pageView.curIndex) * pageView.layout.itemSize.width + pageView.layout.itemSize.width/2 {
            index = pageView.curIndex + 1
        } else {
            index = pageView.curIndex - 1
        }
        print(#function, pageView.contentOffset.x, index)
        if let model = viewModel.bannerModels?[exist: index], let string = model.background_attribute?.service_url {
            topBgBackImgView.kf.setImage(with: URL(string: string))
        }
        
        topBgFrontImgView.alpha = 1 -  pageView.contentOffset.x.truncatingRemainder(dividingBy: UIScreenWidth)/UIScreenWidth
        topBgBackImgView.alpha = pageView.contentOffset.x.truncatingRemainder(dividingBy: UIScreenWidth)/UIScreenWidth
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didSelectedItemCell cell: UICollectionViewCell, at index: Int) {
        
        if let model = viewModel.bannerModels?[index] {
            if let courseID = model.target_id, model.target_type == "Course" {
                navigationController?.pushViewController(DCourseDetailViewController(courseID: courseID), animated: true)
            } else if let storyID = model.target_id, model.target_type == "Story" {
                navigationController?.pushViewController(DTeacherStoryDetailViewController(storyID: storyID), animated: true)
            }
        }
    }
}


extension DHomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == carouselScrollView else { return }
        
        let progress: CGFloat = abs((scrollView.contentOffset.x - CGFloat(pageControl.currentPage) * UIScreenWidth))/UIScreenWidth
//        print(#function, scrollView.contentOffset.x, progress)
        var index: Int = 0
        if scrollView.contentOffset.x >= CGFloat(pageControl.currentPage) * UIScreenWidth {
            index = pageControl.currentPage + 1
            
        } else {
            index = pageControl.currentPage - 1
        }
        
        topBgFrontImgView.alpha = 1 - progress
        topBgBackImgView.alpha = progress
        
        if let model = viewModel.bannerModels?[exist: index], let string = model.background_attribute?.service_url {
            topBgBackImgView.kf.setImage(with: URL(string: string))
        }
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == carouselScrollView else { return }
        
        let index = Int(scrollView.contentOffset.x / UIScreenWidth)
        
        if let model = viewModel.bannerModels?[exist: index], let string = model.background_attribute?.service_url {
            topBgFrontImgView.kf.setImage(with: URL(string: string))
            topBgFrontImgView.alpha = 1.0
        }
        
        pageControl.currentPage = index
    }
}
