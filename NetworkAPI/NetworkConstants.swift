//
//  NetworkConstants.swift
//  HeyMail
//
//  Created by Vergil.Wang on 2018/7/19.
//  Copyright © 2018 heyooo. All rights reserved.
//

import Foundation
import Alamofire


//FIXME: Server Host
var CRMServerHost = "http://sg.1314-edu.com"

var ServerHost = "https://m.1314-edu.com"
//var ServerHost = "https://yy.1314-edu.com"

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
