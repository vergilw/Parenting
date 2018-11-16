//
//  DOrdersViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/16.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DOrdersViewController: BaseViewController {

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
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        tableView.backgroundColor = UIConstants.Color.background
        tableView.rowHeight = 192
        tableView.register(OrderCell.self, forCellReuseIdentifier: OrderCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubviews([categoryView, tableView])
        categoryView.addSubviews([nonpaymentBtn, paymentBtn, categoryIndicatorImgView])
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
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
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
        tableView.reloadData()
    }
}


extension DOrdersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.className(), for: indexPath) as! OrderCell
        cell.setup(mode: orderMode)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(DPurchaseViewController(), animated: true)
    }
}
