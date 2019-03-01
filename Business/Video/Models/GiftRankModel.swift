//
//  GiftRankModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/3/1.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import HandyJSON

class GiftRankModel: HandyJSON {
    
    var id: Int?
    var amount: String?
    var user: UserModel?
    var position: Int?
    
    required init() { }
    
}

