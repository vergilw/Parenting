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
        
        @objc public static let signOut: Notification.Name = Notification.Name(String(describing: Authorization.self) + #keyPath(signOut))
    }

    public class Mail {
        @objc public static let mailModelsCountDidChange: Notification.Name = Notification.Name(String(describing: Mail.self) + #keyPath(mailModelsCountDidChange))
        
        @objc public static let mailModelsValueDidChange: Notification.Name = Notification.Name(String(describing: Mail.self) + #keyPath(mailModelsValueDidChange))
        
        @objc public static let mailboxModelsCountDidChange: Notification.Name = Notification.Name(String(describing: Mail.self) + #keyPath(mailboxModelsCountDidChange))
        
        @objc public static let mailboxModelsValueDidChange: Notification.Name = Notification.Name(String(describing: Mail.self) + #keyPath(mailboxModelsValueDidChange))
        
        @objc public static let mailboxSelectDidChange: Notification.Name = Notification.Name(String(describing: Mail.self) + #keyPath(mailboxSelectDidChange))
    }
    
    public class Setting {
        @objc public static let userSettingChange: Notification.Name = Notification.Name(String(describing: Setting.self) + #keyPath(userSettingChange))
    }
    
    public class Write {
        @objc public static let contactTextViewDidChange: Notification.Name = Notification.Name(String(describing: Write.self) + #keyPath(contactTextViewDidChange))
    }
}
