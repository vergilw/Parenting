//
//  DPaymentViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/21.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DPaymentViewController: BaseViewController {

    var coinLogModels: [CoinLogModel]?
    
    lazy fileprivate var pageNumber: Int = 1
    
    lazy fileprivate var contentView: CategoryView = {
        var contentHeight: CGFloat = 0
        if #available(iOS 11, *) {
            let safeTop: CGFloat = (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight)
            let navigationHeight: CGFloat = (navigationController?.navigationBar.bounds.size.height ?? 0)
            contentHeight = UIScreenHeight-safeTop-navigationHeight-46
        } else {
            let safeTop: CGFloat = UIStatusBarHeight
            let navigationHeight: CGFloat = (navigationController?.navigationBar.bounds.size.height ?? 0)
            contentHeight = UIScreenHeight-safeTop-navigationHeight-46
        }
        let view = CategoryView(distribution: UIStackView.Distribution.fillEqually, titles: ["氧育币", "金币"], childViews: [coinView, rewardView], contentHeight: contentHeight)
        view.delegate = self
        return view
    }()
    
    lazy fileprivate var coinView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy fileprivate var rewardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        return view
    }()
    
    lazy fileprivate var rewardTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.rowHeight = 118
        tableView.register(RewardDetailsCell.self, forCellReuseIdentifier: RewardDetailsCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.estimatedRowHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
        }
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self, weak tableView] in
            self?.fetchMoreData()
        })
        tableView.mj_footer.isHidden = true
        
        return tableView
    }()
    
    lazy fileprivate var coinBalanceLabel: PriceLabel = {
        let label = PriceLabel()
        label.font = UIFont(name: "PingFangSC-Semibold", size: 30)!
        label.textColor = .white
        return label
    }()
    
    lazy fileprivate var rewardBalanceLabel: PriceLabel = {
        let label = PriceLabel()
        label.font = UIFont(name: "PingFangSC-Semibold", size: 30)!
        label.textColor = .white
        return label
    }()
    
    lazy fileprivate var todayRewardLabel: PriceLabel = {
        let label = PriceLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var overallRewardLabel: PriceLabel = {
        let label = PriceLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "支付中心"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        reload()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubview(contentView)
        
        initCoinView()
        rewardView.addSubview(rewardTableView)
        initRewardHeaderView()
        initRewardBottom()
    }
    
    fileprivate func initCoinView() {
        let coinContentView: UIView = {
            let view = UIView()
            view.clipsToBounds = false
            return view
        }()
        
        let bgImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "payment_coinGradientBg")
            return imgView
        }()
        
        let balanceTitleLabel: ParagraphLabel = {
            let label = ParagraphLabel()
            label.font = UIConstants.Font.foot
            label.textColor = .white
            label.text = "当前氧育币"
            return label
        }()
        
        let topUpBtn: UIButton = {
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: "payment_topUpBtnShadow"), for: .normal)
            button.setTitleColor(UIConstants.Color.primaryGreen, for: .normal)
            button.titleLabel?.font = UIConstants.Font.body
            button.setTitle("充值", for: .normal)
            button.titleEdgeInsets = UIEdgeInsets(top: -2.5, left: 0, bottom: 2.5, right: 0)
            button.addTarget(self, action: #selector(topUpBtnAction), for: .touchUpInside)
            return button
        }()
        
        let footnoteLabel: ParagraphLabel = {
            let label = ParagraphLabel()
            label.font = UIConstants.Font.foot
            label.textColor = .white
            label.text = "仅可用于课程购买"
            return label
        }()
        
        coinView.addSubview(coinContentView)
        coinContentView.addSubviews([bgImgView, coinBalanceLabel, balanceTitleLabel, topUpBtn, footnoteLabel])
        
        let shadowWidth: CGFloat = 720/((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)*2)*20/2
        coinContentView.drawSeparator(startPoint: CGPoint(x: 15+shadowWidth, y: 96), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.leading-30-shadowWidth*2, y: 96), color: .white)
        
        coinContentView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(20)
            make.height.equalTo(146)
        }
        bgImgView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(350/290.0)
            make.width.equalToSuperview().multipliedBy(720/((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)*2))
        }
        coinBalanceLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(30)
            make.height.equalTo(25)
        }
        balanceTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(coinBalanceLabel.snp.bottom).offset(12)
        }
        footnoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.bottom.equalTo(-20)
        }
        topUpBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-22.5)
            make.bottom.equalTo(balanceTitleLabel).offset(5)
            make.size.equalTo(CGSize(width: 85, height: 40))
        }
    }
    
    fileprivate func initRewardHeaderView() {
        let headerView: UIView = {
            let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: 325)))
            view.backgroundColor = .white
            return view
        }()
        
        let coinContentView: UIView = {
            let view = UIView()
            view.clipsToBounds = false
            return view
        }()
        
        let bgImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "payment_rewardGradientBg")
            return imgView
        }()
        
        let balanceTitleLabel: ParagraphLabel = {
            let label = ParagraphLabel()
            label.font = UIConstants.Font.foot
            label.textColor = .white
            label.text = "当前金币"
            return label
        }()
        
        let withdrawBtn: UIButton = {
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: "payment_withdrawBtnShadow"), for: .normal)
            button.setTitleColor(UIConstants.Color.primaryOrange, for: .normal)
            button.titleLabel?.font = UIConstants.Font.body
            button.setTitle("提现", for: .normal)
            button.addTarget(self, action: #selector(withdrawBtnAction), for: .touchUpInside)
            button.titleEdgeInsets = UIEdgeInsets(top: -2.5, left: 0, bottom: 2.5, right: 0)
            return button
        }()
        
        let footnoteLabel: ParagraphLabel = {
            let label = ParagraphLabel()
            label.font = UIConstants.Font.foot
            label.textColor = .white
            label.text = "100金币=1元=1氧育币"
            return label
        }()
        
        let exchangeBtn: UIButton = {
            let button = UIButton()
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIConstants.Font.foot
            button.setTitle("去兑换 ", for: .normal)
            button.setImage(UIImage(named: "public_arrowIndicator")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = .white
            button.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
            button.addTarget(self, action: #selector(exchangeBtnAction), for: .touchUpInside)
            return button
        }()
        
        
        headerView.addSubview(coinContentView)
        coinContentView.addSubviews([bgImgView, rewardBalanceLabel, balanceTitleLabel, withdrawBtn, footnoteLabel, exchangeBtn])
        initOverallView(superview: headerView)
        
        let shadowWidth: CGFloat = 720/((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)*2)*20/2
        coinContentView.drawSeparator(startPoint: CGPoint(x: 15+shadowWidth, y: 96), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.leading-30-shadowWidth*2, y: 96), color: .white)
        headerView.drawSeparator(startPoint: CGPoint(x: 0, y: 324.5), endPoint: CGPoint(x: UIScreenWidth, y: 324.5))
        
        coinContentView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(20)
            make.height.equalTo(146)
        }
        bgImgView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(350/290.0)
            make.width.equalToSuperview().multipliedBy(720/((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)*2))
        }
        rewardBalanceLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(30)
            make.height.equalTo(25)
        }
        balanceTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(rewardBalanceLabel.snp.bottom).offset(12)
        }
        footnoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.bottom.equalTo(-20)
        }
        withdrawBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-22.5)
            make.bottom.equalTo(balanceTitleLabel)
            make.size.equalTo(CGSize(width: 85, height: 40))
        }
        exchangeBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-22.5)
            make.centerY.equalTo(footnoteLabel)
            make.size.equalTo(CGSize(width: 85, height: 40))
        }
        
        rewardTableView.tableHeaderView = headerView
    }
    
    fileprivate func initOverallView(superview: UIView) {
        let stackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .center
            view.axis = .horizontal
            view.distribution = .fillEqually
            view.drawRoundBg(roundedRect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing, height: 58)), cornerRadius: 29, color: UIConstants.Color.background)
            return view
        }()
        
        let todayStackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .center
            view.axis = .vertical
            view.distribution = .fillProportionally
            return view
        }()
        
        let overallStackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .center
            view.axis = .vertical
            view.distribution = .fillProportionally
            return view
        }()
        
        let todayTitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.foot
            label.textColor = UIConstants.Color.foot
            label.text = "今日金币"
            return label
        }()
        
        let overallTitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.foot
            label.textColor = UIConstants.Color.foot
            label.text = "累计金币"
            return label
        }()
        
        let footnoteLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.foot
            label.textColor = UIConstants.Color.foot
            label.text = "金币收支明细"
            return label
        }()
        
        stackView.addArrangedSubview(todayStackView)
        stackView.addArrangedSubview(overallStackView)
        todayStackView.addArrangedSubview(todayRewardLabel)
        todayStackView.addArrangedSubview(todayTitleLabel)
        overallStackView.addArrangedSubview(overallRewardLabel)
        overallStackView.addArrangedSubview(overallTitleLabel)
        
        superview.addSubviews([stackView, footnoteLabel])
        footnoteLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-26)
        }
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.height.equalTo(58)
            make.bottom.equalTo(footnoteLabel.snp.top).offset(-26)
        }
    }
    
    fileprivate func initRewardBottom() {
        let stackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .center
            view.axis = .horizontal
            view.distribution = .fillProportionally
            view.spacing = 18
            view.layoutMargins = UIEdgeInsets(top: 7.5, left: UIConstants.Margin.leading, bottom: 7.5, right: UIConstants.Margin.trailing)
            view.isLayoutMarginsRelativeArrangement = true
            return view
        }()
        
        let rankBtn: UIButton = {
            let button = UIButton()
            button.setTitleColor(UIConstants.Color.primaryOrange, for: .normal)
            button.titleLabel?.font = UIConstants.Font.h2
            button.setTitle("收入排行", for: .normal)
            button.layer.cornerRadius = 20
            button.layer.borderColor = UIConstants.Color.primaryOrange.cgColor
            button.layer.borderWidth = 1
            button.addTarget(self, action: #selector(rankingBtnAction), for: .touchUpInside)
            return button
        }()
        
        let shareBtn: UIButton = {
            let button = UIButton()
            button.setTitleColor(UIConstants.Color.primaryOrange, for: .normal)
            button.titleLabel?.font = UIConstants.Font.h2
            button.setTitle("Marvel", for: .normal)
            button.layer.cornerRadius = 20
            button.layer.borderColor = UIConstants.Color.primaryOrange.cgColor
            button.layer.borderWidth = 1
            //            button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
            return button
        }()
        
        stackView.addArrangedSubview(rankBtn)
        stackView.addArrangedSubview(shareBtn)
        shareBtn.widthAnchor.constraint(equalToConstant: 193).isActive = true
        
        rewardView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.height.equalTo((UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)+55)
            } else {
                make.height.equalTo(55)
            }
            make.top.equalTo(rewardTableView.snp.bottom)
        }
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        rewardTableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.User.userInfoDidChange, object: nil)
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchRewardData() {
        HUDService.sharedInstance.showFetchingView(target: rewardView)
        
        RewardCoinProvider.request(.reward_detail(pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            HUDService.sharedInstance.hideFetchingView(target: self.rewardView)
            if code >= 0 {
                self.rewardView.alpha = 1.0
                
                if let data = JSON?["coin"] as? [String: Any] {
                    if let balance = data["amount"] as? String {
                        self.rewardBalanceLabel.setPriceText(text: balance)
                    }
                    if let todayReward = data["today_amount"] as? String {
                        self.todayRewardLabel.setPriceText(text: todayReward)
                    }
                    if let overallReward = data["income_amount"] as? String {
                        self.overallRewardLabel.setPriceText(text: overallReward)
                    }
                }
                
                if let data = JSON?["coin_logs"] as? [[String: Any]] {
                    self.coinLogModels = [CoinLogModel].deserialize(from: data) as? [CoinLogModel]
                    self.rewardTableView.reloadData()
                }
                
                if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                    if totalPages > self.pageNumber {
                        self.pageNumber += 1
                        self.rewardTableView.mj_footer.isHidden = false
                        self.rewardTableView.mj_footer.resetNoMoreData()
                        
                    } else {
                        self.rewardTableView.mj_footer.isHidden = true
                    }
                }

            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: self.view) { [weak self] in
                    self?.fetchRewardData()
                }
            }
        }))
    }
    
    fileprivate func fetchMoreData() {
        
        RewardCoinProvider.request(.reward_detail(pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            self.rewardTableView.mj_footer.endRefreshing()
            
            if code >= 0 {
                if let data = JSON?["coin_logs"] as? [[String: Any]] {
                    if let models = [CoinLogModel].deserialize(from: data) as? [CoinLogModel] {
                        self.coinLogModels?.append(contentsOf: models)
                    }
                    self.rewardTableView.reloadData()
                    
                    if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                        if totalPages > self.pageNumber {
                            self.pageNumber += 1
                            self.rewardTableView.mj_footer.endRefreshing()
                        } else {
                            self.rewardTableView.mj_footer.endRefreshingWithNoMoreData()
                        }
                    }
                }
                
            }
        }))
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        if let balance = AuthorizationService.sharedInstance.user?.balance {
            coinBalanceLabel.setPriceText(text: balance, discount: nil)
        }
    }
    
    // MARK: - ============= Action =============
    @objc func topUpBtnAction() {
        navigationController?.pushViewController(DTopUpViewController(), animated: true)
    }
    
    @objc func exchangeBtnAction() {
        navigationController?.pushViewController(DExchangeViewController(), animated: true)
    }
    
    @objc func withdrawBtnAction() {
        navigationController?.pushViewController(DWithdrawViewController(), animated: true)
    }
    
    @objc func rankingBtnAction() {
        navigationController?.pushViewController(DRewardRankingViewController(), animated: true)
    }
}


extension DPaymentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinLogModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RewardDetailsCell.className(), for: indexPath) as! RewardDetailsCell
        if let model = coinLogModels?[exist: indexPath.row] {
            cell.setup(model: model)
        }
        return cell
    }
    
}


extension DPaymentViewController: CategoryDelegate {
    
    func contentView(_ contentView: UIView, didScrollRowAt index: Int) {
        if index == 1 && rewardView.alpha == 0 {
            fetchRewardData()
        }
    }
}
