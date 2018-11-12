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
        
//        let homeNavigationController = BaseNavigationController(rootViewController: DHomeViewController())
//        let homeImg = UIImage(named: "tab_playbooks")?.withRenderingMode(.alwaysTemplate).byResize(to: CGSize(width: 24, height: 24))
//        homeNavigationController.tabBarItem = UITabBarItem(title: "首页", image: homeImg, tag: 0)
//        homeNavigationController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)], for: .normal)
//        homeNavigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -1)
//
//        let meNavigationController = BaseNavigationController(rootViewController: DMeViewController())
//        let meImg = UIImage(named: "tab_authors")?.withRenderingMode(.alwaysTemplate).byResize(to: CGSize(width: 24, height: 24))
//        meNavigationController.tabBarItem = UITabBarItem(title: "我", image: meImg, tag: 2)
//        meNavigationController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)], for: .normal)
//        meNavigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -1)
//
//        let tabBarController = UITabBarController()
//        tabBarController.tabBar.isTranslucent = false
//        tabBarController.tabBar.tintColor = UIColor("#333")
//        tabBarController.tabBar.unselectedItemTintColor = UIColor("#999")
//        tabBarController.setViewControllers([homeNavigationController, meNavigationController], animated: true)
        
        let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
        
        self.window?.rootViewController = authorizationNavigationController
        self.window?.makeKeyAndVisible()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemImage = UIImage(named: "public_dismissKeyboard")
        
        setupAudioSession()
        
        return true
    }
    
    func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        PlayListService.sharedInstance.setupNowPlaying()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

