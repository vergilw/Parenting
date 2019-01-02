//
//  WithdrawDetailsModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/2.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import HandyJSON

class WithdrawDetailsModel: HandyJSON {
    
    var state_i18n: String?
    var created_at: Date?
    var done_at: Date?
    var state: String?
    var comment: String?
    var cash_amount: String?
    var coin_amount: String?
    
    required init() { }
    
    func mapping(mapper: HelpingMapper) {
        
        mapper <<<
            self.created_at <-- DateISO8601Transform()
        
        mapper <<<
            self.done_at <-- DateISO8601Transform()
    }
}
