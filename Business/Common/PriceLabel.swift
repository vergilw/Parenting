//
//  PriceLabel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/17.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class PriceLabel: UILabel {

    lazy fileprivate var strikethroughLayer: CAShapeLayer? = nil
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override var intrinsicContentSize: CGSize {
        if let size = attributedText?.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size {
            return CGSize(width: size.width+0.5, height: font.lineHeight /*- (font.lineHeight - font.pointSize)*/)
        }

        return super.intrinsicContentSize
    }

    func setPriceText(text: String, symbol: String? = nil, discount: Float? = nil) {
        if let strikethroughLayer = strikethroughLayer {
            strikethroughLayer.removeFromSuperlayer()
            self.strikethroughLayer = nil
        }
        
        let formatterText: String = String.priceFormatter.string(from: (NSNumber(string: text) ?? NSNumber())) ?? ""
        var formatterDiscount: String?
        if let discount = discount, discount != 0 {
            formatterDiscount = String.priceFormatter.string(from: (NSNumber(value: discount)))
        }
        
        var text: String = "\(formatterText)"
        if let symbol = symbol {
            text = " \(symbol)\(text)"
        }
        if let formatterDiscount = formatterDiscount {
            text = "\(text)  \(formatterDiscount) "
        }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([NSAttributedString.Key.font: font as UIFont], range: NSRange(location: 0, length: attributedString.length))
        if let symbol = symbol, (symbol == "+" || symbol == "-") {
            attributedString.addAttributes([NSAttributedString.Key.baselineOffset: (font.lineHeight-singlelineHeight(font: font))/4], range: NSString(string: text).range(of: symbol))
        }
        if let formatterDiscount = formatterDiscount {
            attributedString.addAttributes([NSAttributedString.Key.font : UIConstants.Font.foot, NSAttributedString.Key.foregroundColor: UIColor("#cacaca")], range: NSString(string: text).range(of: " \(formatterDiscount) "))
        }
        attributedText = attributedString
        
        if let formatterDiscount = formatterDiscount {
            let indentSize: CGSize = NSString(string: "\(formatterText) ").boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: UIConstants.Font.h3], context: nil).size
            let strikethroughSize: CGSize = NSString(string: " \(formatterDiscount) ").boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: UIConstants.Font.foot], context: nil).size
            let size = attributedText?.size() ?? .zero
            let strikethroughHeight = (size.height - (size.height - strikethroughSize.height) + (font.lineHeight - font.pointSize)) / 2
                
            strikethroughLayer = CAShapeLayer()
            let linePath = UIBezierPath()
            linePath.move(to: CGPoint(x: indentSize.width, y: strikethroughHeight))
            linePath.addLine(to: CGPoint(x: indentSize.width+strikethroughSize.width, y: strikethroughHeight))
            strikethroughLayer?.path = linePath.cgPath
            strikethroughLayer?.strokeColor = UIColor("#acacac").cgColor
            strikethroughLayer?.lineWidth = 1.0
            layer.addSublayer(strikethroughLayer!)
        }
    }
    
    func setStatisticText(string: String) {
        guard let string = Float(string) else { return }
        
        if string < 1000 {
            setPriceText(text: String(string))
            return
        }
        
        text = String(format: "%.3fk", string/1000.0)
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
}
