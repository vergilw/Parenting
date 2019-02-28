//
//  RewardGiftCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/2/28.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class RewardGiftCell: UICollectionViewCell {
    
    fileprivate lazy var iconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    fileprivate lazy var bgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_giftSelectedBg")
        imgView.isHidden = true
        return imgView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot1
        label.textColor = .white
        return label
    }()
    
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Regular", size: 9)!
        label.textColor = UIColor("#aaaaaa")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews([iconImgView, titleLabel, priceLabel, bgImgView])
        
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func initConstraints() {
        iconImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualTo(20)
            make.trailing.lessThanOrEqualTo(-20)
            make.top.greaterThanOrEqualTo(12)
            make.bottom.lessThanOrEqualTo(titleLabel.snp.top).offset(-12)
        }
        bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(72)
            make.height.equalTo(12)
        }
        priceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.height.equalTo(9)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                bgImgView.isHidden = false
                
                let animation = CAKeyframeAnimation(keyPath: "transform.scale")
                animation.values = [NSNumber(value: 1.0), NSNumber(value: 0.9), NSNumber(value: 1.0)]
                animation.keyTimes = [NSNumber(value: 0.0), NSNumber(value: 0.5), NSNumber(value: 1.0)]
                animation.duration = 1
                animation.repeatCount = .greatestFiniteMagnitude
                animation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)]
                iconImgView.layer.add(animation, forKey: "transformScaleAnimation")
            } else {
                bgImgView.isHidden = true
                
                iconImgView.layer.removeAllAnimations()
            }
        }
    }
    
    func setup(model: GiftModel) {
        if let URLString = model.icon_url {
            iconImgView.kf.setImage(with: URL(string: URLString))
        }
        
        titleLabel.text = model.name
        
        if let amount = model.amount {
            priceLabel.text = "\(amount)氧育币"
        }
        
    }
}
