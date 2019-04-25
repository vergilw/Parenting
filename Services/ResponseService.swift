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
    
    func response(completion: @escaping (_ code: Int, _ resultJSON: ([String: Any])?)->()) -> Completion {
        let returnCompletion: Completion = { result in
            switch result {
            case let .success(response):
                
                if let token = response.response?.allHeaderFields["Auth-Token"] as? String {
                    AuthorizationService.sharedInstance.authToken = token
                }
                if let token = response.response?.allHeaderFields["Organ-Token"] as? String {
                    AuthorizationService.sharedInstance.organToken = token
                }
                
                if response.statusCode >= 200 && response.statusCode < 300 {
                    
                    guard let JSON = ((try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]) as [String : Any]??) else {
                        return completion(response.statusCode, nil)
                    }
                    
                    if let code = JSON?["code"] as? Int {
                        completion(code, JSON)
                    } else {
                        completion(response.statusCode, JSON)
                    }
                    
                } else if response.statusCode == 401 {
                    AuthorizationService.sharedInstance.signOut()
                    let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
                    UIApplication.shared.keyWindow?.rootViewController?.present(authorizationNavigationController, animated: true, completion: nil)
                    completion(-1, nil)
                    
                } else {
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions.allowFragments)
                        
                        if let errorMsg = JSON as? String {
                            #if DEBUG
                            print("\(errorMsg)")
                            #endif
                            HUDService.sharedInstance.show(string: errorMsg)
                            
                        } else if let dictionary = JSON as? [String: Any], let errorMsg = dictionary["message"] as? String {
                            #if DEBUG
                            print("\(errorMsg)")
                            #endif
                            HUDService.sharedInstance.show(string: errorMsg)
                        }
                        
                        completion(-1, nil)
                    } catch {
                        HUDService.sharedInstance.show(string: "服务端错误")
                        completion(-1, nil)
                    }
                }
            case .failure(_):
                HUDService.sharedInstance.show(string: "网络异常")
                completion(-2, nil)
            }
        }
        return returnCompletion
    }
}
