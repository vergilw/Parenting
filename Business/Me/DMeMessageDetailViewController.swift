//
//  DMeMessageDetailViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/2/27.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class DMeMessageDetailViewController: BaseViewController {

    fileprivate var messageID: Int?
    
    fileprivate var messageModel: MessageModel?
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot2
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    fileprivate lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.subhead
        label.numberOfLines = 0
        return label
    }()
    
    init(messageID: Int) {
        super.init(nibName: nil, bundle: nil)
        
        self.messageID = messageID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "通知"

        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubview(scrollView)
        scrollView.addSubviews([titleLabel, timeLabel, bodyLabel])
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(10)
        }
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
        }
        bodyLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(timeLabel.snp.bottom).offset(22)
            make.bottom.equalTo(-20)
            make.width.equalTo(UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchData() {
        guard let messageID = messageID else { return }
        
        HUDService.sharedInstance.showFetchingView(target: self.view)
        
        MessageProvider.request(.message(messageID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            HUDService.sharedInstance.hideFetchingView(target: self.view)
            
            if code >= 0 {
                if let data = JSON?["notification"] as? [String: Any] {
                    self.messageModel = MessageModel.deserialize(from: data)
                    self.reload()
                }
                
            } else if code == -2 {
                HUDService.sharedInstance.showNoNetworkView(target: self.view) { [weak self] in
                    self?.fetchData()
                }
            }
        }))
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        titleLabel.text = messageModel?.title
        
        if let text = messageModel?.body {
            let attributedString = NSMutableAttributedString(string: text)
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineHeightMultiple = 1.2
            paragraph.paragraphSpacing = 20
            paragraph.lineBreakMode = .byCharWrapping
            
            attributedString.addAttributes([
                NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.font: bodyLabel.font], range: NSRange(location: 0, length: attributedString.length))
            
            bodyLabel.attributedText = attributedString
        }
        
        timeLabel.text = messageModel?.created_at?.string(format: "yyyy.MM.dd HH:mm")
    }
    
    // MARK: - ============= Action =============
    
    // MARK: - ============= Public =============
    
    // MARK: - ============= Private =============

}
