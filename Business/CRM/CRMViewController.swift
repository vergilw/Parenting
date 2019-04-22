//
//  CRMViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/4/15.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import Flutter
import MessageUI

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
        return imgView
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    fileprivate lazy var notificationImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "crm_notificationIcon")
        return imgView
    }()
    
    fileprivate lazy var notificationLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.caption1
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "园区管理系统"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubview(scrollView)
        
        scrollView.addSubviews([avatarImgView, nameLabel, notificationImgView, notificationLabel])
        
        initShortcutView()
        
        let userProfileBtn: UIButton = {
            let button = UIButton()
            button.setTitleColor(UIConstants.Color.body, for: .normal)
            button.titleLabel?.font = UIConstants.Font.body
            button.setTitle("个人资料修改", for: .normal)
            button.addTarget(self, action: #selector(userProfileBtnAction), for: .touchUpInside)
            return button
        }()
        scrollView.addSubview(userProfileBtn)
        userProfileBtn.snp.makeConstraints { make in
            make.centerY.leading.equalTo(avatarImgView)
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
    }
    
    fileprivate func initShortcutView() {
        let maintainBtn: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "crm_maintain"), for: .normal)
            button.addTarget(self, action: #selector(maintainBtnAction), for: .touchUpInside)
            return button
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
        maintainBtn.addSubviews([maintainTitleLabel, maintainSubtitleLabel])
        maintainTitleLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-28)
            make.top.equalTo(24)
        }
        maintainSubtitleLabel.snp.makeConstraints { make in
            make.trailing.equalTo(maintainTitleLabel)
            make.top.equalTo(maintainTitleLabel.snp.bottom)
        }
        
        let classScheduleBtn: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "crm_classSchedule"), for: .normal)
            button.addTarget(self, action: #selector(classScheduleBtnAction), for: .touchUpInside)
            return button
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
        classScheduleBtn.addSubviews([classScheduleTitleLabel, classScheduleSubtitleLabel])
        classScheduleTitleLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-28)
            make.top.equalTo(24)
        }
        classScheduleSubtitleLabel.snp.makeConstraints { make in
            make.trailing.equalTo(classScheduleTitleLabel)
            make.top.equalTo(classScheduleTitleLabel.snp.bottom)
        }
        
        let classPunchBtn: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "crm_classPunch"), for: .normal)
            button.addTarget(self, action: #selector(classPunchBtnAction), for: .touchUpInside)
            return button
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
        classPunchBtn.addSubviews([classPunchTitleLabel, classPunchSubtitleLabel])
        classPunchTitleLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-28)
            make.top.equalTo(24)
        }
        classPunchSubtitleLabel.snp.makeConstraints { make in
            make.trailing.equalTo(classPunchTitleLabel)
            make.top.equalTo(classPunchTitleLabel.snp.bottom)
        }
        
        
        let notificationBtn: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "crm_notification"), for: .normal)
            button.addTarget(self, action: #selector(notificationBtnAction), for: .touchUpInside)
            return button
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
        notificationBtn.addSubviews([notificationTitleLabel, notificationSubtitleLabel])
        notificationTitleLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-28)
            make.top.equalTo(24)
        }
        notificationSubtitleLabel.snp.makeConstraints { make in
            make.trailing.equalTo(notificationTitleLabel)
            make.top.equalTo(notificationTitleLabel.snp.bottom)
        }
        
        
        let activityBtn: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "crm_activity"), for: .normal)
            button.addTarget(self, action: #selector(activityBtnAction), for: .touchUpInside)
            return button
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
        activityBtn.addSubviews([activityTitleLabel, activitySubtitleLabel])
        activityTitleLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-28)
            make.top.equalTo(24)
        }
        activitySubtitleLabel.snp.makeConstraints { make in
            make.trailing.equalTo(activityTitleLabel)
            make.top.equalTo(activityTitleLabel.snp.bottom)
        }
        
        scrollView.addSubviews([maintainBtn, classScheduleBtn, classPunchBtn, activityBtn, notificationBtn])
        
        maintainBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(avatarImgView.snp.bottom).offset(66)
            make.height.equalTo(85)
            make.width.equalTo(UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)
        }
        classScheduleBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(maintainBtn.snp.bottom).offset(20)
            make.height.equalTo(85)
        }
        classPunchBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(classScheduleBtn.snp.bottom).offset(20)
            make.height.equalTo(85)
        }
        notificationBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(classPunchBtn.snp.bottom).offset(20)
            make.height.equalTo(85)
        }
        activityBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(notificationBtn.snp.bottom).offset(20)
            make.height.equalTo(85)
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
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImgView.snp.trailing).offset(5)
            make.centerY.equalTo(avatarImgView)
        }
        notificationImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(avatarImgView.snp.bottom).offset(24)
        }
        notificationLabel.snp.makeConstraints { make in
            make.leading.equalTo(notificationImgView.snp.trailing).offset(3)
            make.centerY.equalTo(notificationImgView)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
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
    @objc fileprivate func maintainBtnAction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let engine = appDelegate.flutterEngine else { return }
        
//        guard let flutter = FlutterViewController(engine: engine, nibName: nil, bundle: nil) else { return }
        let flutter = TestViewController()
        flutter.setInitialRoute("module_sales")
        
        let channel = FlutterMethodChannel(name: "com.otof.yangyu/crm", binaryMessenger: flutter)
        channel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "Unauthorized" {
                //                let authorizationNavigationController = BaseNavigationController(rootViewController: DTopUpViewController())
                self?.present(DTopUpViewController(), animated: true, completion: nil)
            }
        }
        
        present(flutter, animated: true, completion: nil)
    }
    
    @objc fileprivate func classScheduleBtnAction() {
        
        let flutter = TestViewController()
        flutter.setInitialRoute("teacher_class_schedule")
        
        let channel = FlutterMethodChannel(name: "com.otof.yangyu/crm", binaryMessenger: flutter)
        channel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "Unauthorized" {
                //                let authorizationNavigationController = BaseNavigationController(rootViewController: DTopUpViewController())
                self?.present(DTopUpViewController(), animated: true, completion: nil)
            }
        }
        
        present(flutter, animated: true, completion: nil)
        
    }
    
    @objc fileprivate func classPunchBtnAction() {
        let flutter = TestViewController()
        flutter.setInitialRoute("class_punch")
        
        let channel = FlutterMethodChannel(name: "com.otof.yangyu/crm", binaryMessenger: flutter)
        channel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "Unauthorized" {
                //                let authorizationNavigationController = BaseNavigationController(rootViewController: DTopUpViewController())
                self?.present(DTopUpViewController(), animated: true, completion: nil)
            }
        }
        
        present(flutter, animated: true, completion: nil)
    }
    
    @objc fileprivate func activityBtnAction() {
        let flutter = TestViewController()
        flutter.setInitialRoute("module_activity")
        
        let channel = FlutterMethodChannel(name: "com.otof.yangyu/crm", binaryMessenger: flutter)
        channel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "Unauthorized" {
                //                let authorizationNavigationController = BaseNavigationController(rootViewController: DTopUpViewController())
                self?.present(DTopUpViewController(), animated: true, completion: nil)
            } else if call.method == "remindAll" {
                if let mobileNumbers = call.arguments as? Array<String> {
                    
//                    if MFMessageComposeViewController.canSendText() {
//                        let controller = MFMessageComposeViewController()
//                        controller.recipients = mobileNumbers
//                        flutter.present(controller, animated: true, completion: nil)
//                    }
                }
            }
        }
        
        present(flutter, animated: true, completion: nil)
    }
    
    @objc fileprivate func notificationBtnAction() {
        let flutter = TestViewController()
        flutter.setInitialRoute("module_notification")
        
        let channel = FlutterMethodChannel(name: "com.otof.yangyu/crm", binaryMessenger: flutter)
        channel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "Unauthorized" {
                //                let authorizationNavigationController = BaseNavigationController(rootViewController: DTopUpViewController())
                self?.present(DTopUpViewController(), animated: true, completion: nil)
            }
        }
        
        present(flutter, animated: true, completion: nil)
    }

    @objc fileprivate func userProfileBtnAction() {
        let flutter = TestViewController()
        flutter.setInitialRoute("module_personal_info")
        
        let channel = FlutterMethodChannel(name: "com.otof.yangyu/crm", binaryMessenger: flutter)
        channel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "Unauthorized" {
                //                let authorizationNavigationController = BaseNavigationController(rootViewController: DTopUpViewController())
                self?.present(DTopUpViewController(), animated: true, completion: nil)
            } else if call.method == "uploadByQiNiu" {
                guard let params = call.arguments as? [String: Any], let filepath = params["file_path"] as? String, let key = params["key"] as? String, let token = params["token"] as? String else { return result(FlutterError()) }
                UploadService.sharedInstance.putImgToQiniu(filepath: filepath, key: key, token: token, completeClosure: { (resultState) in
                    result(resultState)
                })
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        present(flutter, animated: true, completion: nil)
    }
    
    // MARK: - ============= Public =============
    
    // MARK: - ============= Private =============

}
