//
//  DRewardRankingViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/24.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DRewardRankingViewController: BaseViewController {

    fileprivate var rankingModels: [RewardRankingModel]?
    
    fileprivate var myRankingModel: RewardRankingModel?
    
    lazy fileprivate var pageNumber: Int = 1
    
    lazy fileprivate var bottomPinnedView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 0, height: -3.0)
        view.layer.shadowOpacity = 0.05
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()
    
    lazy fileprivate var bottomRankingCell: RewardRankingCell = {
        let view = RewardRankingCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: RewardRankingCell.className())
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "收入排行榜"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
        reload()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 82
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        tableView.separatorColor = UIConstants.Color.separator
        tableView.separatorStyle = .singleLine
        tableView.register(RewardRankingCell.self, forCellReuseIdentifier: RewardRankingCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.fetchData()
        })
        tableView.mj_footer.isHidden = true
        
        view.addSubviews([tableView, bottomPinnedView])
        bottomPinnedView.addSubview(bottomRankingCell.contentView)
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        bottomPinnedView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom)
            if #available(iOS 11, *) {
                make.height.equalTo(55+(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
            } else {
                make.height.equalTo(55)
            }
        }
        bottomRankingCell.contentView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(55)
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchData() {
        HUDService.sharedInstance.showFetchingView(target: self.view)
        
        RewardCoinProvider.request(.reward_ranking(pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            HUDService.sharedInstance.hideFetchingView(target: self.view)
            
            if code >= 0 {
                if let data = JSON?["coins"] as? [[String: Any]] {
                    if let models = [RewardRankingModel].deserialize(from: data) as? [RewardRankingModel] {
                        self.rankingModels = models
                    }
                    self.tableView.reloadData()
                    
                    if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                        if totalPages > self.pageNumber {
                            self.pageNumber += 1
                            self.tableView.mj_footer.isHidden = false
                            self.tableView.mj_footer.resetNoMoreData()
                            
                        } else {
                            self.tableView.mj_footer.isHidden = true
                        }
                    }
                }
                
                if let data = JSON?["coin"] as? [String: Any] {
                    if let model = RewardRankingModel.deserialize(from: data) {
                        self.myRankingModel = model
                        self.bottomRankingCell.setup(model: model)
                    }
                }
                
            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: self.view) { [weak self] in
                    self?.fetchData()
                }
            }
        }))
    }
    
    fileprivate func fetchMoreData() {
        
        RewardCoinProvider.request(.reward_ranking(pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            self.tableView.mj_footer.endRefreshing()
            
            if code >= 0 {
                if let data = JSON?["coins"] as? [[String: Any]] {
                    if let models = [RewardRankingModel].deserialize(from: data) as? [RewardRankingModel] {
                        self.rankingModels?.append(contentsOf: models)
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
    
    // MARK: - ============= Reload =============
    @objc func reload() {
    }
    
    // MARK: - ============= Action =============

}


extension DRewardRankingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankingModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RewardRankingCell.className(), for: indexPath) as! RewardRankingCell
        if let model = rankingModels?[exist: indexPath.row] {
            cell.setup(model: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        if let model = courseModels?[exist: indexPath.row], let courseID = model.id {
//            navigationController?.pushViewController(DCourseDetailViewController(courseID: courseID), animated: true)
//        }
    }
}

