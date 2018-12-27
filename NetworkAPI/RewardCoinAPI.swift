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
    case reward_detail(Int)
    case reward_ranking(Int)
    case reward_courses(Int)
    case reward_exchangeList
    case reward_exchange(Float)
}

extension RewardCoinAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: ServerHost)!
    }
    
    public var path: String {
        switch self {
        case let .reward(storyID):
            return "/api/Course/\(storyID)/aim_logs"
        case .reward_detail:
            return "/api/coin_logs"
        case .reward_ranking:
            return "/api/coin_logs/top"
        case .reward_courses:
            return "/app/courses.json"
        case .reward_exchangeList:
            return "/api/coin_wallets/list"
        case .reward_exchange:
            return "/api/coin_wallets"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .reward:
            return .post
        case .reward_detail:
            return .get
        case .reward_ranking:
            return .get
        case .reward_courses:
            return .get
        case .reward_exchangeList:
            return .get
        case .reward_exchange:
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
        case let .reward_detail(page):
            return .requestParameters(parameters: ["page":page, "per":"10"], encoding: URLEncoding.default)
        case let .reward_ranking(page):
            return .requestParameters(parameters: ["page":page, "per":"10"], encoding: URLEncoding.default)
        case let .reward_courses(page):
            return .requestParameters(parameters: ["page":page, "per_page":"10", "reward.amount-gt":"0"], encoding: URLEncoding.default)
        case .reward_exchangeList:
            return .requestPlain
        case let .reward_exchange(value):
            let parameters = ["coin_wallet": ["coin_amount": value]]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
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
