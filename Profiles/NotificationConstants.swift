//
//  NotificationConstants.swift
//  HeyMail
//
//  Created by Vergil.Wang on 2018/7/23.
//  Copyright © 2018 heyooo. All rights reserved.
//

import Foundation

public extension Notification {
    
    public class Authorization {
        @objc public static let signInDidSuccess: Notification.Name = Notification.Name(String(describing: Authorization.self) + #keyPath(signInDidSuccess))
        
        @objc public static let signOutDidSuccess: Notification.Name = Notification.Name(String(describing: Authorization.self) + #keyPath(signOutDidSuccess))
    }
    
    public class User {
        @objc public static let userInfoDidChange: Notification.Name = Notification.Name(String(describing: User.self) + #keyPath(userInfoDidChange))
    }
    
    public class Payment {
        @objc public static let payCourseDidSuccess: Notification.Name = Notification.Name(String(describing: Payment.self) + #keyPath(payCourseDidSuccess))
    }
    
    public class Course {
        @objc public static let courseRecordDidChanged: Notification.Name = Notification.Name(String(describing: Course.self) + #keyPath(courseRecordDidChanged))
        
    }
    
    public class Video {
        @objc public static let rewardStatusDidChange: Notification.Name = Notification.Name(String(describing: Video.self) + #keyPath(rewardStatusDidChange))
        
        @objc public static let commentCountDidChange: Notification.Name = Notification.Name(String(describing: Video.self) + #keyPath(commentCountDidChange))
        
        @objc public static let videoSubmitDidSuccess: Notification.Name = Notification.Name(String(describing: Video.self) + #keyPath(videoSubmitDidSuccess))
        
        @objc public static let videoFavoritesDidChange: Notification.Name = Notification.Name(String(describing: Video.self) + #keyPath(videoFavoritesDidChange))
    }
    
    public class Setting {
        @objc public static let userSettingChange: Notification.Name = Notification.Name(String(describing: Setting.self) + #keyPath(userSettingChange))
    }
    
}
