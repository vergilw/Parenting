//
//  CRMViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/4/15.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import Flutter
import Kingfisher

class CRMViewController: BaseViewController {

    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    fileprivate lazy var avatarImgView: UIImageView = {
        let imgView = UIImageView()
//        imgView.image = UIImage(named: <#T##String#>)
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 22.5
        imgView.clipsToBounds = true
        return imgView
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h3
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    fileprivate lazy var notificationImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "crm_notificationIcon")
        imgView.contentMode = .center
        return imgView
    }()
    
    fileprivate lazy var notificationLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.caption1
        label.textColor = UIConstants.Color.head
        label.text = "园区暂无通知"
        return label
    }()
    
    fileprivate lazy var salesViewController: TestViewController = {
        let flutter = TestViewController()
        flutter.setInitialRoute("module_sales")
        flutter.splashScreenView = SplashView()
        setupFlutterChannel(flutter: flutter)
        return flutter
    }()
    
    fileprivate lazy var scheduleViewController: TestViewController = {
        let flutter = TestViewController()
        flutter.setInitialRoute("teacher_class_schedule")
        flutter.splashScreenView = SplashView()
        setupFlutterChannel(flutter: flutter)
        return flutter
    }()
    
    fileprivate lazy var punchViewController: TestViewController = {
        let flutter = TestViewController()
        flutter.setInitialRoute("class_punch")
        flutter.splashScreenView = SplashView()
        setupFlutterChannel(flutter: flutter)
        return flutter
    }()
    
    fileprivate lazy var notificationViewController: TestViewController = {
        let flutter = TestViewController()
        flutter.setInitialRoute("module_notification")
        flutter.splashScreenView = SplashView()
        setupFlutterChannel(flutter: flutter)
        return flutter
    }()
    
    fileprivate lazy var activityViewController: TestViewController = {
        let flutter = TestViewController()
        flutter.setInitialRoute("module_activity")
        flutter.splashScreenView = SplashView()
        setupFlutterChannel(flutter: flutter)
        return flutter
    }()
    
    fileprivate lazy var profileViewController: TestViewController = {
        let flutter = TestViewController()
        flutter.setInitialRoute("module_personal_info")
        flutter.splashScreenView = SplashView()
        setupFlutterChannel(flutter: flutter)
        return flutter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "园区管理系统"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        reload()
        if AuthorizationService.sharedInstance.isSignIn() {
            fetchProfile()
        }
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        initNavigationItems()
        
        view.addSubview(scrollView)
        
        scrollView.drawRoundBg(roundedRect: CGRect(origin: CGPoint(x: UIConstants.Margin.leading, y: 80), size: CGSize(width: UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing, height: 30)), cornerRadius: 15, color: UIConstants.Color.background)
        scrollView.addSubviews([avatarImgView, nameLabel, notificationImgView, notificationLabel])
        
        initShortcutView()
        
        let userProfileBtn: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(userProfileBtnAction), for: .touchUpInside)
            return button
        }()
        scrollView.addSubview(userProfileBtn)
        userProfileBtn.snp.makeConstraints { make in
            make.centerY.leading.equalTo(avatarImgView)
            make.height.equalTo(45)
            make.leading.equalTo(avatarImgView.snp.leading).offset(-10)
            make.trailing.equalTo(nameLabel.snp.trailing).offset(10)
        }
        
    }
    
    fileprivate func initNavigationItems() {
        let msgBtn: UIButton = {
            let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 18+UIConstants.Margin.trailing*2, height: navigationController?.navigationBar.bounds.height ?? 44)))
            button.setImage(UIImage(named: "crm_msgBar"), for: .normal)
            button.addTarget(self, action: #selector(msgsBarBtnAction), for: .touchUpInside)
            return button
        }()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: msgBtn)
        navigationItem.rightMargin = 0
    }
    
    fileprivate func initShortcutView() {
        let maintainBtn: UIButton = {
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: "crm_maintain"), for: .normal)
            button.addTarget(self, action: #selector(maintainBtnAction), for: .touchUpInside)
            return button
        }()
        let maintainStackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .leading
            view.axis = .vertical
            view.distribution = .fillProportionally
            return view
        }()
        let maintainTitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.h2
            label.textColor = .white
            label.text = "销售顾问"
            return label
        }()
        let maintainSubtitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.caption1
            label.textColor = .white
            label.text = "录入到签单一体化"
            return label
        }()
        maintainStackView.addArrangedSubview(maintainTitleLabel)
        maintainStackView.addArrangedSubview(maintainSubtitleLabel)
        maintainBtn.addSubview(maintainStackView)
        maintainStackView.snp.makeConstraints { make in
            make.leading.equalTo(28)
            make.centerY.equalToSuperview().offset(-7.5)
        }
        
        let classScheduleBtn: UIButton = {
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: "crm_classSchedule"), for: .normal)
            button.addTarget(self, action: #selector(classScheduleBtnAction), for: .touchUpInside)
            return button
        }()
        let classScheduleStackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .leading
            view.axis = .vertical
            view.distribution = .fillProportionally
            return view
        }()
        let classScheduleTitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.h2
            label.textColor = .white
            label.text = "课程表"
            return label
        }()
        let classScheduleSubtitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.caption1
            label.textColor = .white
            label.text = "一周课程早知道"
            return label
        }()
        classScheduleStackView.addArrangedSubview(classScheduleTitleLabel)
        classScheduleStackView.addArrangedSubview(classScheduleSubtitleLabel)
        classScheduleBtn.addSubview(classScheduleStackView)
        classScheduleStackView.snp.makeConstraints { make in
            make.leading.equalTo(28)
            make.centerY.equalToSuperview().offset(-7.5)
        }
        
        let classPunchBtn: UIButton = {
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: "crm_classPunch"), for: .normal)
            button.addTarget(self, action: #selector(classPunchBtnAction), for: .touchUpInside)
            return button
        }()
        let classPunchStackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .leading
            view.axis = .vertical
            view.distribution = .fillProportionally
            return view
        }()
        let classPunchTitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.h2
            label.textColor = .white
            label.text = "签到请假"
            return label
        }()
        let classPunchSubtitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.caption1
            label.textColor = .white
            label.text = "宝宝考勤一键完成"
            return label
        }()
        classPunchStackView.addArrangedSubview(classPunchTitleLabel)
        classPunchStackView.addArrangedSubview(classPunchSubtitleLabel)
        classPunchBtn.addSubview(classPunchStackView)
        classPunchStackView.snp.makeConstraints { make in
            make.leading.equalTo(28)
            make.centerY.equalToSuperview().offset(-7.5)
        }
        
        
        let notificationBtn: UIButton = {
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: "crm_notification"), for: .normal)
            button.addTarget(self, action: #selector(notificationBtnAction), for: .touchUpInside)
            return button
        }()
        let notificationStackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .leading
            view.axis = .vertical
            view.distribution = .fillProportionally
            return view
        }()
        let notificationTitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.h2
            label.textColor = .white
            label.text = "消息通知"
            return label
        }()
        let notificationSubtitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.caption1
            label.textColor = .white
            label.text = "信息动态可视化"
            return label
        }()
        notificationStackView.addArrangedSubview(notificationTitleLabel)
        notificationStackView.addArrangedSubview(notificationSubtitleLabel)
        notificationBtn.addSubview(notificationStackView)
        notificationStackView.snp.makeConstraints { make in
            make.leading.equalTo(28)
            make.centerY.equalToSuperview().offset(-7.5)
        }
        
        
        let activityBtn: UIButton = {
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: "crm_activity"), for: .normal)
            button.addTarget(self, action: #selector(activityBtnAction), for: .touchUpInside)
            return button
        }()
        let activityStackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .leading
            view.axis = .vertical
            view.distribution = .fillProportionally
            return view
        }()
        let activityTitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.h2
            label.textColor = .white
            label.text = "线下活动"
            return label
        }()
        let activitySubtitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.caption1
            label.textColor = .white
            label.text = "信息动态可视化"
            return label
        }()
        activityStackView.addArrangedSubview(activityTitleLabel)
        activityStackView.addArrangedSubview(activitySubtitleLabel)
        activityBtn.addSubview(activityStackView)
        activityStackView.snp.makeConstraints { make in
            make.leading.equalTo(28)
            make.centerY.equalToSuperview().offset(-13)
        }
        
        scrollView.addSubviews([maintainBtn, classScheduleBtn, classPunchBtn, activityBtn, notificationBtn])
        
        maintainBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(avatarImgView.snp.bottom).offset(66)
            make.height.equalTo((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)/678*240)
            make.width.equalTo(UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)
        }
        classScheduleBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(maintainBtn.snp.bottom).offset(0)
            make.height.equalTo((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)/678*240)
        }
        classPunchBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(classScheduleBtn.snp.bottom).offset(0)
            make.height.equalTo((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)/678*240)
        }
        notificationBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(classPunchBtn.snp.bottom).offset(0)
            make.height.equalTo((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)/678*240)
        }
        activityBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(notificationBtn.snp.bottom).offset(0)
            make.height.equalTo((UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)/678*261)
            make.bottom.equalTo(-20)
        }
        
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        avatarImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(20)
            make.size.equalTo(CGSize(width: 45, height: 45))
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImgView.snp.trailing).offset(5)
            make.centerY.equalTo(avatarImgView)
        }
        notificationImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading+15)
            make.top.equalTo(avatarImgView.snp.bottom).offset(15)
            make.height.equalTo(30)
        }
        notificationLabel.snp.makeConstraints { make in
            make.leading.equalTo(notificationImgView.snp.trailing).offset(6.5)
            make.centerY.equalTo(notificationImgView)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing-25)
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Authorization.signInDidSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Authorization.signOutDidSuccess, object: nil)
    }
    
    // MARK: - ============= Request =============
    fileprivate func fetchProfile() {
        CRMProvider.request(.members, completion: ResponseService.sharedInstance.response(completion: { (code,JSON) in
            
            if code >= 0 {
                if let accountsJSON = JSON?["members"] as? [[String: Any]] {
                    for account in accountsJSON {
                        if let avatar = account["avatar_url"] as? String, let name = account["name"] as? String {
                            self.nameLabel.text = name
                            
                            self.avatarImgView.kf.setImage(with: URL(string: avatar), placeholder: UIImage(named: "public_avatarPlaceholder"))
                            return
                        }
                    }
                }
                
                self.nameLabel.text = "个人资料修改"
                self.avatarImgView.image = UIImage(named: "public_avatarPlaceholder")
            }
        }))
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        if AuthorizationService.sharedInstance.isSignIn() {
            fetchProfile()
        } else {
            self.nameLabel.text = "登录/注册"
            self.avatarImgView.image = UIImage(named: "public_avatarPlaceholder")
        }
    }
    
    // MARK: - ============= Action =============
    @objc fileprivate func msgsBarBtnAction() {
        guard AuthorizationService.sharedInstance.isSignIn() else {
            let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
            present(authorizationNavigationController, animated: true, completion: nil)
            return
        }
        
        navigationController?.pushViewController(DMeMessagesViewController(), animated: true)
    }
    
    @objc fileprivate func maintainBtnAction() {
        guard AuthorizationService.sharedInstance.isSignIn() else {
            let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
            present(authorizationNavigationController, animated: true, completion: nil)
            return
        }
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let engine = appDelegate.flutterEngine else { return }
        
//        guard let flutter = FlutterViewController(engine: engine, nibName: nil, bundle: nil) else { return }
        
//        let flutter = TestViewController()
//        flutter.setInitialRoute("module_sales")
//        setupFlutterChannel(flutter: flutter)
        present(salesViewController, animated: true, completion: nil)
        
    }
    
    @objc fileprivate func classScheduleBtnAction() {
        guard AuthorizationService.sharedInstance.isSignIn() else {
            let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
            present(authorizationNavigationController, animated: true, completion: nil)
            return
        }
        
        present(scheduleViewController, animated: true, completion: nil)
    }
    
    @objc fileprivate func classPunchBtnAction() {
        guard AuthorizationService.sharedInstance.isSignIn() else {
            let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
            present(authorizationNavigationController, animated: true, completion: nil)
            return
        }
        
        present(punchViewController, animated: true, completion: nil)
    }
    
    @objc fileprivate func activityBtnAction() {
        guard AuthorizationService.sharedInstance.isSignIn() else {
            let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
            present(authorizationNavigationController, animated: true, completion: nil)
            return
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc fileprivate func notificationBtnAction() {
        guard AuthorizationService.sharedInstance.isSignIn() else {
            let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
            present(authorizationNavigationController, animated: true, completion: nil)
            return
        }
        
        present(notificationViewController, animated: true, completion: nil)
    }

    @objc fileprivate func userProfileBtnAction() {
        guard AuthorizationService.sharedInstance.isSignIn() else {
            let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
            present(authorizationNavigationController, animated: true, completion: nil)
            return
        }
        
        present(BaseNavigationController(rootViewController: profileViewController), animated: true, completion: nil)
    }
    
    // MARK: - ============= Public =============
    
    // MARK: - ============= Private =============
    fileprivate func setupFlutterChannel(flutter: FlutterViewController) {
        let channel = FlutterMethodChannel(name: "com.otof.yangyu/crm", binaryMessenger: flutter)
        channel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "uploadByQiNiu" {
                guard let params = call.arguments as? [String: Any], let filepath = params["file_path"] as? String, let key = params["key"] as? String, let token = params["token"] as? String else { return result(FlutterError()) }
                UploadService.sharedInstance.putImgToQiniu(filepath: filepath, key: key, token: token, completeClosure: { (resultState) in
                    result(resultState)
                })
                
            } else if call.method == "getTokens" {
                if let authToken = AuthorizationService.sharedInstance.authToken, let organToken = AuthorizationService.sharedInstance.organToken {
                    result(["Auth-Token": authToken, "Organ-Token": organToken])
                } else {
                    result(FlutterError(code: "Token does not exist", message: nil, details: nil))
                }
                
            } else if call.method == "resetAuthToken" {
                if let token = call.arguments as? String {
                    AuthorizationService.sharedInstance.authToken = token
                } else {
                    result(FlutterError(code: "User does not exist", message: nil, details: nil))
                }
                
            } else if call.method == "resetOrganToken" {
                if let token = call.arguments as? String {
                    AuthorizationService.sharedInstance.organToken = token
                } else {
                    result(FlutterError(code: "Arguments does not exist", message: nil, details: nil))
                }
                
            } else if call.method == "reload" {
                flutter.present(BaseNavigationController(rootViewController: AuthorizationViewController()), animated: true, completion: nil)
                
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
