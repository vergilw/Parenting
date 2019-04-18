//
//  AppDelegate.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/23.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AVFoundation
import StoreKit
import UserNotifications
import PLShortVideoKit
import Flutter
import FlutterPluginRegistrant

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {

//    var window: UIWindow?
    
    let tabBarController: UITabBarController = {
        let homeVC = DHomeViewController()
        let homeNavigationController = BaseNavigationController(rootViewController: DHomeViewController())
        let homeImg = UIImage(named: "tab_homeNormal")?.withRenderingMode(.alwaysOriginal)//.byResize(to: CGSize(width: 24, height: 24))
        let homeItem = UITabBarItem(title: "首页", image: homeImg, tag: 0)
        homeNavigationController.tabBarItem = homeItem
        homeNavigationController.tabBarItem.selectedImage = UIImage(named: "tab_homeSelected")?.withRenderingMode(.alwaysOriginal)
        homeNavigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 1)
        
        let videoNavigationController = BaseNavigationController(rootViewController: DVideosViewController())
        let videoImg = UIImage(named: "tab_videoNormal")?.withRenderingMode(.alwaysOriginal)//.byResize(to: CGSize(width: 24, height: 24))
        let videoItem = UITabBarItem(title: "视频", image: videoImg, tag: 1)
        videoNavigationController.tabBarItem = videoItem
        videoNavigationController.tabBarItem.selectedImage = UIImage(named: "tab_videoSelected")?.withRenderingMode(.alwaysOriginal)
        videoNavigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 1)
        
        let crmNavigationController = BaseNavigationController(rootViewController: CRMViewController())
        let crmImg = UIImage(named: "tab_crmNormal")?.withRenderingMode(.alwaysOriginal)//.byResize(to: CGSize(width: 24, height: 24))
        let crmItem = UITabBarItem(title: "园区", image: crmImg, tag: 2)
        crmNavigationController.tabBarItem = crmItem
        crmNavigationController.tabBarItem.selectedImage = UIImage(named: "tab_crmSelected")?.withRenderingMode(.alwaysOriginal)
        crmNavigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 1)
        
        let meNavigationController = BaseNavigationController(rootViewController: DMeViewController())
        let meImg = UIImage(named: "tab_meNormal")?.withRenderingMode(.alwaysOriginal)//.byResize(to: CGSize(width: 24, height: 24))
        let meItem = UITabBarItem(title: "我", image: meImg, tag: 3)
        meNavigationController.tabBarItem = meItem
        meNavigationController.tabBarItem.selectedImage = UIImage(named: "tab_meSelected")?.withRenderingMode(.alwaysOriginal)
        meNavigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundImage = UIImage(color: .white)
        tabBarController.tabBar.shadowImage = UIImage()
        
        tabBarController.tabBar.layer.shadowOffset = CGSize(width: 0, height: -3.0)
        tabBarController.tabBar.layer.shadowOpacity = 0.05
        tabBarController.tabBar.layer.shadowColor = UIColor.black.cgColor
        
        tabBarController.setViewControllers([homeNavigationController, videoNavigationController, crmNavigationController, meNavigationController], animated: true)
        
        return tabBarController
    }()
    
    fileprivate lazy var tabBarDelegate = AnimationTabBar()
    
    var flutterEngine: FlutterEngine?
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundVerticalPositionAdjustment:-3 forBarMetrics:UIBarMetricsDefault];
//        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackButtonBackgroundVerticalPositionAdjustment:-3 forBarMetrics:UIBarMetricsDefault];
        
        
        self.window = UIWindow()
        setupRootViewController()
        self.window?.makeKeyAndVisible()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemImage = UIImage(named: "public_dismissKeyboard")
        
        setupAudioSession()
        setupThirdPartyPlatforms()
        setupFlutter()
        
        SKPaymentQueue.default().add(PaymentService.sharedInstance)
        PlaybackRecordService.sharedInstance.syncRecords()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        //FIXME: shutdown constraints log
//        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        
        return true
    }
    
    @objc func setupRootViewController() {
        
        UITextField.appearance().tintColor = UIConstants.Color.primaryGreen
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor("#BFC2C9"), NSAttributedString.Key.font: UIConstants.Font.foot2], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIConstants.Color.primaryGreen, NSAttributedString.Key.font: UIConstants.Font.foot2], for: .selected)
        
        guard let isFirstLaunch = AppCacheService.sharedInstance.isFirstLaunch, isFirstLaunch == false else {
            self.window?.rootViewController = GuideViewController()
            return
        }
        
        tabBarController.delegate = tabBarDelegate
        self.window?.rootViewController = tabBarController
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupRootViewController), name: Notification.Authorization.signInDidSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupRootViewController), name: Notification.Authorization.signOutDidSuccess, object: nil)
    }
    
    func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    func setupThirdPartyPlatforms() {
        //FIXME: Umeng
//        #if DEBUG
//        if let deviceID = UMConfigure.deviceIDForIntegration() {
//            print("\(#function) \(deviceID)")
//        }
//        UMConfigure.setLogEnabled(true)
//        #endif

        UMConfigure.initWithAppkey("5bd6ab53b465f5473b0000e7", channel: "App Store")
        UMSocialManager.default()?.setPlaform(.wechatSession, appKey: "wxc7c60047a9c75018", appSecret: "c5168f183fd20a038df632c1d6d4157e", redirectURL: "http://mobile.umeng.com/social")
        UMSocialGlobal.shareInstance()?.isUsingHttpsWhenShareContent = false
        

        #if DEBUG
        Bugly.start(withAppId: "87773979f0", developmentDevice: true, config: nil)
        #else
        Bugly.start(withAppId: "87773979f0")
        #endif
        
        GeTuiSdk.start(withAppId: "VVsqPhssZX5kMkwXeMOp2", appKey: "1moSQ8HVzE6jbWhH0YRcI7", appSecret: "Sy2GYDFe9X8AEnhgbpbG76", delegate: self)
        
        if AuthorizationService.sharedInstance.isSignIn() {
            registerRemoteNotification()
        }
        
        PLShortVideoKitEnv.initEnv()
//        PLShortVideoKitEnv.setLogLevel(.debug)
//        PLShortVideoKitEnv.enableFileLogging()
        
//        AVAudioSession.sharedInstance().setCategory(.playback, mode: AVAudioSession.Mode.moviePlayback, options: AVAudioSession.CategoryOptions())
    }
    
    func setupFlutter() {
        flutterEngine = FlutterEngine(name: "io.flutter", project: nil)
        flutterEngine?.run(withEntrypoint: nil)
        GeneratedPluginRegistrant.register(with: flutterEngine)
    }

    override func applicationDidEnterBackground(_ application: UIApplication) {
        PlayListService.sharedInstance.setupNowPlaying()
    }
    
    override func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let result = UMSocialManager.default()?.handleOpen(url, options: options)
        return result ?? true
    }

    override func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let rootViewController = window?.rootViewController {
            if rootViewController.presentedViewController is DPlayerViewController {
                return rootViewController.presentedViewController!.supportedInterfaceOrientations
            } else if rootViewController is DPlayerViewController {
                return rootViewController.supportedInterfaceOrientations
            } else if let rootViewController = rootViewController as? UINavigationController, rootViewController.topViewController is DPlayerViewController {
                return rootViewController.topViewController!.supportedInterfaceOrientations
            } else if let rootViewController = rootViewController as? UITabBarController, let navigationController = rootViewController.selectedViewController as? UINavigationController, navigationController.topViewController is DPlayerViewController {
                return navigationController.topViewController!.supportedInterfaceOrientations
            }
            
        }
        return [UIInterfaceOrientationMask.portrait]
    }
    
    
}

// MARK: - ============= APNS =============

extension AppDelegate: UNUserNotificationCenterDelegate, GeTuiSdkDelegate {
    
    func registerRemoteNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.badge, .sound, .alert, .carPlay]) { (granted, error) in
            
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map({ String(format: "%02.2hhx", $0)}).joined()
        GeTuiSdk.registerDeviceToken(token)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        GeTuiSdk.handleRemoteNotification(response.notification.request.content.userInfo)

        let JSON = response.notification.request.content.userInfo
        if let payload = JSON["payload"] as? [String: Any], let string = payload["link"] as? String, let url = URL(string: string) {

            guard let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController else { return }
            guard let navigationController = tabBarController.selectedViewController as? UINavigationController else { return }
            navigationController.popToRootViewController(animated: false)

            if let viewController = RouteService.shared.route(URI: url) {
                navigationController.pushViewController(viewController, animated: true)
            }
        }
        
        completionHandler()
    }
    
    func geTuiSdkDidRegisterClient(_ clientId: String!) {
        print(#function + clientId)
        
        guard AuthorizationService.sharedInstance.isSignIn() else { return }
        
        UserProvider.request(.updatePushToken(clientId), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
        }))
    }
    
    func geTuiSdkDidReceivePayloadData(_ payloadData: Data!, andTaskId taskId: String!, andMsgId msgId: String!, andOffLine offLine: Bool, fromGtAppId appId: String!) {
        
//        guard let JSON = try? JSONSerialization.jsonObject(with: payloadData, options: JSONSerialization.ReadingOptions()) as? [String: Any] else {
//            return
//        }
//        guard let aps = JSON?["aps"] as? [String: Any], let alert = aps["alert"] as? [String: String] else {
//            return
//        }
        
//        if UIApplication.shared.applicationState == .inactive ||
//            UIApplication.shared.applicationState == .background {
//            let notiObj = UNMutableNotificationContent()
//            notiObj.title = alert["title"] ?? "氧育亲子"
//            if let subtitle = alert["subtitle"] {
//                notiObj.subtitle = subtitle
//            }
//            notiObj.body = alert["body"] ?? ""
//            notiObj.badge = NSNumber(string: (aps["badge"] as? String) ?? "")
//            notiObj.categoryIdentifier = UUID.init().uuidString
//
//            let request = UNNotificationRequest.init(identifier: notiObj.categoryIdentifier, content: notiObj, trigger: nil)
//            UNUserNotificationCenter.current().add(request)
//        } else {
        
        
//        }
        
        NotificationCenter.default.post(name: Notification.Message.messageUnreadCountDidChange, object: nil)
    }
    
}


extension AppDelegate {
    
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        if userActivity.activityType == "NSUserActivityTypeBrowsingWeb" {
            guard let URL = userActivity.webpageURL else { return true }
            
            guard let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController else { return true }
            guard let navigationController = tabBarController.selectedViewController as? UINavigationController else { return true }
            navigationController.popToRootViewController(animated: false)
            
            if let viewController = RouteService.shared.route(URI: URL) {
                navigationController.pushViewController(viewController, animated: true)
            }
        }
        
        return true
    }
}
