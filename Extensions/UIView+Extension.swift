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
    
    public func drawSeparator(startPoint: CGPoint, endPoint: CGPoint, color: UIColor = UIColor("#e7e8ea")) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        line.path = linePath.cgPath
        line.strokeColor = color.cgColor
        line.lineWidth = 0.5
        layer.addSublayer(line)
    }
    
    public func drawRoundBg(roundedRect: CGRect, cornerRadius: CGFloat, color: UIColor = .white) {
        let sublayer = CAShapeLayer()
        let circlePath = UIBezierPath(roundedRect: roundedRect, cornerRadius: cornerRadius)
        sublayer.path = circlePath.cgPath
        sublayer.fillColor = color.cgColor
        layer.addSublayer(sublayer)
    }

    func drawGradientBg(roundedRect: CGRect, colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = roundedRect
        gradientLayer.colors = colors
        gradientLayer.locations = [0.0, 0.8]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.addSublayer(gradientLayer)
    }
}
