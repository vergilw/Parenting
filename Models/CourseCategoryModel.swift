//
//  CourseCategoryModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/23.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import HandyJSON

class CourseCategoryModel: HandyJSON {
    
    var id: Int?
    var name: String?
    var icon_attribute: AssetModel?
    
    required init() {}
}
