//
//  CourseAPI.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/25.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Foundation
import Moya

let CourseProvider = MoyaProvider<CourseAPI>()

enum CourseAPI {
    case course(courseID: Int)
    case course_sections(courseID: Int)
    case course_section(courseID: Int, sectionID: Int)
}

extension CourseAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: ServerHost)!
    }
    
    public var path: String {
        switch self {
        case let .course(courseID):
            return "/courses/\(courseID)"
        case let .course_sections(courseID):
            return "/courses/\(courseID)/course_catalogues"
        case let .course_section(courseID, sectionID):
            return "/courses/\(courseID)/course_catalogues/\(sectionID)"
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

        }
    }
    
    var validationType: ValidationType {
        return .none
    }
    
    var headers: [String: String]? {
        return nil
    }
}
