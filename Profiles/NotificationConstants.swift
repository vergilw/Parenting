//
//  NotificationConstants.swift
//  HeyMail
//
//  Created by Vergil.Wang on 2018/7/23.
//  Copyright © 2018 heyooo. All rights reserved.
//

import Foundation

public extension Notification {
    
    class Authorization {
        @objc public static let signInDidSuccess: Notification.Name = Notification.Name(String(describing: Authorization.self) + #keyPath(signInDidSuccess))
        
        @objc public static let signOutDidSuccess: Notification.Name = Notification.Name(String(describing: Authorization.self) + #keyPath(signOutDidSuccess))
    }
    
    class User {
        @objc public static let userInfoDidChange: Notification.Name = Notification.Name(String(describing: User.self) + #keyPath(userInfoDidChange))
    }
    
    class Payment {
        @objc public static let payCourseDidSuccess: Notification.Name = Notification.Name(String(describing: Payment.self) + #keyPath(payCourseDidSuccess))
    }
    
    class Course {
        @objc public static let courseRecordDidChanged: Notification.Name = Notification.Name(String(describing: Course.self) + #keyPath(courseRecordDidChanged))
        
    }
    
    class Video {
        @objc public static let rewardStatusDidChange: Notification.Name = Notification.Name(String(describing: Video.self) + #keyPath(rewardStatusDidChange))
        
        @objc public static let commentCountDidChange: Notification.Name = Notification.Name(String(describing: Video.self) + #keyPath(commentCountDidChange))
        
        @objc public static let videoSubmitDidSuccess: Notification.Name = Notification.Name(String(describing: Video.self) + #keyPath(videoSubmitDidSuccess))
        
        @objc public static let videoFavoritesDidChange: Notification.Name = Notification.Name(String(describing: Video.self) + #keyPath(videoFavoritesDidChange))
        
        @objc public static let videoGiftGiveDidSuccess: Notification.Name = Notification.Name(String(describing: Video.self) + #keyPath(videoGiftGiveDidSuccess))
    }
    
    class Setting {
        @objc public static let userSettingChange: Notification.Name = Notification.Name(String(describing: Setting.self) + #keyPath(userSettingChange))
    }
    
    class Message {
        @objc public static let messageUnreadCountDidChange: Notification.Name = Notification.Name(String(describing: Message.self) + #keyPath(messageUnreadCountDidChange))
    }
    
}
