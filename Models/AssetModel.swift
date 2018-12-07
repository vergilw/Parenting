//
//  AssetModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/25.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import HandyJSON

class AssetModel: HandyJSON {

    var id: Int?
    var service_url: String?
    var content_type: String?
    var height: Float?
    var width: Float?
    
    required init() {
        
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.height <-- ["metadata.height", "height"]
        
        mapper <<<
            self.width <-- ["metadata.width", "width"]
    }
    
//    required convenience init?(map: Map) {
//        self.init()
//    }
//
//    func mapping(map: Map) {
//        id <- map["id"]
//        serviceUrl <- map["service_url"]
//        contentType <- map["content_type"]
//    }
}
