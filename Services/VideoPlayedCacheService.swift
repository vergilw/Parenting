//
//  VideoPlayedCacheService.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/28.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

class VideoPlayedCacheService {
    
    static let shared = VideoPlayedCacheService()
    
    private init() { }
    
    lazy fileprivate var cache = YYCache(name: "D" + String(describing: type(of: self)))
    
    var finishedPlayingIDs: [Int]? {
        get {
            return cache?.object(forKey: "finishedPlayingIDs") as? [Int]
        }
        set {
            if let newValue = newValue {
                if newValue.count > 10 {
                    cache?.setObject(Array(newValue[newValue.count-10...newValue.count-1]) as NSCoding?, forKey: "finishedPlayingIDs")
                } else {
                    cache?.setObject(newValue as NSCoding?, forKey: "finishedPlayingIDs")
                }
            } else {
                cache?.removeObject(forKey: "finishedPlayingIDs")
            }
        }
    }
    
    func cacheFinishedID(_ id: Int) {
        if finishedPlayingIDs == nil {
            finishedPlayingIDs = [Int]()
        }
        if !(finishedPlayingIDs?.contains(id) ?? true) {
            finishedPlayingIDs?.append(id)
        }
    }
}
