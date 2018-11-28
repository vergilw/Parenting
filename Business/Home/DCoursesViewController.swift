//
//  DCoursesViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/22.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DCoursesViewController: BaseViewController {

    lazy fileprivate var viewModel = DCourseViewModel()
    
    lazy fileprivate var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        view.backgroundColor = .white
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 9)
//        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy fileprivate var categoryIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIConstants.Color.primaryGreen
        return imgView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "课程列表"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.backgroundColor = UIConstants.Color.background
        
        tableView.backgroundColor = UIConstants.Color.background
        tableView.rowHeight = CourseCell.cellHeight()
        tableView.contentInset = UIEdgeInsets(top: UIConstants.Margin.leading-10, left: 0, bottom: UIConstants.Margin.leading-10, right: 0)
        tableView.register(CourseCell.self, forCellReuseIdentifier: CourseCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.viewModel.fetchCourses(completion: { (code, next) in
                if code < 0 || next {
                    self?.tableView.mj_footer.endRefreshing()
                } else {
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                self?.tableView.reloadData()
            })
        })
        tableView.mj_footer.isHidden = true
//        let footer = tableView.mj_footer as! MJRefreshAutoStateFooter
//        footer.setTitle("没有更多", for: .noMoreData)
        
        view.addSubviews([scrollView, tableView])
        scrollView.addSubview(categoryIndicatorImgView)
    }
    
    fileprivate func initCategoryView() {
        
        var width: CGFloat = 0
        var i = -1
        var model: CourseCategoryModel?
        
        repeat {
//            guard let model = viewModel.categoryModels?[i] else { break }
            
            let button: UIButton = {
                let button = UIButton()
                button.setTitleColor(UIConstants.Color.body, for: .normal)
                button.titleLabel?.font = UIConstants.Font.body
                if let string = model?.name {
                    button.setTitle(string, for: .normal)
                } else {
                    button.setTitle("全部", for: .normal)
                    button.setTitleColor(UIConstants.Color.head, for: .normal)
                    button.titleLabel?.font = UIConstants.Font.h2
                }
                button.addTarget(self, action: #selector(categoryBtnAction(sender:)), for: .touchUpInside)
                button.tag = i+1
                return button
            }()
            
            scrollView.addSubview(button)
            
            let size = NSString(string: button.titleLabel?.text ?? "").size(for: button.titleLabel!.font, size: CGSize(width: UIScreenWidth, height: 36), mode: NSLineBreakMode.byTruncatingTail)
            button.snp.makeConstraints { make in
                make.leading.equalTo(width)
                if i == (viewModel.categoryModels?.count)! - 1 {
                    make.trailing.equalToSuperview()
                }
                make.width.equalTo(size.width+32)
                make.height.equalTo(46)
                make.top.bottom.equalToSuperview()
            }
            width += size.width+32
            i += 1
            if viewModel.categoryModels?.count ?? 0 > i {
                model = viewModel.categoryModels?[i]
            } else {
                break
            }
            
        } while (model != nil)
        
        let size = NSString(string: "全部").size(for: UIConstants.Font.body, size: CGSize(width: UIScreenWidth, height: 36), mode: NSLineBreakMode.byTruncatingTail)
        categoryIndicatorImgView.snp.remakeConstraints { make in
            make.centerX.equalTo((size.width+32)/2)
            make.height.equalTo(1.5)
            make.width.equalTo(29)
            make.bottom.equalTo(scrollView)
        }
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
//        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        scrollView.heightAnchor.constraint(equalToConstant: 46).isActive = true
//
//        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        tableView.topAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(46)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(scrollView.snp.bottom)
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchData() {
        HUDService.sharedInstance.showFetchingView(target: self.tableView, frame: CGRect(origin: CGPoint(x: 0, y: -tableView.contentInset.top), size: CGSize(width: UIScreenWidth, height: UIScreenHeight-(navigationController?.navigationBar.bounds.size.height ?? 0)-46)))
        viewModel.fetchCategory { (code) in

            if code >= 0 {
                self.initCategoryView()
                self.fetchCourses()

            } else if code == -2 {
                HUDService.sharedInstance.hideFetchingView(target: self.tableView)

                HUDService.sharedInstance.showNoNetworkView(target: self.tableView) { [weak self] in
                    self?.fetchData()
                }
            } else {
                HUDService.sharedInstance.hideFetchingView(target: self.tableView)
            }
        }
    }
    
    fileprivate func fetchCourses() {
        HUDService.sharedInstance.showFetchingView(target: self.tableView)
        self.viewModel.fetchCourses { (code, next) in
            HUDService.sharedInstance.hideFetchingView(target: self.tableView)
            if code >= 0 {
                self.tableView.reloadData()
            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: self.tableView) { [weak self] in
                    self?.fetchCourses()
                }
            }
        }
    }
    
    fileprivate func refetchCourses(categoryID: Int?) {
        HUDService.sharedInstance.showFetchingView(target: self.tableView)
        viewModel.refetchCourses(categoryID: categoryID) { (code, next) in
            HUDService.sharedInstance.hideFetchingView(target: self.tableView)
            if code >= 0 {
                self.tableView.reloadData()
                if next {
                    self.tableView.mj_footer.isHidden = false
                    self.tableView.mj_footer.resetNoMoreData()
                } else {
                    self.tableView.mj_footer.isHidden = true
                }
            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: self.tableView) { [weak self] in
                    self?.refetchCourses(categoryID: categoryID)
                }
            }
        }
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
    }
    
    @objc func recoverCategoryStyle() {
        for button in scrollView.subviews {
            guard let button = button as? UIButton else { continue }
            
            button.titleLabel?.font = UIConstants.Font.body
            button.setTitleColor(UIConstants.Color.body, for: .normal)
        }
        
    }
    
    // MARK: - ============= Action =============
    @objc func categoryBtnAction(sender: UIButton) {
        categoryIndicatorImgView.snp.remakeConstraints { make in
            make.centerX.equalTo(sender)
            make.width.equalTo(29)
            make.height.equalTo(1.5)
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.35, animations: {
            self.scrollView.layoutIfNeeded()
        })
        
        recoverCategoryStyle()
        
        sender.setTitleColor(UIConstants.Color.head, for: .normal)
        sender.titleLabel?.font = UIConstants.Font.h2
        
        if let model = viewModel.categoryModels?[exist: sender.tag-1], let categoryID = model.id {
            refetchCourses(categoryID: categoryID)
        } else if sender.tag == 0 {
            refetchCourses(categoryID: nil)
        }
    }
}


extension DCoursesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.courseModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseCell.className(), for: indexPath) as! CourseCell
        if let model = viewModel.courseModels?[indexPath.row] {
            cell.setup(mode: CourseCell.CellDisplayMode.default, model: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let model = viewModel.courseModels?[indexPath.row], let courseID = model.id {
            navigationController?.pushViewController(DCourseDetailViewController(courseID: courseID), animated: true)
        }
    }
}

