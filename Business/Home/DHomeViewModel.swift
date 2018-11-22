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
    
    func fetchBanners(completion: @escaping (Bool)->Void) {
        let JSONString = "[{\"id\":5,\"name\":\"asdfasdf\",\"sort\":4,\"image_attribute\":{\"id\":1994,\"service_url\":\"http:\\/\\/cloud.1314-edu.com\\/RMQaSCiDu1bPkHRiH2mHc8Ye\"},\"target_type\":\"Course\"},{\"id\":6,\"name\":\"asdfasdf\",\"sort\":5,\"image_attribute\":{\"id\":1995,\"service_url\":\"http:\\/\\/cloud.1314-edu.com\\/BrDwmDQ5pXkYgmD1TV54na2p\"},\"target_type\":\"Activity\"}]"
        bannerModels = [BannerModel].deserialize(from: JSONString) as? [BannerModel]
        completion(true)
    }
    
}
