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
    case course
}

extension CourseAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: ServerHost)!
    }
    
    public var path: String {
        switch self {
        case .course:
            return "/courses/2"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .course:
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
        }
    }
    
    var validationType: ValidationType {
        return .none
    }
    
    var headers: [String: String]? {
        return nil
    }
}
