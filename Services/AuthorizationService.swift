//
//  AuthorizationService.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/13.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Foundation

class AuthorizationService {
    
    static let sharedInstance = AuthorizationService()
    
    lazy fileprivate var cache = YYCache(name: "D" + String(describing: type(of: self)))
    
    var user: UserModel? {
        get {
            let string = cache?.object(forKey: "DUserModel") as? String
            return UserModel.deserialize(from: string)
        }
        set {
            if newValue != nil {
                let string = newValue?.toJSONString()
                cache?.setObject(string as NSCoding?, forKey: "DUserModel")
            } else {
                cache?.removeObject(forKey: "DUserModel")
            }
        }
    }
    
    var authToken: String? {
        get {
            let string = cache?.object(forKey: "authToken") as? String
            return string
        }
        set {
            if newValue != nil {
                cache?.setObject(newValue as NSCoding?, forKey: "authToken")
            } else {
                cache?.removeObject(forKey: "authToken")
            }
        }
    }
    
    var organToken: String? {
        get {
            let string = cache?.object(forKey: "organToken") as? String
            return string
        }
        set {
            if newValue != nil {
                cache?.setObject(newValue as NSCoding?, forKey: "organToken")
            } else {
                cache?.removeObject(forKey: "organToken")
            }
        }
    }
    
    private init() {
        addObserver()
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(signInDidSuccess), name: Notification.Authorization.signInDidSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signOutDidSuccess), name: Notification.Authorization.signOutDidSuccess, object: nil)
    }
    
    @objc func signInDidSuccess() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        appDelegate.registerRemoteNotification()
        
        let viewModel = DAuthorizationViewModel()
        viewModel.fetchOrganToken { (token) in
            if token != nil {
                appDelegate.tabBarController.setViewControllers([appDelegate.homeNavigationController, appDelegate.videoNavigationController, appDelegate.crmNavigationController, appDelegate.meNavigationController], animated: false)
            } else {
                appDelegate.tabBarController.setViewControllers([appDelegate.homeNavigationController, appDelegate.videoNavigationController, appDelegate.meNavigationController], animated: false)
            }
        }
    }
    
    @objc func signOutDidSuccess() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        appDelegate.tabBarController.setViewControllers([appDelegate.homeNavigationController, appDelegate.videoNavigationController, appDelegate.meNavigationController], animated: false)
    }
    
    func isSignIn() -> Bool {
        if user != nil && user?.isDeviceSignIn == false {
            return true
        }
        return false
    }
    
    func isDeviceSignIn() -> Bool {
        if user != nil {
            return true
        }
        return false
    }
    
    func cacheSignInInfo(model: UserModel) {
        user = model
        NotificationCenter.default.post(name: Notification.User.userInfoDidChange, object: nil)
    }
    
    func signOut() {
        user = nil
        organToken = nil
        NotificationCenter.default.post(name: Notification.Authorization.signOutDidSuccess, object: nil)
    }
    
    func updateUserInfo() {
        UserProvider.request(.user, completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if let userJSON = JSON?["user"] as? [String: Any], let model = UserModel.deserialize(from: userJSON) {
                model.isDeviceSignIn = self.user?.isDeviceSignIn
                AuthorizationService.sharedInstance.cacheSignInInfo(model: model)
            }
        }))
    }
}
