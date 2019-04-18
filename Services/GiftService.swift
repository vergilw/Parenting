//
//  GiftService.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/2/27.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

class GiftService {
    
    static let shared = GiftService()
    
    private init() { }
    
    func fetchGiftData() {
        
        VideoProvider.request(.video_gifts, completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if code >= 0 {
//                if let data = JSON?["gifts"] as? [String: Any] {
//                    self.messageModel = MessageModel.deserialize(from: data)
//                    self.reload()
//                }
                
            }
        }))
    }
}
