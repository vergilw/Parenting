//
//  AuthorizationAPI.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/12.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Foundation
import Moya

let AuthorizationProvider = MoyaProvider<AuthorizationAPI>(manager: DefaultAlamofireManager.sharedManager)

enum AuthorizationAPI {
    case fetchCode(phone: Int)
    case signInWithPasscode(account: String, passcode: String)
    case signInWithPassword(account: String, password: String)
    case signInWithWechat(openID: String, accessToken: String)
    case signUpWithWechat(openID: String, phone: String, code: String)
    case bindWechat(parameters: [String: Any])
    case signUpWithDeviceID
}

extension AuthorizationAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: CRMServerHost)!
    }
    
    public var path: String {
        switch self {
        case .fetchCode:
            return "/join/token"
        case .signInWithPasscode:
            return "/login"
        case .signInWithPassword:
            return "/login"
        case .signInWithWechat:
            return "/app/wechats"
        case .signUpWithWechat:
            return "/app/wechats/bind_mobile"
        case .bindWechat:
            return "/app/login/bind_wechat"
        case .signUpWithDeviceID:
            return "/backend/mock"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchCode:
            return .get
        case .signInWithPasscode:
            return .post
        case .signInWithPassword:
            return .post
        case .signInWithWechat:
            return .post
        case .signUpWithWechat:
            return .post
        case .bindWechat:
            return .post
        case .signUpWithDeviceID:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case let .fetchCode(phone):
            return .requestParameters(parameters: ["identity":phone], encoding: URLEncoding.default)

        case let .signInWithPasscode(account, passcode):
            return .requestParameters(parameters: ["identity":account, "token":passcode], encoding: URLEncoding.default)
            
        case let .signInWithPassword(account, password):
            return .requestParameters(parameters: ["identity":account, "password":password], encoding: URLEncoding.default)
            
        case let .signInWithWechat(openID, accessToken):
            return .requestParameters(parameters: ["openid":openID, "access_token":accessToken], encoding: URLEncoding.default)
            
        case let .signUpWithWechat(openID, phone, code):
            return .requestParameters(parameters: ["uid":openID, "mobile":phone, "token":code], encoding: URLEncoding.default)
            
        case let .bindWechat(parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .signUpWithDeviceID:
            return .requestParameters(parameters: ["account":AppService.sharedInstance.uniqueIdentifier], encoding: URLEncoding.default)
        }
    }
    
    var validationType: ValidationType {
        return .none
    }
    
    var headers: [String: String]? {
        var headers = ["Accept-Language": "zh-CN",
                       "Device-ID": AppService.sharedInstance.uniqueIdentifier,
                       "OS": UIDevice.current.systemName,
                       "OS-Version": UIDevice.current.systemVersion,
                       "Device-Model": UIDevice.current.machineModel ?? "",
                       "App-Version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String,
                       "Accept": "application/vnd.inee.v1+json"]
        if let token = AuthorizationService.sharedInstance.authToken {
            headers["Auth-Token"] = token
        }
        return headers
    }
}
