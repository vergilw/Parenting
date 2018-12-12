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
    
    lazy fileprivate var section0HeaderHeight: CGFloat = 25 + 8 + 18 + 32
    lazy fileprivate var section0FooterHeight: CGFloat = 10 + 42 + 60
    lazy fileprivate var section1HeaderHeight: CGFloat = 25 + 30
    lazy fileprivate var itemWidth: CGFloat = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
    lazy fileprivate var item0Height: CGFloat = itemWidth/16.0*9 + 10 + 12 + 7 + 37
    lazy fileprivate var item1Height: CGFloat = itemWidth/16.0*9 + 10 + 37
    lazy fileprivate var item0Spacing: CGFloat = 22
    lazy fileprivate var collectionHeight: CGFloat = section0HeaderHeight + item0Height * 2 + item0Spacing + section0FooterHeight
    
    lazy fileprivate var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
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
        
        let img = YYImage(named: "public_audioAnimationItem")
        let imgView = YYAnimatedImageView(image: img)
        
        button.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-5)
            make.width.equalTo(22)
            make.height.equalTo(22)
        }
        return button
    }()
    
    lazy fileprivate var carouselView: TYCyclePagerView = {
        let view = TYCyclePagerView()
        view.isInfiniteLoop = false
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.className())
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    lazy fileprivate var pageControl: UIPageControl = {
        let view = UIPageControl()
        view.pageIndicatorTintColor = .white
        view.currentPageIndicatorTintColor = UIColor(white: 1, alpha: 0.3)
        return view
    }()
    
    lazy fileprivate var storyView: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.head, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 18)
        button.setTitle("氧育者故事", for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(teacherStoriesBtnAction), for: .touchUpInside)
        return button
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
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        navigationController?.setNavigationBarHidden(true, animated: true)
//    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        
        view.addSubview(scrollView)
        
        tableView.rowHeight = item1Height
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
        scrollView.addSubviews([carouselView, pageControl, storyView, coursesCollectionView, teacherBannerBtn, tableView, bottomBannerView])
//        searchBtn.addSubviews([searchIconImgView, searchTitleLabel])
        storyView.addSubviews([storyIndicatorImgView, storyAvatarsView])
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
            make.edges.equalTo(view)
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
//        audioBarBtn.snp.remakeConstraints { make in
//            make.leading.equalTo(searchBtn.snp.trailing)
//            make.trailing.equalToSuperview()
//            if #available(iOS 11, *) {
//                make.top.equalTo((UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)+7.5)
//            } else {
//                make.top.equalTo(7.5)
//            }
//            make.height.equalTo(42)
//            make.width.equalTo(15+22+25)
//        }
        carouselView.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.trailing.equalTo(scrollView)
            make.top.equalTo(20)
            make.width.equalTo(UIScreenWidth)
            make.height.equalTo((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)/16.0*9)
        }
        storyView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(carouselView.snp.bottom).offset(22)
            make.height.equalTo(52)
        }
        
        
        
        coursesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView)
            make.top.equalTo(storyView.snp.bottom).offset(29)
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo(collectionHeight)
        }
        teacherBannerBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(coursesCollectionView.snp.bottom).offset(0)
            make.height.equalTo((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)/16.0*5)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView)
            make.top.equalTo(teacherBannerBtn.snp.bottom).offset(60)
            make.height.equalTo((section1HeaderHeight+item1Height))
        }
        bottomBannerView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(tableView.snp.bottom).offset(40)
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
            make.centerX.equalTo(carouselView)
            make.bottom.equalTo(carouselView.snp.bottom)
        }
        
        //story view
        storyIndicatorImgView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
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
            self?.initNavigationItem()
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
        carouselView.reloadData()
        
        coursesCollectionView.reloadData()
        
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
    
    func reloadSearchBar() {
        if PlayListService.sharedInstance.playingIndex != -1 {
            
            audioBarBtn.isHidden = false
            
            if let animatedImgView = audioBarBtn.subviews.first(where: { (subview) -> Bool in
                return subview.isKind(of: YYAnimatedImageView.self)
            }) as? YYAnimatedImageView {
                
                if PlayListService.sharedInstance.isPlaying {
                    animatedImgView.startAnimating()
                } else {
                    animatedImgView.stopAnimating()
                }
            }
            
            searchBtn.snp.remakeConstraints { make in
                make.leading.equalTo(UIConstants.Margin.leading)
                if #available(iOS 11, *) {
                    make.top.equalTo((UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)+7.5)
                } else {
                    make.top.equalTo(7.5)
                }
                make.height.equalTo(42)
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
            return CGSize(width: UIScreenWidth, height: 25 + 8 + 18 + 32)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == coursesCollectionView {
            return CGSize(width: UIScreenWidth, height: 64+42)
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
            let titleLabel: ParagraphLabel = {
                let label = ParagraphLabel()
                label.font = UIConstants.Font.h1
                label.textColor = UIConstants.Color.head
                label.setParagraphText("最新课程")
                return label
            }()
            view?.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.leading.equalTo(UIConstants.Margin.leading)
                make.top.equalTo(1)
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
            return label
        }()
        
        let footnoteLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "PingFangSC-Regular", size: 15)
            label.textColor = UIConstants.Color.body
            label.text = "让孩子更优秀的秘密，百万家长的选择推荐"
            return label
        }()
        
        addSubviews(titleLabel, footnoteLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(0)
        }
        
        footnoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(titleLabel.snp.lastBaseline).offset(8)
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
            button.setTitleColor(UIConstants.Color.primaryGreen, for: .normal)
            button.titleLabel?.font = UIConstants.Font.h2_regular
            button.setTitle("查看更多", for: .normal)
            button.layer.cornerRadius = 21
            button.layer.borderColor = UIConstants.Color.primaryGreen.cgColor
            button.layer.borderWidth = 0.5
            button.addTarget(self, action: #selector(actionBtnAction), for: .touchUpInside)
            return button
        }()
        
        addSubviews(moreBtn)
        
        moreBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(10)
            make.width.equalTo(158)
            make.height.equalTo(42)
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
        layout.itemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        //        layout.layoutType = .normal
        return layout
    }
    
    func pagerViewDidScroll(_ pageView: TYCyclePagerView) {
        pageControl.currentPage = pageView.curIndex
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
