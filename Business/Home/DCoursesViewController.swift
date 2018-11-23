//
//  DCoursesViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/22.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DCoursesViewController: BaseViewController {

    lazy fileprivate var viewModel = DCourseViewModel()
    
    //FIXME: instead collectionview use scrollview
    lazy fileprivate var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        layout.itemSize = UICollectionViewFlowLayout.automaticSize
//        layout.estimatedItemSize = CGSize(width: 122, height: 46)
        layout.itemSize = CGSize(width: 122, height: 46)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.className())
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        view.alwaysBounceHorizontal = true
        return view
    }()
    
    lazy fileprivate var categoryIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIConstants.Color.primaryGreen
        return imgView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "课程列表"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        tableView.backgroundColor = UIConstants.Color.background
        tableView.rowHeight = 172
        tableView.register(CourseCell.self, forCellReuseIdentifier: CourseCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubviews([collectionView, tableView])
        collectionView.addSubview(categoryIndicatorImgView)
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(46)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom)
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchData() {
        viewModel.fetchCategory { (status) in
            if status {
                self.collectionView.reloadData()
                
                self.collectionView.layoutIfNeeded()
                
                if let item = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) {
                    let rect = self.view.convert(item.frame, from: self.collectionView)
                    self.categoryIndicatorImgView.snp.remakeConstraints { make in
                        make.centerX.equalTo(rect.origin.x+rect.size.width/2)
                        make.height.equalTo(1.5)
                        make.width.equalTo(29)
                        make.bottom.equalTo(self.collectionView)
                    }
                }
                
                self.viewModel.fetchCourses { (status, next) in
                    if status {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    fileprivate func fetchCourses() {
        self.viewModel.fetchCourses { (status, next) in
            if status {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
    }
    
    // MARK: - ============= Action =============

}


extension DCoursesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.courseModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseCell.className(), for: indexPath) as! CourseCell
        if let model = viewModel.courseModels?[indexPath.row] {
            cell.setup(mode: CourseCell.CellDisplayMode.default, model: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let model = viewModel.courseModels?[indexPath.row], let courseID = model.id {
            navigationController?.pushViewController(DCourseDetailViewController(courseID: courseID), animated: true)
        }
    }
}


extension DCoursesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoryModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.className(), for: indexPath) as! CategoryCell
        if let model = viewModel.categoryModels?[indexPath.row] {
            cell.setup(model: model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
        if let item = self.collectionView.cellForItem(at: indexPath) {
            let rect = self.view.convert(item.frame, from: self.collectionView)
            self.categoryIndicatorImgView.snp.remakeConstraints { make in
                make.centerX.equalTo(rect.origin.x+rect.size.width/2)
                make.height.equalTo(1.5)
                make.width.equalTo(29)
                make.bottom.equalTo(self.collectionView)
            }
            UIView.animate(withDuration: 0.35, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        if let model = viewModel.categoryModels?[indexPath.row], let categoryID = model.id {
            viewModel.categoryID = categoryID
            fetchCourses()
        }
    }
    
}


fileprivate class CategoryCell: UICollectionViewCell {
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
//            make.leading.equalTo(16)
//            make.trailing.equalTo(-16)
//            make.height.equalTo(46)
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel.font = UIConstants.Font.h2
                titleLabel.textColor = UIConstants.Color.head
            } else {
                titleLabel.font = UIConstants.Font.body
                titleLabel.textColor = UIConstants.Color.body
            }
        }
    }
    
    func setup(model: CourseCategoryModel) {
        titleLabel.text = model.name
    }
}
