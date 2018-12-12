//
//  AppCacheService.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/9.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Foundation

class AppCacheService {
    
    static let sharedInstance = AppCacheService()
    
    lazy fileprivate var cache = YYCache(name: "D" + String(describing: type(of: self)))
    
    var autoplayOnWWAN: Bool?
    
    var lastFetchingPasscodeDate: Date? {
        get {
            let date = cache?.object(forKey: "fetchingPasscodeDate") as? Date
            return date
        }
        set {
            if newValue != nil {
                cache?.setObject(newValue as NSCoding?, forKey: "fetchingPasscodeDate")
            } else {
                cache?.removeObject(forKey: "fetchingPasscodeDate")
            }
        }
    }
    
    var isFirstLaunch: Bool? {
        get {
            if let bool = cache?.object(forKey: "firstLaunch") as? Bool {
                return bool
            } else {
                cache?.setObject(true as NSCoding?, forKey: "firstLaunch")
                return true
            }
        }
        set {
            if newValue != nil {
                cache?.setObject(newValue as NSCoding?, forKey: "firstLaunch")
            } else {
                cache?.removeObject(forKey: "firstLaunch")
            }
        }

    }
    
    private init() { }
    
    
}
