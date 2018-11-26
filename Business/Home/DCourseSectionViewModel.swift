//
//  DCourseSectionViewModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/29.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Foundation

class DCourseSectionViewModel {
    
    public var courseID: Int = 0
    
    public var sectionID: Int = 0
    
    public var courseSectionModel: CourseSectionModel?

    public var courseCatalogueModels: [CourseSectionModel]?
    
    func fetchCourseSection(completion: @escaping (Int)->Void) {
        
        CourseProvider.request(.course_section(courseID: courseID, sectionID: sectionID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if let JSON = JSON {
                self.courseSectionModel = CourseSectionModel.deserialize(from: JSON)
            }
            completion(code)
        }))
        
    }
    
    func fetchCourseSections(completion: @escaping (Int)->Void) {
        CourseProvider.request(.course_sections(courseID: courseID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if let JSON = JSON {
                self.courseCatalogueModels = CourseModel.deserialize(from: JSON)?.course_catalogues
            }
            completion(code)
        }))
        
    }
}
