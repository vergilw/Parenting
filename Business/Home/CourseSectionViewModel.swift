//
//  CourseSectionViewModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/29.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Foundation

class CourseSectionViewModel {
    
    public var courseID: Int = 0
    
    public var sectionID: Int = 0
    
    public var courseSectionModel: CourseSectionModel?

    public var courseCatalogueModels: [CourseSectionModel]?
    
    func fetchCourseSection(completion: @escaping (Bool)->Void) {
        CourseProvider.request(.course_section(courseID: courseID, sectionID: sectionID)) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    let JSON = try! JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions()) as! [String: Any]
                    self.courseSectionModel = CourseSectionModel.deserialize(from: JSON)
                    completion(false)
                    
                } else {
                    //                    let error = try? JSON(data: response.data)
                    //                    let errorCode = error?["code"].stringValue
                    //                    print(error)
                }
            case let .failure(error):
                //                HUDService.sharedInstance.show(targetView: self.view, text: error.localizedDescription)
                print("failure")
            }
        }
    }
    
    func fetchCourseSections(completion: @escaping (Bool)->Void) {
        CourseProvider.request(.course_sections(courseID: courseID)) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    let JSON = try! JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions()) as! [String: Any]
                    self.courseCatalogueModels = CourseModel.deserialize(from: JSON)?.course_catalogues
                    completion(false)
                    
                } else {
                    //                    let error = try? JSON(data: response.data)
                    //                    let errorCode = error?["code"].stringValue
                    //                    print(error)
                }
            case let .failure(error):
                //                HUDService.sharedInstance.show(targetView: self.view, text: error.localizedDescription)
                print("failure")
            }
        }
    }
}
