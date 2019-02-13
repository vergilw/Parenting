//
//  DVideosViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/14.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit


class DVideosViewController: BaseViewController {

    var videoModels: [VideoModel]?
    
    fileprivate lazy var orderedSet: NSMutableOrderedSet = NSMutableOrderedSet()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = (UIScreenWidth-1)/2.0
        layout.itemSize = CGSize(width: width, height: width/9.0*16)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        if #available(iOS 11, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        view.showsVerticalScrollIndicator = false
        view.register(VideoCollectionCell.self, forCellWithReuseIdentifier: VideoCollectionCell.className())
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        
        view.mj_header = CustomMJHeader(refreshingBlock: { [weak self] in
            self?.fetchData()
        })
        view.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self, weak view] in
            self?.fetchMoreData()
        })
        view.mj_footer.isHidden = true
        
        return view
    }()
    
    lazy fileprivate var cameraBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 27.5
        button.clipsToBounds = true
        button.backgroundColor = UIColor("#ffe142")
        button.setImage(UIImage(named: "video_cameraIndicator"), for: .normal)
        button.addTarget(self, action: #selector(cameraBtnAction), for: .touchUpInside)
        button.layer.shadowOffset = CGSize(width: 0, height: 3.5)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 11
        button.layer.shadowColor = UIColor.black.cgColor
        return button
    }()
    
    lazy fileprivate var lastOffsetY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "视频"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
        
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        
        view.addSubviews([collectionView, cameraBtn])
    }

    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cameraBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 55, height: 55))
            make.bottom.equalTo(-45)
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: Notification.Authorization.signInDidSuccess, object: nil)
    }
    
    // MARK: - ============= Request =============
    @objc fileprivate func fetchData() {
        if !collectionView.mj_header.isRefreshing {
            HUDService.sharedInstance.showFetchingView(target: self.view)
        }
        
        VideoProvider.request(.videos("next", nil), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if self.collectionView.mj_header.isRefreshing {
                self.collectionView.mj_header.endRefreshing()
            } else {
                HUDService.sharedInstance.hideFetchingView(target: self.view)
            }
            
            if code >= 0 {
                if let data = JSON?["next"] as? [[String: Any]] {
                    
                    self.orderedSet.removeAllObjects()
                    
                    if let models = [VideoModel].deserialize(from: data) as? [VideoModel] {
                        self.videoModels = models
                        
                        if let ids = (models.map { $0.id }) as? [String] {
                            self.orderedSet.addObjects(from: ids)
                        }
                        
                        if models.count > 0 {
                            self.collectionView.mj_footer.isHidden = false
                            self.collectionView.mj_footer.resetNoMoreData()
                            
                        } else {
                            self.collectionView.mj_footer.isHidden = true
                        }
                    }
                    self.collectionView.reloadData()
                    
                }
                
            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: self.view) { [weak self] in
                    self?.fetchData()
                }
            }
        }))
    }
    
    fileprivate func fetchMoreData() {
        guard let videoID = orderedSet.lastObject as? String else { return }
        
        VideoProvider.request(.videos("next", Int(videoID)), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            self.collectionView.mj_footer.endRefreshing()
            
            if code >= 0 {
                if let data = JSON?["next"] as? [[String: Any]] {
                    if let models = [VideoModel].deserialize(from: data) as? [VideoModel] {
                        self.videoModels?.append(contentsOf: models)
                        
                        if let ids = (models.map { $0.id }) as? [String] {
                            self.orderedSet.addObjects(from: ids)
                        }
                        
                        if models.count > 0 {
                            self.collectionView.mj_footer.endRefreshing()
                            
                        } else {
                            self.collectionView.mj_footer.endRefreshingWithNoMoreData()
                        }
                    }
                    self.collectionView.reloadData()
                    
                }
                
            }
        }))
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    
    // MARK: - ============= Action =============
    @objc func cameraBtnAction() {
        //FIXME: DEBUG
        guard AuthorizationService.sharedInstance.isSignIn() else {
            let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
            present(authorizationNavigationController, animated: true, completion: nil)
            return
        }

        let navigationController = BaseNavigationController(rootViewController: DVideoShootViewController())
        present(navigationController, animated: true, completion: nil)
        
//        navigationController?.pushViewController(DVideoPostViewController(fileURL: URL(fileURLWithPath: "T##String"), coverImg: UIImage()), animated: true)
        
    }
}


extension DVideosViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionCell.className(), for: indexPath) as! VideoCollectionCell
        if let model = videoModels?[exist: indexPath.row] {
            cell.setup(model: model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let models = videoModels, let model = models[exist: indexPath.row] {
            navigationController?.pushViewController(DVideoDetailViewController(mode: .fragment, models: [model], index: 0), animated: true)
        }
    }
    
}


extension DVideosViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        guard navigationView.frame.size != .zero else { return }

        if cameraBtn.translatesAutoresizingMaskIntoConstraints == false {
            cameraBtn.translatesAutoresizingMaskIntoConstraints = true
        }
        
        //TODO: iOS 10 first
        let offsetY = lastOffsetY - scrollView.contentOffset.y
        
        if cameraBtn.center.y-offsetY > view.bounds.height+cameraBtn.bounds.midY {
            cameraBtn.center = CGPoint(x: view.bounds.midX, y: view.bounds.height+cameraBtn.bounds.midY)
        } else if cameraBtn.center.y-offsetY < view.bounds.height-45-cameraBtn.bounds.midY || scrollView.contentOffset.y <= 0 {
            cameraBtn.center = CGPoint(x: view.bounds.midX, y: view.bounds.height-45-cameraBtn.bounds.midY)
        } else {
            cameraBtn.center = CGPoint(x: view.bounds.midX, y: cameraBtn.center.y-offsetY)
        }
        print(cameraBtn.center.y-offsetY, offsetY)
//        if scrollView.contentOffset.y < 0 {
//            cameraBtn.center = CGPoint(x: view.bounds.midX, y: view.bounds.height-45-55-cameraBtn.bounds.height/2)
//            lastOffsetY = 0
//        } else if offsetY > 0 {
//            if cameraBtn.frame.minY < view.bounds.height {
//                if cameraBtn.center.y+offsetY > view.bounds.height+cameraBtn.bounds.midY {
//                    cameraBtn.center = CGPoint(x: view.bounds.midX, y: view.bounds.height+cameraBtn.bounds.midY)
//                } else {
//                    cameraBtn.center = CGPoint(x: view.bounds.midX, y: cameraBtn.center.y+offsetY)
//                }
//
//            } else {
//                cameraBtn.center = CGPoint(x: view.bounds.midX, y: view.bounds.height+cameraBtn.bounds.midY)
//            }
//
//            lastOffsetY = scrollView.contentOffset.y
//        } else {
//
//            if cameraBtn.frame.maxY > view.bounds.height-45 {
//                if ((cameraBtn.center.y+offsetY) as CGFloat) < ((view.bounds.height-45-55+cameraBtn.bounds.height/2) as CGFloat) {
//                    cameraBtn.center = CGPoint(x: view.bounds.midX, y: view.bounds.height-45-55+cameraBtn.bounds.height/2)
//                    print("1", lastOffsetY)
//                } else {
//                    cameraBtn.center = CGPoint(x: view.bounds.midX, y: cameraBtn.center.y+offsetY)
//                    print("2", lastOffsetY)
//                }
//
//            } else {
//                cameraBtn.center = CGPoint(x: view.frame.midX, y: view.bounds.height-45-55+cameraBtn.bounds.height/2)
//                print("3", lastOffsetY)
//            }
//
            lastOffsetY = scrollView.contentOffset.y
//        }
        
    }
}
