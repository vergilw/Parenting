//
//  CommentModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/5.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import HandyJSON

class CommentModel: HandyJSON {
    
    var id: Int?
    var content: String?
    var star: Int?
    var user_name: String?
    var user_avatar: String?
    var created_at_timestamp: Int?
    
    required init() {
        
    }

}
