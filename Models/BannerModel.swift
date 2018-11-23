//
//  BannerModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/22.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import HandyJSON

class BannerModel: HandyJSON {
    
    var id: Int?
    var name: String?
    var sort: Int?
    var image_attribute: AssetModel?
    var target_type: String?
    var target_id: Int?
    
    required init() {}
}
