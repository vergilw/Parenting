//
//  AuthorizationAPI.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/12.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Foundation
import Moya

let AuthorizationProvider = MoyaProvider<AuthorizationAPI>()

enum AuthorizationAPI {
    case fetchCode(phone: Int)
    case signIn(phone: String, code: String, wechatUID: String?)
    case signInWithWechat(wechatUID: String)
}

extension AuthorizationAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: ServerHost)!
    }
    
    public var path: String {
        switch self {
        case .fetchCode:
            return "/app/login/confirm"
        case .signIn:
            return "/app/login"
        case .signInWithWechat:
            return "/app/auth"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchCode:
            return .get
        case .signIn:
            return .post
        case .signInWithWechat:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case let .fetchCode(phone):
            return .requestParameters(parameters: ["mobile":phone, "device":"app"], encoding: URLEncoding.default)

        case let .signIn(phone, code, wechatUID):
            var parameters = ["account":phone, "token":code]
            if wechatUID != nil {
                parameters["uid"] = wechatUID
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case let .signInWithWechat(wechatUID):
            return .requestParameters(parameters: ["code":wechatUID], encoding: URLEncoding.default)
        }
    }
    
    var validationType: ValidationType {
        return .none
    }
    
    var headers: [String: String]? {
        return nil
    }
}
