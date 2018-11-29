//
//  DSettingsViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/22.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DSettingsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "其他"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        tableView.rowHeight = 75
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIConstants.Color.separator
        tableView.register(MeItemCell.self, forCellReuseIdentifier: MeItemCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        
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


extension DSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MeItemCell.className(), for: indexPath) as! MeItemCell
        if indexPath.row == 0 {
            cell.setup(title: "关于氧育")
        } else if indexPath.row == 1 {
            cell.setup(title: "清除缓存", value: "320MB")
            //TODO: NSByteCountFormatter
        } else if indexPath.row == 2 {
            cell.setup(title: "意见反馈")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            navigationController?.pushViewController(DAboutViewController(), animated: true)
        } else if indexPath.row == 1 {
//            navigationController?.pushViewController(DPaymentViewController(), animated: true)
        } else if indexPath.row == 2 {
            navigationController?.pushViewController(DFeedbackViewController(), animated: true)
        }
    }
}
