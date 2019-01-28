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
        tableView.rowHeight = CourseCell.cellHeight()
        tableView.register(CourseCell.self, forCellReuseIdentifier: CourseCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.fetchMoreData()
        })
        tableView.mj_footer.isHidden = true
        
        view.addSubview(contentView)
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchData() {
        HUDService.sharedInstance.showFetchingView(target: self.tableView)
        
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
                    HUDService.sharedInstance.showNoDataView(target: self.tableView) { [weak self] in
                        self?.navigationController?.pushViewController(DCoursesViewController(), animated: true)
                    }
                }
                
            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: self.tableView) { [weak self] in
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
    
    fileprivate func fetchVideoData() {
        HUDService.sharedInstance.showFetchingView(target: self.collectionView)
        
        VideoProvider.request(.video_favorites(1), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            HUDService.sharedInstance.hideFetchingView(target: self.collectionView)
            self.collectionView.alpha = 1.0
            
            if code >= 0 {
                if let data = JSON?["videos"] as? [[String: Any]] {
                    if let models = [VideoModel].deserialize(from: data) as? [VideoModel] {
                        self.videoModels = models
                    }
                    self.collectionView.reloadData()
                    
                    if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                        if totalPages > self.pageNumber {
                            self.pageNumber = 2
                            self.collectionView.mj_footer.isHidden = false
                            self.collectionView.mj_footer.resetNoMoreData()
                            
                        } else {
                            self.collectionView.mj_footer.isHidden = true
                        }
                    }
                }
                
                if self.favoritesModels?.count ?? 0 == 0 {
                    HUDService.sharedInstance.showNoDataView(target: self.collectionView) { [weak self] in
                        self?.navigationController?.pushViewController(DCoursesViewController(), animated: true)
                    }
                }
                
            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: self.collectionView) { [weak self] in
                    self?.fetchData()
                }
            }
        }))
    }
    
    fileprivate func fetchMoreVideosData() {
        
        VideoProvider.request(.video_favorites(videoPageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            self.collectionView.mj_footer.endRefreshing()
            
            if code >= 0 {
                if let data = JSON?["videos"] as? [[String: Any]] {
                    if let models = [VideoModel].deserialize(from: data) as? [VideoModel] {
                        self.videoModels?.append(contentsOf: models)
                    }
                    self.collectionView.reloadData()
                    
                    if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                        if totalPages > self.pageNumber {
                            self.pageNumber += 1
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
    
    // MARK: - ============= Action =============
    
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
            cell.actionBlock = { [weak self] button in
                button.startAnimating()
                
                CourseProvider.request(.course_toggle_favorites(courseID: courseID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
                    
                    if let isFavorite = JSON?["is_favorite"] as? Bool {
                        button.stopAnimating()
                        
                        model.is_favorite = isFavorite
                        
                        if model.is_favorite == true {
                            button.setImage(UIImage(named: "course_favoriteSelected"), for: .normal)
                        } else {
                            button.setImage(UIImage(named: "course_favoriteNormal"), for: .normal)
                        }
                        
                        button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
                            button.transform = CGAffineTransform.identity
                        }, completion: nil)
                    }
                }))
            }
        }
        return cell
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
        if index == 1 && collectionView.alpha == 0 {
            fetchVideoData()
        }
    }
}
