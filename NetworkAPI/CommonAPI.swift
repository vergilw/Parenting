//
//  CommonAPI.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/23.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Foundation
import Moya
import HandyJSON

let CommonProvider = MoyaProvider<CommonAPI>()

enum CommonAPI {
    case home
    case feedback(String)
    case uploadToken(Int, String)
}

extension CommonAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: ServerHost)!
    }
    
    public var path: String {
        switch self {
        case .home:
            return "/app/home.json"
        case .feedback:
            return "/app/user_feedbacks.json"
        case .uploadToken:
            return "/rails/active_storage/direct_uploads"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .home:
            return .get
        case .feedback:
            return .post
        case .uploadToken:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .home:
            return .requestPlain
        case let .feedback(content):
            return .requestParameters(parameters: ["user_feedback[content]":content,
                                                   "user_feedback[device_info]os_name": UIDevice.current.systemName,
                                                   "user_feedback[device_info]os_version": UIDevice.current.systemVersion,
                                                   "user_feedback[device_info]device_model": UIDevice.current.machineModel ?? "",
                                                   "user_feedback[device_info]app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String,
                                                   "user_feedback[device_info]device_id": AppService.sharedInstance.uniqueIdentifier], encoding: URLEncoding.default)
        case let .uploadToken(size, contentType):
            return .requestParameters(parameters: ["[blob]byte_size": size,
                                                   "[blob]content_type": contentType,
                                                   "[blob]filename": "",
                                                   "[blob]checksum": ""], encoding: URLEncoding.default)
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
                       "Device-Name": UIDevice.current.machineModel ?? "",
                       "App-Version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String]
        if let model = AuthorizationService.sharedInstance.user, let token = model.auth_token {
            headers["Auth-Token"] = token
        }
        return headers
    }
}
