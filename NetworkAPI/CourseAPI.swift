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

let CourseProvider = MoyaProvider<CourseAPI>()

enum CourseAPI {
    case course(courseID: Int)
    case course_sections(courseID: Int)
    case course_section(courseID: Int, sectionID: Int)
    case comments(courseID: Int, page: Int)
    case my_comment(courseID: Int)
    case post_comment(courseID: Int, starsCount: Int, content: String?)
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
