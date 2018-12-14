//
//  UserAPI.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/5.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Moya
import HandyJSON

let UserProvider = MoyaProvider<UserAPI>(manager: DefaultAlamofireManager.sharedManager)

enum UserAPI {
    case updateUser(name: String?, avatar: String?)
    case user
    case updatePushToken(String)
}

extension UserAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: ServerHost)!
    }
    
    public var path: String {
        switch self {
        case .updateUser:
            return "/app/profile"
        case .user:
            return "/app/profile"
        case .updatePushToken:
            return "/app/profile/update_getui_token"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .updateUser:
            return .put
        case .user:
            return .get
        case .updatePushToken:
            return .put
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case let .updateUser(name, avatar):
            var parameters: [String: Any] = [String: Any]()
            if let name = name {
                parameters["user"] = ["name": name]
            }
            if let avatar = avatar {
                parameters["user"] = ["avatar": avatar]
            }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .user:
            return .requestPlain
        case let .updatePushToken(pushToken):
            return .requestParameters(parameters: ["token": pushToken], encoding: URLEncoding.default)
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
                       "App-Version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String]
        if let model = AuthorizationService.sharedInstance.user, let token = model.auth_token {
            headers["Auth-Token"] = token
        }
        return headers
    }
}
