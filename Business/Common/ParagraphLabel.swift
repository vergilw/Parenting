//
//  ParagraphLabel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/31.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class ParagraphLabel: UILabel {

    
    lazy var originalFont: UIFont? = nil
    
    lazy var originalForegroundColor: UIColor? = nil
    
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
        
        setSymbolText(text, symbolText: nil, symbolAttributes: nil)
        /*
//        guard numberOfLines != 1 else {
//            assertionFailure("numberOfLines is 1")
//            return
//        }
//        guard preferredMaxLayoutWidth != 0 else {
//            assertionFailure("preferredMaxLayoutWidth is 0.0")
//            return
//        }
        
        if let originalFont = originalFont {
            font = originalFont
        }
        if let originalForegroundColor = originalForegroundColor {
            textColor = originalForegroundColor
        }
        
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
        paragraph.alignment = textAlignment
        attributedString.addAttributes([
            NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.baselineOffset: (lineHeight-font.lineHeight)/4, NSAttributedString.Key.font: font], range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
        
        let textHeight = attributedText!.boundingRect(with: CGSize(width: preferredMaxLayoutWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size.height
        if textHeight >= lineHeight*2 && numberOfLines != 1 {
            
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
 */
    }
    
    
    public func setPriceText(_ text: String, symbolFont: UIFont) {
        setSymbolText(text, symbolText: "¥", symbolAttributes: [NSAttributedString.Key.font : symbolFont])
    }
    
    
    public func setSymbolText(_ text: String, symbolText: String?, symbolAttributes: [NSAttributedString.Key : Any]?) {
        
        if let originalFont = originalFont {
            font = originalFont
        }
        if let originalForegroundColor = originalForegroundColor {
            textColor = originalForegroundColor
        }
        
        let attributedString = NSMutableAttributedString(string: text)
        
        let paragraph = NSMutableParagraphStyle()
        var lineHeight: CGFloat = singlelineHeight(font: font)
        paragraph.maximumLineHeight = lineHeight
        paragraph.minimumLineHeight = lineHeight
        paragraph.alignment = textAlignment
        paragraph.lineBreakMode = lineBreakMode
        
        attributedString.addAttributes([
            NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.baselineOffset: (lineHeight-font.lineHeight)/4, NSAttributedString.Key.font: font], range: NSRange(location: 0, length: attributedString.length))
        originalFont = font
        originalForegroundColor = textColor
        
        //FIXME: price display error
        if let symbolAttributes = symbolAttributes, let symbolText = symbolText {
            var attributes = symbolAttributes
            if let symbolFont = attributes[NSAttributedString.Key.font] as? UIFont {
                attributes[NSAttributedString.Key.baselineOffset] = (singlelineHeight(font: symbolFont)-symbolFont.lineHeight)/4
                
//                let paragraph = NSMutableParagraphStyle()
//                let lineHeight: CGFloat = singlelineHeight(font: symbolFont)
//                paragraph.maximumLineHeight = lineHeight
//                paragraph.minimumLineHeight = lineHeight
//                paragraph.alignment = textAlignment
//                paragraph.lineBreakMode = lineBreakMode
//
//                attributes[NSAttributedString.Key.paragraphStyle] = paragraph
            }
            attributedString.addAttributes(attributes, range: NSString(string: text).range(of: symbolText))
        }
        attributedText = attributedString
        
        
        let textHeight = attributedText!.boundingRect(with: CGSize(width: preferredMaxLayoutWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size.height
        if (textHeight >= lineHeight*2 || numberOfLines != 1) {
            
            lineHeight = multilineHeight(font: font)
            paragraph.maximumLineHeight = lineHeight
            paragraph.minimumLineHeight = lineHeight
            paragraph.alignment = textAlignment
            paragraph.lineBreakMode = lineBreakMode
            
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes([
                NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.baselineOffset: (lineHeight-font.lineHeight)/4+1.25, NSAttributedString.Key.font: font], range: NSRange(location: 0, length: attributedString.length))
            if let symbolAttributes = symbolAttributes, let symbolText = symbolText {
                var attributes = symbolAttributes
                if let symbolFont = attributes[NSAttributedString.Key.font] as? UIFont {
                    attributes[NSAttributedString.Key.baselineOffset] = (multilineHeight(font: symbolFont)-symbolFont.lineHeight)/4+1.25
                }
                attributedString.addAttributes(attributes, range: NSString(string: text).range(of: symbolText))
            }
            attributedText = attributedString
        }
    }
    
    fileprivate func singlelineHeight(font: UIFont) -> CGFloat {
        var lineHeight: CGFloat = 0
        if font == UIConstants.Font.h1 {
            lineHeight = UIConstants.LineHeight.h1
            
        } else if font == UIConstants.Font.h2 {
            lineHeight = UIConstants.LineHeight.h2
            
        } else if font == UIConstants.Font.h3 {
            lineHeight = UIConstants.LineHeight.h3
            
        } else if font == UIConstants.Font.body {
            lineHeight = UIConstants.LineHeight.body
            
        } else if font == UIConstants.Font.foot {
            lineHeight = UIConstants.LineHeight.foot
        } else {
            lineHeight = font.pointSize
        }
        return lineHeight
    }
    
    fileprivate func multilineHeight(font: UIFont) -> CGFloat {
        var lineHeight: CGFloat = 0
        if font == UIConstants.Font.h1 {
            lineHeight = UIConstants.ParagraphLineHeight.h1
            
        } else if font == UIConstants.Font.h2 {
            lineHeight = UIConstants.ParagraphLineHeight.h2
            
        } else if font == UIConstants.Font.h3 {
            lineHeight = UIConstants.ParagraphLineHeight.h3
            
        } else if font == UIConstants.Font.body {
            lineHeight = UIConstants.ParagraphLineHeight.body
            
        } else if font == UIConstants.Font.foot {
            lineHeight = UIConstants.ParagraphLineHeight.foot
        } else {
            lineHeight = font.pointSize * 1.2
        }
        return lineHeight
    }
}
