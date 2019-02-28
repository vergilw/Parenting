//
//  DVideoCommentViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/9.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class DVideoCommentViewController: BaseViewController {

    var videoID: Int
    
    fileprivate var commentModels: [VideoCommentModel]?
    
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
    
    lazy fileprivate var bottomInputView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy fileprivate var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.returnKeyType = .send
        textField.clearButtonMode = .whileEditing
        textField.font = UIConstants.Font.body
        textField.textColor = UIConstants.Color.head
        textField.layer.cornerRadius = 17.5
        textField.backgroundColor = UIConstants.Color.background
        textField.attributedPlaceholder = NSAttributedString(string: "写评论", attributes: [NSAttributedString.Key.foregroundColor : UIConstants.Color.foot])
        let placeholderView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 35)))
        placeholderView.image = UIImage(named: "video_commentIcon")
        placeholderView.contentMode = .center
        textField.leftView = placeholderView
        textField.leftViewMode = .always
        if #available(iOS 11.0, *) {
            textField.keyboardDistanceFromTextField = -11-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
        } else {
            textField.keyboardDistanceFromTextField = 5
        }
        return textField
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

//        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(DVideoCommentViewController.self)
        
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
        
        tableView.estimatedRowHeight = 110
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIConstants.Color.separator
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        tableView.register(VideoCommentCell.self, forCellReuseIdentifier: VideoCommentCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.fetchMoreData()
        })
        tableView.mj_footer.isHidden = true
        
        view.addSubviews([titleView, tableView, bottomInputView])
        
        initTitleView()
        initInputView()
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
    
    fileprivate func initInputView() {
        bottomInputView.drawSeparator(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: UIScreenWidth, y: 0))
        
        bottomInputView.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.height.equalTo(36)
            make.top.equalTo(5)
        }
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        titleView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(60)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom)
            make.bottom.equalTo(bottomInputView.snp.top)
        }
        
        bottomInputView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.height.equalTo(46+(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
            } else {
                make.height.equalTo(46)
            }
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchData() {
        var HUDHeight: CGFloat = 440 - 60 - 46
        if #available(iOS 11.0, *) {
            HUDHeight -= (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
        }
        HUDService.sharedInstance.showFetchingView(target: self.tableView, frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: HUDHeight)))
        
        VideoProvider.request(.video_comments(videoID, pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            HUDService.sharedInstance.hideFetchingView(target: self.tableView)
            
            if code >= 0 {
                if let data = JSON?["comments"] as? [[String: Any]] {
                    if let models = [VideoCommentModel].deserialize(from: data) as? [VideoCommentModel] {
                        self.commentModels = models
                    }
                    self.tableView.reloadData()
                    
                    
                    
                    if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                        
                        if let totalCount = pagination["total_count"] as? Int {
                            self.titleLabel.text = "\(totalCount)条评论"
                        }
                        
                        if totalPages > self.pageNumber {
                            self.pageNumber += 1
                            self.tableView.mj_footer.isHidden = false
                            self.tableView.mj_footer.resetNoMoreData()
                            
                        } else {
                            self.tableView.mj_footer.isHidden = true
                        }
                    }
                    
                    if self.commentModels?.count ?? 0 == 0 {
                        HUDService.sharedInstance.showNoDataView(target: self.tableView)
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
        
        VideoProvider.request(.video_comments(videoID, pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            self.tableView.mj_footer.endRefreshing()
            
            if code >= 0 {
                if let data = JSON?["comments"] as? [[String: Any]] {
                    if let models = [VideoCommentModel].deserialize(from: data) as? [VideoCommentModel] {
                        self.commentModels?.append(contentsOf: models)
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
    
    fileprivate func reportRequest(commentID: Int) {
        VideoProvider.request(.video_comment_report(commentID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if code > 0 {
                HUDService.sharedInstance.show(string: "举报成功")
            }
        }))
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============

}


extension DVideoCommentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoCommentCell.className(), for: indexPath) as! VideoCommentCell
        if let model = commentModels?[exist: indexPath.row] {
            cell.setup(model: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let model = commentModels?[exist: indexPath.row], let string = model.id, let commentID = Int(string) else { return }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "色情低俗", style: UIAlertAction.Style.default, handler: { (action) in
            self.reportRequest(commentID: commentID)
        }))
        alertController.addAction(UIAlertAction(title: "政治敏感", style: UIAlertAction.Style.default, handler: { (action) in
            self.reportRequest(commentID: commentID)
        }))
        alertController.addAction(UIAlertAction(title: "违法犯罪", style: UIAlertAction.Style.default, handler: { (action) in
            self.reportRequest(commentID: commentID)
        }))
        alertController.addAction(UIAlertAction(title: "垃圾广告", style: UIAlertAction.Style.default, handler: { (action) in
            self.reportRequest(commentID: commentID)
        }))
        alertController.addAction(UIAlertAction(title: "造谣传谣、涉嫌欺诈", style: UIAlertAction.Style.default, handler: { (action) in
            self.reportRequest(commentID: commentID)
        }))
        alertController.addAction(UIAlertAction(title: "侮辱谩骂", style: UIAlertAction.Style.default, handler: { (action) in
            self.reportRequest(commentID: commentID)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
}


extension DVideoCommentViewController {
//    @objc func keyboardWillShow(sender: Notification) {
//        guard let keyboardInfo = sender.userInfo else { return }
//        keyboardInfo[UIResponder.keyboardFrameBeginUserInfoKey]
//    }
//
//    @objc func keyboardWillHide(sender: Notification) {
//
//    }
}


extension DVideoCommentViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard AuthorizationService.sharedInstance.isSignIn() else {
            let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
            authorizationNavigationController.modalPresentationStyle = .overFullScreen
            present(authorizationNavigationController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text, text.trimmingCharacters(in: CharacterSet.whitespaces).count > 0 else {
            HUDService.sharedInstance.show(string: "您还没有添加评论内容哟！")
            return false
        }
        
        textField.resignFirstResponder()
        
        VideoProvider.request(.video_comment(videoID, text), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if code >= 0, let data = JSON?["comment"] as? [String: Any] {
                if let model = VideoCommentModel.deserialize(from: data) {
                    self.commentModels?.insert(model, at: 0)
                    self.tableView.reloadData()
                    
                    HUDService.sharedInstance.hideResultView(target: self.tableView)
                    
                    if let amount = self.titleLabel.text {
                        self.titleLabel.text = "\(atoi(amount)+1)条评论"
                        
                        NotificationCenter.default.post(name: Notification.Video.commentCountDidChange, object: nil, userInfo: ["count": atoi(amount)+1])
                    }
                    
                    
                }
                
                textField.text = nil
                
                
                //赏金逻辑
                if let reward = JSON?["reward"] as? [String: Any], let status = reward["code"] as? String, status == "success", let amount = reward["amount"] as? String {
                    let view = RewardView()
                    UIApplication.shared.keyWindow?.addSubview(view)
                    view.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                    view.present(string: amount, mode: RewardView.DRewardMode.comment)
                    
                    if let rewardCodes = reward["rewardable_codes"] as? [String] {
                        NotificationCenter.default.post(name: Notification.Video.rewardStatusDidChange, object: nil, userInfo: ["id": String(self.videoID), "rewardable_codes": rewardCodes])
                    }
                    
                }
            }
        }))
        
        return false
    }
}
