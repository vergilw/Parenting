//
//  RewardCoinAPI.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/24.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Moya
import HandyJSON

let RewardCoinProvider = MoyaProvider<RewardCoinAPI>(manager: DefaultAlamofireManager.sharedManager)

enum RewardCoinAPI {
    case reward(Int)
}

extension RewardCoinAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: ServerHost)!
    }
    
    public var path: String {
        switch self {
        case let .reward(storyID):
            return "/api/Course/\(storyID)/aim_logs"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .reward:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .reward:
            return .requestParameters(parameters: ["code": "share"], encoding: URLEncoding.default)
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
