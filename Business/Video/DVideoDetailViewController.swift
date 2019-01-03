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
    
    lazy fileprivate var selectedIndex: Int = 0
    
    lazy fileprivate var dismissBtn: UIButton = {
        let button = UIButton()
        //        button.setImage(UIImage(named: <#T##String#>)?.withRenderingMode(.alwaysTemplate), for: .normal)
        //        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    init(models: [VideoModel], index: Int) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel.videosModels = models
        selectedIndex = index
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
        
        tableView.scrollToRow(at: IndexPath(row: selectedIndex, section: 0), at: UITableView.ScrollPosition.top, animated: false)
        
        //TODO: init
//        try? AVAudioSession.sharedInstance().setMode(AVAudioSession.Mode.videoRecording)
//        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        tableView.rowHeight = UIScreenHeight
        tableView.register(VideoDetailCell.self, forCellReuseIdentifier: VideoDetailCell.className())
        tableView.isPagingEnabled = true
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubviews([tableView, dismissBtn])
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
