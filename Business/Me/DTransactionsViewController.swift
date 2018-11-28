//
//  DTransactionsViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/22.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DTransactionsViewController: BaseViewController {

    enum DTransactionsMode {
        case course
        case details
    }
    
    lazy fileprivate var transactionsMode: DTransactionsViewController.DTransactionsMode = .course
    
    lazy fileprivate var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = UIConstants.Color.primaryGreen
        return view
    }()
    
    lazy fileprivate var backBarBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "public_backBarItem")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backBarItemAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = .white
        label.textAlignment = .center
        label.text = "讲师入口"
        return label
    }()
    
    lazy fileprivate var headerView: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: 174)))
        view.backgroundColor = UIConstants.Color.primaryGreen
        return view
    }()
    
    lazy fileprivate var corporationLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
        label.textColor = .white
        label.setParagraphText("武汉壹叁壹肆教育科技有限公司")
        return label
    }()
    
    lazy fileprivate var leftView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy fileprivate var rightView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy fileprivate var courseNumberLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h1
        label.textColor = .white
        return label
    }()
    
    lazy fileprivate var courseTitleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        label.setParagraphText("售出课程")
        return label
    }()
    
    lazy fileprivate var incomeLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h1
        label.textColor = .white
        return label
    }()
    
    lazy fileprivate var incomeTitleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        label.setParagraphText("总收入")
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
        
        reload()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        tableView.rowHeight = 106
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIConstants.Color.separator
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubviews([navigationView, tableView])
        navigationView.addSubviews([backBarBtn, navigationTitleLabel])
        headerView.addSubviews([corporationLabel, leftView, rightView])
        tableView.tableHeaderView = headerView
        
        leftView.addSubviews([courseNumberLabel, courseTitleLabel])
        rightView.addSubviews([incomeLabel, incomeTitleLabel])
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        navigationView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            if #available(iOS 11, *) {
                make.height.equalTo((navigationController?.navigationBar.bounds.size.height ?? 44)+(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight))
            } else {
                make.height.equalTo((navigationController?.navigationBar.bounds.size.height ?? 44) + UIStatusBarHeight)
            }
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom)
        }
        
        backBarBtn.snp.makeConstraints { make in
            make.leading.equalTo(0)
            if #available(iOS 11, *) {
                make.top.equalTo(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight)
            } else {
                make.height.equalTo(UIStatusBarHeight)
            }
            make.width.equalTo(62.5)
            make.height.equalTo(navigationController!.navigationBar.bounds.size.height)
        }
        navigationTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backBarBtn)
        }
        corporationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(16)
        }
        leftView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.top.equalTo(corporationLabel.snp.bottom)
        }
        rightView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.leading.equalTo(leftView.snp.trailing)
            make.top.equalTo(corporationLabel.snp.bottom)
            make.width.equalTo(leftView)
        }
        courseNumberLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(leftView.snp.centerY).offset(-4)
        }
        courseTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(leftView.snp.centerY).offset(4)
        }
        incomeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(rightView.snp.centerY).offset(-4)
        }
        incomeTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(rightView.snp.centerY).offset(4)
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        tableView.reloadData()
        
        let attributedString = NSMutableAttributedString(string: "130套")
        let paragraph = NSMutableParagraphStyle()
        let lineHeight: CGFloat = UIConstants.LineHeight.h1
        paragraph.maximumLineHeight = lineHeight
        paragraph.minimumLineHeight = lineHeight
        attributedString.addAttributes([
            NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.baselineOffset: (lineHeight-courseNumberLabel.font.lineHeight)/4, NSAttributedString.Key.font: courseNumberLabel.font], range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttributes([NSAttributedString.Key.font : UIConstants.Font.foot], range: NSRange(location: attributedString.length-1, length: 1))
        courseNumberLabel.attributedText = attributedString
        
        incomeLabel.setParagraphText("2654")
    }
    
    // MARK: - ============= Action =============

}


extension DTransactionsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.className()) as? HeaderView
        if view == nil {
            view = HeaderView(reuseIdentifier: HeaderView.className())
            view?.changedBlock = { [weak self] mode in
                self?.transactionsMode = mode
                self?.reload()
            }
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.className(), for: indexPath) as! TransactionCell
        cell.setup(mode: transactionsMode)
        return cell
    }
}


fileprivate class HeaderView: UITableViewHeaderFooterView {
    
    fileprivate var changedBlock: ((DTransactionsViewController.DTransactionsMode)->())?
    
    lazy fileprivate var transactionsMode: DTransactionsViewController.DTransactionsMode = .course
    
    lazy fileprivate var topBgImg: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIConstants.Color.primaryGreen
        return imgView
    }()
    
    lazy fileprivate var bottomBgImg: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .white
        return imgView
    }()
    
    lazy fileprivate var courseBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.head, for: .normal)
        button.titleLabel?.font = UIConstants.Font.h2
        button.setTitle("课程收入", for: .normal)
        button.addTarget(self, action: #selector(categoryBtnAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var detailsBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.body, for: .normal)
        button.titleLabel?.font = UIConstants.Font.body
        button.setTitle("收入明细", for: .normal)
        button.addTarget(self, action: #selector(categoryBtnAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var categoryIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIConstants.Color.primaryGreen
        return imgView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        layer.shadowOffset = CGSize(width: 0, height: 4.0)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 11
        layer.shadowColor = UIColor.black.cgColor
        
        addSubviews([topBgImg, bottomBgImg])
        
        drawRoundBg(roundedRect: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: 40)), cornerRadius: UIConstants.cornerRadius, color: .white)
        addSubviews([courseBtn, detailsBtn, categoryIndicatorImgView])
        
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func initConstraints() {
        topBgImg.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        bottomBgImg.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(topBgImg.snp.bottom)
            make.height.equalTo(topBgImg)
        }
        courseBtn.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        detailsBtn.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(courseBtn.snp.trailing)
            make.width.equalTo(courseBtn)
        }
        categoryIndicatorImgView.snp.makeConstraints { make in
            make.centerX.equalTo(courseBtn)
            make.height.equalTo(1.5)
            make.width.equalTo(29)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func categoryBtnAction(sender: UIButton) {
        categoryIndicatorImgView.snp.remakeConstraints { make in
            make.centerX.equalTo(sender)
            make.width.equalTo(29)
            make.height.equalTo(1.5)
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.35, animations: {
            self.layoutIfNeeded()
        })
        
        courseBtn.titleLabel?.font = UIConstants.Font.body
        detailsBtn.titleLabel?.font = UIConstants.Font.body
        courseBtn.setTitleColor(UIConstants.Color.body, for: .normal)
        detailsBtn.setTitleColor(UIConstants.Color.body, for: .normal)
        
        sender.setTitleColor(UIConstants.Color.head, for: .normal)
        sender.titleLabel?.font = UIConstants.Font.h2
        
        if sender == courseBtn {
            transactionsMode = .course
        } else if sender == detailsBtn {
            transactionsMode = .details
        }
        if let block = changedBlock {
            block(transactionsMode)
        }
    }
}
