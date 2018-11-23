//
//  DHomeViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/23.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class DHomeViewController: BaseViewController {
    
    lazy fileprivate var viewModel = DHomeViewModel()
    
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
        button.titleLabel?.font = UIConstants.Font.h2
        button.setTitle("氧育精彩故事", for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(teacherStoriesBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var storyIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_arrowIndicator")
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
        layout.minimumLineSpacing = 32
        layout.minimumInteritemSpacing = 12
        let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
        layout.itemSize = CGSize(width: width, height: width/16.0*9+12+15+8+20)
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

    override func viewDidLoad() {
        super.viewDidLoad()

        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        
        view.addSubview(scrollView)
        
        let itemWidth: CGFloat = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
        let item1Height: CGFloat = itemWidth/16.0*9 + 12 + 52
        tableView.rowHeight = item1Height
        tableView.register(TeacherCoursesCell.self, forCellReuseIdentifier: TeacherCoursesCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        
        scrollView.mj_header = CustomMJHeader(refreshingBlock: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self?.scrollView.mj_header.endRefreshing()
            }
        })
        
        scrollView.addSubviews([searchBtn, carouselView, pageControl, storyView, coursesCollectionView, teacherBannerBtn, tableView, bottomBannerView])
        searchBtn.addSubviews([searchIconImgView, searchTitleLabel])
        storyView.addSubviews([storyIndicatorImgView, storyAvatarsView])
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        searchBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            if #available(iOS 11, *) {
                make.top.equalTo((UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)+7.5)
            } else {
                make.top.equalTo(7.5)
            }
            make.height.equalTo(42)
        }
        carouselView.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.trailing.equalTo(scrollView)
            make.top.equalTo(searchBtn.snp.bottom).offset(16)
            make.width.equalTo(UIScreenWidth)
            make.height.equalTo((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)/16.0*9)
        }
        storyView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(carouselView.snp.bottom).offset(22)
            make.height.equalTo(52)
        }
        
        let section0HeaderHeight: CGFloat = 25 + 8 + 18 + 32
        let section0FooterHeight: CGFloat = 64 + 42
        let section1HeaderHeight: CGFloat = 64+25
        let itemWidth: CGFloat = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
        let item0Height: CGFloat = itemWidth/16.0*9 + 12 + 52 + 8 + 20
        let item1Height: CGFloat = itemWidth/16.0*9 + 12 + 52
        let collectionHeight: CGFloat = section0HeaderHeight + item0Height * 2 + 32 + section0FooterHeight
        
        coursesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView)
            make.top.equalTo(storyView.snp.bottom).offset(54)
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo(collectionHeight)
        }
        teacherBannerBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(coursesCollectionView.snp.bottom).offset(24)
            make.height.equalTo((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)/16.0*5)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView)
            make.top.equalTo(teacherBannerBtn.snp.bottom).offset(24)
            make.height.equalTo((section1HeaderHeight+item1Height))
        }
        bottomBannerView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(tableView.snp.bottom).offset(52)
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)/16.0*5)
            make.bottom.equalTo(-UIConstants.Margin.bottom)
        }
        
        //search view
        searchIconImgView.snp.makeConstraints { make in
            make.leading.equalTo(21)
            make.centerY.equalToSuperview()
        }
        searchTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchIconImgView.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(-21)
            make.centerY.equalToSuperview()
        }
        
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
            make.trailing.equalTo(storyIndicatorImgView.snp.leading).offset(10)
            make.top.bottom.equalToSuperview()
        }
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchData() {
        viewModel.fetchHomeData { (bool) in
            if bool {
                self.reload()
            } else {
                
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
            cell.setup(model: model)
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
        return 64+25
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
                return label
            }()
            view?.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.leading.equalTo(UIConstants.Margin.leading)
                make.centerY.equalToSuperview()
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
            button.titleLabel?.font = UIConstants.Font.h2
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
            make.centerY.equalToSuperview()
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
            }
        }
    }
}
