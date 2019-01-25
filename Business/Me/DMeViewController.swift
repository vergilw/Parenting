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
        
        if AuthorizationService.sharedInstance.isSignIn() {
            AuthorizationService.sharedInstance.updateUserInfo()
        }
        
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
            button.layer.borderColor = UIColor("#f3f4f6").cgColor
            button.layer.borderWidth = 1.5
            button.clipsToBounds = true
            button.layer.cornerRadius = 35
            button.imageView?.contentMode = .scaleAspectFill
            button.setImage(UIImage(named: "public_avatarPlaceholder")?.withRenderingMode(.alwaysOriginal), for: .normal)
            button.addTarget(self, action: #selector(avatarBtnAction), for: .touchUpInside)
            button.isUserInteractionEnabled = false
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
                avatarBtn.kf.setImage(with: URL(string: avatarURL), for: .normal, placeholder: UIImage(named: "public_avatarPlaceholder"))
            }
            
            headerView.addSubviews([actionBtn, nameLabel, editTitleLabel, arrowImgView, avatarBtn])
            
            
            actionBtn.snp.makeConstraints { make in
                make.leading.top.bottom.equalToSuperview()
                make.trailing.equalTo(avatarBtn.snp.leading)
            }
            nameLabel.snp.makeConstraints { make in
                make.leading.equalTo(UIConstants.Margin.leading)
                make.bottom.equalTo(avatarBtn.snp.centerY).offset(-2.5)
                make.trailing.lessThanOrEqualTo(avatarBtn.snp.leading).offset(-30)
                make.height.equalTo(nameLabel.font.lineHeight - (nameLabel.font.lineHeight - nameLabel.font.pointSize))
            }
            editTitleLabel.snp.makeConstraints { make in
                make.leading.equalTo(UIConstants.Margin.leading)
                make.top.equalTo(avatarBtn.snp.centerY).offset(7.5)
                make.height.equalTo(editTitleLabel.font.lineHeight - (editTitleLabel.font.lineHeight - editTitleLabel.font.pointSize))
            }
            arrowImgView.snp.makeConstraints { make in
                make.leading.equalTo(editTitleLabel.snp.trailing).offset(4.5)
                make.centerY.equalTo(editTitleLabel)
            }
            avatarBtn.snp.makeConstraints { make in
                if #available(iOS 11, *) {
                    make.centerY.equalToSuperview().offset((UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight)/2)
                } else {
                    make.centerY.equalToSuperview()
                }
                make.trailing.equalTo(-UIConstants.Margin.leading)
                make.size.equalTo(CGSize(width: 70, height: 70))
            }
        } else {
            avatarBtn.isUserInteractionEnabled = false
            headerView.addSubviews([signInLabel, signInArrowImgView, avatarBtn, signInBtn])
            
            signInLabel.snp.makeConstraints { make in
                make.leading.equalTo(UIConstants.Margin.leading)
                make.centerY.equalTo(avatarBtn)
            }
            signInArrowImgView.snp.makeConstraints { make in
                make.leading.equalTo(signInLabel.snp.trailing).offset(4.5)
                make.centerY.equalTo(signInLabel)
            }
            avatarBtn.snp.makeConstraints { make in
                if #available(iOS 11, *) {
                    make.centerY.equalToSuperview().offset((UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight)/2)
                } else {
                    make.centerY.equalToSuperview()
                }
                make.trailing.equalTo(-UIConstants.Margin.leading)
                make.size.equalTo(CGSize(width: 70, height: 70))
            }
            signInBtn.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        tableView.tableHeaderView = headerView
        tableView.layoutIfNeeded()
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
        
        //update balance display
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: UITableView.RowAnimation.none)
    }
    
    // MARK: - ============= Action =============
    
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
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 5 {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MeItemCell.className(), for: indexPath) as! MeItemCell
        if indexPath.section == 0 {
            cell.setup(img: UIImage(named: "me_itemOrder")!, title: "我的订单")
        } else if indexPath.section == 1 {
            var value: String?
            if let balance = AuthorizationService.sharedInstance.user?.balance {
                if let string = String.priceFormatter.string(from: NSNumber(string: balance) ?? NSNumber()) {
                    value = "氧育币" + string
                }
            }
            cell.setup(img: UIImage(named: "me_itemPayment")!, title: "支付中心", value: value)
        } else if indexPath.section == 2 {
            cell.setup(img: UIImage(named: "me_itemCourses")!, title: "我的视频")
        } else if indexPath.section == 3 {
            cell.setup(img: UIImage(named: "me_itemCourses")!, title: "我的课程")
        } else if indexPath.section == 4 {
            cell.setup(img: UIImage(named: "me_itemFavorites")!, title: "我的收藏")
        } else if indexPath.section == 5 {
            cell.setup(img: UIImage(named: "me_itemTeacher")!, title: "我是老师")
        } else if indexPath.section == 6 {
            cell.setup(img: UIImage(named: "me_itemOthers")!, title: "设置")
        } else if indexPath.section == 7 {
            cell.setup(img: UIImage(named: "me_itemHelp")!, title: "帮助中心")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if indexPath.section == 0 {
            guard AuthorizationService.sharedInstance.isSignIn() else {
                let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
                present(authorizationNavigationController, animated: true, completion: nil)
                return
            }
            navigationController?.pushViewController(DOrdersViewController(), animated: true)
        } else if indexPath.section == 1 {
            guard AuthorizationService.sharedInstance.isSignIn() else {
                let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
                present(authorizationNavigationController, animated: true, completion: nil)
                return
            }
            navigationController?.pushViewController(DPaymentViewController(), animated: true)
        } else if indexPath.section == 2 {
            guard AuthorizationService.sharedInstance.isSignIn() else {
                let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
                present(authorizationNavigationController, animated: true, completion: nil)
                return
            }
            let viewController = DVideoUserViewController()
            viewController.userID = AuthorizationService.sharedInstance.user?.id
            navigationController?.pushViewController(viewController, animated: true)
        } else if indexPath.section == 3 {
            guard AuthorizationService.sharedInstance.isSignIn() else {
                let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
                present(authorizationNavigationController, animated: true, completion: nil)
                return
            }
            navigationController?.pushViewController(DMeCoursesViewController(), animated: true)
        } else if indexPath.section == 4 {
            guard AuthorizationService.sharedInstance.isSignIn() else {
                let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
                present(authorizationNavigationController, animated: true, completion: nil)
                return
            }
            navigationController?.pushViewController(DMeFavoritesViewController(), animated: true)
        } else if indexPath.section == 5 {
            navigationController?.pushViewController(DTransactionsViewController(), animated: true)
        } else if indexPath.section == 6 {
            navigationController?.pushViewController(DSettingsViewController(), animated: true)
        } else if indexPath.section == 7 {
            let viewController = WebViewController()
            viewController.navigationItem.title = "帮助中心"
            #if DEBUG
            viewController.url = URL(string: "http://m.1314-edu.com/help/")
            #else
            viewController.url = URL(string: "https://yy.1314-edu.com/help/")
            #endif
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
