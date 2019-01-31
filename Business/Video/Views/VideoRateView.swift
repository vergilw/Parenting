//
//  VideoRateView.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/11.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import AudioToolbox

class VideoRateView: UIView {
    
    enum VideoRateMode {
        case topslow
        case slow
        case normal
        case fast
        case topfast
    }
    
    var completionHandler: ((VideoRateMode)->Void)?
    
    let scale: CGFloat =  1.0 //375.0/UIScreenWidth

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
        imgView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        imgView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*19.5).scaledBy(x: 0.0, y: 0.0)
        return imgView
    }()
    
    lazy fileprivate var topSlowLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = .white
        label.text = "极慢"
        return label
    }()
    
    let slowIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_shootRateIndicator")
        imgView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        imgView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*11).scaledBy(x: 0.5, y: 0.5)
        return imgView
    }()
    
    lazy fileprivate var slowLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = .white
        label.text = "慢"
        return label
    }()
    
    let normalIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_shootRateIndicator")
        imgView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        return imgView
    }()
    
    lazy fileprivate var normalLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = .white
        label.text = "正常"
        return label
    }()
    
    let fastIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_shootRateIndicator")
        imgView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        imgView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/180*11).scaledBy(x: 0.5, y: 0.5)
        return imgView
    }()
    
    lazy fileprivate var fastLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = .white
        label.text = "快"
        return label
    }()
    
    let topFastIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_shootRateIndicator")
        imgView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        imgView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/180*20).scaledBy(x: 0.0, y: 0.0)
        return imgView
    }()
    
    lazy fileprivate var topFastLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = .white
        label.text = "极快"
        return label
    }()
    
    var lastOffsetX: CGFloat = 0
    
    fileprivate lazy var sound: SystemSoundID = {
        let soundPath = Bundle.main.path(forResource: "dita", ofType: "wav")!
        var shakeSound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: soundPath) as CFURL, &shakeSound)
        return shakeSound
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubviews([bgImgView, contentView])
        contentView.addSubviews([topSlowIndicatorImgView, slowIndicatorImgView, normalIndicatorImgView, fastIndicatorImgView, topFastIndicatorImgView])
        contentView.addSubviews([topSlowLabel, slowLabel, normalLabel, fastLabel, topFastLabel])
        
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
        
        
        normalLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(normalIndicatorImgView.snp.top).offset(-10)
        }
        topSlowLabel.snp.makeConstraints { make in
            make.centerX.equalTo(topSlowIndicatorImgView).offset(8)
            make.bottom.equalTo(topSlowIndicatorImgView.snp.top).offset(-10)
        }
        slowLabel.snp.makeConstraints { make in
            make.centerX.equalTo(slowIndicatorImgView).offset(5)
            make.bottom.equalTo(slowIndicatorImgView.snp.top).offset(-10)
        }
        fastLabel.snp.makeConstraints { make in
            make.centerX.equalTo(fastIndicatorImgView).offset(-5)
            make.bottom.equalTo(fastIndicatorImgView.snp.top).offset(-10)
        }
        topFastLabel.snp.makeConstraints { make in
            make.centerX.equalTo(topFastIndicatorImgView).offset(-8)
            make.bottom.equalTo(topFastIndicatorImgView.snp.top).offset(-10)
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
        
        if sender.state == .changed {
            let amountX = sender.velocity(in: self).x/300
            lastOffsetX += amountX
            
            var offset: CGFloat = 0
            if lastOffsetX > 19.5 {
                offset = 19.5
            } else if lastOffsetX < -20 {
                offset = -20
            } else {
                offset = lastOffsetX
            }
            lastOffsetX = offset
            print(amountX, lastOffsetX)
//            if angle >= 11 {
//                topSlowIndicatorImgView.isHidden = false
//            } else {
//                topSlowIndicatorImgView.isHidden = true
//            }
            
            
            
            translatePanOffset(offset: lastOffsetX)
            
            
            
        } else if sender.state == .ended {
            if lastOffsetX >= 15 {
                lastOffsetX = 19.5
                UIView.animate(withDuration: 0.25) {
                    self.translatePanOffset(offset: self.lastOffsetX)
                }
                if let closure = completionHandler {
                    closure(.topslow)
                }
            } else if lastOffsetX >= 5.5 {
                lastOffsetX = 11
                UIView.animate(withDuration: 0.25) {
                    self.translatePanOffset(offset: self.lastOffsetX)
                }
                if let closure = completionHandler {
                    closure(.slow)
                }
            } else if lastOffsetX >= -5.5 {
                lastOffsetX = 0
                UIView.animate(withDuration: 0.25) {
                    self.translatePanOffset(offset: self.lastOffsetX)
                }
                if let closure = completionHandler {
                    closure(.normal)
                }
            } else if lastOffsetX >= -15 {
                lastOffsetX = -11
                UIView.animate(withDuration: 0.25) {
                    self.translatePanOffset(offset: self.lastOffsetX)
                }
                if let closure = completionHandler {
                    closure(.fast)
                }
            } else {
                lastOffsetX = -20
                UIView.animate(withDuration: 0.25) {
                    self.translatePanOffset(offset: self.lastOffsetX)
                }
                if let closure = completionHandler {
                    closure(.topfast)
                }
                
//                if lastOffsetX > 10 {
//                    AudioServicesPlaySystemSound(sound)
                
//                }
            }
        }
        
    }
    
    fileprivate func translatePanOffset(offset: CGFloat) {
        let offsetX = abs(offset)
        topSlowIndicatorImgView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*19.5).scaledBy(x: offsetX/19.5, y: offsetX/19.5)
        topSlowLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*offset)
        
        slowIndicatorImgView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*11).scaledBy(x: 1.0-abs(offset-11)/22, y: 1.0-abs(offset-11)/22)
        slowLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*offset)
        
        normalIndicatorImgView.transform = CGAffineTransform(scaleX: (abs(offset)-22)/22, y: -(abs(offset)-22)/22)
        normalLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*offset)
        
        fastIndicatorImgView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/180*11).scaledBy(x: 1.0-abs(offset+11)/22, y: 1.0-abs(offset+11)/22)
        fastLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*offset)
        
        topFastIndicatorImgView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/180*20).scaledBy(x: offsetX/20, y: offsetX/20)
        topFastLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*offset)
        
        contentView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/180*offset)
    }
    
    deinit {
        AudioServicesDisposeSystemSoundID(sound)
    }
}
