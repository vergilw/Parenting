//
//  CourseSectionViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/26.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class CourseSectionViewController: BaseViewController {

    lazy fileprivate var viewModel = CourseSectionViewModel()
    
    lazy fileprivate var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = UIConstants.Color.primaryGreen
        return view
    }()
    
    lazy fileprivate var backgroundImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIConstants.Color.primaryGreen
        return imgView
    }()
    
    lazy fileprivate var cornerBgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .white
        imgView.layer.cornerRadius = 5
        return imgView
    }()
    
    lazy fileprivate var backBarBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "public_backBarItem")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backBarItemAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var shareBarBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "public_shareBarItem")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
//        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    lazy fileprivate var avatarImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_avatarPlaceholder")
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 15
        return imgView
    }()
    
    lazy fileprivate var courseEntranceBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIConstants.Font.foot
        button.setTitle("进入课程", for: .normal)
        button.layer.cornerRadius = UIConstants.cornerRadius
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0.5
//        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = .white
        return label
    }()
    
    lazy fileprivate var tagLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        return label
    }()
    
    lazy fileprivate var audioPanelView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = UIConstants.cornerRadius
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = UIConstants.cornerRadius
        view.layer.shadowColor = UIColor(white: 0, alpha: 0.2).cgColor
        return view
    }()
    
    lazy fileprivate var audioActionBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIConstants.Color.primaryGreen
        button.setImage(UIImage(named: "course_playAction")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 22.5
//        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    lazy fileprivate var audioSlider: UISlider = {
        let view = UISlider()
        view.minimumTrackTintColor = UIConstants.Color.primaryGreen
        view.maximumTrackTintColor = UIConstants.Color.background
        view.setThumbImage(UIImage(named: "course_audioSliderThumb"), for: .normal)
        return view
    }()
    
    lazy fileprivate var audioCurrentTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    lazy fileprivate var audioDurationTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    lazy fileprivate var playListBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.primaryGreen, for: .normal)
        button.titleLabel?.font = UIConstants.Font.foot
        button.setTitle("播放列表", for: .normal)
//        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h1
        label.textColor = UIConstants.Color.head
        label.numberOfLines = 10
        return label
    }()
    
    lazy fileprivate var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy fileprivate var lastOffsetY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        viewModel.fetchCourseSection { (bool) in
            self.reload()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        
        view.addSubviews([scrollView, navigationView])
        navigationView.addSubviews([backBarBtn, shareBarBtn])
        scrollView.addSubviews([backgroundImgView, cornerBgImgView, avatarImgView, courseEntranceBtn, titleLabel, tagLabel, audioPanelView, sectionTitleLabel, containerView])
        audioPanelView.addSubviews([audioActionBtn, progressLabel, audioSlider, audioCurrentTimeLabel, audioDurationTimeLabel, playListBtn])
        
        scrollView.layoutMargins = UIEdgeInsets(top: 16, left: 25, bottom: 16, right: 25)
        
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backgroundImgView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(audioPanelView.snp.centerY).offset(10)
        }
        cornerBgImgView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(audioPanelView.snp.centerY)
            make.height.equalTo(30)
        }
        navigationView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(navigationController!.navigationBar.bounds.size.height+UIStatusBarHeight)
        }
        backBarBtn.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(UIStatusBarHeight)
            make.width.equalTo(62.5)
            make.height.equalTo(navigationController!.navigationBar.bounds.size.height)
        }
        shareBarBtn.snp.makeConstraints { make in
            make.trailing.equalTo(0)
            make.top.equalTo(UIStatusBarHeight)
            make.width.equalTo(69)
            make.height.equalTo(navigationController!.navigationBar.bounds.size.height)
        }
        
        avatarImgView.snp.makeConstraints { make in
            make.leading.equalTo(scrollView.snp_leadingMargin)
            make.top.equalTo(navigationController!.navigationBar.bounds.size.height+UIStatusBarHeight+32)
            make.size.equalTo(UIConstants.Size.avatar)
        }
        courseEntranceBtn.snp.makeConstraints { make in
            make.trailing.equalTo(scrollView.snp_trailingMargin)
            make.centerY.equalTo(avatarImgView)
            make.width.equalTo(80)
            make.height.equalTo(25)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImgView.snp.trailing).offset(10)
            make.top.equalTo(avatarImgView.snp.top).offset(-2.5)
            make.trailing.greaterThanOrEqualTo(courseEntranceBtn.snp.leading).offset(-10)
            make.height.equalTo(14)
        }
        tagLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImgView.snp.trailing).offset(10)
            make.trailing.greaterThanOrEqualTo(courseEntranceBtn.snp.leading).offset(-10)
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.height.equalTo(12)
        }
        audioPanelView.snp.makeConstraints { make in
            make.leading.equalTo(scrollView.snp_leadingMargin)
            make.trailing.equalTo(scrollView.snp_trailingMargin)
            make.top.equalTo(avatarImgView.snp.bottom).offset(32)
            make.height.equalTo(94)
        }
        audioActionBtn.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(25)
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
        progressLabel.snp.makeConstraints { make in
            make.leading.equalTo(audioActionBtn.snp.trailing).offset(20)
            make.top.equalTo(audioActionBtn).offset(-5)
        }
        playListBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-10)
            make.centerY.equalTo(progressLabel)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        audioSlider.snp.makeConstraints { make in
            make.leading.equalTo(progressLabel)
            make.centerY.equalTo(audioActionBtn).offset(5)
            make.trailing.equalTo(-20)
        }
        audioCurrentTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(progressLabel)
            make.top.equalTo(audioSlider.snp.bottom).offset(4)
        }
        audioDurationTimeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(audioSlider)
            make.top.equalTo(audioSlider.snp.bottom).offset(4)
        }
        sectionTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(scrollView.snp_leadingMargin)
            make.trailing.equalTo(scrollView.snp_trailingMargin)
            make.top.equalTo(audioPanelView.snp.bottom).offset(32)
//            if #available(iOS 11.0, *) {
//                make.bottom.greaterThanOrEqualTo(scrollView.safeAreaLayoutGuide.snp.bottom).offset(-16)
//            } else {
//                make.bottom.equalTo(scrollView.snp.bottom).offset(-16)
//            }
        }
        containerView.snp.makeConstraints { make in
            make.leading.equalTo(scrollView.snp_leadingMargin)
            make.trailing.equalTo(scrollView.snp_trailingMargin)
            make.top.equalTo(sectionTitleLabel.snp.bottom).offset(32)
            make.bottom.equalTo(-32)
            make.width.equalTo(UIScreenWidth)
        }
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        tableView.reloadData()
        
        if let avatarURL = viewModel.courseSectionModel?.course?.teacher?.headshot_attribute?.service_url {
            avatarImgView.kf.setImage(with: URL(string: avatarURL))
        }
        
        titleLabel.text = viewModel.courseSectionModel?.title
        if let tags = viewModel.courseSectionModel?.course?.teacher?.tags {
            let tagString = tags.joined(separator: " | ")
            tagLabel.text = tagString
        }
        
        progressLabel.text = String(format: "已学习%d%%", viewModel.courseSectionModel?.learned ?? 0)
        audioCurrentTimeLabel.text = "00:00"
        if let durationSeconds = viewModel.courseSectionModel?.duration_with_seconds {
            let duration: TimeInterval = TimeInterval(durationSeconds)
            let durationDate = Date(timeIntervalSince1970: duration)
            audioDurationTimeLabel.text = CourseCatalogueCell.timeFormatter.string(from: durationDate)
        }
        
        let attributedString = NSMutableAttributedString(string: viewModel.courseSectionModel?.subtitle ?? "")
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 12
        attributedString.addAttributes([
            NSAttributedString.Key.paragraphStyle: paragraph], range: NSRange(location: 0, length: attributedString.length))
        sectionTitleLabel.attributedText = attributedString
        
        let titleHeight = sectionTitleLabel.systemLayoutSizeFitting(CGSize(width: UIScreenWidth-50, height: CGFloat.greatestFiniteMagnitude)).height
        if titleHeight < sectionTitleLabel.font.lineHeight*2 {
            let attributedString = NSMutableAttributedString(string: viewModel.courseSectionModel?.subtitle ?? "")
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 0
            attributedString.addAttributes([
                NSAttributedString.Key.paragraphStyle: paragraph], range: NSRange(location: 0, length: attributedString.length))
            sectionTitleLabel.attributedText = attributedString
            sectionTitleLabel.snp.remakeConstraints { make in
                make.leading.equalTo(scrollView.snp_leadingMargin)
                make.trailing.equalTo(scrollView.snp_trailingMargin)
                make.top.equalTo(audioPanelView.snp.bottom).offset(32)
                make.width.equalTo(UIScreenWidth-50)
                make.height.equalTo(17)
            }
            
        } else {
            sectionTitleLabel.snp.remakeConstraints { make in
                make.leading.equalTo(scrollView.snp_leadingMargin)
                make.trailing.equalTo(scrollView.snp_trailingMargin)
                make.top.equalTo(audioPanelView.snp.bottom).offset(32)
                make.width.equalTo(UIScreenWidth-50)
            }
        }
        
        containerView.removeAllSubviews()
        var containerHeight: CGFloat = 0
        for imgAsset in viewModel.courseSectionModel?.content_images_attribute ?? [] {
            let imgView: UIImageView = {
                let imgView = UIImageView()
                imgView.kf.setImage(with: URL(string: imgAsset.service_url ?? ""))
                imgView.contentMode = .scaleToFill
                return imgView
            }()
            containerView.addSubview(imgView)
            
            guard let height = imgAsset.height, let width = imgAsset.width else { return }
            let layoutHeight = CGFloat(height)/CGFloat(width)*(UIScreenWidth)
            imgView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(containerHeight)
                make.height.equalTo(layoutHeight)
            }
            containerHeight += layoutHeight
        }
        containerView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(sectionTitleLabel.snp.bottom).offset(32)
            make.bottom.equalTo(-32)
            make.width.equalTo(UIScreenWidth)
            make.height.equalTo(containerHeight)
        }
    }
    
    // MARK: - ============= Action =============

}

extension CourseSectionViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        let offsetY = scrollView.panGestureRecognizer.vel
        
//        if offsetY < 0 {
//            if navigationView.frame.origin.y > 0 {
//                navigationView.frame = CGRect(x: navigationView.frame.origin.x,
//                                              y: navigationView.frame.origin.y+offsetY,
//                                              width: navigationView.frame.size.width,
//                                              height: navigationView.frame.size.height)
//            } else {
//                navigationView.frame = CGRect(x: navigationView.frame.origin.x,
//                                              y: -navigationView.frame.size.height,
//                                              width: navigationView.frame.size.width,
//                                              height: navigationView.frame.size.height)
//            }
//        } else {
//            if navigationView.frame.origin.y < 0 {
//                navigationView.frame = CGRect(x: navigationView.frame.origin.x,
//                                              y: navigationView.frame.origin.y+offsetY,
//                                              width: navigationView.frame.size.width,
//                                              height: navigationView.frame.size.height)
//            } else {
//                navigationView.frame = CGRect(x: navigationView.frame.origin.x,
//                                              y: 0,
//                                              width: navigationView.frame.size.width,
//                                              height: navigationView.frame.size.height)
//            }
//        }
        
        let offsetY = scrollView.contentOffset.y - lastOffsetY
        
        if scrollView.contentOffset.y < 0 {
            navigationView.frame = CGRect(x: navigationView.frame.origin.x,
                                          y: 0,
                                          width: navigationView.frame.size.width,
                                          height: navigationView.frame.size.height)
            lastOffsetY = 0
        } else if offsetY > 0 {
            if navigationView.frame.origin.y > -navigationView.frame.size.height &&
                offsetY < navigationView.frame.size.height {
                
                navigationView.frame = CGRect(x: navigationView.frame.origin.x,
                                              y: navigationView.frame.origin.y-offsetY,
                                              width: navigationView.frame.size.width,
                                              height: navigationView.frame.size.height)
            } else {
                navigationView.frame = CGRect(x: navigationView.frame.origin.x,
                                              y: -navigationView.frame.size.height,
                                              width: navigationView.frame.size.width,
                                              height: navigationView.frame.size.height)
            }
            lastOffsetY = scrollView.contentOffset.y
        } else {
            if navigationView.frame.origin.y < 0 &&
                offsetY < navigationView.frame.size.height {
                navigationView.frame = CGRect(x: navigationView.frame.origin.x,
                                              y: navigationView.frame.origin.y-offsetY,
                                              width: navigationView.frame.size.width,
                                              height: navigationView.frame.size.height)
            } else {
                navigationView.frame = CGRect(x: navigationView.frame.origin.x,
                                              y: 0,
                                              width: navigationView.frame.size.width,
                                              height: navigationView.frame.size.height)
            }
            lastOffsetY = scrollView.contentOffset.y
        }
        
    }
}
