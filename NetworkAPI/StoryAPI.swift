//
//  StoryAPI.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/29.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Moya
import HandyJSON

let StoryProvider = MoyaProvider<StoryAPI>()

enum StoryAPI {
    case stories(Int)
    case story(Int)
}

extension StoryAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: ServerHost)!
    }
    
    public var path: String {
        switch self {
        case .stories:
            return "/app/user_stories.json"
        case let .story(storyID):
            return "/app/user_stories/" + String(storyID) + ".json"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .stories:
            return .get
        case .story:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case let .stories(page):
            return .requestParameters(parameters: ["page":page, "per_page":"10"], encoding: URLEncoding.default)
        case .story:
            return .requestPlain
        }
    }
    
    var validationType: ValidationType {
        return .none
    }
    
    var headers: [String: String]? {
        var headers = ["Accept-Language": "zh-CN"]
        if let model = AuthorizationService.sharedInstance.user, let token = model.auth_token {
            headers["Auth-Token"] = token
        }
        return headers
    }
}
