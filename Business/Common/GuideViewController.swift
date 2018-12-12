//
//  GuideViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/12.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class GuideViewController: BaseViewController {

    lazy fileprivate var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy fileprivate var pageControl: UIPageControl = {
        let view = UIPageControl()
        view.numberOfPages = 4
        view.currentPageIndicatorTintColor = UIConstants.Color.primaryGreen
        view.pageIndicatorTintColor = UIConstants.Color.foot
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubviews([scrollView, pageControl])
        
        for i in 0...3 {
            let imgView: UIImageView = {
                let imgView = UIImageView()
                imgView.image = UIImage(named: "guide_\(i)")
                return imgView
            }()
            scrollView.addSubview(imgView)
            imgView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.leading.equalTo(UIScreenWidth*CGFloat(i))
                make.width.equalTo(UIScreenWidth)
                make.height.equalTo(UIScreenHeight)
                if i == 3 {
                    make.trailing.equalToSuperview()
                }
            }
        }
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if #available(iOS 11, *) {
                make.bottom.equalTo(-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? UIStatusBarHeight)-12)
            } else {
                make.bottom.equalTo(-12)
            }
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============

}


extension GuideViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > UIScreenWidth*3.2 {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, AppCacheService.sharedInstance.isFirstLaunch != false else {
                return
            }
            
            AppCacheService.sharedInstance.isFirstLaunch = false
            
            appDelegate.setupRootViewController()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = Int(targetContentOffset.pointee.x/UIScreenWidth)
        
        pageControl.currentPage = index
    }
}
