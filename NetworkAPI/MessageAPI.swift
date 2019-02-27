//
//  MessageAPI.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/2/27.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import Foundation
import Moya

let MessageProvider = MoyaProvider<MessageAPI>(manager: DefaultAlamofireManager.sharedManager)

enum MessageAPI {
    case messages(Int)
    case message(Int)
    case messages_asReadAll
}

extension MessageAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: ServerHost)!
    }
    
    public var path: String {
        switch self {
        case .messages:
            return "/notifications"
        case let .message(identifier):
            return "/notifications/\(identifier)"
        case .messages_asReadAll:
            return "/notifications/read_all"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .messages:
            return .get
        case .message:
            return .get
        case .messages_asReadAll:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case let .messages(page):
            return .requestParameters(parameters: ["page":page, "per":"10"], encoding: URLEncoding.default)
        case .message:
            return .requestPlain
        case .messages_asReadAll:
            return .requestPlain
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
        if let model = AuthorizationService.sharedInstance.user, let token = model.auth_token {
            headers["Auth-Token"] = token
        }
        return headers
    }
}

