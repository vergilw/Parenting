//
//  CoinLogModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/27.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import HandyJSON

class CoinLogModel: HandyJSON {
    
    var id: Int?
    var amount: String?
    var title: String?
    var tag_str: String?
    var created_at: Date?
    
    required init() { }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.created_at <-- DateISO8601Transform()
    }
}
