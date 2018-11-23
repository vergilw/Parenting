//
//  DSearchViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/21.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DSearchViewController: BaseViewController {

    lazy fileprivate var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 11
        view.layer.shadowColor = UIColor.black.cgColor
//        view.clipsToBounds = false
        return view
    }()
    
    lazy fileprivate var searchView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy fileprivate var textField: UITextField = {
        let textField = UITextField()
//        textField.delegate = self
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = UIConstants.Color.background
        textField.layer.cornerRadius = 21
        textField.font = UIConstants.Font.body
        textField.textColor = UIConstants.Color.head
        textField.attributedPlaceholder = NSAttributedString(string: "搜索您感兴趣的内容", attributes: [NSAttributedString.Key.foregroundColor : UIConstants.Color.foot])
        
        let placeholderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 21+17+8, height: 42)))
        let searchIconImgView: UIImageView = {
            let imgView = UIImageView(frame: CGRect(origin: CGPoint(x: 21, y: 21-17/2), size: CGSize(width: 17, height: 17)))
            imgView.image = UIImage(named: "public_searchIcon")
            placeholderView.addSubview(imgView)
            return imgView
        }()
        textField.leftView = placeholderView
        textField.leftViewMode = .always
        return textField
    }()
    
    lazy fileprivate var dismissBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.body, for: .normal)
        button.titleLabel?.font = UIConstants.Font.body
        button.setTitle("取消", for: .normal)
        button.addTarget(self, action: #selector(dismissBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    enum DSearchMode {
        case all
        case course
        case teacher
    }
    
    lazy fileprivate var searchMode: DSearchMode = .all
    
    lazy fileprivate var allBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.head, for: .normal)
        button.titleLabel?.font = UIConstants.Font.h2
        button.setTitle("全部", for: .normal)
        button.addTarget(self, action: #selector(categoryBtnAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var courseBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.body, for: .normal)
        button.titleLabel?.font = UIConstants.Font.body
        button.setTitle("课程", for: .normal)
        button.addTarget(self, action: #selector(categoryBtnAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var teacherBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.body, for: .normal)
        button.titleLabel?.font = UIConstants.Font.body
        button.setTitle("老师", for: .normal)
        button.addTarget(self, action: #selector(categoryBtnAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var categoryIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIConstants.Color.primaryGreen
        return imgView
    }()
    
    lazy fileprivate var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 100, height: 36)
        layout.sectionInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 18
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(HistoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HistoryHeaderView.className())
        view.register(SearchHistoryCell.self, forCellWithReuseIdentifier: SearchHistoryCell.className())
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        
        view.alwaysBounceVertical = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "搜索"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        //        tableView.register(MailListTableViewCell.self, forCellReuseIdentifier: MailListTableViewCell.className())
        tableView.rowHeight = 109
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 36, bottom: 0, right: 15)
        tableView.separatorColor = UIColor("#e8e8e8")
        tableView.backgroundColor = .white
        //        tableView.dataSource = self
        //        tableView.delegate = self
        
        view.addSubviews([tableView, collectionView, topView])
        topView.addSubviews([searchView, categoryView])
        searchView.addSubviews([textField, dismissBtn])
        categoryView.addSubviews([allBtn, courseBtn, teacherBtn, categoryIndicatorImgView])
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        topView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            if #available(iOS 11, *) {
                make.height.equalTo(90+(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight)+7.5)
            } else {
                make.height.equalTo(90+UIStatusBarHeight+7.5)
            }
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
        }
        
        searchView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            if #available(iOS 11, *) {
                make.top.equalTo((UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight)+7.5)
            } else {
                make.top.equalTo(UIStatusBarHeight+7.5)
            }
            make.height.equalTo(42)
        }
        categoryView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.bottom.equalToSuperview()
        }
        dismissBtn.snp.makeConstraints { make in
            make.leading.equalTo(textField.snp.trailing)
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(15+30+UIConstants.Margin.trailing)
        }
        
        allBtn.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        courseBtn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(allBtn.snp.trailing)
            make.width.equalTo(allBtn)
        }
        teacherBtn.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(courseBtn.snp.trailing)
            make.width.equalTo(courseBtn)
        }
        categoryIndicatorImgView.snp.makeConstraints { make in
            make.centerX.equalTo(allBtn)
            make.height.equalTo(1.5)
            make.width.equalTo(29)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============
    @objc func dismissBtnAction() {
        dismiss(animated: true, completion: nil)
    }
    
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
        
        allBtn.titleLabel?.font = UIConstants.Font.body
        courseBtn.titleLabel?.font = UIConstants.Font.body
        teacherBtn.titleLabel?.font = UIConstants.Font.body
        allBtn.setTitleColor(UIConstants.Color.body, for: .normal)
        courseBtn.setTitleColor(UIConstants.Color.body, for: .normal)
        teacherBtn.setTitleColor(UIConstants.Color.body, for: .normal)
        
        sender.setTitleColor(UIConstants.Color.head, for: .normal)
        sender.titleLabel?.font = UIConstants.Font.h2
        
        if sender == allBtn {
            searchMode = .all
        } else if sender == courseBtn {
            searchMode = .course
        } else if sender == teacherBtn {
            searchMode = .teacher
        }
        reload()
    }
}


extension DSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreenWidth, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HistoryHeaderView.className(), for: indexPath)
            return view
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchHistoryCell.className(), for: indexPath) as! SearchHistoryCell
        cell.setup()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
}


fileprivate class HistoryHeaderView: UICollectionReusableView {
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.text = "历史记录"
        return label
    }()
    
    lazy fileprivate var deleteBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "course_historyDeleteIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([titleLabel, deleteBtn])
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(32)
            make.bottom.equalTo(-18)
        }
        deleteBtn.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 14.5+UIConstants.Margin.trailing*2, height: 15+18*2))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
