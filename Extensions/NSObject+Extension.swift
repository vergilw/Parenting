//
//  NSObject+Extension.swift
//  HeyMail
//
//  Created by Vergil.Wang on 2018/7/23.
//  Copyright © 2018 heyooo. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
