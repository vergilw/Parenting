//
//  UIView+Extension.swift
//  HeyMail
//
//  Created by mufeng on 2018/7/20.
//  Copyright © 2018 heyooo. All rights reserved.
//

import UIKit

extension UIView {
    
    @discardableResult
    public func addSubviews(_ subviews: UIView...) -> UIView{
        subviews.forEach(addSubview)
        return self
    }
    
    @discardableResult
    public func addSubviews(_ subviews: [UIView]) -> UIView{
        subviews.forEach (addSubview)
        return self
    }
    
    public func removeAllSubviews() {
        while subviews.count != 0 {
            subviews.last?.removeFromSuperview()
        }
    }
    
    public func drawSeparator(startPoint: CGPoint, endPoint: CGPoint) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        line.path = linePath.cgPath
        line.strokeColor = UIColor("f2f2f2").cgColor
        line.lineWidth = 1
        layer.addSublayer(line)
    }
}
