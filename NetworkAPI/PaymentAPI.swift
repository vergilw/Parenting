//
//  PaymentAPI.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/5.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Moya
import HandyJSON

let PaymentProvider = MoyaProvider<PaymentAPI>()

enum PaymentAPI {
    case advances
}

extension PaymentAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: ServerHost)!
    }
    
    public var path: String {
        switch self {
        case .advances:
            return "/app/advances"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .advances:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .advances:
            return .requestPlain
        }
    }
    
    var validationType: ValidationType {
        return .none
    }
    
    var headers: [String: String]? {
        var headers = ["Accept-Language": "zh-CN",
                       "device_id": AppService.sharedInstance.uniqueIdentifier]
        if let model = AuthorizationService.sharedInstance.user, let token = model.auth_token {
            headers["Auth-Token"] = token
        }
        return headers
    }
}
