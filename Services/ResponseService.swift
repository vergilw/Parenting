//
//  ResponseService.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/13.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Foundation
import Moya

class ResponseService {
    
    static let sharedInstance = ResponseService()
    
    private init() { }
    
    enum ResponseError: Error {
        case serialization
        case statusCode
        case network
    }
    
    func response(completion: @escaping (_ resultJSON: ([String: Any])?)->()) -> Completion {
        let returnCompletion: Completion = { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions()) as! [String: Any]
                        if let code = JSON["code"] as? Int, code == 200 {
                            completion(JSON)
                        } else {
                            HUDService.sharedInstance.show(string: JSON["message"] as! String)
                            completion(nil)
                        }
                        
                    } catch {
                        HUDService.sharedInstance.show(string: "服务端错误")
                        completion(nil)
                    }
                    
                } else {
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions()) as? [String: Any]
                        HUDService.sharedInstance.show(string: JSON?["message"] as! String)
                        completion(nil)
                    } catch {
                        HUDService.sharedInstance.show(string: "服务端错误")
                        completion(nil)
                    }
                }
            case .failure(_):
                HUDService.sharedInstance.show(string: "网络异常")
                completion(nil)
            }
        }
        return returnCompletion
    }
}
