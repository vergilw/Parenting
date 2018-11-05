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
        CourseProvider.request(.comments(courseID: courseID, page: 1)) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    let JSON = try! JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions()) as! [String: Any]
                    self.commentModel = [CommentModel].deserialize(from: JSON["comments"] as! [[String: Any]]) as? [CommentModel]
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
