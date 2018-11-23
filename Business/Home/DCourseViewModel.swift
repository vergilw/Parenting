//
//  DCourseViewModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/23.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import HandyJSON

class DCourseViewModel {
    
    var categoryID: Int = 0
    
    var categoryModels: [CourseCategoryModel]?
    
    var courseModels: [CourseModel]?
    
    lazy fileprivate var pageNumber: Int = 1
    
    func fetchCategory(completion: @escaping (Bool)->Void) {
        CourseProvider.request(.course_category, completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            if code >= 0 {
                if let data = JSON?["data"] as? [[String: Any]] {
                    self.categoryModels = [CourseCategoryModel].deserialize(from: data) as? [CourseCategoryModel]
                    if let first = self.categoryModels?.first, let categoryID = first.id {
                        self.categoryID = categoryID
                    }
                }
                completion(true)
            } else {
                completion(false)
            }
        }))
    }
    
    func fetchCourses(completion: @escaping (_ status: Bool, _ next: Bool)->Void) {
        CourseProvider.request(.courses(categoryID: categoryID, page: pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            guard let JSONArr = JSON?["data"] as? [[String: Any]], code >= 0 else {
                completion(false, false)
                return
            }
            
            if let models = [CourseModel].deserialize(from: JSONArr) as? [CourseModel] {
                //TODO: refresh header and footer
//                if self.courseModels == nil {
                    self.courseModels = models
//                } else {
//                    self.courseModels?.append(contentsOf: models)
//                }
            }
            
            if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                if totalPages > self.pageNumber {
                    self.pageNumber += 1
                    completion(true, true)
                } else {
                    completion(true, false)
                }
            } else {
                completion(true, false)
            }
            
            
        }))
    }
}
