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
    case signIn(phone: String, code: String)
    case signInWithWechat(openID: String, accessToken: String)
    case signUpWithWechat(openID: String, phone: String, code: String)
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
        case .signUpWithWechat:
            return "/app/auth/bind_mobile"
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
        case .signUpWithWechat:
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

        case let .signIn(phone, code):
            return .requestParameters(parameters: ["account":phone, "token":code], encoding: URLEncoding.default)
            
        case let .signInWithWechat(openID, accessToken):
            return .requestParameters(parameters: ["openid":openID, "access_token":accessToken], encoding: URLEncoding.default)
            
        case let .signUpWithWechat(openID, phone, code):
            return .requestParameters(parameters: ["uid":openID, "mobile":phone, "token":code], encoding: URLEncoding.default)
        }
    }
    
    var validationType: ValidationType {
        return .none
    }
    
    var headers: [String: String]? {
        return nil
    }
}
