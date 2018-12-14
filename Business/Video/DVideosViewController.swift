//
//  DVideosViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/14.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DVideosViewController: BaseViewController {

    lazy fileprivate var viewModel = DVideosViewModel()
    
    lazy fileprivate var buttons = [UIButton]()
    lazy fileprivate var collectionViews = [UICollectionView]()
    lazy fileprivate var selectedIndex = 0
    
    lazy fileprivate var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        view.backgroundColor = .white
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 9)
        //        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy fileprivate var categoryIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIConstants.Color.primaryGreen
        return imgView
    }()
    
    lazy fileprivate var tableViewScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.delegate = self
        if let gesture = navigationController?.view.gestureRecognizers?.first(where: { (gesture) -> Bool in
            return gesture.isKind(of: UIScreenEdgePanGestureRecognizer.self)
            
        }) {
            scrollView.panGestureRecognizer.require(toFail: gesture)
        }
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "小视频"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubviews([scrollView, tableViewScrollView])
        scrollView.addSubview(categoryIndicatorImgView)
    }
    
    fileprivate func initCategoryView() {
        
        var width: CGFloat = 0
        var i = -1
        var model: VideoCategoryModel?
        
        viewModel.videosModels = [[VideoModel]]()
        
        repeat {
            //setup category view
            let button: UIButton = {
                let button = UIButton()
                button.setTitleColor(UIConstants.Color.body, for: .normal)
                button.titleLabel?.font = UIConstants.Font.body
                if let string = model?.name {
                    button.setTitle(string, for: .normal)
                } else {
                    button.setTitle("全部", for: .normal)
                    button.setTitleColor(UIConstants.Color.head, for: .normal)
                    button.titleLabel?.font = UIConstants.Font.h2
                }
                button.addTarget(self, action: #selector(categoryBtnAction(sender:)), for: .touchUpInside)
                button.tag = i+1
                return button
            }()
            
            scrollView.addSubview(button)
            
            let size = NSString(string: button.titleLabel?.text ?? "").size(for: button.titleLabel!.font, size: CGSize(width: UIScreenWidth, height: 36), mode: NSLineBreakMode.byTruncatingTail)
            button.snp.makeConstraints { make in
                make.leading.equalTo(width)
                if i == (viewModel.categoryModels?.count)! - 1 {
                    make.trailing.equalToSuperview()
                }
                make.width.equalTo(size.width+32)
                make.height.equalTo(46)
                make.top.bottom.equalToSuperview()
            }
            
            buttons.append(button)
            
            width += size.width+32
            
            
            //setup tableview
            let collectionView: UICollectionView = {
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .vertical
                layout.itemSize = CGSize(width: (UIScreenWidth-30)/2.0, height: 122)
                layout.sectionInset = UIEdgeInsets(top: UIConstants.Margin.leading-10, left: 0, bottom: UIConstants.Margin.leading-10, right: 0)
                layout.minimumLineSpacing = 15
                layout.minimumInteritemSpacing = 15
                
                let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
                if #available(iOS 11, *) {
                    view.contentInsetAdjustmentBehavior = .never
                }
                view.showsVerticalScrollIndicator = false
                view.register(VideoCollectionCell.self, forCellWithReuseIdentifier: VideoCollectionCell.className())
                view.dataSource = self
                view.delegate = self
                view.backgroundColor = .white
                view.tag = i+1
                
                view.mj_header = CustomMJHeader(refreshingBlock: { [weak self] in
                    let index = view.tag
                    if let modelsArray = self?.viewModel.videosModels?[exist: index], modelsArray.count >= 0 {
                        self?.viewModel.videosModels?[index].removeAll()
                    }
                    self?.refetchVideos(index: index)
                })
                view.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self, weak view] in
                    guard let view = view else { return }
                    
                    self?.viewModel.fetchVideos(completion: { (code, next, models) in
                        if code < 0 || next {
                            view.mj_footer.endRefreshing()
                        } else {
                            view.mj_footer.endRefreshingWithNoMoreData()
                        }
                        
                        if let models = models, let index = self?.collectionViews.firstIndex(of: view), let _ = self?.viewModel.videosModels?[exist: index] {
                            self?.viewModel.videosModels?[index].append(contentsOf: models)
                            view.reloadData()
                        }
                    })
                })
                view.mj_footer.isHidden = true
                
                return view
            }()
            
            tableViewScrollView.addSubview(collectionView)
            tableViewScrollView.sendSubviewToBack(collectionView)
            collectionView.snp.makeConstraints { make in
                make.leading.equalTo(CGFloat(collectionViews.count)*UIScreenWidth)
                if i == (viewModel.categoryModels?.count)! - 1 {
                    make.trailing.equalToSuperview()
                }
                make.width.equalTo(UIScreenWidth)
                make.top.bottom.equalToSuperview()
                
                let navigationBarHeight: CGFloat = (navigationController?.navigationBar.bounds.size.height ?? 0)
                let tabBarHeight: CGFloat = (tabBarController?.tabBar.bounds.size.height ?? 0)
                if #available(iOS 11.0, *) {
                    let topInset: CGFloat = (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight)
//                    let bottomInset: CGFloat = (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
                    make.height.equalTo(UIScreenHeight-topInset-navigationBarHeight-tabBarHeight-46)
                } else {
                    make.height.equalTo(UIScreenHeight-UIStatusBarHeight-navigationBarHeight-tabBarHeight-46)
                }
            }
            collectionViews.append(collectionView)
            
            //setup models
            viewModel.videosModels?.append([VideoModel]())
            
            i += 1
            if viewModel.categoryModels?.count ?? 0 > i {
                model = viewModel.categoryModels?[i]
            } else {
                break
            }
            
        } while (model != nil)
        
        let size = NSString(string: "全部").size(for: UIConstants.Font.h2, size: CGSize(width: UIScreenWidth, height: 36), mode: NSLineBreakMode.byTruncatingTail)
        categoryIndicatorImgView.snp.remakeConstraints { make in
            make.centerX.equalTo((size.width+32)/2)
            make.height.equalTo(1.5)
            make.width.equalTo(29)
            make.bottom.equalTo(scrollView)
        }
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        scrollView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(46)
        }
        tableViewScrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(scrollView.snp.bottom)
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchData() {
        let offsetY: CGFloat = (UIConstants.Margin.leading-10)
        var tableViewHeight: CGFloat = 0
        if #available(iOS 11.0, *) {
            tableViewHeight = (UIScreenHeight-(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight)-(navigationController?.navigationBar.bounds.size.height ?? 0)-46)
        } else {
            tableViewHeight = (UIScreenHeight-UIStatusBarHeight-(navigationController?.navigationBar.bounds.size.height ?? 0)-46)
        }
        
        HUDService.sharedInstance.showFetchingView(target: tableViewScrollView, frame: CGRect(origin: CGPoint(x: 0, y: -offsetY), size: CGSize(width: UIScreenWidth, height: tableViewHeight)))
        viewModel.fetchCategory { (code) in
            
            if code >= 0 {
                self.initCategoryView()
                if let view = self.collectionViews.first {
                    self.fetchVideos(view: view)
                } else {
                    HUDService.sharedInstance.hideFetchingView(target: self.tableViewScrollView)
                }
                
            } else if code == -2 {
                HUDService.sharedInstance.hideFetchingView(target: self.tableViewScrollView)
                
                HUDService.sharedInstance.showNoNetworkView(target: self.tableViewScrollView) { [weak self] in
                    self?.fetchData()
                }
            } else {
                HUDService.sharedInstance.hideFetchingView(target: self.tableViewScrollView)
            }
        }
    }
    
    fileprivate func fetchVideos(view: UICollectionView) {
        if !tableViewScrollView.subviews.contains(where: { (view) -> Bool in
            return view.isKind(of: FetchView.self)
        }) {
            HUDService.sharedInstance.showFetchingView(target: view)
        }
        
        self.viewModel.fetchVideos { (code, next, models) in
            
            if self.tableViewScrollView.subviews.contains(where: { (view) -> Bool in
                return view.isKind(of: FetchView.self)
            }) {
                HUDService.sharedInstance.hideFetchingView(target: self.tableViewScrollView)
            } else {
                HUDService.sharedInstance.hideFetchingView(target: view)
            }
            
            if code >= 0 {
                
                if let index = self.collectionViews.firstIndex(of: view) {
                    if let _ = self.viewModel.videosModels?[exist: index], let models = models {
                        
                        if models.count == 0 {
                            HUDService.sharedInstance.showNoDataView(target: view) { }
                        } else {
                            self.viewModel.videosModels?[index].append(contentsOf: models)
                        }
                    }
                }
                
                if next {
                    view.mj_footer.isHidden = false
                    view.mj_footer.resetNoMoreData()
                } else {
                    view.mj_footer.isHidden = true
                }
                
                view.reloadData()
                
            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: view) { [weak self] in
                    self?.fetchVideos(view: view)
                }
            }
        }
    }
    
    fileprivate func refetchVideos(index: Int) {
        guard let view = collectionViews[exist: index] else { return }
        
        guard let modelsArray = viewModel.videosModels?[exist: index], modelsArray.count == 0 else {
            view.mj_header.endRefreshing()
            return
        }
        
        var categoryID: Int? = nil
        if let model = viewModel.categoryModels?[exist: index-1] {
            categoryID = model.id
        }
        
        if !view.mj_header.isRefreshing {
            HUDService.sharedInstance.showFetchingView(target: view)
        }
        
        viewModel.refetchVideos(categoryID: categoryID) { (code, next, models) in
            view.mj_header.endRefreshing()
            HUDService.sharedInstance.hideFetchingView(target: view)
            if code >= 0 {
                if let models = models {
                    if models.count == 0 {
                        HUDService.sharedInstance.showNoDataView(target: view, frame: CGRect(origin: .zero, size: view.bounds.size)) { }
                    } else {
                        self.viewModel.videosModels?[index].append(contentsOf: models)
                    }
                }
                
                view.reloadData()
                if next {
                    view.mj_footer.isHidden = false
                    view.mj_footer.resetNoMoreData()
                } else {
                    view.mj_footer.isHidden = true
                }
            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: view, frame: CGRect(origin: CGPoint.zero, size: view.bounds.size)) { [weak self] in
                    self?.refetchVideos(index: index)
                }
            }
        }
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    @objc func recoverCategoryStyle() {
        for button in scrollView.subviews {
            guard let button = button as? UIButton else { continue }
            
            button.titleLabel?.font = UIConstants.Font.body
            button.setTitleColor(UIConstants.Color.body, for: .normal)
        }
        
    }
    
    // MARK: - ============= Action =============
    @objc func categoryBtnAction(sender: UIButton) {
        categoryIndicatorImgView.snp.remakeConstraints { make in
            make.centerX.equalTo(sender)
            make.width.equalTo(29)
            make.height.equalTo(1.5)
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.35, animations: {
            self.scrollView.layoutIfNeeded()
        })
        
        recoverCategoryStyle()
        
        sender.setTitleColor(UIConstants.Color.head, for: .normal)
        sender.titleLabel?.font = UIConstants.Font.h2
        
        refetchVideos(index: sender.tag)
        tableViewScrollView.setContentOffset(CGPoint(x: UIScreenWidth*CGFloat(sender.tag), y: 0), animated: true)
        
        selectedIndex = sender.tag
    }
}


extension DVideosViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let index = collectionViews.firstIndex(of: collectionView) {
            return viewModel.videosModels?[exist: index]?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionCell.className(), for: indexPath) as! VideoCollectionCell
        if let index = collectionViews.firstIndex(of: collectionView) {
            if let models = viewModel.videosModels?[exist: index], let model = models[exist: indexPath.row] {
                cell.setup(model: model)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        //        if let index = tableViews.firstIndex(of: tableView) {
        //            if let models = viewModel.videosModels?[exist: index], let model = models[exist: indexPath.row], let courseID = model.id {
        //                navigationController?.pushViewController(DCourseDetailViewController(courseID: courseID), animated: true)
        //            }
        //        }
    }
    
}


extension DVideosViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard scrollView == tableViewScrollView else { return }
        
        let index = Int(targetContentOffset.pointee.x/UIScreenWidth)
        if index != selectedIndex {
            guard let sender = buttons[exist: index] else { return }
            categoryIndicatorImgView.snp.remakeConstraints { make in
                make.centerX.equalTo(sender)
                make.width.equalTo(29)
                make.height.equalTo(1.5)
                make.bottom.equalToSuperview()
            }
            
            UIView.animate(withDuration: 0.35, animations: {
                self.scrollView.layoutIfNeeded()
            })
            
            recoverCategoryStyle()
            
            sender.setTitleColor(UIConstants.Color.head, for: .normal)
            sender.titleLabel?.font = UIConstants.Font.h2
            
            refetchVideos(index: index)
            
            selectedIndex = index
            
            self.scrollView.scrollRectToVisible(sender.frame, animated: true)
        }
    }
}
