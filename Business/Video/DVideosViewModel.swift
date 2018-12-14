//
//  DVideosViewModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/14.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import HandyJSON

class DVideosViewModel {
    
    var categoryID: Int?
    
    var categoryModels: [VideoCategoryModel]?
    
    var videosModels: [[VideoModel]]?
    
    lazy fileprivate var pageNumber: Int = 1
    
    func fetchCategory(completion: @escaping (Int)->Void) {
        VideoProvider.request(.video_category, completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if let data = JSON?["video_taxons"] as? [[String: Any]] {
                self.categoryModels = [VideoCategoryModel].deserialize(from: data) as? [VideoCategoryModel]
                //                if let first = self.categoryModels?.first, let categoryID = first.id {
                //                    self.categoryID = categoryID
                //                }
            }
            
            completion(code)
        }))
    }
    
    func refetchVideos(categoryID: Int?, completion: @escaping (_ code: Int, _ next: Bool, _ models: [VideoModel]?)->Void) {
        
        VideoProvider.request(.videos(categoryID, 1), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            guard let JSONArr = JSON?["videos"] as? [[String: Any]], code >= 0 else {
                completion(code, false, nil)
                return
            }
            
            self.categoryID = categoryID
            self.pageNumber = 1
            
            let models = [VideoModel].deserialize(from: JSONArr) as? [VideoModel]
            //            if let models = [CourseModel].deserialize(from: JSONArr) as? [CourseModel] {
            //                self.courseModels = models
            //            }
            
            if let pagination = JSON?["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                if totalPages > self.pageNumber {
                    self.pageNumber += 1
                    completion(code, true, models)
                } else {
                    completion(code, false, models)
                }
            } else {
                completion(code, false, models)
            }
            
            
        }))
    }
    
    func fetchVideos(completion: @escaping (_ code: Int, _ next: Bool, _ models: [VideoModel]?)->Void) {
        VideoProvider.request(.videos(categoryID, pageNumber), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            guard let JSONArr = JSON?["videos"] as? [[String: Any]], code >= 0 else {
                completion(code, false, nil)
                return
            }
            
            let models = [VideoModel].deserialize(from: JSONArr) as? [VideoModel]
            //            if let models = [CourseModel].deserialize(from: JSONArr) as? [CourseModel] {
            //                if self.courseModels == nil {
            //                    self.courseModels = models
            //                } else {
            //                    self.courseModels?.append(contentsOf: models)
            //                }
            //            }
            
            if let pagination = JSON?["pagination"] as? [String: Any], let totalPages = pagination["total_pages"] as? Int {
                if totalPages > self.pageNumber {
                    self.pageNumber += 1
                    completion(code, true, models)
                } else {
                    completion(code, false, models)
                }
            } else {
                completion(code, false, models)
            }
            
        }))
    }
}
