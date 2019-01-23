//
//  VideoModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/14.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import HandyJSON

class VideoModel: HandyJSON {
    
    var id: String?
    var author: UserModel?
    var name: String?
    var color_from: String?
    var color_to: String?
    var color_main: String?
    var media : MediaModel?
    var title: String?
    var created_at: Date?
    var cover_url: String?
    var view_count: String?
    var liked_count: Int?
    var share_count: Int?
    var comments_count: Int?
    var share_url: String?
    var starred: Bool?
    var liked: Bool?
    var viewed: Bool?
    var rewardable: Bool?
    var rewardable_codes: [String]?
    
    required init() { }
    
    func mapping(mapper: HelpingMapper) {
        
        mapper <<<
            self.created_at <-- DateISO8601Transform()
    }
}
