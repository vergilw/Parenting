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
            
            if let userJSON = JSON?["user"] as? [String: Any], let model = UserModel.deserialize(from: userJSON), let token = JSON?["auth_token"] as? String {
                AuthorizationService.sharedInstance.cacheSignInInfo(model: model)
                AuthorizationService.sharedInstance.authToken = token
                NotificationCenter.default.post(name: Notification.Authorization.signInDidSuccess, object: nil)
                AuthorizationService.sharedInstance.updateUserInfo()
            }
            completion(code)
        }))
    }
    
    func signInWithPassword(account: String, password: String, completion: @escaping (_ code: Int)->Void) {
        AuthorizationProvider.request(.signInWithPassword(account: account, password: password), completion: ResponseService.sharedInstance.response(completion: { (code,JSON) in
            
            if let userJSON = JSON?["user"] as? [String: Any], let model = UserModel.deserialize(from: userJSON), let token = JSON?["auth_token"] as? String {
                AuthorizationService.sharedInstance.cacheSignInInfo(model: model)
                AuthorizationService.sharedInstance.authToken = token
                NotificationCenter.default.post(name: Notification.Authorization.signInDidSuccess, object: nil)
                AuthorizationService.sharedInstance.updateUserInfo()
            }
            completion(code)
        }))
    }
    
    func signIn(openID: String, accessToken: String, refreshToken: String, expiresAt: String, completion: @escaping (_ code: Int, _ oauthID: String?)->Void) {
        AuthorizationProvider.request(.signInWithWechat(openID: openID, accessToken: accessToken, refreshToken: refreshToken, expiresAt: expiresAt), completion: ResponseService.sharedInstance.response(completion: { (code,JSON) in
            
            if let oauthID = JSON?["oauth_user_id"] as? String {
                completion(-1, oauthID)
            } else if let userJSON = JSON?["user"] as? [String: Any], let model = UserModel.deserialize(from: userJSON), let token = JSON?["auth_token"] as? String {
                AuthorizationService.sharedInstance.cacheSignInInfo(model: model)
                AuthorizationService.sharedInstance.authToken = token
                NotificationCenter.default.post(name: Notification.Authorization.signInDidSuccess, object: nil)
                AuthorizationService.sharedInstance.updateUserInfo()
            }
            completion(code, nil)
        }))
    }
    
    func signUp(oauthID: String, phone: String, passcode: String, completion: @escaping (_ code: Int)->Void) {
        AuthorizationProvider.request(.signUpWithWechat(oauthID: oauthID, phone: phone, passcode: passcode), completion: ResponseService.sharedInstance.response(completion: { (code,JSON) in
            
            if let userJSON = JSON?["user"] as? [String: Any], let model = UserModel.deserialize(from: userJSON), let token = JSON?["auth_token"] as? String {
                AuthorizationService.sharedInstance.cacheSignInInfo(model: model)
                AuthorizationService.sharedInstance.authToken = token
                NotificationCenter.default.post(name: Notification.Authorization.signInDidSuccess, object: nil)
                AuthorizationService.sharedInstance.updateUserInfo()
            }
            completion(code)
        }))
    }
    
    func bindWechat(openID: String, accessToken: String, refreshToken: String, expiresAt: String, completion: @escaping (_ code: Int)->Void) {
        AuthorizationProvider.request(.bindWechat(openID: openID, accessToken: accessToken, refreshToken: refreshToken, expiresAt: expiresAt), completion: ResponseService.sharedInstance.response(completion: { (code,JSON) in
            
            if let userJSON = JSON?["user"] as? [String: Any], let model = UserModel.deserialize(from: userJSON), let token = JSON?["auth_token"] as? String {
                AuthorizationService.sharedInstance.cacheSignInInfo(model: model)
                AuthorizationService.sharedInstance.authToken = token
            }
            completion(code)
        }))
    }
    
    func fetchOrganToken(completion: @escaping (_ token: String?)->Void) {
        CRMProvider.request(.members, completion: ResponseService.sharedInstance.response(completion: { (code,JSON) in
            
            if let members = JSON?["members"] as? [[String: Any]] {
                for member in members {
                    guard let organs = member["organs"] as? [[String: Any]] else { continue }
                    for organ in organs {
                        if let token = organ["organ_token"] as? String {
                            AuthorizationService.sharedInstance.organToken = token
                            return completion(token)
                        }
                    }
                }
            }
            completion(nil)
        }))
    }
}
