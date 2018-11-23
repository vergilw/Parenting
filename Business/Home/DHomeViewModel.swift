//
//  DHomeViewModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/22.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import HandyJSON

class DHomeViewModel {
    
    var bannerModels: [BannerModel]?
    
    var bottomBannerModel: BannerModel?
    
    var hottestCourseModels: [CourseModel]?
    
    var newestCourseModels: [CourseModel]?
    
    var recommendedCourseModel: CourseModel?
    
    func fetchHomeData(completion: @escaping (Bool)->Void) {
        
        CommonProvider.request(.home, completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            if code >= 0 {
                if let data = JSON?["data"] as? [String: Any] {
                    if let ads = data["ads"] as? [String: Any] {
                        if let banners = ads["banner"] as? [[String: Any]] {
                            self.bannerModels = [BannerModel].deserialize(from: banners) as? [BannerModel]
                        }
                        if let banners = ads["bottom"] as? [[String: Any]] {
                            if let models = [BannerModel].deserialize(from: banners) as? [BannerModel], models.count > 0 {
                                self.bottomBannerModel = models.first
                            }
                        }
                    }
                    
                    if let ads = data["courses"] as? [String: Any] {
                        if let courses = ads["hottest"] as? [[String: Any]] {
                            self.hottestCourseModels = [CourseModel].deserialize(from: courses) as? [CourseModel]
                        }
                        if let courses = ads["newest"] as? [[String: Any]] {
                            self.newestCourseModels = [CourseModel].deserialize(from: courses) as? [CourseModel]
                        }
                        if let courses = ads["recommended"] as? [String: Any] {
                            self.recommendedCourseModel = CourseModel.deserialize(from: courses)
                        }
                    }
                }
                
                completion(true)
            } else {
                completion(false)
            }
        }))
        
        
//        let JSONString = "[{\"id\":5,\"name\":\"asdfasdf\",\"sort\":4,\"image_attribute\":{\"id\":1994,\"service_url\":\"http:\\/\\/cloud.1314-edu.com\\/RMQaSCiDu1bPkHRiH2mHc8Ye\"},\"target_type\":\"Course\"},{\"id\":6,\"name\":\"asdfasdf\",\"sort\":5,\"image_attribute\":{\"id\":1995,\"service_url\":\"http:\\/\\/cloud.1314-edu.com\\/BrDwmDQ5pXkYgmD1TV54na2p\"},\"target_type\":\"Activity\"}]"
//        bannerModels = [BannerModel].deserialize(from: JSONString) as? [BannerModel]
//        completion(true)
    }
    
}
