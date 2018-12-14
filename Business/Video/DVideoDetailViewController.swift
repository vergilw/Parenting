//
//  DVideoDetailViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/14.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DVideoDetailViewController: BaseViewController {

    lazy fileprivate var viewModel = DVideoDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        tableView.rowHeight = UIScreenHeight
//        tableView.register(TeacherStoriesCell.self, forCellReuseIdentifier: TeacherStoriesCell.className())
//        tableView.dataSource = self
//        tableView.delegate = self
        
        view.addSubview(tableView)
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: TeacherStoriesCell.className(), for: indexPath) as! TeacherStoriesCell
//        if let model = storyModels?[exist: indexPath.row] {
//            cell.setup(model: model)
//        }
        return cell
    }
}
