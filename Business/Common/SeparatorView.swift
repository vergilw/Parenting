//
//  SeparatorView.swift
//  imystery
//
//  Created by Vergil.Wang on 2018/9/29.
//

import UIKit

class SeparatorView: UIView {

    override func draw(_ rect: CGRect) {
//        let context = UIGraphicsGetCurrentContext()
//        drawHairline(in: context!, scale: UIScreen.main.scale, color: UIColor.gray.cgColor)
        
//        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let scale = UIScreen.main.scale
        
        let width = 1 / scale
        let offset = width / 2
        
        context.setLineWidth(width)
        context.setStrokeColor(UIColor(red: 243/255.0, green: 244/255.0, blue: 246/255.0, alpha: 1.0).cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: 0, y: rect.maxY - offset))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - offset))
        context.strokePath()
    }
    
    // pass in the scale of your UIScreen
    func drawHairline(in context: CGContext, scale: CGFloat, color: CGColor) {
        
        // pick which row/column of pixels to treat as the "center" of a point
        // through which to draw lines -- favor true center for odd scales, or
        // offset to the side for even scales so we fall on pixel boundaries
        let center: CGFloat
        if Int(scale) % 2 == 0 {
            center = 1 / (scale * 2)
        } else {
            center = 0
        }
        
        let offset = 0.5 - center // use the "center" choice to create an offset
        let p1 = CGPoint(x: 0, y: 0 + offset)
        let p2 = CGPoint(x: UIScreen.main.bounds.size.width + offset, y: 0 + offset)
        
        // draw line of minimal stroke width
        let width = 1 / scale
        context.setLineWidth(width)
        context.setStrokeColor(color)
        context.beginPath()
        context.move(to: p1)
        context.addLine(to: p2)
        context.strokePath()
    }
}
