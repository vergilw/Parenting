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
    case videos_paging([String: Any])
    case videos(String?, Int?)
    case video_detail(Int)
    case video_like(String, Bool)
    case video_comments(Int, Int)
    case videos_user(Int, Int)
    case video_comment(Int, String)
    case video_comment_like(String, String)
    case video(String, String, String)
    case video_favorite(Int)
    case video_favorite_delete(Int)
    case video_viewed(Int)
    case video_delete(Int)
    case video_favorites(Int)
    case video_report(Int)
    case video_tags
    case video_comment_report(Int)
    case video_gifts
    case video_gift_give(Int, Int)
    case video_gifts_rank(Int, Int)
}

extension VideoAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: ServerHost)!
    }
    
    public var path: String {
        switch self {
        case .video_category:
            return "/api/video_taxons"
        case .videos_paging:
            return "/api/videos"
        case .videos:
            return "/api/videos/list"
        case let .video_detail(videoID):
            return "/api/videos/\(videoID)"
        case let .video_like(videoID, _):
            return "/api/Video/\(videoID)/attitudes"
        case let .video_comments(videoID, _):
            return "/api/Video/\(videoID)/comments"
        case .videos_user:
            return "/api/videos"
        case let .video_comment(videoID, _):
            return "/api/Video/\(videoID)/comments"
        case let .video_comment_like(commentID, _):
            return "/api/Comment/\(commentID)/attitudes"
        case .video:
            return "/api/videos"
        case let .video_favorite(videoID):
            return "/api/Video/\(videoID)/stars"
        case let .video_favorite_delete(videoID):
            return "/api/Video/\(videoID)/stars"
        case let .video_viewed(videoID):
            return "/api/videos/\(videoID)/viewed"
        case let .video_delete(videoID):
            return "/api/videos/\(videoID)"
        case .video_favorites:
            return "/api/videos/starred"
        case let .video_report(videoID):
            return "/api/Video/\(videoID)/abuses"
        case .video_tags:
            return "/api/video_tags"
        case let .video_comment_report(commentID):
            return "/api/Comment/\(commentID)/abuses"
        case .video_gifts:
            return "/api/gifts"
        case let .video_gift_give(giftID, _):
            return "/api/gifts/\(giftID)/give"
        case .video_gifts_rank:
            return "/api/rewards/top"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .video_category:
            return .get
        case .videos_paging:
            return .get
        case .videos:
            return .get
        case .video_detail:
            return .get
        case .video_like:
            return .post
        case .video_comments:
            return .get
        case .videos_user:
            return .get
        case .video_comment:
            return .post
        case .video_comment_like:
            return .post
        case .video:
            return .post
        case .video_favorite:
            return .post
        case .video_favorite_delete:
            return .delete
        case .video_viewed:
            return .patch
        case .video_delete:
            return .delete
        case .video_favorites:
            return .get
        case .video_report:
            return .post
        case .video_tags:
            return .get
        case .video_comment_report:
            return .post
        case .video_gifts:
            return .get
        case .video_gift_give:
            return .post
        case .video_gifts_rank:
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
        case let .videos_paging(parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .videos(scope, videoID):
            var parameters = ["per":"10"]
            if let videoID = videoID {
                parameters["id"] = String(videoID)
            }
            if let scope = scope {
                parameters["scope"] = scope
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .video_detail:
            return .requestPlain
        case let .video_like(_, isLike):
            return .requestParameters(parameters: ["opinion": isLike ? "liked" : "like_canceled"], encoding: URLEncoding.default)
        case let .video_comments(_, page):
            return .requestParameters(parameters: ["page":page, "per":"10"], encoding: URLEncoding.default)
        case let .videos_user(userID, page):
            return .requestParameters(parameters: ["author_id": userID, "page":page, "per":"12"], encoding: URLEncoding.default)
        case let .video_comment(_, string):
            return .requestParameters(parameters: ["comment": ["content": string]], encoding: JSONEncoding.default)
        case let .video_comment_like(_, string):
            return .requestParameters(parameters: ["opinion": string], encoding: URLEncoding.default)
        case let .video(title, media, cover):
            return .requestParameters(parameters: ["video": ["title": title, "media": media, "cover": cover]], encoding: JSONEncoding.default)
        case .video_favorite:
            return .requestPlain
        case .video_favorite_delete:
            return .requestPlain
        case .video_viewed:
            return .requestPlain
        case .video_delete:
            return .requestPlain
        case let .video_favorites(page):
            return .requestParameters(parameters: ["page":page, "per": "12"], encoding: URLEncoding.default)
        case .video_report:
            return .requestPlain
        case .video_tags:
            return .requestPlain
        case .video_comment_report:
            return .requestPlain
        case .video_gifts:
            return .requestPlain
        case let .video_gift_give(_, videoID):
            return .requestParameters(parameters: ["entity_type":"Video", "entity_id": videoID], encoding: URLEncoding.default)
        case let .video_gifts_rank(videoID, page):
            return .requestParameters(parameters: ["entity_type":"Video", "entity_id": videoID, "page":page, "per": "12"], encoding: URLEncoding.default)
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
