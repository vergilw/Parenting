//
//  ParagraphLabel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/31.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class ParagraphLabel: UILabel {

//    override var intrinsicContentSize: CGSize {
//        if font == UIConstants.Font.h1 ||
//            font == UIConstants.Font.h2 ||
//            font == UIConstants.Font.h3 ||
//            font == UIConstants.Font.body {
//            if let size = attributedText?.boundingRect(with: CGSize(width: preferredMaxLayoutWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size {
//                if size.height <= font.lineHeight*2 {
//                    return CGSize(width: size.width, height: font.lineHeight - (font.lineHeight - font.pointSize))
//                }
//            }
//        }
//        
//        return super.intrinsicContentSize
//    }

    public func setParagraphText(_ text: String) {
//        guard numberOfLines != 1 else {
//            assertionFailure("numberOfLines is 1")
//            return
//        }
//        guard preferredMaxLayoutWidth != 0 else {
//            assertionFailure("preferredMaxLayoutWidth is 0.0")
//            return
//        }
        
        let attributedString = NSMutableAttributedString(string: text)
        
        let paragraph = NSMutableParagraphStyle()
        var lineHeight: CGFloat = 0
        if font == UIConstants.Font.h1 {
//            paragraph.lineSpacing = UIConstants.LineSpacing.h1 - (font.lineHeight - font.pointSize)
            lineHeight = UIConstants.LineHeight.h1
            
        } else if font == UIConstants.Font.h2 {
//            paragraph.lineSpacing = UIConstants.LineSpacing.h2 - (font.lineHeight - font.pointSize)
            lineHeight = UIConstants.LineHeight.h2
            
        } else if font == UIConstants.Font.h3 {
//            paragraph.lineSpacing = UIConstants.LineSpacing.h3 - (font.lineHeight - font.pointSize)
            lineHeight = UIConstants.LineHeight.h3
            
        } else if font == UIConstants.Font.body {
//            paragraph.lineSpacing = UIConstants.LineSpacing.body - (font.lineHeight - font.pointSize)
            lineHeight = UIConstants.LineHeight.body
            
        } else if font == UIConstants.Font.foot {
//            paragraph.lineSpacing = UIConstants.LineSpacing.body - (font.lineHeight - font.pointSize)
            lineHeight = UIConstants.LineHeight.foot
        } else {
            lineHeight = font.pointSize
        }
        paragraph.maximumLineHeight = lineHeight
        paragraph.minimumLineHeight = lineHeight
        
        attributedString.addAttributes([
            NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.baselineOffset: (lineHeight-font.lineHeight)/4, NSAttributedString.Key.font: font], range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
        
        let textHeight = attributedText!.boundingRect(with: CGSize(width: preferredMaxLayoutWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size.height
        if textHeight >= lineHeight*2 {
            
            if font == UIConstants.Font.h1 {
//            paragraph.lineSpacing = UIConstants.LineSpacing.h1 - (font.lineHeight - font.pointSize)
                lineHeight = UIConstants.ParagraphLineHeight.h1
                
            } else if font == UIConstants.Font.h2 {
//            paragraph.lineSpacing = UIConstants.LineSpacing.h2 - (font.lineHeight - font.pointSize)
                lineHeight = UIConstants.ParagraphLineHeight.h2
                
            } else if font == UIConstants.Font.h3 {
//            paragraph.lineSpacing = UIConstants.LineSpacing.h3 - (font.lineHeight - font.pointSize)
                lineHeight = UIConstants.ParagraphLineHeight.h3
                
            } else if font == UIConstants.Font.body {
//            paragraph.lineSpacing = UIConstants.LineSpacing.body - (font.lineHeight - font.pointSize)
                lineHeight = UIConstants.ParagraphLineHeight.body
                
            } else if font == UIConstants.Font.foot {
//            paragraph.lineSpacing = UIConstants.LineSpacing.body - (font.lineHeight - font.pointSize)
                lineHeight = UIConstants.ParagraphLineHeight.foot
            } else {
                lineHeight = font.pointSize * 1.2
            }
            paragraph.maximumLineHeight = lineHeight
            paragraph.minimumLineHeight = lineHeight
            
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes([
                NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.baselineOffset: (lineHeight-font.lineHeight)/4+1.25, NSAttributedString.Key.font: font], range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}
