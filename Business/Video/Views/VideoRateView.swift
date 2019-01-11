//
//  VideoRateView.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/11.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class VideoRateView: UIView {
    
    let scale: CGFloat = 375.0/UIScreenWidth

    lazy fileprivate var bgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_shootRatePanel")
        return imgView
    }()
    
    lazy fileprivate var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let topSlowIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_shootRateIndicator")
        imgView.alpha = 0
        imgView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        imgView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*18.5).scaledBy(x: 0.0, y: 0.0)
        return imgView
    }()
    
    let slowIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_shootRateIndicator")
        imgView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        imgView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*11).scaledBy(x: 0.5, y: 0.5)
        return imgView
    }()
    
    let normalIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_shootRateIndicator")
        imgView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        return imgView
    }()
    
    let fastIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_shootRateIndicator")
        imgView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        imgView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/180*11).scaledBy(x: 0.5, y: 0.5)
        return imgView
    }()
    
    let topFastIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_shootRateIndicator")
        imgView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        imgView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/180*20.5).scaledBy(x: 0.5, y: 0.5)
        return imgView
    }()
    
    var lastOffsetX: CGFloat = 0
    
    init() {
        super.init(frame: .zero)
        
        addSubviews([bgImgView, contentView])
        contentView.addSubviews([topSlowIndicatorImgView, slowIndicatorImgView, normalIndicatorImgView, fastIndicatorImgView, topFastIndicatorImgView])
        
        bgImgView.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 851*scale, height: 851*scale))
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        normalIndicatorImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(4)
        }
        topSlowIndicatorImgView.snp.makeConstraints { make in
            make.trailing.equalTo(normalIndicatorImgView.snp.leading).offset(-66*2*scale)
            make.bottom.equalTo(-22*scale)
        }
        slowIndicatorImgView.snp.makeConstraints { make in
            make.trailing.equalTo(normalIndicatorImgView.snp.leading).offset(-66*scale)
            make.bottom.equalTo(-3.5*scale)
        }
        fastIndicatorImgView.snp.makeConstraints { make in
            make.leading.equalTo(normalIndicatorImgView.snp.trailing).offset(66*scale)
            make.bottom.equalTo(-3.5*scale)
        }
        topFastIndicatorImgView.snp.makeConstraints { make in
            make.leading.equalTo(normalIndicatorImgView.snp.trailing).offset(66*2*scale)
            make.bottom.equalTo(-22*scale)
        }
        
        let panGesture: UIPanGestureRecognizer = {
            let view = UIPanGestureRecognizer(target: self, action: #selector(gestureAction(sender:)))
            return view
        }()
        addGestureRecognizer(panGesture)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    @objc func gestureAction(sender: UIPanGestureRecognizer) {
        
        if sender.state == .began {
//            lastOffsetX = 0
            
        } else if sender.state == .changed {
            let amount = sender.translation(in: self)
            
            if amount.x > 18.5 {
                lastOffsetX = 18.5
            } else if amount.x < -22 {
                lastOffsetX = -22
            } else {
                lastOffsetX = amount.x
            }
            print(lastOffsetX)
//            if angle >= 11 {
//                topSlowIndicatorImgView.isHidden = false
//            } else {
//                topSlowIndicatorImgView.isHidden = true
//            }
            
            let offsetX = abs(lastOffsetX)
            if offsetX > 11 {
                topSlowIndicatorImgView.alpha = 1
            } else {
                topSlowIndicatorImgView.alpha = lastOffsetX/11
            }
            topSlowIndicatorImgView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*18.5).scaledBy(x: offsetX/18.5, y: offsetX/18.5)
            
            
            slowIndicatorImgView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*11).scaledBy(x: 1.0-abs(lastOffsetX-11)/22, y: 1.0-abs(lastOffsetX-11)/22)
            
            normalIndicatorImgView.transform = CGAffineTransform(scaleX: (abs(lastOffsetX)-22)/22, y: -(abs(lastOffsetX)-22)/22)
            
            
            contentView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/180*lastOffsetX)
            
        }
        
    }
}
