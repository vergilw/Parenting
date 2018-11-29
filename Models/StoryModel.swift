//
//  StoryModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/29.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import HandyJSON

class StoryModel: HandyJSON {
    
    var id: Int?
    var title: String?
    var teller_id: String?
    var cover_image: AssetModel?
    var story_teller: TeacherModel?
    var content_images: [AssetModel]?
    var avatar: String?
    
    required init() { }

}
