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
    
    func signIn(phone: String, code: String, completion: @escaping (_ code: Int)->Void) {
        AuthorizationProvider.request(.signIn(phone: phone, code: code), completion: ResponseService.sharedInstance.response(completion: { (code,JSON) in
            
            if let userJSON = JSON?["user"] as? [String: Any], let model = UserModel.deserialize(from: userJSON) {
                AuthorizationService.sharedInstance.cacheSignInInfo(model: model)
                NotificationCenter.default.post(name: Notification.Authorization.signInDidSuccess, object: nil)
            }
            completion(code)
        }))
    }
    
    func signIn(openID: String, accessToken: String, completion: @escaping (_ code: Int)->Void) {
        AuthorizationProvider.request(.signInWithWechat(openID: openID, accessToken: accessToken), completion: ResponseService.sharedInstance.response(completion: { (code,JSON) in
            
            if let userJSON = JSON?["user"] as? [String: Any], let model = UserModel.deserialize(from: userJSON) {
                AuthorizationService.sharedInstance.cacheSignInInfo(model: model)
                NotificationCenter.default.post(name: Notification.Authorization.signInDidSuccess, object: nil)
            }
            completion(code)
        }))
    }
    
    func signUp(openID: String, phone: String, code: String, completion: @escaping (_ code: Int)->Void) {
        AuthorizationProvider.request(.signUpWithWechat(openID: openID, phone: phone, code: code), completion: ResponseService.sharedInstance.response(completion: { (code,JSON) in
            
            if let userJSON = JSON?["user"] as? [String: Any], let model = UserModel.deserialize(from: userJSON) {
                AuthorizationService.sharedInstance.cacheSignInInfo(model: model)
                NotificationCenter.default.post(name: Notification.Authorization.signInDidSuccess, object: nil)
            }
            completion(code)
        }))
    }
}
