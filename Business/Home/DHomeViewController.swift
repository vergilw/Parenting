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
    
    lazy fileprivate var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    lazy fileprivate var searchBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 21
        button.backgroundColor = UIConstants.Color.background
//        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
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
//        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
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
        layout.sectionInset = UIEdgeInsets(top: 30, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        layout.minimumLineSpacing = 32
        layout.minimumInteritemSpacing = 10
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(HomeSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeader.className())
        view.register(MoreFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MoreFooterView.className())
        view.register(TeacherHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TeacherHeaderView.className())
        
        view.register(PickedCourseCell.self, forCellWithReuseIdentifier: PickedCourseCell.className())
        view.backgroundColor = .white
        view.dataSource = self
        view.delegate = self
        view.isScrollEnabled = false
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
        
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        
        view.addSubview(scrollView)
        scrollView.addSubviews([searchBtn, carouselView, pageControl, storyView, coursesCollectionView, bottomBannerView])
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
                make.top.equalTo(7.5+UIStatusBarHeight)
            }
            make.height.equalTo(42)
        }
        carouselView.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.trailing.equalTo(scrollView)
            make.top.equalTo(searchBtn.snp.bottom).offset(16)
            make.width.equalTo(UIScreen.main.bounds.size.width)
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
//        let section1HeaderHeight: CGFloat = 96
        let itemWidth: CGFloat = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
        let item0Height: CGFloat = itemWidth/16.0*9 + 12 + 52 + 8 + 20
//        let item1Height: CGFloat = itemWidth/16.0*9 + 12 + 52
        let collectionHeight: CGFloat = section0HeaderHeight + item0Height * 2 + 32 + section0FooterHeight
        
        coursesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView)
            make.top.equalTo(storyView.snp.bottom).offset(54)
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo(collectionHeight)
        }
        bottomBannerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView)
            make.top.equalTo(coursesCollectionView.snp.bottom)
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo(200)
            make.bottom.equalTo(-90)
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
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        tableView.reloadData()
        pageControl.numberOfPages = 6
    }
    
    // MARK: - ============= Action =============
}


extension DHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: UIScreenWidth, height: 25 + 8 + 18 + 32)
        } else if section == 1 {
            return CGSize(width: UIScreenWidth, height: 96)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: UIScreenWidth, height: 64+42)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            if kind == UICollectionView.elementKindSectionHeader {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeader.className(), for: indexPath)
                return view
            } else if kind == UICollectionView.elementKindSectionFooter {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MoreFooterView.className(), for: indexPath)
                return view
            }
        } else if indexPath.section == 1 {
            if kind == UICollectionView.elementKindSectionHeader {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TeacherHeaderView.className(), for: indexPath) as! TeacherHeaderView
                view.setup()
                return view
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
            return CGSize(width: width, height: width/16.0*9+12+52+8+20)
        } else if indexPath.section == 1 {
            let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
            return CGSize(width: width, height: width/16.0*9+12+52)
        }
        return UICollectionViewFlowLayout.automaticSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PickedCourseCell.className(), for: indexPath) as! PickedCourseCell
        cell.setup()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(DCourseDetailViewController(courseID: 2), animated: true)
        
        //FIXME: debug
//        let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
//        present(authorizationNavigationController, animated: true, completion: nil)
        
        
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
//            button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
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
        return 6
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
        imgView = view.viewWithTag(1) as? UIImageView ?? nil
        let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)*2
        let processor = RoundCornerImageProcessor(cornerRadius: 8, targetSize: CGSize(width: width, height: width/16.0*9))
        imgView?.kf.setImage(with: URL(string: "http://cloud.1314-edu.com/yVstTMQcm6uYCt5an9HpPxgJ"), options: [.processor(processor)])
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
}
