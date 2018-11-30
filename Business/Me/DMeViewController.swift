//
//  DMeViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/23.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class DMeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "个人中心"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        tableView.rowHeight = 75
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIConstants.Color.separator
        tableView.register(MeItemCell.self, forCellReuseIdentifier: MeItemCell.className())
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        initHeaderView()
        initFooterView()
    }
    
    func initHeaderView() {
        let headerView: UIView = {
            let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth, height: 205)))
            view.backgroundColor = .white
            view.drawSeparator(startPoint: CGPoint(x: UIConstants.Margin.leading, y: 205), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.trailing, y: 205))
            return view
        }()
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.h1
            label.textColor = UIConstants.Color.head
            return label
        }()
        
        let editTitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.body
            label.textColor = UIConstants.Color.subhead
            label.text = "编辑个人资料"
            return label
        }()
        
        let arrowImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "public_arrowIndicator")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            imgView.tintColor = UIConstants.Color.foot
            return imgView
        }()
        
        let actionBtn: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(editBtnAction), for: .touchUpInside)
            return button
        }()
        
        let avatarBtn: UIButton = {
            let button = UIButton()
            button.clipsToBounds = true
            button.layer.cornerRadius = 35
            button.imageView?.contentMode = .scaleAspectFill
            button.setImage(UIImage(named: "public_avatarPlaceholder")?.withRenderingMode(.alwaysOriginal), for: .normal)
            button.addTarget(self, action: #selector(avatarBtnAction), for: .touchUpInside)
            return button
        }()
        
        let signInLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.h2
            label.textColor = UIConstants.Color.primaryGreen
            label.text = "登录/注册"
            return label
        }()
        
        let signInArrowImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "public_arrowIndicator")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            imgView.tintColor = UIConstants.Color.foot
            return imgView
        }()
        
        let signInBtn: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(signInBtnAction), for: .touchUpInside)
            return button
        }()
        
        if AuthorizationService.sharedInstance.isSignIn() {
            avatarBtn.isUserInteractionEnabled = true
            nameLabel.text = AuthorizationService.sharedInstance.user?.name ?? "名字"
            if let avatarURL = AuthorizationService.sharedInstance.user?.avatar_url {
                avatarBtn.kf.setImage(with: URL(string: avatarURL), for: .normal)
            }
            
            headerView.addSubviews([actionBtn, nameLabel, editTitleLabel, arrowImgView, avatarBtn])
            
            
            actionBtn.snp.makeConstraints { make in
                make.leading.top.bottom.equalToSuperview()
                make.trailing.equalTo(avatarBtn.snp.leading)
            }
            nameLabel.snp.makeConstraints { make in
                make.leading.equalTo(UIConstants.Margin.leading)
                make.top.equalTo(avatarBtn.snp.top).offset(10)
            }
            editTitleLabel.snp.makeConstraints { make in
                make.leading.equalTo(UIConstants.Margin.leading)
                make.top.equalTo(nameLabel.snp.bottom).offset(6.5)
            }
            arrowImgView.snp.makeConstraints { make in
                make.leading.equalTo(editTitleLabel.snp.trailing).offset(4.5)
                make.centerY.equalTo(editTitleLabel)
            }
            avatarBtn.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalTo(-UIConstants.Margin.leading)
                make.size.equalTo(CGSize(width: 70, height: 70))
            }
        } else {
            avatarBtn.isUserInteractionEnabled = false
            headerView.addSubviews([signInLabel, signInArrowImgView, avatarBtn, signInBtn])
            
            signInLabel.snp.makeConstraints { make in
                make.leading.equalTo(UIConstants.Margin.leading)
                make.centerY.equalToSuperview()
            }
            signInArrowImgView.snp.makeConstraints { make in
                make.leading.equalTo(signInLabel.snp.trailing).offset(4.5)
                make.centerY.equalTo(signInLabel)
            }
            avatarBtn.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalTo(-UIConstants.Margin.leading)
                make.size.equalTo(CGSize(width: 70, height: 70))
            }
            signInBtn.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        tableView.tableHeaderView = headerView
    }
    
    func initFooterView() {
        guard AuthorizationService.sharedInstance.isSignIn() else {
            tableView.tableFooterView = nil
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
    func initConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Authorization.signInDidSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Authorization.signOutDidSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.User.userInfoDidChange, object: nil)
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        initHeaderView()
        initFooterView()
    }
    
    // MARK: - ============= Action =============
    @objc func signOutBtnAction() {
        AuthorizationService.sharedInstance.signOut()
        HUDService.sharedInstance.show(string: "退出成功")
    }
    
    @objc func signInBtnAction() {
        let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
        present(authorizationNavigationController, animated: true, completion: nil)
    }
    
    @objc func avatarBtnAction() {
        
    }
    
    @objc func editBtnAction() {
        navigationController?.pushViewController(DMeEditViewController(), animated: true)
    }
}


extension DMeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MeItemCell.className(), for: indexPath) as! MeItemCell
        if indexPath.row == 0 {
            cell.setup(img: UIImage(named: "me_itemOrder")!, title: "我的订单")
        } else if indexPath.row == 1 {
            cell.setup(img: UIImage(named: "me_itemPayment")!, title: "支付中心")
        } else if indexPath.row == 2 {
            cell.setup(img: UIImage(named: "me_itemCourses")!, title: "我的课程")
        } else if indexPath.row == 3 {
            cell.setup(img: UIImage(named: "me_itemFavorites")!, title: "我的收藏")
        } else if indexPath.row == 4 {
            cell.setup(img: UIImage(named: "me_itemTeacher")!, title: "讲师入口")
        } else if indexPath.row == 5 {
            cell.setup(img: UIImage(named: "me_itemOthers")!, title: "其他")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if indexPath.row == 0 {
            navigationController?.pushViewController(DOrdersViewController(), animated: true)
        } else if indexPath.row == 1 {
            navigationController?.pushViewController(DPaymentViewController(), animated: true)
        } else if indexPath.row == 2 {
            navigationController?.pushViewController(DMeCoursesViewController(), animated: true)
        } else if indexPath.row == 3 {
            guard AuthorizationService.sharedInstance.isSignIn() else {
                let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
                present(authorizationNavigationController, animated: true, completion: nil)
                return
            }
            navigationController?.pushViewController(DMeFavoritesViewController(), animated: true)
        } else if indexPath.row == 4 {
            navigationController?.pushViewController(DTransactionsViewController(), animated: true)
        } else if indexPath.row == 5 {
            navigationController?.pushViewController(DSettingsViewController(), animated: true)
        }
    }
}
