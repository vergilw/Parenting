//
//  DMeCoursesViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/15.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DMeCoursesViewController: BaseViewController {

    fileprivate var courseModels: [CourseModel]?
    
    lazy fileprivate var pageNumber: Int = 1
    
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
        tableView.rowHeight = CourseCell.cellHeight()
        tableView.register(CourseCell.self, forCellReuseIdentifier: CourseCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.fetchData()
        })
        tableView.mj_footer.isHidden = true
        
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
        HUDService.sharedInstance.showFetchingView(target: self.view)
        
        CourseProvider.request(.courses_my(pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            HUDService.sharedInstance.hideFetchingView(target: self.view)
            if code >= 0 {
                if let data = JSON?["courses"] as? [[String: Any]] {
                    self.courseModels = [CourseModel].deserialize(from: data) as? [CourseModel]
                    self.tableView.reloadData()
                    
                    if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                        if totalPages > self.pageNumber {
                            self.pageNumber += 1
                            self.tableView.mj_footer.isHidden = false
                            self.tableView.mj_footer.endRefreshingWithNoMoreData()
                            
                        } else {
                            self.tableView.mj_footer.isHidden = true
                        }
                    }
                    
                    if self.courseModels?.count ?? 0 == 0 {
                        HUDService.sharedInstance.showNoDataView(target: self.view) { [weak self] in
                            self?.navigationController?.pushViewController(DCoursesViewController(), animated: true)
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
        return courseModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseCell.className(), for: indexPath) as! CourseCell
        if let model = courseModels?[exist: indexPath.row] {
            cell.setup(mode: CourseCell.CellDisplayMode.owned, model: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let model = courseModels?[exist: indexPath.row], let courseID = model.id {
            navigationController?.pushViewController(DCourseDetailViewController(courseID: courseID), animated: true)
        }
    }
}
