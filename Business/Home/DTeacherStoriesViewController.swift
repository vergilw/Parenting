//
//  DTeacherStoriesViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/20.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DTeacherStoriesViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "氧育故事"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        tableView.rowHeight = 211
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .white
        tableView.register(TeacherStoriesCell.self, forCellReuseIdentifier: TeacherStoriesCell.className())
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


extension DTeacherStoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeacherStoriesCell.className(), for: indexPath) as! TeacherStoriesCell
        cell.setup()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(DTeacherStoryDetailViewController(), animated: true)
    }
}
