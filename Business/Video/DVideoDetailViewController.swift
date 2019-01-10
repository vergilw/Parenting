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

    lazy fileprivate var viewModel = DVideoDetailViewModel()
    
    @objc dynamic var currentIndex: Int = 0
    
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
    
    init(models: [VideoModel], index: Int) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel.videosModels = models
        currentIndex = index
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
        
        PlayListService.sharedInstance.invalidateObserver = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.tableView.scrollToRow(at: IndexPath(row: self.currentIndex, section: 0), at: UITableView.ScrollPosition.middle, animated: false)
            self.addObserver(self, forKeyPath: "currentIndex", options: [.initial, .new], context: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        tableView.contentInset = UIEdgeInsets(top: UIScreenHeight, left: 0, bottom: UIScreenHeight * 3, right: 0);
        tableView.rowHeight = UIScreenHeight
        tableView.register(VideoDetailCell.self, forCellReuseIdentifier: VideoDetailCell.className())
//        tableView.isPagingEnabled = true
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
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============

    deinit {
        NotificationCenter.default.removeObserver(self)
        
        PlayListService.sharedInstance.invalidateObserver = false
    }
}


extension DVideoDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.videosModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoDetailCell.className(), for: indexPath) as! VideoDetailCell
        cell.delegate = self
        addPlayer(cell.player)
        if let model = viewModel.videosModels?[exist: indexPath.row] {
            cell.setup(model: model)
        }
        return cell
    }
}


extension DVideoDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let models = viewModel.videosModels else { return }

        DispatchQueue.main.async {
            let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
            scrollView.panGestureRecognizer.isEnabled = false

            if translatedPoint.y < -50 && self.currentIndex < (models.count - 1) {
                self.currentIndex += 1
            }
            if translatedPoint.y > 50 && self.currentIndex > 0 {
                self.currentIndex -= 1
            }
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                self.tableView.scrollToRow(at: IndexPath.init(row: self.currentIndex, section: 0), at: UITableView.ScrollPosition.top, animated: false)
            }, completion: { finished in
                scrollView.panGestureRecognizer.isEnabled = true
            })
        }
    }
}


extension DVideoDetailViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "currentIndex") {
            weak var cell = tableView.cellForRow(at: IndexPath.init(row: currentIndex, section: 0)) as? VideoDetailCell
            pauseAllPlayers()
            cell?.player.play()
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
//        self.customPresentViewController(commentPresenter, viewController: viewController, animated: true)
//        view.addSubview(viewController.view)
//        addChild(viewController)
//        viewController.view.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalToSuperview()
//            make.height.equalTo(440)
//        }
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    func tableViewCellForward(_ tableViewCell: VideoDetailCell) {
//        guard let string = tableViewCell.model?.id, let videoID = Int(string) else { return }
        let viewController = DVideoForwardViewController()
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    func tableViewCellAvatar(_ tableViewCell: VideoDetailCell) {
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
