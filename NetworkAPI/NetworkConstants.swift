//
//  NetworkConstants.swift
//  HeyMail
//
//  Created by Vergil.Wang on 2018/7/19.
//  Copyright © 2018 heyooo. All rights reserved.
//

import Foundation
import Alamofire


//#if DEBUG
    var ServerHost = "http://m.1314-edu.com"
//#else
//    var ServerHost = "https://yy.1314-edu.com"
//#endif

class DefaultAlamofireManager: Alamofire.SessionManager {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 15 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 15 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}
