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
    case course_order(Int)
    case order(Int)
    case orders(String, Int)
    case order_pay(Int)
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
        case let .course_order(courseID):
            return "/app/courses/\(courseID)/order"
        case let .order(orderID):
            return "/app/my/orders/\(orderID)"
        case .orders:
            return "/app/my/orders"
        case let .order_pay(orderID):
            return "/app/my/orders/\(orderID)/wallet_pay"
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
        case .course_order:
            return .post
        case .order:
            return .get
        case .orders:
            return .get
        case .order_pay:
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
        case .course_order:
            return .requestPlain
        case .order:
            return .requestPlain
        case let .orders(status, page):
            return .requestParameters(parameters: ["good_type":"Course", "status":status, "page":page, "per_page":"10"], encoding: URLEncoding.default)
        case .order_pay:
            let deviceParameters = ["os_name": UIDevice.current.systemName,
             "os_version": UIDevice.current.systemVersion,
             "device_model": UIDevice.current.machineModel ?? "",
             "app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String,
             "device_id": AppService.sharedInstance.uniqueIdentifier]
            return .requestParameters(parameters: ["device_info": deviceParameters], encoding: JSONEncoding.default)
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
