//
//  GiftPresentationView.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/3/1.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class GiftPresentationView: UIView {

    fileprivate lazy var titleImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_giftPresentTitle")
        return imgView
    }()
    
    fileprivate lazy var iconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    fileprivate lazy var bgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_giftPresentBg")
        return imgView
    }()
    
    init(imgURLString: String) {
        super.init(frame: .zero)
        
        iconImgView.kf.setImage(with: URL(string: imgURLString))
        
        addSubviews([titleImgView, bgImgView, iconImgView])
        
        initConstraints()
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        animation.values = [NSNumber(value: 0), NSNumber(value: -20), NSNumber(value: 0)]
        animation.keyTimes = [NSNumber(value: 0.0), NSNumber(value: 0.5), NSNumber(value: 1.0)]
        animation.duration = 2
        animation.repeatCount = .greatestFiniteMagnitude
        animation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)]
        iconImgView.layer.add(animation, forKey: "transformScaleAnimation")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func initConstraints() {
        titleImgView.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
        }
        bgImgView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(titleImgView.snp.bottom).offset(12)
        }
        iconImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualTo(38)
            make.trailing.lessThanOrEqualTo(-38)
            make.top.greaterThanOrEqualTo(titleImgView.snp.bottom).offset(10)
            make.bottom.lessThanOrEqualTo(-43)
        }
    }
}
