//
//  UIDevice+Extension.swift
//  HeyMail
//
//  Created by mufeng on 2018/7/27.
//  Copyright © 2018 heyooo. All rights reserved.
//

import UIKit

public extension UIDevice {
    
    static let screenBounds: CGRect = UIScreen.main.bounds
    
    static let screenWidth: CGFloat = UIDevice.screenBounds.size.width
    
    static let screenHeight: CGFloat = UIDevice.screenBounds.size.height
    
    var versionCode: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let versionCode: String = String(validatingUTF8: NSString(bytes: &systemInfo.machine,
                                                                  length: Int(_SYS_NAMELEN),
                                                                  encoding: String.Encoding.ascii.rawValue)!.utf8String!)!
        
        return versionCode
    }
    
    var isiPhoneX: Bool {
        return UIDevice.current.modelName == "iPhone X"
    }
    
    var isSmallScreen: Bool {
        return UIDevice.current.modelName == "iPhone 5" ||
            UIDevice.current.modelName == "iPhone 5C" ||
            UIDevice.current.modelName == "iPhone 5S" ||
            UIDevice.current.modelName == "iPhone SE" ||
            UIDevice.screenWidth < 375
    }
    
    var modelName: String {
        let versionCode = UIDevice.current.versionCode
        
        switch versionCode {
            
        case "iPhone5,1", "iPhone5,2":                   return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                   return "iPhone 5C"
        case "iPhone6,1", "iPhone6,2":                   return "iPhone 5S"
        case "iPhone7,2":                                return "iPhone 6"
        case "iPhone7,1":                                return "iPhone 6 Plus"
        case "iPhone8,1":                                return "iPhone 6S"
        case "iPhone8,2":                                return "iPhone 6S Plus"
        case "iPhone8,4":                                return "iPhone SE"
        case "iPhone9,1", "iPhone9,3":                   return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                   return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                 return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                 return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                 return "iPhone X"
            
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":            return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":            return "iPad 4"
        case "iPad6,11", "iPad6,12":                     return "iPad 5"
        case "iPad7,5", "iPad7,6":                       return "iPad 6"
        case "iPad4,1", "iPad4,2", "iPad4,3":            return "iPad Air"
        case "iPad5,3", "iPad5,4":                       return "iPad Air 2"
        case "iPad4,4", "iPad4,5", "iPad4,6":            return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":            return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                       return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                       return "iPad Pro 9.7"
        case "iPad7,3", "iPad7,4":                       return "iPad Pro 10.5"
        case "iPad6,7", "iPad6,8":                       return "iPad Pro 12.9"
        case "iPad7,1", "iPad7,2":                       return "iPad Pro 12.9 2nd"
            
        case "i386", "x86_64":                           return "Simulator"
        default:                                         return versionCode
        }
    }
}
