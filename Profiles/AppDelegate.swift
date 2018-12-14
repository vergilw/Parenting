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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var tabBarController: UITabBarController = {
        let homeNavigationController = BaseNavigationController(rootViewController: DHomeViewController())
        let homeImg = UIImage(named: "tab_homeNormal")?.withRenderingMode(.alwaysOriginal)//.byResize(to: CGSize(width: 24, height: 24))
        homeNavigationController.tabBarItem = UITabBarItem(title: "首页", image: homeImg, tag: 0)
        homeNavigationController.tabBarItem.selectedImage = UIImage(named: "tab_homeSelected")?.withRenderingMode(.alwaysOriginal)
        homeNavigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 1)
        
        let videoNavigationController = BaseNavigationController(rootViewController: DVideosViewController())
        let videoImg = UIImage(named: "tab_meNormal")?.withRenderingMode(.alwaysOriginal)//.byResize(to: CGSize(width: 24, height: 24))
        videoNavigationController.tabBarItem = UITabBarItem(title: "小视频", image: videoImg, tag: 1)
        videoNavigationController.tabBarItem.selectedImage = UIImage(named: "tab_meSelected")?.withRenderingMode(.alwaysOriginal)
        videoNavigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 1)
        
        let meNavigationController = BaseNavigationController(rootViewController: DMeViewController())
        let meImg = UIImage(named: "tab_meNormal")?.withRenderingMode(.alwaysOriginal)//.byResize(to: CGSize(width: 24, height: 24))
        meNavigationController.tabBarItem = UITabBarItem(title: "我", image: meImg, tag: 2)
        meNavigationController.tabBarItem.selectedImage = UIImage(named: "tab_meSelected")?.withRenderingMode(.alwaysOriginal)
        meNavigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.isTranslucent = false
        
        tabBarController.tabBar.backgroundImage = UIImage(color: .white)
        tabBarController.tabBar.shadowImage = UIImage()
        
        tabBarController.tabBar.layer.shadowOffset = CGSize(width: 0, height: -3.0)
        tabBarController.tabBar.layer.shadowOpacity = 0.05
        tabBarController.tabBar.layer.shadowColor = UIColor.black.cgColor
        
        tabBarController.setViewControllers([homeNavigationController, videoNavigationController, meNavigationController], animated: true)
        
        return tabBarController
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundVerticalPositionAdjustment:-3 forBarMetrics:UIBarMetricsDefault];
//        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackButtonBackgroundVerticalPositionAdjustment:-3 forBarMetrics:UIBarMetricsDefault];
        
        self.window = UIWindow()
        setupRootViewController()
        self.window?.makeKeyAndVisible()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemImage = UIImage(named: "public_dismissKeyboard")
        
        setupAudioSession()
        setupThirdPartyPlatforms()
        
        SKPaymentQueue.default().add(PaymentService.sharedInstance)
        
        
        
        //FIXME: Umeng
        
        let deviceID = UMConfigure.deviceIDForIntegration()
        print(deviceID)
        //此函数在UMCommon.framework版本1.4.2及以上版本，在UMConfigure.h的头文件中加入。
        //如果用户用组件化SDK,需要升级最新的UMCommon.framework版本。
        
        
        
        return true
    }
    
    @objc func setupRootViewController() {
        
        UITextField.appearance().tintColor = UIConstants.Color.primaryGreen
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIConstants.Color.head, NSAttributedString.Key.font: UIConstants.Font.foot], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIConstants.Color.head, NSAttributedString.Key.font: UIConstants.Font.foot], for: .highlighted)
        
        guard let isFirstLaunch = AppCacheService.sharedInstance.isFirstLaunch, isFirstLaunch == false else {
            self.window?.rootViewController = GuideViewController()
            return
        }
        
        self.window?.rootViewController = tabBarController
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
        UMConfigure.initWithAppkey("5bd6ab53b465f5473b0000e7", channel: "App Store")
        UMSocialManager.default()?.setPlaform(.wechatSession, appKey: "wxc7c60047a9c75018", appSecret: "c5168f183fd20a038df632c1d6d4157e", redirectURL: "http://mobile.umeng.com/social")
        UMSocialGlobal.shareInstance()?.isUsingHttpsWhenShareContent = false
        
        #if DEBUG
        Bugly.start(withAppId: "87773979f0", developmentDevice: true, config: nil)
        #else
        Bugly.start(withAppId: "87773979f0")
        #endif
        
        GeTuiSdk.start(withAppId: "VVsqPhssZX5kMkwXeMOp2", appKey: "1moSQ8HVzE6jbWhH0YRcI7", appSecret: "Sy2GYDFe9X8AEnhgbpbG76", delegate: self)
        registerRemoteNotification()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        PlayListService.sharedInstance.setupNowPlaying()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let result = UMSocialManager.default()?.handleOpen(url, options: options)
        return result ?? true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
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
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map({ String(format: "%02.2hhx", $0)}).joined()
        GeTuiSdk.registerDeviceToken(token)
        
        
        guard AuthorizationService.sharedInstance.isSignIn() else { return }
        
        UserProvider.request(.updatePushToken(token), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
        }))
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        GeTuiSdk.handleRemoteNotification(response.notification.request.content.userInfo)
        
        completionHandler()
    }
    
    func geTuiSdkDidRegisterClient(_ clientId: String!) {
        print(#function + clientId)
    }
    
    func geTuiSdkDidReceivePayloadData(_ payloadData: Data!, andTaskId taskId: String!, andMsgId msgId: String!, andOffLine offLine: Bool, fromGtAppId appId: String!) {
        
        guard let JSON = try? JSONSerialization.jsonObject(with: payloadData, options: JSONSerialization.ReadingOptions()) as? [String: Any] else {
            return
        }
        guard let aps = JSON?["aps"] as? [String: Any], let alert = aps["alert"] as? [String: String] else {
            return
        }
        if UIApplication.shared.applicationState == .inactive ||
            UIApplication.shared.applicationState == .background {
            let notiObj = UNMutableNotificationContent()
            notiObj.title = alert["title"] ?? "氧育"
            if let subtitle = alert["subtitle"] {
                notiObj.subtitle = subtitle
            }
            notiObj.body = alert["body"] ?? ""
            notiObj.badge = NSNumber(string: (aps["badge"] as? String) ?? "")
            notiObj.categoryIdentifier = UUID.init().uuidString
            
            let request = UNNotificationRequest.init(identifier: notiObj.categoryIdentifier, content: notiObj, trigger: nil)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
}
