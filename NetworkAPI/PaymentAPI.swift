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
    case advance(Int)
    case advance_receipt(String)
}

extension PaymentAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: ServerHost)!
    }
    
    public var path: String {
        switch self {
        case .advances:
            return "/app/advances"
        case let .advance(advanceID):
            return "/app/advances/\(advanceID)/order"
        case .advance_receipt:
            return "/app/advances/apple_pay"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .advances:
            return .get
        case .advance:
            return .get
        case .advance_receipt:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .advances:
            return .requestPlain
        case .advance:
            return .requestPlain
        case let .advance_receipt(receipt):
            return .requestParameters(parameters: ["receipt-data": receipt], encoding: JSONEncoding.default)
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
