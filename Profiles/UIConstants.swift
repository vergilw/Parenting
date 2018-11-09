//
//  UIConstants.swift
//  HeyMail
//
//  Created by Vergil.Wang on 2018/7/19.
//  Copyright © 2018 heyooo. All rights reserved.
//

import Foundation
import UIKit

let UIScreenWidth = UIScreen.main.bounds.size.width
let UIScreenHeight = UIScreen.main.bounds.size.height
let UIStatusBarHeight = UIApplication.shared.statusBarFrame.size.height

public struct UIConstants {
    
    public struct Color {
        public static let primaryGreen: UIColor = UIColor("#00a7a9")
        public static let primaryOrange: UIColor = UIColor("#f6a500")
        public static let primaryRed: UIColor = UIColor("#f05053")
        
        public static let head: UIColor = UIColor("#222")
        public static let subhead: UIColor = UIColor("#333")
        public static let body: UIColor = UIColor("#666")
        public static let foot: UIColor = UIColor("#999")
        public static let disable: UIColor = UIColor("#ccc")
        
        public static let background: UIColor = UIColor("#f3f4f6")
        public static let separator: UIColor = UIColor("#e7e8ea")
    }
    
    public struct Font {
        public static let h1: UIFont = UIFont(name: "PingFangSC-Semibold", size: 25)!
        public static let h2: UIFont = UIFont(name: "PingFangSC-Semibold", size: 18)!
        public static let h3: UIFont = UIFont(name: "PingFangSC-Medium", size: 17)!
        
        public static let body: UIFont = UIFont(name: "PingFangSC-Regular", size: 15)!
        public static let foot: UIFont = UIFont(name: "PingFangSC-Regular", size: 12)!
    }
    
    public struct Size {
        public static let avatar: CGSize = CGSize(width: 30, height: 30)
        
    }
    
    public struct ParagraphLineHeight {
        public static let h1: CGFloat = 38.5
        public static let h2: CGFloat = 31
        public static let h3: CGFloat = 29
        
        public static let body: CGFloat = 26
        public static let foot: CGFloat = 22
    }
    
    public struct LineHeight {
        public static let h1: CGFloat = 25
        public static let h2: CGFloat = 18
        public static let h3: CGFloat = 17
        
        public static let body: CGFloat = 15
        public static let foot: CGFloat = 12
    }
    
    public struct LineSpacing {
        public static let h1: CGFloat = 15
        public static let h2: CGFloat = 14
        public static let h3: CGFloat = 13
        
        public static let body: CGFloat = 12
        public static let foot: CGFloat = 10
    }
    
    public struct Margin {
        public static let leading: CGFloat = 25
        public static let trailing: CGFloat = 25
        public static let top: CGFloat = 16
        public static let bottom: CGFloat = 16
    }
    
    public static let cornerRadius: CGFloat = 2.5
}
