//
//  OrderModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/7.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import HandyJSON

class OrderModel: HandyJSON {
    
    var id: Int?
    var uuid: String?
    var amount: String?
    var payment_status: String?
    var payment_status_text: String?
    var created_at: Date?
    var balance: String?
    var order_items: [OrderItemModel]?
    
    required init() { }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.balance <-- ["buyer.wallet.ios_balance", "ios_balance"]
        
        mapper <<<
            self.created_at <-- DateISO8601Transform()
    }
    
}


class OrderItemModel: HandyJSON {
    
    var id: Int?
    var number: Int?
    var amount: String?
    var course: CourseModel?
    
    required init() { }
        
}

