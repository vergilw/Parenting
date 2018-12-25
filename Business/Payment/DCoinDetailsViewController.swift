//
//  DCoinDetailsViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/25.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DCoinDetailsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "交易记录"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 72
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        tableView.separatorColor = UIConstants.Color.separator
        tableView.separatorStyle = .singleLine
        tableView.register(CoinDetailsCell.self, forCellReuseIdentifier: CoinDetailsCell.className())
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
//            self?.fetchData()
//        })
//        tableView.mj_footer.isHidden = true
        
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
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============

}


extension DCoinDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6//storyModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoinDetailsCell.className(), for: indexPath) as! CoinDetailsCell
//        if let model = storyModels?[exist: indexPath.row] {
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
