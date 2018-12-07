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
    var auth_token: String?
    var mobile: Int?
    var avatar_url: String?
    var name: String?
    var wechat_name: String?
    var balance: String?
    
    required init() {
        
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.balance <-- ["wallet.ios_balance", "ios_balance"]
    }
    
    /*
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(auth_token, forKey: "auth_token")
        aCoder.encode(mobile, forKey: "mobile")
        aCoder.encode(avatar_url, forKey: "avatar_url")
//        aCoder.encode(name, forKey: "name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? Int
        auth_token = aDecoder.decodeObject(forKey: "auth_token") as? String
        mobile = aDecoder.decodeObject(forKey: "mobile") as? Int
        avatar_url = aDecoder.decodeObject(forKey: "avatar_url") as? String
//        name = aDecoder.decodeObject(forKey: "name") as? String
    }
 */
}
