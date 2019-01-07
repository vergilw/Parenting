//
//  DVideoDetailViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/14.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import AVFoundation

class DVideoDetailViewController: BaseViewController {

    lazy fileprivate var viewModel = DVideoDetailViewModel()
    
    @objc dynamic var currentIndex: Int = 0
    
    lazy fileprivate var isCurPlayerPause: Bool = false
    
    lazy fileprivate var dismissBtn: UIButton = {
        let button = UIButton()
        //        button.setImage(UIImage(named: <#T##String#>)?.withRenderingMode(.alwaysTemplate), for: .normal)
        //        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    init(models: [VideoModel], index: Int) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel.videosModels = models
        currentIndex = index
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
        
        
        //TODO: init
//        try? AVAudioSession.sharedInstance().setMode(AVAudioSession.Mode.videoRecording)
//        try? AVAudioSession.sharedInstance().setActive(true)
        
        PlayListService.sharedInstance.invalidateObserver = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            
            let curIndexPath = IndexPath.init(row: self.currentIndex, section: 0)
            self.tableView.scrollToRow(at: curIndexPath, at: UITableView.ScrollPosition.middle, animated: false)
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
                make.height.equalTo((UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight)+(navigationController?.navigationBar.bounds.size.height ?? 0))
            } else {
                make.height.equalTo(UIStatusBarHeight+(navigationController?.navigationBar.bounds.size.height ?? 0))
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
        let cells = tableView.visibleCells as! [VideoDetailCell]
        for cell in cells {
            cell.playerView.cancelLoading()
        }
        removeObserver(self, forKeyPath: "currentIndex")
        
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
            isCurPlayerPause = false
            weak var cell = tableView.cellForRow(at: IndexPath.init(row: currentIndex, section: 0)) as? VideoDetailCell
            if cell?.isPlayerReady ?? false {
                cell?.replay()
            } else {
                AVPlayerManager.shared().pauseAll()
                cell?.onPlayerReady = { [weak self] in
                    if let indexPath = self?.tableView.indexPath(for: cell!) {
                        if !(self?.isCurPlayerPause ?? true) && indexPath.row == self?.currentIndex {
                            cell?.play()
                        }
                    }
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
