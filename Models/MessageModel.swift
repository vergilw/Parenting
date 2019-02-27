//
//  MessageModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/2/27.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import HandyJSON

class MessageModel: HandyJSON {
    
    var id: Int?
    var notifiable_type: String?
    var official: Bool?
    var title: String?
    var body: String?
    var created_at: Date?
    var read_at: Date?
    var sender: UserModel?
    var link: String?
    
    required init() { }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.created_at <-- DateISO8601Transform()
        mapper <<<
            self.read_at <-- DateISO8601Transform()
    }
}
