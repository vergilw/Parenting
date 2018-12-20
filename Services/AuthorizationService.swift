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
    
    private init() {
        addObserver()
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(signInDidSuccess), name: Notification.Authorization.signInDidSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signOutDidSuccess), name: Notification.Authorization.signOutDidSuccess, object: nil)
    }
    
    @objc func signInDidSuccess() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.registerRemoteNotification()
        }
    }
    
    @objc func signOutDidSuccess() {
        
    }
    
    func isSignIn() -> Bool {
        return user != nil
    }
    
    func cacheSignInInfo(model: UserModel) {
        user = model
        NotificationCenter.default.post(name: Notification.User.userInfoDidChange, object: nil)
    }
    
    func signOut() {
        user = nil
        NotificationCenter.default.post(name: Notification.Authorization.signOutDidSuccess, object: nil)
    }
    
    func updateUserInfo() {
        UserProvider.request(.user, completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if let userJSON = JSON?["user"] as? [String: Any], let model = UserModel.deserialize(from: userJSON) {
                AuthorizationService.sharedInstance.cacheSignInInfo(model: model)
            }
        }))
    }
}
