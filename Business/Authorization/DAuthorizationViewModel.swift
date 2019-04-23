//
//  DAuthorizationViewModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/12.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Foundation
import HandyJSON

class DAuthorizationViewModel {
    
    var wechatUID: String?
    
    func fetchCode(phone: Int, completion: @escaping (_ code: Int)->Void) {
        AuthorizationProvider.request(.fetchCode(phone: phone), completion: ResponseService.sharedInstance.response(completion: { (code,JSON) in
            completion(code)
        }))
    }
    
    func signInWithPasscode(account: String, passcode: String, completion: @escaping (_ code: Int)->Void) {
        AuthorizationProvider.request(.signInWithPasscode(account: account, passcode: passcode), completion: ResponseService.sharedInstance.response(completion: { (code,JSON) in
            
            if let userJSON = JSON?["user"] as? [String: Any], let model = UserModel.deserialize(from: userJSON) {
                AuthorizationService.sharedInstance.cacheSignInInfo(model: model)
                NotificationCenter.default.post(name: Notification.Authorization.signInDidSuccess, object: nil)
                AuthorizationService.sharedInstance.updateUserInfo()
            }
            completion(code)
        }))
    }
    
    func signInWithPassword(account: String, password: String, completion: @escaping (_ code: Int)->Void) {
        AuthorizationProvider.request(.signInWithPassword(account: account, password: password), completion: ResponseService.sharedInstance.response(completion: { (code,JSON) in
            
            if let userJSON = JSON?["user"] as? [String: Any], let model = UserModel.deserialize(from: userJSON) {
                AuthorizationService.sharedInstance.cacheSignInInfo(model: model)
                NotificationCenter.default.post(name: Notification.Authorization.signInDidSuccess, object: nil)
                AuthorizationService.sharedInstance.updateUserInfo()
            }
            completion(code)
        }))
    }
    
    func signIn(openID: String, accessToken: String, completion: @escaping (_ code: Int)->Void) {
        AuthorizationProvider.request(.signInWithWechat(openID: openID, accessToken: accessToken), completion: ResponseService.sharedInstance.response(completion: { (code,JSON) in
            
            if let userJSON = JSON?["user"] as? [String: Any], let model = UserModel.deserialize(from: userJSON) {
                AuthorizationService.sharedInstance.cacheSignInInfo(model: model)
                NotificationCenter.default.post(name: Notification.Authorization.signInDidSuccess, object: nil)
                AuthorizationService.sharedInstance.updateUserInfo()
            }
            completion(code)
        }))
    }
    
    func signUp(openID: String, phone: String, code: String, completion: @escaping (_ code: Int)->Void) {
        AuthorizationProvider.request(.signUpWithWechat(openID: openID, phone: phone, code: code), completion: ResponseService.sharedInstance.response(completion: { (code,JSON) in
            
            if let userJSON = JSON?["user"] as? [String: Any], let model = UserModel.deserialize(from: userJSON) {
                AuthorizationService.sharedInstance.cacheSignInInfo(model: model)
                NotificationCenter.default.post(name: Notification.Authorization.signInDidSuccess, object: nil)
                AuthorizationService.sharedInstance.updateUserInfo()
            }
            completion(code)
        }))
    }
    
    func bindWechat(openID: String, accessToken: String, completion: @escaping (_ code: Int)->Void) {
        AuthorizationProvider.request(.bindWechat(parameters: ["access_token": accessToken, "openid": openID]), completion: ResponseService.sharedInstance.response(completion: { (code,JSON) in
            
            if let userJSON = JSON?["user"] as? [String: Any], let model = UserModel.deserialize(from: userJSON) {
                AuthorizationService.sharedInstance.cacheSignInInfo(model: model)
            }
            completion(code)
        }))
    }
    
    func fetchOrganToken(completion: @escaping (_ token: String?)->Void) {
        CRMProvider.request(.accounts, completion: ResponseService.sharedInstance.response(completion: { (code,JSON) in
            
            if let accountsJSON = JSON?["accounts"] as? [[String: Any]] {
                for account in accountsJSON {
                    if let member = account["member"] as? [String: Any], let token = member["organ_token"] as? String {
                        AuthorizationService.sharedInstance.organToken = token
                        return completion(token)
                    }
                }
            }
            completion(nil)
        }))
    }
}
