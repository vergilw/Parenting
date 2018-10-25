//
//  TeacherModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/25.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import HandyJSON

class TeacherModel: HandyJSON {

    var id: Int?
    var name: String?
    var description: String?
    var headshot_attribute: AssetModel?
    var tags: [String]?
    
    required init() {
        
    }
    
//    required convenience init?(map: Map) {
//        self.init()
//    }
//    
//    func mapping(map: Map) {
//        id <- map["id"]
//        name <- map["name"]
//        description <- map["description"]
//        headshotAttribute <- map["headshot_attribute"]
//        tags <- map["tags"]
//    }
}
