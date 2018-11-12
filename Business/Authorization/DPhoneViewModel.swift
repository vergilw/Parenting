//
//  DPhoneViewModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/12.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Foundation
import HandyJSON

class DPhoneViewModel {
    
    func fetchCode(phone: Int, completion: @escaping (Bool)->Void) {
        AuthorizationProvider.request(.fetchCode(phone: phone)) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions()) as? [String: Any]
//                        self.courseModel = CourseModel.deserialize(from: JSON)
                    } catch {
                        HUDService.sharedInstance.show(string: "服务端错误")
                    }
                    completion(false)
                    
                } else {
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions()) as? [String: Any]
                        HUDService.sharedInstance.show(string: JSON?["messages"] as! String)
                    } catch {
                        HUDService.sharedInstance.show(string: "服务端错误")
                    }
                    completion(false)
                }
            case .failure(_):
                HUDService.sharedInstance.show(string: "网络异常")
                completion(false)
            }
        }
    }
    
    
    func signIn(phone: String, code: String, completion: @escaping (Bool)->Void) {
        AuthorizationProvider.request(.signIn(phone: phone, code: code)) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions()) as? [String: Any]
//                        self.courseModel = CourseModel.deserialize(from: JSON)
//
                    } catch {
                        HUDService.sharedInstance.show(string: "服务端错误")
                    }
                    completion(false)
                    
                } else {
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions()) as? [String: Any]
                        HUDService.sharedInstance.show(string: JSON?["messages"] as! String)
                    } catch {
                        HUDService.sharedInstance.show(string: "服务端错误")
                    }
                    completion(false)
                }
            case .failure(_):
                HUDService.sharedInstance.show(string: "网络异常")
                completion(false)
            }
        }
    }
}
