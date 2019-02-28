//
//  GiftModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/2/28.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import HandyJSON

class GiftModel: HandyJSON {
    
    var id: Int?
    var name: String?
    var amount: String?
    var icon_url: String?
    
    required init() { }
    
}
