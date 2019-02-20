//
//  DMeFavoritesViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/15.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DMeFavoritesViewController: BaseViewController {

    fileprivate var favoritesModels: [CourseModel]?
    
    fileprivate var videoModels: [VideoModel]?
    
    lazy fileprivate var pageNumber: Int = 1
    
    lazy fileprivate var videoPageNumber: Int = 1
    
    fileprivate lazy var contentView: CategoryView = {
        var contentHeight: CGFloat = 0
        if #available(iOS 11, *) {
            let safeTop: CGFloat = (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight)
            let navigationHeight: CGFloat = (navigationController?.navigationBar.bounds.size.height ?? 0)
            contentHeight = UIScreenHeight-safeTop-navigationHeight-46
        } else {
            let safeTop: CGFloat = UIStatusBarHeight
            let navigationHeight: CGFloat = (navigationController?.navigationBar.bounds.size.height ?? 0)
            contentHeight = UIScreenHeight-safeTop-navigationHeight-46
        }
        let view = CategoryView(distribution: UIStackView.Distribution.fillEqually, titles: ["课程", "视频"], childViews: [tableView, collectionView], contentHeight: contentHeight)
        view.delegate = self
        return view
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = (UIScreenWidth-2)/3.0
        layout.itemSize = CGSize(width: width, height: width/9.0*16)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        if #available(iOS 11, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        view.showsVerticalScrollIndicator = false
        view.register(VideoUserCell.self, forCellWithReuseIdentifier: VideoUserCell.className())
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        view.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self, weak view] in
            self?.fetchMoreVideosData()
        })
        view.mj_footer.isHidden = true
        view.alpha = 0.0
        return view
    }()
    
    lazy fileprivate var editBtn: UIButton = {
        let button = UIButton()
        button.frame = CGRect(origin: .zero, size: CGSize(width: 84, height: 44))
        button.setTitleColor(UIConstants.Color.primaryRed, for: .normal)
        button.titleLabel?.font = UIConstants.Font.h3
        button.setTitle("编辑", for: .normal)
        button.addTarget(self, action: #selector(editBtnAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "我的收藏夹"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        tableView.backgroundColor = UIConstants.Color.background
        tableView.rowHeight = 112
        tableView.register(CourseCell.self, forCellReuseIdentifier: CourseCell.className())
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        tableView.separatorColor = UIConstants.Color.separator
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.fetchMoreData()
        })
        tableView.mj_footer.isHidden = true
        
        view.addSubview(contentView)
        
        reloadNavigationItem(isHidden: false)
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchVideoData), name: Notification.Video.videoFavoritesDidChange, object: nil)
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchData() {
        var HUDHeight: CGFloat = 0
        if #available(iOS 11, *) {
            HUDHeight = UIScreenHeight-(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight)-(navigationController?.navigationBar.bounds.size.height ?? 0)-46
        } else {
            HUDHeight = UIScreenHeight-UIStatusBarHeight-(navigationController?.navigationBar.bounds.size.height ?? 0)-46
        }
        HUDService.sharedInstance.showFetchingView(target: self.tableView, frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: HUDHeight)))
        
        CourseProvider.request(.course_favorites(1), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            HUDService.sharedInstance.hideFetchingView(target: self.tableView)
            
            if code >= 0 {
                if let data = JSON?["data"] as? [[String: Any]] {
                    if let models = [CourseModel].deserialize(from: data) as? [CourseModel] {
                        self.favoritesModels = models
                    }
                    self.tableView.reloadData()
                    
                    if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                        if totalPages > self.pageNumber {
                            self.pageNumber = 2
                            self.tableView.mj_footer.isHidden = false
                            self.tableView.mj_footer.resetNoMoreData()
                            
                        } else {
                            self.tableView.mj_footer.isHidden = true
                        }
                    }
                }
                
                if self.favoritesModels?.count ?? 0 == 0 {
                    HUDService.sharedInstance.showNoDataView(target: self.tableView, frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: HUDHeight))) { [weak self] in
                        self?.navigationController?.pushViewController(DCoursesViewController(), animated: true)
                    }
                }
                
            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: self.tableView, frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: HUDHeight))) { [weak self] in
                    self?.fetchData()
                }
            }
        }))
    }
    
    fileprivate func fetchMoreData() {
        
        CourseProvider.request(.course_favorites(pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            self.tableView.mj_footer.endRefreshing()
            
            if code >= 0 {
                if let data = JSON?["data"] as? [[String: Any]] {
                    if let models = [CourseModel].deserialize(from: data) as? [CourseModel] {
                        self.favoritesModels?.append(contentsOf: models)
                    }
                    self.tableView.reloadData()
                    
                    if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                        if totalPages > self.pageNumber {
                            self.pageNumber += 1
                            self.tableView.mj_footer.endRefreshing()
                        } else {
                            self.tableView.mj_footer.endRefreshingWithNoMoreData()
                        }
                    }
                }
                
            }
        }))
    }
    
    @objc fileprivate func fetchVideoData() {
        var HUDHeight: CGFloat = 0
        if #available(iOS 11, *) {
            HUDHeight = UIScreenHeight-(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight)-(navigationController?.navigationBar.bounds.size.height ?? 0)-46
        } else {
            HUDHeight = UIScreenHeight-UIStatusBarHeight-(navigationController?.navigationBar.bounds.size.height ?? 0)-46
        }
        HUDService.sharedInstance.showFetchingView(target: self.collectionView, frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: HUDHeight)))
        
        VideoProvider.request(.videos_paging(["page": 1, "per": 12, "starred": "true"]), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            HUDService.sharedInstance.hideFetchingView(target: self.collectionView)
            self.collectionView.alpha = 1.0
            
            if code >= 0 {
                if let data = JSON?["videos"] as? [[String: Any]] {
                    if let models = [VideoModel].deserialize(from: data) as? [VideoModel] {
                        self.videoModels = models
                    }
                    self.collectionView.reloadData()
                    
                    if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                        if totalPages > self.videoPageNumber {
                            self.videoPageNumber = 2
                            self.collectionView.mj_footer.isHidden = false
                            self.collectionView.mj_footer.resetNoMoreData()
                            
                        } else {
                            self.collectionView.mj_footer.isHidden = true
                        }
                    }
                }
                
                if self.videoModels?.count ?? 0 == 0 {
                    HUDService.sharedInstance.showNoDataView(target: self.collectionView, frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: HUDHeight))) { [weak self] in
                        
                        if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController, let viewController = tabBarController.viewControllers?[exist: 1] {
                            tabBarController.selectedViewController = viewController
                        }
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                }
                
            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: self.collectionView, frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: HUDHeight))) { [weak self] in
                    self?.fetchData()
                }
            }
        }))
    }
    
    fileprivate func fetchMoreVideosData() {
        
        VideoProvider.request(.videos_paging(["page": videoPageNumber, "per": 12, "starred": "true"]), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            self.collectionView.mj_footer.endRefreshing()
            
            if code >= 0 {
                if let data = JSON?["videos"] as? [[String: Any]] {
                    if let models = [VideoModel].deserialize(from: data) as? [VideoModel] {
                        self.videoModels?.append(contentsOf: models)
                    }
                    self.collectionView.reloadData()
                    
                    if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                        if totalPages > self.videoPageNumber {
                            self.videoPageNumber += 1
                            self.collectionView.mj_footer.endRefreshing()
                        } else {
                            self.collectionView.mj_footer.endRefreshingWithNoMoreData()
                        }
                    }
                }
                
            }
        }))
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    func reloadNavigationItem(isHidden: Bool) {
        if isHidden == false {
            let barBtnItem = UIBarButtonItem(customView: editBtn)
            barBtnItem.width = 34+50
            navigationItem.rightBarButtonItem = barBtnItem
            navigationItem.rightMargin = 0
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    // MARK: - ============= Action =============
    @objc fileprivate func editBtnAction() {
        if editBtn.isSelected {
            tableView.setEditing(false, animated: true)
            editBtn.setTitle("编辑", for: UIControl.State.normal)
        } else {
            tableView.setEditing(true, animated: true)
            editBtn.setTitle("取消", for: UIControl.State.normal)
        }
        
        editBtn.isSelected = !editBtn.isSelected
    }
}


extension DMeFavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseCell.className(), for: indexPath) as! CourseCell
        if let model = favoritesModels?[exist: indexPath.row], let courseID = model.id {
            cell.setup(mode: CourseCell.CellDisplayMode.favirotes, model: model)
            
            cell.deleteClosure = { [weak self] in
                guard let self = `self` else { return }
                
                let progressView = MBProgressHUD(view: self.tableView)
                progressView.mode = .indeterminate
                progressView.label.text = "正在删除"
                self.tableView.addSubview(progressView)
                progressView.show(animated: true)
                
                CourseProvider.request(.course_toggle_favorites(courseID: courseID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
                    
                    progressView.hide(animated: true)
                    
                    if code >= 0 {
                        self.favoritesModels?.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                    }
                }))
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let model = favoritesModels?[exist: indexPath.row], let courseID = model.id {
            navigationController?.pushViewController(DCourseDetailViewController(courseID: courseID), animated: true)
        }
    }
}


// MARK: - ============= Favorites Collection DataSource Delegate =============
extension DMeFavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoUserCell.className(), for: indexPath) as! VideoUserCell
        if let model = videoModels?[exist: indexPath.row] {
            cell.setup(model: model, hideDelete: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let models = videoModels {
            navigationController?.pushViewController(DVideoDetailViewController(mode: .paging, models: models, index: indexPath.row), animated: true)
        }
    }
    
}


// MARK: - ============= CategoryViewDelegate =============
extension DMeFavoritesViewController: CategoryDelegate {
    
    func contentView(_ contentView: UIView, didScrollRowAt index: Int) {
        if index == 0 {
            reloadNavigationItem(isHidden: false)
        } else {
            reloadNavigationItem(isHidden: true)
        }
        
        if index == 1 && collectionView.alpha == 0 {
            fetchVideoData()
        }
    }
}
