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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

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
        
        return true
    }
    
    @objc func setupRootViewController() {
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIConstants.Color.head, NSAttributedString.Key.font: UIConstants.Font.foot], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIConstants.Color.head, NSAttributedString.Key.font: UIConstants.Font.foot], for: .highlighted)
        
        if self.window?.rootViewController != nil {
            guard let rootViewController = self.window?.rootViewController, !rootViewController.isKind(of: UITabBarController.self) else {
                return
            }
        }
        
        let homeNavigationController = BaseNavigationController(rootViewController: DHomeViewController())
        let homeImg = UIImage(named: "tab_homeNormal")?.withRenderingMode(.alwaysOriginal)//.byResize(to: CGSize(width: 24, height: 24))
        homeNavigationController.tabBarItem = UITabBarItem(title: "首页", image: homeImg, tag: 0)
        homeNavigationController.tabBarItem.selectedImage = UIImage(named: "tab_homeSelected")?.withRenderingMode(.alwaysOriginal)
        homeNavigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 1)
        
        let meNavigationController = BaseNavigationController(rootViewController: DMeViewController())
        let meImg = UIImage(named: "tab_meNormal")?.withRenderingMode(.alwaysOriginal)//.byResize(to: CGSize(width: 24, height: 24))
        meNavigationController.tabBarItem = UITabBarItem(title: "我", image: meImg, tag: 2)
        meNavigationController.tabBarItem.selectedImage = UIImage(named: "tab_meSelected")?.withRenderingMode(.alwaysOriginal)
        meNavigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.isTranslucent = false
        tabBarController.setViewControllers([homeNavigationController, meNavigationController], animated: true)
        
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
        #if DEBUG
        Bugly.start(withAppId: "87773979f0", developmentDevice: true, config: nil)
        #else
        Bugly.start(withAppId: "87773979f0")
        #endif
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

