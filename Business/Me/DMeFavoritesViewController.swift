//
//  DMeFavoritesViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/15.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DMeFavoritesViewController: BaseViewController {

    
    fileprivate var favoritesModels: [CourseModel]?
    
    lazy fileprivate var pageNumber: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "我的收藏夹"
        
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
    fileprivate func fetchData() {
        HUDService.sharedInstance.showFetchingView(target: self.view)
        
        CourseProvider.request(.course_favorites(pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            HUDService.sharedInstance.hideFetchingView(target: self.view)
            if code >= 0 {
                if let data = JSON?["data"] as? [[String: Any]] {
                    self.favoritesModels = [CourseModel].deserialize(from: data) as? [CourseModel]
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


extension DMeFavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseCell.className(), for: indexPath) as! CourseCell
        if let model = favoritesModels?[exist: indexPath.row], let courseID = model.id {
            cell.setup(mode: CourseCell.CellDisplayMode.favirotes, model: model)
            cell.actionBlock = { [weak self] button in
                button.startAnimating()
                
                CourseProvider.request(.course_toggle_favorites(courseID: courseID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
                    
                    if let isFavorite = JSON?["is_favorite"] as? Bool {
                        button.stopAnimating()
                        
                        model.is_favorite = isFavorite
                        
                        if model.is_favorite == true {
                            button.setImage(UIImage(named: "course_favoriteSelected"), for: .normal)
                        } else {
                            button.setImage(UIImage(named: "course_favoriteNormal"), for: .normal)
                        }
                        
                        button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
                            button.transform = CGAffineTransform.identity
                        }, completion: nil)
                    }
                }))
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(DCourseDetailViewController(courseID: 2), animated: true)
    }
}
