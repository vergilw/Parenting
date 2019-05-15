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
    case signInWithWechat(openID: String, accessToken: String, refreshToken: String, expiresAt: String)
    case signUpWithWechat(oauthID: String, phone: String, passcode: String)
    case bindWechat(openID: String, accessToken: String, refreshToken: String, expiresAt: String)
    case signUpWithDeviceID
}

extension AuthorizationAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: CRMServerHost)!
    }
    
    public var path: String {
        switch self {
        case .fetchCode:
            return "/sign/token"
        case .signInWithPasscode:
            return "/login"
        case .signInWithPassword:
            return "/login"
        case .signInWithWechat:
            return "/wechat/auth"
        case .signUpWithWechat:
            return "/login"
        case .bindWechat:
            return "/wechat/auth"
        case .signUpWithDeviceID:
            return "/backend/mock"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchCode:
            return .post
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
            
        case let .signInWithWechat(openID, accessToken, refreshToken, expiresAt):
            return .requestParameters(parameters: ["openid":openID, "access_token":accessToken, "refresh_token":refreshToken, "expires_at":expiresAt, "app_id":"wxc7c60047a9c75018"], encoding: JSONEncoding.default)
            
        case let .signUpWithWechat(oauthID, phone, passcode):
            return .requestParameters(parameters: ["oauth_user_id":oauthID, "identity":phone, "token":passcode], encoding: JSONEncoding.default)
            
        case let .bindWechat(openID, accessToken, refreshToken, expiresAt):
            return .requestParameters(parameters: ["openid":openID, "access_token":accessToken, "refresh_token":refreshToken, "expires_at":expiresAt, "app_id":"wxc7c60047a9c75018"], encoding: JSONEncoding.default)
            
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
        switch self {
        case .bindWechat:
            if let token = AuthorizationService.sharedInstance.authToken {
                headers["Auth-Token"] = token
            }
        default: break
        }
        
        return headers
    }
}
