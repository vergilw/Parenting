//
//  UIConstants.swift
//  HeyMail
//
//  Created by Vergil.Wang on 2018/7/19.
//  Copyright © 2018 heyooo. All rights reserved.
//

import Foundation
import UIKit

enum UIConstants {
    case head
    case subhead
    case body
    case description
    case footnote
    
    case primary
    
    public var color: UIColor {
        switch self {
        case .head:
            return UIColor("#000")
        case .subhead:
            return UIColor("#343434")
        case .body:
            return UIColor("#343434")
        case .description:
            return UIColor("#838a96")
        case .footnote:
            return UIColor("#cacaca")
            
        case .primary:
            return UIColor("#3A7082")
        }
    }
    
    public var font: UIFont {
        switch self {
        case .head:
            return UIFont.systemFont(ofSize: 20, weight: .semibold)
        case .subhead:
            return UIFont.systemFont(ofSize: 18)
        case .body:
            return UIFont.systemFont(ofSize: 16)
        case .description:
            return UIFont.systemFont(ofSize: 14)
        case .footnote:
            return UIFont.systemFont(ofSize: 14)
            
        default:
            return UIFont.systemFont(ofSize: 14)
        }
    }
}

//struct UIConstants {
//
//    static let COLOR_BG_PLACEHOLDER: UIColor = UIColor(red: 0xea, green: 0xea, blue: 0xea, alpha: 1.0)
//    static let COLOR_LINE_SEPARATOR: UIColor = UIColor(red: 0xf2, green: 0xf2, blue: 0xf2, alpha: 1.0)
//    static let COLOR_BG: UIColor = UIColor(red: 0xf2, green: 0xf2, blue: 0xf2, alpha: 1.0)
//}
