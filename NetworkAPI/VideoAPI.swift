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
    case videos(String?, Int?)
    case video_like(String, Bool)
    case video_comments(Int, Int)
    case videos_user(Int, Int)
    case video_comment(Int, String)
    case video(String, String, String)
    case video_favorite(Int)
    case video_favorite_delete(Int)
    case video_viewed(Int)
}

extension VideoAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: ServerHost)!
    }
    
    public var path: String {
        switch self {
        case .video_category:
            return "/api/video_taxons"
        case .videos:
            return "/api/videos/list"
        case let .video_like(videoID, _):
            return "/api/Video/\(videoID)/attitudes"
        case let .video_comments(videoID, _):
            return "/api/Video/\(videoID)/comments"
        case .videos_user:
            return "/api/videos"
        case let .video_comment(videoID, _):
            return "/api/Video/\(videoID)/comments"
        case .video:
            return "/api/videos"
        case let .video_favorite(videoID):
            return "/api/Video/\(videoID)/stars"
        case let .video_favorite_delete(videoID):
            return "/api/Video/\(videoID)/stars"
        case let .video_viewed(videoID):
            return "/api/videos/\(videoID)/viewed"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .video_category:
            return .get
        case .videos:
            return .get
        case .video_like:
            return .post
        case .video_comments:
            return .get
        case .videos_user:
            return .get
        case .video_comment:
            return .post
        case .video:
            return .post
        case .video_favorite:
            return .post
        case .video_favorite_delete:
            return .delete
        case .video_viewed:
            return .patch
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .video_category:
            return .requestPlain
        case let .videos(scope, videoID):
            var parameters = ["per":"10"]
            if let videoID = videoID {
                parameters["id"] = String(videoID)
            }
            if let scope = scope {
                parameters["scope"] = scope
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .video_like(_, isLike):
            return .requestParameters(parameters: ["opinion": isLike ? "liked" : "like_canceled"], encoding: URLEncoding.default)
        case let .video_comments(_, page):
            return .requestParameters(parameters: ["page":page, "per":"10"], encoding: URLEncoding.default)
        case let .videos_user(userID, page):
            return .requestParameters(parameters: ["author_id": userID, "page":page, "per":"12"], encoding: URLEncoding.default)
        case let .video_comment(_, string):
            return .requestParameters(parameters: ["comment": ["content": string]], encoding: JSONEncoding.default)
        case let .video(title, media, cover):
            return .requestParameters(parameters: ["video": ["title": title, "media": media, "cover": cover]], encoding: JSONEncoding.default)
        case .video_favorite:
            return .requestPlain
        case .video_favorite_delete:
            return .requestPlain
        case .video_viewed:
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
