//
//  CourseSectionModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/26.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import HandyJSON

class CourseSectionModel: HandyJSON {

    var id: Int?
    var title: String?
    var sort: Int?
    var audition: Bool?
    var duration: Int?
    var duration_with_seconds: Float?
    
    required init() {
        
    }
}
