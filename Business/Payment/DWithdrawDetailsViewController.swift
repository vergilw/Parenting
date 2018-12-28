//
//  DWithdrawDetailsViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/28.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DWithdrawDetailsViewController: BaseViewController {

    var coinLogModels: [CoinLogModel]?
    
    lazy fileprivate var pageNumber: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "提现记录"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 104
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        tableView.separatorColor = UIConstants.Color.separator
        tableView.separatorStyle = .singleLine
        tableView.register(WithdrawDetailsCell.self, forCellReuseIdentifier: WithdrawDetailsCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.fetchMoreData()
        })
        tableView.mj_footer.isHidden = true
        let footer = tableView.mj_footer as! MJRefreshAutoNormalFooter
        footer.setTitle("仅显示3个月以内的提现记录", for: .noMoreData)
        footer.stateLabel.textColor = UIConstants.Color.foot
        
        view.addSubview(tableView)
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchData() {
        HUDService.sharedInstance.showFetchingView(target: self.view)
        
        PaymentProvider.request(.coin_logs(pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            HUDService.sharedInstance.hideFetchingView(target: self.view)
            
            if code >= 0 {
                if let data = JSON?["wallet_logs"] as? [[String: Any]] {
                    if let models = [CoinLogModel].deserialize(from: data) as? [CoinLogModel] {
                        self.coinLogModels = models
                    }
                    self.tableView.reloadData()
                    
                    if self.coinLogModels?.count ?? 0 == 0 {
                        HUDService.sharedInstance.showNoDataView(target: self.view)
                    }
                
                    if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                        if totalPages > self.pageNumber {
                            self.pageNumber += 1
                            self.tableView.mj_footer.isHidden = false
                            self.tableView.mj_footer.resetNoMoreData()
                            
                        } else {
                            self.tableView.mj_footer.endRefreshingWithNoMoreData()
                            if self.coinLogModels?.count ?? 0 == 0 {
                                self.tableView.mj_footer.isHidden = true
                            } else {
                                self.tableView.mj_footer.isHidden = false
                            }
                        }
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
        
        PaymentProvider.request(.coin_logs(pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            self.tableView.mj_footer.endRefreshing()
            
            if code >= 0 {
                if let data = JSON?["wallet_logs"] as? [[String: Any]] {
                    if let models = [CoinLogModel].deserialize(from: data) as? [CoinLogModel] {
                        self.coinLogModels?.append(contentsOf: models)
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


extension DWithdrawDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinLogModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WithdrawDetailsCell.className(), for: indexPath) as! WithdrawDetailsCell
//        if let model = coinLogModels?[exist: indexPath.row] {
//            cell.setup(model: model)
//        }
        //FIXME: DEBUG
        cell.setup()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //        if let model = storyModels?[exist: indexPath.row], let storyID = model.id {
        //            navigationController?.pushViewController(DTeacherStoryDetailViewController(storyID: storyID), animated: true)
        //        }
        
    }

}
