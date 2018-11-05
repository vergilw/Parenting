//
//  DCourseDetailViewModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/25.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Foundation
import HandyJSON

class DCourseDetailViewModel {
    
    public var courseID: Int = 2
    
    var courseModel: CourseModel?
    
    var commentModel: [CommentModel]?
    
    var myCommentModel: CommentModel?
    
    lazy fileprivate var commentPage: Int = 1
    
    func fetchCourse(completion: @escaping (Bool)->Void) {
        CourseProvider.request(.course(courseID: courseID)) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    let JSON = try! JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions()) as! [String: Any]
                    self.courseModel = CourseModel.deserialize(from: JSON)
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
    
    func fetchComments(completion: @escaping (Bool)->Void) {
        
        CourseProvider.request(.comments(courseID: courseID, page: commentPage)) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    let JSON = try! JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions()) as! [String: Any]
                    
                    if self.commentModel == nil {
                        self.commentModel = [CommentModel].deserialize(from: JSON["comments"] as! [[String: Any]]) as? [CommentModel]
                    } else {
                        let models = [CommentModel].deserialize(from: JSON["comments"] as! [[String: Any]]) as? [CommentModel]
                        self.commentModel?.append(contentsOf: models!)
                    }
                    
                    if let pageData = JSON["page_data"] as? [String: Any], let totalPages = pageData["total_pages"] as? Int {
                        if totalPages > self.commentPage {
                            self.commentPage += 1
                            completion(true)
                        } else {
                            completion(false)
                        }
                    } else {
                        completion(false)
                    }
                    
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
