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
}

extension CommonAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: ServerHost)!
    }
    
    public var path: String {
        switch self {
        case .home:
            return "/app/home.json"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .home:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .home:
            return .requestPlain
        }
    }
    
    var validationType: ValidationType {
        return .none
    }
    
    var headers: [String: String]? {
        if let model = AuthorizationService.sharedInstance.user, let token = model.auth_token {
            return ["Auth-Token": token]
        }
        return nil
    }
}
