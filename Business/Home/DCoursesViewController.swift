//
//  DCoursesViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/22.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DCoursesViewController: BaseViewController {

    lazy fileprivate var viewModel = DCoursesViewModel()
    
    lazy fileprivate var buttons = [UIButton]()
    lazy fileprivate var tableViews = [UITableView]()
    lazy fileprivate var selectedIndex = 0
    
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
    
    lazy fileprivate var tableViewScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.delegate = self
        if let gesture = navigationController?.view.gestureRecognizers?.first(where: { (gesture) -> Bool in
            return gesture.isKind(of: UIScreenEdgePanGestureRecognizer.self)
            
        }) {
            scrollView.panGestureRecognizer.require(toFail: gesture)
        }
        return scrollView
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
        
        /*
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
        */
        
        view.addSubviews([scrollView, tableViewScrollView])
        scrollView.addSubview(categoryIndicatorImgView)
        
    }
    
    fileprivate func initCategoryView() {
        
        var width: CGFloat = 0
        var i = -1
        var model: CourseCategoryModel?
        
        viewModel.coursesModels = [[CourseModel]]()
        
        repeat {
            //setup category view
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
            
            buttons.append(button)
            
            width += size.width+32
            
            //setup tableview
            let tableView: UITableView = {
                let tableView = UITableView(frame: .zero, style: .plain)
                tableView.backgroundColor = UIConstants.Color.background
                tableView.rowHeight = CourseCell.cellHeight()
                tableView.contentInset = UIEdgeInsets(top: UIConstants.Margin.leading-10, left: 0, bottom: UIConstants.Margin.leading-10, right: 0)
                tableView.register(CourseCell.self, forCellReuseIdentifier: CourseCell.className())
                tableView.dataSource = self
                tableView.delegate = self
                tableView.separatorStyle = .none
                tableView.tableFooterView = UIView()
                tableView.tag = i+1
                if #available(iOS 11, *) {
                    tableView.contentInsetAdjustmentBehavior = .never
                    tableView.estimatedRowHeight = 0
                    tableView.estimatedSectionHeaderHeight = 0
                    tableView.estimatedSectionFooterHeight = 0
                }
                
                tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self, weak tableView] in
                    guard let tableView = tableView else { return }
                    
                    self?.viewModel.fetchCourses(completion: { (code, next, models) in
                        if code < 0 || next {
                            tableView.mj_footer.endRefreshing()
                        } else {
                            tableView.mj_footer.endRefreshingWithNoMoreData()
                        }
                        
                        if let models = models, let index = self?.tableViews.firstIndex(of: tableView), let _ = self?.viewModel.coursesModels?[exist: index] {
                            self?.viewModel.coursesModels?[index].append(contentsOf: models)
                            tableView.reloadData()
                        }
                    })
                })
                tableView.mj_footer.isHidden = true
                
                return tableView
            }()
            
            tableViewScrollView.addSubview(tableView)
            tableViewScrollView.sendSubviewToBack(tableView)
            tableView.snp.makeConstraints { make in
                make.leading.equalTo(CGFloat(tableViews.count)*UIScreenWidth)
                if i == (viewModel.categoryModels?.count)! - 1 {
                    make.trailing.equalToSuperview()
                }
                make.width.equalTo(UIScreenWidth)
                make.top.bottom.equalToSuperview()
                if #available(iOS 11.0, *) {
                    make.height.equalTo(UIScreenHeight-(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight)-(navigationController?.navigationBar.bounds.size.height ?? 0)-46)
                } else {
                    make.height.equalTo(UIScreenHeight-UIStatusBarHeight-(navigationController?.navigationBar.bounds.size.height ?? 0)-46)
                }
            }
            tableViews.append(tableView)
            
            //setup models
            viewModel.coursesModels?.append([CourseModel]())
            
            i += 1
            if viewModel.categoryModels?.count ?? 0 > i {
                model = viewModel.categoryModels?[i]
            } else {
                break
            }
            
        } while (model != nil)
        
        let size = NSString(string: "全部").size(for: UIConstants.Font.h2, size: CGSize(width: UIScreenWidth, height: 36), mode: NSLineBreakMode.byTruncatingTail)
        categoryIndicatorImgView.snp.remakeConstraints { make in
            make.centerX.equalTo((size.width+32)/2)
            make.height.equalTo(1.5)
            make.width.equalTo(29)
            make.bottom.equalTo(scrollView)
        }
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        scrollView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(46)
        }
        tableViewScrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(scrollView.snp.bottom)
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchData() {
        let offsetY: CGFloat = (UIConstants.Margin.leading-10)
        var tableViewHeight: CGFloat = 0
        if #available(iOS 11.0, *) {
            tableViewHeight = (UIScreenHeight-(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight)-(navigationController?.navigationBar.bounds.size.height ?? 0)-46)
        } else {
            tableViewHeight = (UIScreenHeight-UIStatusBarHeight-(navigationController?.navigationBar.bounds.size.height ?? 0)-46)
        }
        
        HUDService.sharedInstance.showFetchingView(target: tableViewScrollView, frame: CGRect(origin: CGPoint(x: 0, y: -offsetY), size: CGSize(width: UIScreenWidth, height: tableViewHeight)))
        viewModel.fetchCategory { (code) in

            if code >= 0 {
                self.initCategoryView()
                if let view = self.tableViews.first {
                    self.fetchCourses(view: view)
                } else {
                    HUDService.sharedInstance.hideFetchingView(target: self.tableViewScrollView)
                }

            } else if code == -2 {
                HUDService.sharedInstance.hideFetchingView(target: self.tableViewScrollView)

                HUDService.sharedInstance.showNoNetworkView(target: self.tableViewScrollView) { [weak self] in
                    self?.fetchData()
                }
            } else {
                HUDService.sharedInstance.hideFetchingView(target: self.tableViewScrollView)
            }
        }
    }
    
    fileprivate func fetchCourses(view: UITableView) {
        if !tableViewScrollView.subviews.contains(where: { (view) -> Bool in
            return view.isKind(of: FetchView.self)
        }) {
            HUDService.sharedInstance.showFetchingView(target: view)
        }
        
        self.viewModel.fetchCourses { (code, next, models) in
            
            if self.tableViewScrollView.subviews.contains(where: { (view) -> Bool in
                return view.isKind(of: FetchView.self)
            }) {
                HUDService.sharedInstance.hideFetchingView(target: self.tableViewScrollView)
            } else {
                HUDService.sharedInstance.hideFetchingView(target: view)
            }
            
            if code >= 0 {
                
                if let index = self.tableViews.firstIndex(of: view) {
                    if let _ = self.viewModel.coursesModels?[exist: index], let models = models {
                        self.viewModel.coursesModels?[index].append(contentsOf: models)
                    }
                }
                
                if next {
                    view.mj_footer.isHidden = false
                    view.mj_footer.resetNoMoreData()
                } else {
                    view.mj_footer.isHidden = true
                }
                
                view.reloadData()
                
            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: view) { [weak self] in
                    self?.fetchCourses(view: view)
                }
            }
        }
    }
    
    fileprivate func refetchCourses(index: Int) {
        guard let view = tableViews[exist: index] else { return }
        
        guard let modelsArray = viewModel.coursesModels?[exist: index], modelsArray.count == 0 else { return }
        
        var categoryID: Int? = nil
        if let model = viewModel.categoryModels?[exist: index-1] {
            categoryID = model.id
        }
        HUDService.sharedInstance.showFetchingView(target: view)
        viewModel.refetchCourses(categoryID: categoryID) { (code, next, models) in
            HUDService.sharedInstance.hideFetchingView(target: view)
            if code >= 0 {
                if let models = models {
                    self.viewModel.coursesModels?[index].append(contentsOf: models)
                }
                
                view.reloadData()
                if next {
                    view.mj_footer.isHidden = false
                    view.mj_footer.resetNoMoreData()
                } else {
                    view.mj_footer.isHidden = true
                }
            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: view) { [weak self] in
                    self?.refetchCourses(index: index)
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
        
        refetchCourses(index: sender.tag)
        tableViewScrollView.setContentOffset(CGPoint(x: UIScreenWidth*CGFloat(sender.tag), y: 0), animated: true)
        
        selectedIndex = sender.tag
        
        if let previous = buttons[exist: selectedIndex-1]  {
            let frame = view.convert(previous.frame, from: previous.superview)
            if frame.origin.x < 0 {
                scrollView.scrollRectToVisible(previous.frame, animated: true)
            }
            
        }
        if let next = buttons[exist: selectedIndex+1], next.frame.origin.x+next.frame.size.width > UIScreenWidth {
            let frame = view.convert(next.frame, from: next.superview)
            if frame.origin.x+frame.size.width > UIScreenWidth {
                scrollView.scrollRectToVisible(next.frame, animated: true)
            }
        }
        
    }
}


extension DCoursesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let index = tableViews.firstIndex(of: tableView) {
            return viewModel.coursesModels?[exist: index]?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseCell.className(), for: indexPath) as! CourseCell
        if let index = tableViews.firstIndex(of: tableView) {
            if let models = viewModel.coursesModels?[exist: index], let model = models[exist: indexPath.row] {
                cell.setup(mode: CourseCell.CellDisplayMode.default, model: model)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let index = tableViews.firstIndex(of: tableView) {
            if let models = viewModel.coursesModels?[exist: index], let model = models[exist: indexPath.row], let courseID = model.id {
                navigationController?.pushViewController(DCourseDetailViewController(courseID: courseID), animated: true)
            }
        }
    }
}


extension DCoursesViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard scrollView == tableViewScrollView else { return }
        
        let index = Int(targetContentOffset.pointee.x/UIScreenWidth)
        if index != selectedIndex {
            guard let sender = buttons[exist: index] else { return }
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
            
            refetchCourses(index: index)
            
            selectedIndex = index
            
            self.scrollView.scrollRectToVisible(sender.frame, animated: true)
        }
    }
}
