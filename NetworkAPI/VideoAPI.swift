//
//  VideoAPI.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/14.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Moya
import HandyJSON

let VideoProvider = MoyaProvider<VideoAPI>(manager: DefaultAlamofireManager.sharedManager)

enum VideoAPI {
    case video_category
    case videos(Int?, Int)
}

extension VideoAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: "http://dappore.store/api")!
    }
    
    public var path: String {
        switch self {
        case .video_category:
            return "/video_taxons"
        case .videos:
            return "/videos"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .video_category:
            return .get
        case .videos:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .video_category:
            return .requestPlain
        case let .videos(categoryID, page):
            var parameters: [String: Any] = ["page":page, "per":"10"]
            if let categoryID = categoryID {
                parameters["video_taxon_id"] = categoryID
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
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
