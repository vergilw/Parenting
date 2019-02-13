//
//  DVideoDetailViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/14.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import AVFoundation
import Presentr

class DVideoDetailViewController: BaseViewController {
    
    enum VideoListMode {
        case paging
        case fragment
    }

    lazy fileprivate var viewModel = DVideoDetailViewModel()
    
    @objc dynamic var currentIndex: Int = 0
    
    lazy fileprivate var reusingIdentifiersMapping = [Int: String]()
    
    lazy fileprivate var isRefetchingData = false
    
    lazy fileprivate var orderedSet: NSMutableOrderedSet = NSMutableOrderedSet()
    
    lazy fileprivate var players = [AVPlayer]()
    
    lazy fileprivate var dismissBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "public_backBarItem")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        if #available(iOS 11.0, *) {
            var topHeight = (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)
            if topHeight == 0 {
                topHeight = 20
            }
            button.imageEdgeInsets = UIEdgeInsets(top: topHeight, left: 0, bottom: 0, right: 0)
        } else {
            button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        }
        button.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        button.layer.shadowOpacity = 0.6
        button.layer.shadowColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(backBarItemAction), for: .touchUpInside)
        return button
    }()

//    lazy fileprivate var userViewController: DVideoUserViewController = {
//        let viewController = DVideoUserViewController()
//        return viewController
//    }()
    
    init(mode: VideoListMode, models: [VideoModel], index: Int) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel.listMode = mode
        viewModel.videoModels = models
        currentIndex = index
        
        //TODO: complete all mode
        if mode == .fragment {
            reusingIdentifiersMapping = [0: "A"]
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        
        //TODO: init
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.moviePlayback)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        //TODO: change assign observer
//        PlayListService.sharedInstance.invalidateObserver = true
        
        
        if viewModel.listMode == .fragment {
            
            refetchData()
            
            self.addObserver(self, forKeyPath: "currentIndex", options: [.initial, .new], context: nil)
            
        } else if viewModel.listMode == .paging {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.tableView.scrollToRow(at: IndexPath(row: self.currentIndex, section: 0), at: UITableView.ScrollPosition.middle, animated: false)
                self.addObserver(self, forKeyPath: "currentIndex", options: [.initial, .new], context: nil)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        tableView.contentInset = UIEdgeInsets(top: UIScreenHeight, left: 0, bottom: UIScreenHeight * 3, right: 0);
        tableView.rowHeight = UIScreenHeight
        
        tableView.register(VideoDetailCell.self, forCellReuseIdentifier: "A")
        tableView.register(VideoDetailCell.self, forCellReuseIdentifier: "B")
        tableView.register(VideoDetailCell.self, forCellReuseIdentifier: "C")
        tableView.register(VideoDetailCell.self, forCellReuseIdentifier: "D")
        tableView.register(VideoDetailCell.self, forCellReuseIdentifier: "E")
        tableView.register(VideoDetailCell.self, forCellReuseIdentifier: "F")
        tableView.register(VideoDetailCell.self, forCellReuseIdentifier: VideoDetailCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubviews([tableView, dismissBtn])
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(-UIScreenHeight)
            make.height.equalTo(UIScreenHeight*5)
        }
        dismissBtn.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalTo(62.5)
            if #available(iOS 11.0, *) {
                var topHeight = (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)
                if topHeight == 0 {
                    topHeight = 20
                }
                make.height.equalTo(topHeight+(navigationController?.navigationBar.bounds.size.height ?? 0))
            } else {
                make.height.equalTo(20+(navigationController?.navigationBar.bounds.size.height ?? 0))
            }
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(refetchData), name: Notification.Authorization.signInDidSuccess, object: nil)
    }
    
    // MARK: - ============= Request =============
    @objc fileprivate func refetchData() {
        guard let model = viewModel.videoModels?[exist: currentIndex], let string = model.id, let videoID = Int(string) else { return }
        
        VideoProvider.request(.videos(nil, videoID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if code >= 0 {
                var index = 0
                var videoModels = [VideoModel]()
                var previousModels = [VideoModel]()
                var currentModel = VideoModel()
                var nextModels = [VideoModel]()
                
                //pre
                if let data = JSON?["pre"] as? [[String: Any]] {
                    if let models = [VideoModel].deserialize(from: data) as? [VideoModel] {
                        previousModels = models.reversed()
                        videoModels.append(contentsOf: models.reversed())
                        index = models.count
                    }
                }
                
                //current
                if let data = JSON?["video"] as? [String: Any] {
                    if let model = VideoModel.deserialize(from: data) {
                        currentModel = model
                        videoModels.append(model)
                    }
                }
                
                //next
                if let data = JSON?["next"] as? [[String: Any]] {
                    if let models = [VideoModel].deserialize(from: data) as? [VideoModel] {
                        nextModels = models
                        videoModels.append(contentsOf: models)
                    }
                }
                
                self.orderedSet.removeAllObjects()
                if let ids = (videoModels.map { $0.id }) as? [String], ids.count > 0 {
                    self.orderedSet.addObjects(from: ids)
                }
                
                //AVPlayer重用
                var currentReusingIdentifier: String?
                if let identifier = self.reusingIdentifiersMapping[1] {
                    currentReusingIdentifier = identifier
                } else if let identifier = self.reusingIdentifiersMapping[0] {
                    currentReusingIdentifier = identifier
                }
                if let identifier = currentReusingIdentifier {
                    var reusableIndentifiers = ["A", "B", "C", "D", "E", "F"].filter({ (string) -> Bool in
                        return string != identifier
                    })
                    
                    if previousModels.count > 0 {
                        self.reusingIdentifiersMapping[0] = reusableIndentifiers[0]
                        self.reusingIdentifiersMapping[1] = reusableIndentifiers[1]
                        self.reusingIdentifiersMapping[2] = identifier
                        self.reusingIdentifiersMapping[3] = reusableIndentifiers[2]
                        self.reusingIdentifiersMapping[4] = reusableIndentifiers[3]
                        self.reusingIdentifiersMapping[5] = reusableIndentifiers[4]
                        
                        
                    } else {
                        self.reusingIdentifiersMapping[0] = reusableIndentifiers[0]
                        self.reusingIdentifiersMapping[1] = identifier
                        self.reusingIdentifiersMapping[2] = reusableIndentifiers[1]
                        self.reusingIdentifiersMapping[3] = reusableIndentifiers[2]
                        self.reusingIdentifiersMapping[4] = reusableIndentifiers[3]
                        self.reusingIdentifiersMapping[5] = reusableIndentifiers[4]
                    }
                }
                
                print(self.reusingIdentifiersMapping.sorted(by: { (a, b) -> Bool in
                    return a.key < b.key
                }))
                
                self.isRefetchingData = true
                self.viewModel.videoModels = videoModels
                self.tableView.reloadData()
                
                
                self.tableView.setContentOffset(CGPoint(x: 0, y: CGFloat(index-1)*UIScreenHeight), animated: false)
                self.currentIndex = index
                
                self.isRefetchingData = false
            }
        }))
    }
    
    fileprivate func fetchHeaderData() {
        guard let videoID = orderedSet.firstObject as? String else { return }
        
        removeObserver(self, forKeyPath: "currentIndex", context: nil)
        
        VideoProvider.request(.videos("pre", Int(videoID)), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if code >= 0 {
                if let data = JSON?["pre"] as? [[String: Any]] {
                    
                    if let models = [VideoModel].deserialize(from: data) as? [VideoModel], models.count > 0 {
                        
                        self.viewModel.videoModels?.insert(contentsOf: models.reversed(), at: 0)
                        
                        if let ids = (models.map { $0.id }) as? [String], ids.count > 0 {
                            self.orderedSet.insert(ids.reversed(), at: IndexSet(0...ids.count-1))
                        }
                        
//                        print(self.reusingIdentifiersMapping.sorted(by: { (a, b) -> Bool in
//                            return a.key < b.key
//                        }))
                        
                        
                        self.tableView.reloadData()
                        
                        self.currentIndex += models.count
                        
                        
                        self.tableView.delegate = nil
                        self.tableView.contentOffset = CGPoint(x: 0, y: CGFloat(self.currentIndex-1)*UIScreenHeight)
                        self.tableView.delegate = self
                        
                        
                        print(self.reusingIdentifiersMapping.sorted(by: { (a, b) -> Bool in
                            return a.key < b.key
                        }))
                        
                        //AVPlayer重用
                        self.tableView.layoutIfNeeded()
                        let swapIdentifiers = self.reusingIdentifiersMapping[5]
                        self.reusingIdentifiersMapping[5] = self.reusingIdentifiersMapping[4]
                        self.reusingIdentifiersMapping[4] = self.reusingIdentifiersMapping[3]
                        self.reusingIdentifiersMapping[3] = self.reusingIdentifiersMapping[2]
                        self.reusingIdentifiersMapping[2] = self.reusingIdentifiersMapping[1]
                        self.reusingIdentifiersMapping[1] = self.reusingIdentifiersMapping[0]
                        self.reusingIdentifiersMapping[0] = swapIdentifiers
                    }
                    
                }
                
            }
            
            self.addObserver(self, forKeyPath: "currentIndex", options: [.new], context: nil)
        }))
    }
    
    fileprivate func fetchFooterData() {
        guard let videoID = orderedSet.lastObject as? String else { return }
        
        VideoProvider.request(.videos("next", Int(videoID)), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if code >= 0 {
                if let data = JSON?["next"] as? [[String: Any]] {
                    
                    if let models = [VideoModel].deserialize(from: data) as? [VideoModel] {
                        self.viewModel.videoModels?.append(contentsOf: models)
                        
                        if let ids = (models.map { $0.id }) as? [String], ids.count > 0 {
                            self.orderedSet.addObjects(from: ids)
                        }
                        
                        let startIndex = (self.viewModel.videoModels?.count ?? 0)-models.count
                        let indexPaths: [IndexPath] = (startIndex..<startIndex+models.count).compactMap({ (i) -> IndexPath in
                            return IndexPath(row: i, section: 0)
                        })
                        self.tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.none)
                        
                        
                        //AVPlayer重用
                        self.tableView.layoutIfNeeded()
                        let swapIdentifiers = self.reusingIdentifiersMapping[0]
                        self.reusingIdentifiersMapping[0] = self.reusingIdentifiersMapping[1]
                        self.reusingIdentifiersMapping[1] = self.reusingIdentifiersMapping[2]
                        self.reusingIdentifiersMapping[2] = self.reusingIdentifiersMapping[3]
                        self.reusingIdentifiersMapping[3] = self.reusingIdentifiersMapping[4]
                        self.reusingIdentifiersMapping[4] = self.reusingIdentifiersMapping[5]
                        self.reusingIdentifiersMapping[5] = swapIdentifiers

                    }
                }
                
            }
        }))
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============

    deinit {
        removeObserver(self, forKeyPath: "currentIndex", context: nil)
        
        NotificationCenter.default.removeObserver(self)
        
//        PlayListService.sharedInstance.invalidateObserver = false
    }
}


extension DVideoDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.videoModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIndentifier = VideoDetailCell.className()
        guard var startRow = (tableView.indexPathsForVisibleRows?.map { $0.row })?.first else {
            return UITableViewCell()
        }
        
        if isRefetchingData == true {
            startRow -= 1
        }
        
        if reusingIdentifiersMapping.keys.contains(indexPath.row-startRow) {
            cellIndentifier = (reusingIdentifiersMapping[indexPath.row-startRow])!
        } else {
            cellIndentifier =  VideoDetailCell.className()
        }
        
        print("visibleRows \(tableView.indexPathsForVisibleRows) \n reuse \(cellIndentifier) at \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as! VideoDetailCell
        cell.delegate = self
        addPlayer(cell.player)
        if let model = viewModel.videoModels?[exist: indexPath.row] {
            cell.setup(model: model)
            if viewModel.videoModels?.count == 1 {
                if cell.player.currentItem != nil {
                    cell.player.play()
                }
                cell.startCountdown()
            }
        }
        return cell
    }
    
}


extension DVideoDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let models = viewModel.videoModels else { return }

        DispatchQueue.main.async {
            let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
            scrollView.panGestureRecognizer.isEnabled = false

            var isTop: Bool? = nil
            if translatedPoint.y < -50 && self.currentIndex < (models.count - 1) {
                self.currentIndex += 1
                
                isTop = false
                
            }
            if translatedPoint.y > 50 && self.currentIndex > 0 {
                self.currentIndex -= 1
                
                isTop = true
                
            }
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                self.tableView.scrollToRow(at: IndexPath(row: self.currentIndex, section: 0), at: UITableView.ScrollPosition.top, animated: false)
            }, completion: { finished in
                scrollView.panGestureRecognizer.isEnabled = true
                
                if isTop == true {
                    //向上翻页prefetching
                    if self.currentIndex <= 3 && self.viewModel.hasMoreHeader {
                        self.fetchHeaderData()
                    }
                } else if isTop == false {
                    //向下翻页prefetching
                    if self.currentIndex >= models.count-4 && self.viewModel.hasMoreFooter {
                        self.fetchFooterData()
                    }
                }
            })
        }
    }
}


extension DVideoDetailViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "currentIndex") {
            print(self.currentIndex)
            weak var cell = tableView.cellForRow(at: IndexPath.init(row: currentIndex, section: 0)) as? VideoDetailCell
            pauseAllPlayers()
            if cell?.player.currentItem != nil {
                cell?.player.play()
            }
            cell?.startCountdown()
            
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    fileprivate func addPlayer(_ element: AVPlayer) {
        if !players.contains(element) {
            players.append(element)
        }
    }
    
    fileprivate func pauseAllPlayers() {
        for player in players {
            player.pause()
        }
    }
}


extension DVideoDetailViewController: VideoDetailCellDelegate {
    
    func tableViewCellComment(_ tableViewCell: VideoDetailCell) {
        guard let string = tableViewCell.model?.id, let videoID = Int(string) else { return }
        let viewController = DVideoCommentViewController(videoID: videoID)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    func tableViewCellForward(_ tableViewCell: VideoDetailCell) {
        guard let model = tableViewCell.model else { return }
        
        let viewController = DVideoForwardViewController(model: model)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    func tableViewCellAvatar(_ tableViewCell: VideoDetailCell) {
        if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController, let navigationController = tabBarController.selectedViewController as? UINavigationController, navigationController.viewControllers.contains(where: { (viewController) -> Bool in
            return viewController.isKind(of: DVideoUserViewController.self)
        }) {
            return
        }
        
        guard let userID = tableViewCell.model?.author?.id else { return }
        
        let viewController = DVideoUserViewController()
        viewController.userID = userID
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension DVideoDetailViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = PresentationManager(presentedViewController: presented, presenting: presenting)
        if presented.isKind(of: DVideoForwardViewController.self) {
            presentation.layoutHeight = 275
        }
        return presentation
    }
}
