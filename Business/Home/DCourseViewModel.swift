//
//  DCourseViewModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/23.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import HandyJSON

class DCourseViewModel {
    
    var categoryID: Int?
    
    var categoryModels: [CourseCategoryModel]?
    
    var courseModels: [CourseModel]?
    
    lazy fileprivate var pageNumber: Int = 1
    
    func fetchCategory(completion: @escaping (Int)->Void) {
        CourseProvider.request(.course_category, completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if let data = JSON?["data"] as? [[String: Any]] {
                self.categoryModels = [CourseCategoryModel].deserialize(from: data) as? [CourseCategoryModel]
//                if let first = self.categoryModels?.first, let categoryID = first.id {
//                    self.categoryID = categoryID
//                }
            }
            
            completion(code)
        }))
    }
    
    func refetchCourses(categoryID: Int?, completion: @escaping (_ code: Int, _ next: Bool)->Void) {
        
        CourseProvider.request(.courses(categoryID: categoryID, page: 1), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            guard let JSONArr = JSON?["data"] as? [[String: Any]], code >= 0 else {
                completion(code, false)
                return
            }
            
            self.categoryID = categoryID
            self.pageNumber = 1
            
            if let models = [CourseModel].deserialize(from: JSONArr) as? [CourseModel] {
                self.courseModels = models
            }
            
            if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                if totalPages > self.pageNumber {
                    self.pageNumber += 1
                    completion(code, true)
                } else {
                    completion(code, false)
                }
            } else {
                completion(code, false)
            }
            
            
        }))
    }
    
    func fetchCourses(completion: @escaping (_ code: Int, _ next: Bool)->Void) {
        CourseProvider.request(.courses(categoryID: categoryID, page: pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            guard let JSONArr = JSON?["data"] as? [[String: Any]], code >= 0 else {
                completion(code, false)
                return
            }
            
            if let models = [CourseModel].deserialize(from: JSONArr) as? [CourseModel] {
                if self.courseModels == nil {
                    self.courseModels = models
                } else {
                    self.courseModels?.append(contentsOf: models)
                }
            }
            
            if let meta = JSON?["meta"] as? [String: Any], let pagination = meta["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                if totalPages > self.pageNumber {
                    self.pageNumber += 1
                    completion(code, true)
                } else {
                    completion(code, false)
                }
            } else {
                completion(code, false)
            }
            
        }))
    }
}
