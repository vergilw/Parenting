//
//  CourseAPI.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/25.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Foundation
import Moya
import HandyJSON

let CourseProvider = MoyaProvider<CourseAPI>(manager: DefaultAlamofireManager.sharedManager)

enum CourseAPI {
    case course(courseID: Int)
    case course_sections(courseID: Int)
    case course_section(courseID: Int, sectionID: Int)
    case comments(courseID: Int, page: Int)
    case my_comment(courseID: Int)
    case post_comment(courseID: Int, starsCount: Int, content: String?)
    case course_category
    case courses(categoryID: Int?, page: Int)
    case course_toggle_favorites(courseID: Int)
    case course_favorites(Int)
    case courses_my(Int)
}

extension CourseAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: ServerHost)!
    }
    
    public var path: String {
        switch self {
        case let .course(courseID):
            return "/app/courses/\(courseID)"
        case let .course_sections(courseID):
            return "/app/courses/\(courseID)/course_catalogues"
        case let .course_section(courseID, sectionID):
            return "/app/courses/\(courseID)/course_catalogues/\(sectionID)"
        case .comments:
            return "/app/comments"
        case .my_comment:
            return "/app/comments/my"
        case .post_comment:
            return "/app/comments"
        case .course_category:
            return "/app/course_categories.json"
        case .courses:
            return "/app/courses.json"
        case let .course_toggle_favorites(courseID):
            return "/app/courses/\(courseID)/toggle_favorite"
        case .course_favorites:
            return "/app/favorites/courses.json"
        case .courses_my:
            return "/app/my/courses"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .course:
            return .get
        case .course_sections:
            return .get
        case .course_section:
            return .get
        case .comments:
            return .get
        case .my_comment:
            return .get
        case .post_comment:
            return .post
        case .course_category:
            return .get
        case .courses:
            return .get
        case .course_toggle_favorites:
            return .post
        case .course_favorites:
            return .get
        case .courses_my:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .course:
            return .requestPlain
        case .course_sections:
            return .requestPlain
        case .course_section:
            return .requestPlain
        case let .comments(courseID, page):
            return .requestParameters(parameters: ["type":"course", "type_id":courseID, "page":page], encoding: URLEncoding.default)
        case let .my_comment(courseID):
            return .requestParameters(parameters: ["type":"course", "type_id":courseID], encoding: URLEncoding.default)
        case let .post_comment(courseID, starsCount, content):
            var parameters: [String: Any] = ["[comment]commentable_type":"Course", "[comment]commentable_id":courseID, "[comment]star":starsCount]
            if let content = content {
                parameters["[comment]content"] = content
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .course_category:
            return .requestPlain
        case let .courses(categoryID, page):
            if let categoryID = categoryID {
                return .requestParameters(parameters: ["course_category_id":categoryID, "page":page, "per_page":"10"], encoding: URLEncoding.default)
            } else {
                return .requestParameters(parameters: ["page":page, "per_page":"10"], encoding: URLEncoding.default)
            }
        case .course_toggle_favorites:
            return .requestPlain
        case let .course_favorites(page):
            return .requestParameters(parameters: ["page":page, "per_page":"10"], encoding: URLEncoding.default)
        case let .courses_my(page):
            return .requestParameters(parameters: ["page":page, "per_page":"10"], encoding: URLEncoding.default)
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
