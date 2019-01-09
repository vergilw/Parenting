//
//  VideoCommentModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/9.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import HandyJSON

class VideoCommentModel: HandyJSON {
    
    var id: Int?
    var content: String?
    var liked_count: Int?
    var commenter: UserModel?
    var created_at: Date?
    
    required init() { }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.created_at <-- DateISO8601Transform()
    }
}
