//
//  CourseCataloguesView.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/30.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class CourseCataloguesView: UIView {

    public var courseSectionModels: [CourseSectionModel]?
    
    public var dismissBlock: (()->())?

    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        tableView.register(CourseCatalogueCell.self, forCellReuseIdentifier: CourseCatalogueCell.className())
        tableView.tableFooterView = UIView()
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
        }
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy fileprivate var separatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIConstants.Color.separator
        return imgView
    }()
    
    lazy fileprivate var cornerBgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .white
        imgView.layer.cornerRadius = 5
        return imgView
    }()
    
    lazy var dismissArrowBtn: UIButton = {
        let button = UIButton()
//        button.backgroundColor = .white
        button.setImage(UIImage(named: "public_dismissArrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(dismissBtnAction), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([tableView, cornerBgImgView, dismissArrowBtn, separatorImgView])
        
        dismissArrowBtn.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(77)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(dismissArrowBtn.snp.top)
        }
        cornerBgImgView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(dismissArrowBtn)
            make.height.equalTo(dismissArrowBtn.snp.height).offset(10)
        }
        separatorImgView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(dismissArrowBtn)
            make.height.equalTo(0.5)
        }
        if #available(iOS 11.0, *) {
            tableView.contentInset = UIEdgeInsets(top: UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    public func reload() {
        tableView.reloadData()
    }
    
    @objc func dismissBtnAction() {
        if let dismissBlock = dismissBlock {
            dismissBlock()
        }
    }
    
}

extension CourseCataloguesView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseSectionModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseCatalogueCell.className(), for: indexPath) as! CourseCatalogueCell
        cell.setup(model: courseSectionModels![indexPath.row], isPlayed: false, isBought: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}
