//
//  UserModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/13.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import HandyJSON

class UserModel: HandyJSON {
    
    var id: Int?
    var mobile: Int?
    var avatar_url: String?
    var name: String?
    var wechat_name: String?
    var intro: String?
    var badge: String?
    var isDeviceSignIn: Bool? = false
    
    required init() {
        
    }
    
}
