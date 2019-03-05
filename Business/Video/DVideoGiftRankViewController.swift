//
//  DVideoGiftRankViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/3/1.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class DVideoGiftRankViewController: BaseViewController {

    var videoID: Int
    
    fileprivate var rankModels: [GiftRankModel]?
    
    lazy fileprivate var pageNumber: Int = 1
    
    lazy fileprivate var titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        return label
    }()

    
    init(videoID: Int) {
        self.videoID = videoID
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
    }

    override func viewWillLayoutSubviews() {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 4, height: 4))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        
        tableView.rowHeight = 68
        tableView.separatorStyle = .none
        tableView.register(VideoGiftRankCell.self, forCellReuseIdentifier: VideoGiftRankCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.fetchMoreData()
        })
        tableView.mj_footer.isHidden = true
        
        view.addSubviews([titleView, tableView])
        
        initTitleView()
    }
    
    fileprivate func initTitleView() {
        titleView.drawSeparator(startPoint: CGPoint(x: 0, y: 59.5), endPoint: CGPoint(x: UIScreenWidth, y: 59.5))
        
        let dismissBtn: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "public_dismissBtn")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = UIConstants.Color.head
            button.addTarget(self, action: #selector(dimissBarItemAction), for: .touchUpInside)
            return button
        }()
        
        titleView.addSubviews([titleLabel, dismissBtn])
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        dismissBtn.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(75)
        }
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        titleView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(60)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom)
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchData() {
        HUDService.sharedInstance.showFetchingView(target: self.view)
        
        VideoProvider.request(.video_gifts_rank(videoID, 1), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            HUDService.sharedInstance.hideFetchingView(target: self.view)
            
            if code >= 0 {
                if let data = JSON?["praise_users"] as? [[String: Any]] {
                    if let models = [GiftRankModel].deserialize(from: data) as? [GiftRankModel] {
                        self.rankModels = models
                    }
                    self.tableView.reloadData()
                    
                    if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                        
                        if let totalCount = pagination["total_count"] as? Int {
                            self.titleLabel.text = "\(totalCount)人打赏"
                        }
                        
                        if totalPages > self.pageNumber {
                            self.pageNumber = 2
                            self.tableView.mj_footer.isHidden = false
                            self.tableView.mj_footer.resetNoMoreData()
                            
                        } else {
                            self.tableView.mj_footer.isHidden = true
                        }
                    }
                    
                    if self.rankModels?.count ?? 0 == 0 {
                        HUDService.sharedInstance.showNoDataView(target: self.tableView)
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
        
        VideoProvider.request(.video_comments(videoID, pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            self.tableView.mj_footer.endRefreshing()
            
            if code >= 0 {
                if let data = JSON?["praise_users"] as? [[String: Any]] {
                    if let models = [GiftRankModel].deserialize(from: data) as? [GiftRankModel] {
                        self.rankModels?.append(contentsOf: models)
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
    
    // MARK: - ============= Public =============
    
    // MARK: - ============= Private =============
}


extension DVideoGiftRankViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoGiftRankCell.className(), for: indexPath) as! VideoGiftRankCell
        if let model = rankModels?[exist: indexPath.row] {
            cell.setup(model: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let model = rankModels?[exist: indexPath.row], let string = model.user?.id else { return }
        
    }
}
