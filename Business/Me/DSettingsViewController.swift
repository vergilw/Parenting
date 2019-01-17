//
//  DSettingsViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/22.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class DSettingsViewController: BaseViewController {

    var cacheSizeString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "设置"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        reload()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        tableView.rowHeight = 75
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIConstants.Color.separator
        tableView.register(MeItemCell.self, forCellReuseIdentifier: MeItemCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        initFooterView()
    }
    
    func initFooterView() {
        guard AuthorizationService.sharedInstance.isSignIn() else {
            tableView.tableFooterView = UIView()
            return
        }
        
        let footerView: UIView = {
            let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: 72)))
            view.backgroundColor = .white
            view.drawSeparator(startPoint: CGPoint(x: UIConstants.Margin.leading, y: 0), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.trailing, y: 0))
            return view
        }()
        
        let actionBtn: UIButton = {
            let button = UIButton()
            button.setTitleColor(UIConstants.Color.primaryRed, for: .normal)
            button.titleLabel?.font = UIConstants.Font.h2
            button.setTitle("退出", for: .normal)
            button.addTarget(self, action: #selector(signOutBtnAction), for: .touchUpInside)
            return button
        }()
        
        footerView.addSubview(actionBtn)
        
        actionBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 30))
        }
        
        tableView.tableFooterView = footerView
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Authorization.signOutDidSuccess, object: nil)
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        initFooterView()
        ImageCache.default.calculateDiskCacheSize { (size) in
            let formatter = ByteCountFormatter()
            formatter.countStyle = .binary
            formatter.allowsNonnumericFormatting = false
            formatter.allowedUnits = [.useMB, .useGB]
            self.cacheSizeString = formatter.string(fromByteCount: Int64(size))
            
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - ============= Action =============
    @objc func signOutBtnAction() {
        let alertController = UIAlertController(title: nil, message: "确定退出登录吗？", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
            AuthorizationService.sharedInstance.signOut()
            HUDService.sharedInstance.show(string: "退出成功")
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}


extension DSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MeItemCell.className(), for: indexPath) as! MeItemCell
        if indexPath.row == 0 {
            cell.setup(title: "关于氧育")
        } else if indexPath.row == 1 {
            cell.setup(title: "清除缓存", value: cacheSizeString ?? "")
        } else if indexPath.row == 2 {
            cell.setup(title: "意见反馈")
        } else if indexPath.row == 3 {
            cell.setup(title: "隐私")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            navigationController?.pushViewController(DAboutViewController(), animated: true)
            
        } else if indexPath.row == 1 {
            let alertController = UIAlertController(title: nil, message: "清理后部分图片数据需要重新下载，确定删除吗？", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
                ImageCache.default.clearDiskCache(completion: {
                    HUDService.sharedInstance.show(string: "清理完成")
                    self.reload()
                })
            }))
            self.present(alertController, animated: true, completion: nil)
            
        } else if indexPath.row == 2 {
            guard AuthorizationService.sharedInstance.isSignIn() else {
                let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
                present(authorizationNavigationController, animated: true, completion: nil)
                return
            }
            navigationController?.pushViewController(DFeedbackViewController(), animated: true)
            
        } else if indexPath.row == 3 {
            let viewController = WebViewController()
            viewController.navigationItem.title = "隐私"
            #if DEBUG
            viewController.url = URL(string: "http://m.1314-edu.com/help/privacy.html")
            #else
            viewController.url = URL(string: "https://yy.1314-edu.com/help/privacy.html")
            #endif
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
