//
//  DMeCoursesViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/15.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DMeCoursesViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "我的课程"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        tableView.backgroundColor = UIConstants.Color.background
        tableView.rowHeight = 172
        tableView.register(CourseCell.self, forCellReuseIdentifier: CourseCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    func fetchData() {
        HUDService.sharedInstance.showNoDataView(target: view) {
            self.navigationController?.pushViewController(DCoursesViewController(), animated: true)
        }
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============

}


extension DMeCoursesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseCell.className(), for: indexPath) as! CourseCell
        cell.setup(mode: CourseCell.CellDisplayMode.owned)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(DCourseDetailViewController(courseID: 2), animated: true)
    }
}
