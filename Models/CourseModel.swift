//
//  CourseModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/25.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import HandyJSON

class CourseModel: HandyJSON {
    
    var id: Int?
    var title: String?
    var sub_title: String?
    var price: Float?
    var students_count: Int?
    var cover_attribute: AssetModel?
    var suitable: String?
    var teacher: TeacherModel?
    var content_images_attribute: [AssetModel]?
    var is_bought: Bool?
    var is_favorite: Bool?
//    var audition: Bool?
    var course_catalogues: [CourseSectionModel]?
    var is_comment: Bool?
    var recommended_cover_attribute: AssetModel?
    var share_url: String?
    
    required init() {
        
    }
    
//    required convenience init?(map: Map) {
//        self.init()
//    }
//
//    func mapping(map: Map) {
//        id <- map["id"]
//        title <- map["title"]
//        subTitle <- map["sub_title"]
//        studentCount <- map["student_count"]
//        coverAttribute <- map["cover_attribute"]
//        suitable <- map["suitable"]
//        teacher <- map["teacher"]
//    }
}
