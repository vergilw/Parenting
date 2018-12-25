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
    
    public var courseID: Int = 0
    
    var courseModel: CourseModel?
    
    var commentModel: [CommentModel]?
    
    var myCommentModel: CommentModel?
    
    var commentsCount: Int?
    
    lazy fileprivate var commentPage: Int = 1
    
    func fetchCourse(completion: @escaping (Bool)->Void) {
        CourseProvider.request(.course(courseID: courseID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            if code >= 0 {
                self.courseModel = CourseModel.deserialize(from: JSON)
                completion(true)
            } else {
                completion(false)
            }
        }))
    }
    
    func fetchComments(completion: @escaping (_ status: Bool, _ next: Bool)->Void) {
        CourseProvider.request(.comments(courseID: courseID, page: commentPage), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            if let JSON = JSON, code >= 0 {
                if self.commentModel == nil {
                    self.commentModel = [CommentModel].deserialize(from: JSON["comments"] as! [[String: Any]]) as? [CommentModel]
                } else {
                    let models = [CommentModel].deserialize(from: JSON["comments"] as! [[String: Any]]) as? [CommentModel]
                    self.commentModel?.append(contentsOf: models!)
                }
                
                if let pageData = JSON["page_data"] as? [String: Any], let totalPages = pageData["total_pages"] as? Int, let totalCount = pageData["total_count"] as? Int {
                    self.commentsCount = totalCount
                    if totalPages > self.commentPage {
                        self.commentPage += 1
                        completion(true, true)
                    } else {
                        completion(true, false)
                    }
                } else {
                    completion(true, false)
                }
                
            } else {
                completion(false, false)
            }
        }))
    }
    
    func fetchMyComment(completion: @escaping (Bool)->Void) {
        CourseProvider.request(.my_comment(courseID: courseID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            if code >= 0 {
                self.myCommentModel = CommentModel.deserialize(from: JSON?["comments"] as? [String: Any])
                completion(true)
            } else {
                completion(false)
            }
        }))
    }
    
    func toggleFavorites(completion: @escaping (Int, Bool)->Void) {
        CourseProvider.request(.course_toggle_favorites(courseID: courseID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if let isFavorite = JSON?["is_favorite"] as? Bool {
                completion(code, isFavorite)
            } else {
                completion(code, false)
            }
        }))
    }
    
    func shareReward(completion: @escaping (Float?)->Void) {
        RewardCoinProvider.request(.reward(courseID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            if code >= 0, let rewardValue = JSON?["reward"] as? Float {
                completion(rewardValue)
                return
            }
            completion(nil)
        }))
    }
}
