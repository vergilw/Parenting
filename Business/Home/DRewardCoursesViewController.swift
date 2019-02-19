//
//  DRewardCoursesViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/25.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DRewardCoursesViewController: BaseViewController {

    fileprivate var courseModels: [CourseModel]?
    
    lazy fileprivate var pageNumber: Int = 1
    
    lazy fileprivate var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy fileprivate var backBarBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "public_backBarItem")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backBarItemAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Medium", size: 20)!
        label.textColor = .white
        label.textAlignment = .center
        label.text = "赏金课程"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "赏金课程"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        tableView.backgroundColor = UIConstants.Color.background
        tableView.rowHeight = 112
        tableView.register(CourseCell.self, forCellReuseIdentifier: CourseCell.className())
        tableView.clipsToBounds = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        tableView.separatorColor = UIConstants.Color.separator
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.fetchMoreData()
        })
        tableView.mj_footer.isHidden = true
        
        view.addSubviews([tableView, navigationView])
        navigationView.addSubviews([backBarBtn, navigationTitleLabel])
        
        initHeaderView()
    }
    
    fileprivate func initHeaderView() {
        let headerView: UIView = {
            var height: CGFloat = 0
            if #available(iOS 11.0, *) {
                height = UIScreenWidth/375*182 + ((UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight) - 20)
            } else {
                height = UIScreenWidth/375*182
            }
            let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: height)))
            view.backgroundColor = UIColor("#f9ce93")
            view.clipsToBounds = false
            return view
        }()
        
        let bgColorImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.backgroundColor = UIColor("#f9ce93")
            return imgView
        }()
        
        let bgImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "course_rewardCoursesBanner")
            imgView.contentMode = .scaleAspectFill
            return imgView
        }()
        
//        let backBarBtn: UIButton = {
//            let button = UIButton()
//            button.setImage(UIImage(named: "public_backBarItem")?.withRenderingMode(.alwaysTemplate), for: .normal)
//            button.tintColor = .white
//            button.addTarget(self, action: #selector(backBarItemAction), for: .touchUpInside)
//            return button
//        }()
//
//        let titleLabel: UILabel = {
//            let label = UILabel()
//            label.font = UIFont(name: "PingFangSC-Medium", size: 20)!
//            label.textColor = .white
//            label.textAlignment = .center
//            label.text = "赏金课程"
//            return label
//        }()
        
        if #available(iOS 11.0, *) {
            
        } else {
            headerView.addSubview(bgColorImgView)
            bgColorImgView.snp.makeConstraints { make in
                make.top.equalTo(-UIStatusBarHeight)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(UIStatusBarHeight)
            }
        }
        
        headerView.addSubviews([bgImgView])
        
        bgImgView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(UIScreenWidth/375*182)
        }
//        titleLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(UIStatusBarHeight)
//            make.height.equalTo((navigationController?.navigationBar.bounds.size.height ?? 0))
//        }
//        backBarBtn.snp.makeConstraints { make in
//            make.leading.equalTo(0)
//            make.top.equalTo(UIStatusBarHeight)
//            make.width.equalTo(62.5)
//            make.height.equalTo((navigationController?.navigationBar.bounds.size.height ?? 0))
//        }
        
        tableView.tableHeaderView = headerView
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        navigationView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo((navigationController?.navigationBar.bounds.size.height ?? 0)+UIStatusBarHeight)
        }
        backBarBtn.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(UIStatusBarHeight)
            make.width.equalTo(62.5)
            make.height.equalTo((navigationController?.navigationBar.bounds.size.height ?? 0))
        }
        navigationTitleLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(backBarBtn.snp.trailing)
            make.centerX.equalToSuperview()
            make.top.equalTo(UIStatusBarHeight)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchData() {
        HUDService.sharedInstance.showFetchingView(target: self.view)
        
        RewardCoinProvider.request(.reward_courses(pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            HUDService.sharedInstance.hideFetchingView(target: self.view)
            
            if code >= 0 {
                if let data = JSON?["data"] as? [[String: Any]] {
                    if let models = [CourseModel].deserialize(from: data) as? [CourseModel] {
                        self.courseModels = models
                    }
                    self.tableView.reloadData()
                    
                    if self.courseModels?.count ?? 0 == 0 {
                        self.navigationController?.setNavigationBarHidden(false, animated: false)
                        HUDService.sharedInstance.showNoDataView(target: self.view)
                    }
                    
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
                
            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: self.view) { [weak self] in
                    self?.fetchData()
                }
            }
        }))
    }
    
    fileprivate func fetchMoreData() {
        
        RewardCoinProvider.request(.reward_courses(pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            self.tableView.mj_footer.endRefreshing()
            
            if code >= 0 {
                if let data = JSON?["data"] as? [[String: Any]] {
                    if let models = [CourseModel].deserialize(from: data) as? [CourseModel] {
                        self.courseModels?.append(contentsOf: models)
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


extension DRewardCoursesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseCell.className(), for: indexPath) as! CourseCell
        if let model = courseModels?[exist: indexPath.row] {
            cell.setup(mode: CourseCell.CellDisplayMode.reward, model: model)
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


extension DRewardCoursesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard navigationView.frame.size != .zero else { return }
        
        let offsetY = scrollView.contentOffset.y
        if offsetY > (tableView.tableHeaderView?.bounds.size.height ?? 0)-navigationView.bounds.size.height {
            navigationView.backgroundColor = UIColor("#f9ce93")
//            navigationTitleLabel.textColor = UIConstants.Color.head
//            backBarBtn.tintColor = UIConstants.Color.head
        } else {
            navigationView.backgroundColor = UIColor.clear
//            navigationTitleLabel.textColor = .white
//            backBarBtn.tintColor = .white
        }
    }
}
