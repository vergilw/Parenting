//
//  DMeMessagesViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/2/27.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import Moya

class DMeMessagesViewController: BaseViewController {

    enum MsgMode {
        case normal
        case organ
    }
    
    fileprivate var mode: MsgMode
    
    fileprivate lazy var pageNumber: Int = 1
    
    fileprivate var messageModels: [MessageModel]?
    
    fileprivate var unreadCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "消息中心"

        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
    }
    
    init(mode: MsgMode) {
        self.mode = mode
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        
        tableView.rowHeight = 88
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading+62, bottom: 0, right: UIConstants.Margin.trailing)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIConstants.Color.separator
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.fetchMoreData()
        })
        tableView.mj_footer.isHidden = true
        
        view.addSubview(tableView)
    }
    
    fileprivate func initNavigationItem() {
        let asReadBtn: ActionButton = {
            let button = ActionButton()
            button.setIndicatorColor(UIConstants.Color.primaryGreen)
            button.frame = CGRect(origin: .zero, size: CGSize(width: 60+UIConstants.Margin.trailing*2, height: navigationController?.navigationBar.bounds.height ?? 44))
            button.setTitleColor(UIConstants.Color.head, for: .normal)
            button.titleLabel?.font = UIConstants.Font.h3
            button.setTitle("全部已读", for: .normal)
            button.addTarget(self, action: #selector(asReadBtnAction(sender:)), for: .touchUpInside)
            return button
        }()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: asReadBtn)
        navigationItem.rightBarButtonItem?.width = 60+UIConstants.Margin.trailing*2
        navigationItem.rightMargin = 0
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
    fileprivate func fetchData() {
        HUDService.sharedInstance.showFetchingView(target: self.view)
        
        let closure:(Int, ([String: Any])?)->() = { (code, JSON) in
            
            HUDService.sharedInstance.hideFetchingView(target: self.view)
            
            if code >= 0 {
                if let data = JSON?["notifications"] as? [[String: Any]] {
                    if let models = [MessageModel].deserialize(from: data) as? [MessageModel] {
                        self.messageModels = models
                    }
                    self.tableView.reloadData()
                }
                
                if let data = JSON?["unread_count"] as? [String: Any] {
                    if let number = data["total"] as? NSNumber {
                        self.unreadCount = number.intValue
                        if self.unreadCount > 0 {
                            self.initNavigationItem()
                        }
                    }
                }
                
                if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                    if totalPages > self.pageNumber {
                        self.pageNumber = 2
                        self.tableView.mj_footer.isHidden = false
                        self.tableView.mj_footer.resetNoMoreData()
                        
                    } else {
                        self.tableView.mj_footer.isHidden = true
                    }
                }
                
                if self.messageModels?.count ?? 0 == 0 {
                    HUDService.sharedInstance.showNoDataView(target: self.view) { [weak self] in
                        self?.navigationController?.pushViewController(DCoursesViewController(), animated: true)
                    }
                }
                
            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: self.view, retry: {
                    self.fetchData()
                })
            }
        }
        
        if mode == .normal {
            MessageProvider.request(.messages(1), completion: ResponseService.sharedInstance.response(completion: closure))
        } else if mode == .organ {
            CRMProvider.request(.messages(1), completion: ResponseService.sharedInstance.response(completion: closure))
        }
        
    }
    
    fileprivate func fetchMoreData() {
        let closure:(Int, ([String: Any])?)->() = { (code, JSON) in
            
            self.tableView.mj_footer.endRefreshing()
            
            if code >= 0 {
                if let data = JSON?["notifications"] as? [[String: Any]] {
                    if let models = [MessageModel].deserialize(from: data) as? [MessageModel] {
                        self.messageModels?.append(contentsOf: models)
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
        }
        
        if mode == .normal {
            MessageProvider.request(.messages(pageNumber), completion: ResponseService.sharedInstance.response(completion: closure))
        } else if mode == .organ {
            CRMProvider.request(.messages(pageNumber), completion: ResponseService.sharedInstance.response(completion: closure))
        }
    }
    
    fileprivate func asReadRequest(messageID: Int) {
        
        MessageProvider.request(.message(messageID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if code >= 0 {
                
                if let data = JSON?["unread_count"] as? [String: Any] {
                    if let number = data["total"] as? NSNumber {
                        self.unreadCount = number.intValue
                        if self.unreadCount > 0 {
                            self.initNavigationItem()
                        } else {
                            self.navigationItem.rightBarButtonItem = nil
                        }
                    }
                }
                
                NotificationCenter.default.post(name: Notification.Message.messageUnreadCountDidChange, object: nil)
            }
        }))
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============
    @objc fileprivate func asReadBtnAction(sender: ActionButton) {
        sender.startAnimating()
        
        MessageProvider.request(.messages_asReadAll, completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
        
            sender.stopAnimating()
            
            if code >= 0 {
                for model in self.messageModels ?? [] {
                    model.read_at = Date()
                }
                self.tableView.reloadData()
                
                HUDService.sharedInstance.show(string: "全部已读成功")
                
                self.navigationItem.rightBarButtonItem = nil
                
                NotificationCenter.default.post(name: Notification.Message.messageUnreadCountDidChange, object: nil)
            }
        }))
    }
    
    // MARK: - ============= Public =============
    
    // MARK: - ============= Private =============

}


extension DMeMessagesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.className(), for: indexPath) as! MessageCell
        if let model = messageModels?[exist: indexPath.row] {
            cell.setup(model: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let model = messageModels?[exist: indexPath.row], let messageID = model.id {
            
            asReadRequest(messageID: messageID)
            
            if let string = model.link, let url = URL(string: string) {
                guard let viewController = RouteService.shared.route(URI: url) else { return }
                navigationController?.pushViewController(viewController, animated: true)
                
                model.read_at = Date()
                tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            }
        }
    }
}
