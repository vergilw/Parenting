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
    
    func fetchCode(phone: Int, completion: @escaping (Bool)->Void) {
        AuthorizationProvider.request(.fetchCode(phone: phone), completion: ResponseService.sharedInstance.response(completion: { JSON in
            completion(false)
        }))
    }
    
    func signIn(phone: String, code: String, completion: @escaping (Bool)->Void) {
        AuthorizationProvider.request(.signIn(phone: phone, code: code, wechatUID: wechatUID), completion: ResponseService.sharedInstance.response(completion: { JSON in
            if let userJSON = JSON?["user"] as? [String: Any], let model = UserModel.deserialize(from: userJSON) {
                AuthorizationService.sharedInstance.cacheSignInInfo(model: model)
                NotificationCenter.default.post(name: Notification.Authorization.signInDidSuccess, object: nil)
            }
            completion(false)
        }))
    }
    
    func signIn(wechatUID: String, completion: @escaping (Bool)->Void) {
        AuthorizationProvider.request(.signInWithWechat(wechatUID: wechatUID), completion: ResponseService.sharedInstance.response(completion: { JSON in
//            if let userJSON = JSON?["user"] as? [String: Any], let model = UserModel.deserialize(from: userJSON) {
//                AuthorizationService.sharedInstance.cacheSignInInfo(model: model)
//                NotificationCenter.default.post(name: Notification.Authorization.signInDidSuccess, object: nil)
//            }
            completion(false)
        }))
    }
}
