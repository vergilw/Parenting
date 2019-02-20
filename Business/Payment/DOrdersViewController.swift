//
//  DOrdersViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/16.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DOrdersViewController: BaseViewController {

    fileprivate var orderModels: [OrderModel]?
    
    lazy fileprivate var pageNumber: Int = 1
    
    enum DOrdersMode {
        case nonpayment
        case payment
    }
    
    lazy fileprivate var orderMode: DOrdersMode = .nonpayment
    
    lazy fileprivate var categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy fileprivate var nonpaymentBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.head, for: .normal)
        button.titleLabel?.font = UIConstants.Font.h2
        button.setTitle("未支付", for: .normal)
        button.addTarget(self, action: #selector(categoryBtnAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var paymentBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.body, for: .normal)
        button.titleLabel?.font = UIConstants.Font.body
        button.setTitle("已购买", for: .normal)
        button.addTarget(self, action: #selector(categoryBtnAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var categoryIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIConstants.Color.primaryGreen
        return imgView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "我的订单"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 112+30+10
        tableView.register(OrderCell.self, forCellReuseIdentifier: OrderCell.className())
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        tableView.separatorColor = UIConstants.Color.separator
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.fetchMoreData()
        })
        tableView.mj_footer.isHidden = true
        
        view.addSubviews([categoryView, tableView])
        categoryView.addSubviews([nonpaymentBtn, paymentBtn, categoryIndicatorImgView])
        categoryView.drawSeparator(startPoint: CGPoint(x: 0, y: 46), endPoint: CGPoint(x: UIScreenWidth, y: 46))
        
        initHeaderView()
    }
    
    func initHeaderView() {
        guard orderMode == .nonpayment else {
            tableView.tableHeaderView = nil
            return
        }
        
        let headerView: UIView = {
            let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: 27)))
            view.backgroundColor = UIConstants.Color.background
            return view
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.foot
            label.textColor = UIConstants.Color.foot
            
            let text = "未支付订单将在2小时后自动取消"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIConstants.Color.primaryOrange], range: NSString(string: text).range(of: "2"))
            label.attributedText = attributedString
            
            return label
        }()
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.bottom.equalToSuperview()
        }
        
        tableView.tableHeaderView = headerView
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        categoryView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(46)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(categoryView.snp.bottom)
        }
        nonpaymentBtn.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        paymentBtn.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(nonpaymentBtn.snp.trailing)
            make.width.equalTo(nonpaymentBtn)
        }
        categoryIndicatorImgView.snp.makeConstraints { make in
            make.centerX.equalTo(nonpaymentBtn)
            make.height.equalTo(1.5)
            make.width.equalTo(29)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: Notification.Payment.payCourseDidSuccess, object: nil)
    }
    
    // MARK: - ============= Request =============
    @objc fileprivate func fetchData() {
        var orderStatus = "unpaid"
        if orderMode == .payment {
            orderStatus = "paid"
        }
        pageNumber = 1
        
        var HUDHeight: CGFloat = 0
        if #available(iOS 11, *) {
            HUDHeight = UIScreenHeight-(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight)-(navigationController?.navigationBar.bounds.size.height ?? 0)-46
        } else {
            HUDHeight = UIScreenHeight-UIStatusBarHeight-(navigationController?.navigationBar.bounds.size.height ?? 0)-46
        }
        HUDService.sharedInstance.showFetchingView(target: tableView, frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: HUDHeight)))
        HUDService.sharedInstance.hideResultView(target: tableView)
        
        PaymentProvider.request(.orders(orderStatus, pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            HUDService.sharedInstance.hideFetchingView(target: self.tableView)
            if code >= 0 {
                if let data = JSON?["orders"] as? [[String: Any]] {
                    self.orderModels = [OrderModel].deserialize(from: data) as? [OrderModel]
                    self.reload()
                    
                    if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                        if totalPages > self.pageNumber {
                            self.pageNumber += 1
                            self.tableView.mj_footer.isHidden = false
                            self.tableView.mj_footer.resetNoMoreData()
                            
                        } else {
                            self.tableView.mj_footer.isHidden = true
                        }
                    }
                    
                    if self.orderModels?.count ?? 0 == 0 {
                        HUDService.sharedInstance.showNoDataView(target: self.tableView, frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: HUDHeight))) { [weak self] in
                            self?.navigationController?.pushViewController(DCoursesViewController(), animated: true)
                        }
                    }
                }
                
            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: self.tableView, frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: HUDHeight))) { [weak self] in
                    self?.fetchData()
                }
            }
        }))
    }
    
    fileprivate func fetchMoreData() {
        var orderStatus = "unpaid"
        if orderMode == .payment {
            orderStatus = "paid"
        }
        
        HUDService.sharedInstance.showFetchingView(target: tableView)
        
        PaymentProvider.request(.orders(orderStatus, pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            HUDService.sharedInstance.hideFetchingView(target: self.view)
            if code >= 0 {
                if let data = JSON?["orders"] as? [[String: Any]] {
                    if let models = [OrderModel].deserialize(from: data) as? [OrderModel] {
                        self.orderModels?.append(contentsOf: models)
                        self.tableView.reloadData()
                    }
                    
                    if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                        if totalPages > self.pageNumber {
                            self.pageNumber += 1
                            self.tableView.mj_footer.isHidden = false
                            
                        } else {
                            self.tableView.mj_footer.isHidden = true
                            self.tableView.mj_footer.endRefreshingWithNoMoreData()
                        }
                    }
                }
                
            }
        }))
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        initHeaderView()
        tableView.reloadData()
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
            self.categoryView.layoutIfNeeded()
        })
        
        nonpaymentBtn.titleLabel?.font = UIConstants.Font.body
        paymentBtn.titleLabel?.font = UIConstants.Font.body
        nonpaymentBtn.setTitleColor(UIConstants.Color.body, for: .normal)
        paymentBtn.setTitleColor(UIConstants.Color.body, for: .normal)
        
        sender.setTitleColor(UIConstants.Color.head, for: .normal)
        sender.titleLabel?.font = UIConstants.Font.h2
        
        if sender == nonpaymentBtn {
            orderMode = .nonpayment
        } else if sender == paymentBtn {
            orderMode = .payment
        }
        
        fetchData()
    }
}


extension DOrdersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.className(), for: indexPath) as! OrderCell
        if let model = orderModels?[exist: indexPath.row] {
            cell.setup(mode: orderMode, model: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let model = orderModels?[exist: indexPath.row], let orderID = model.id, let courseID = model.order_items?[exist: 0]?.course?.id {
            if orderMode == .nonpayment {
                
                let viewController = DPurchaseViewController(orderID: orderID)
                viewController.completeClosure = {
                    guard var viewControllers = self.navigationController?.viewControllers, let index = viewControllers.firstIndex(where: { (viewController) -> Bool in
                        return viewController.isKind(of: DPurchaseViewController.self)
                    }) else {
                        return
                    }
                    
                    viewControllers.remove(at: index)
                    
                    let pushViewController = DCourseDetailViewController(courseID: courseID)
                    viewControllers.append(pushViewController)
                    self.navigationController?.setViewControllers(viewControllers, animated: true)
                }
                navigationController?.pushViewController(viewController, animated: true)
                
            } else if orderMode == .payment {
                navigationController?.pushViewController(DCourseDetailViewController(courseID: courseID), animated: true)
            }
            
        }
        
    }
}
