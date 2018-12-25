//
//  RewardView.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/25.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class RewardView: UIView {
    
    enum DRewardMode {
        case share
        case comment
        case study
    }
    
    lazy fileprivate var dismissBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0, alpha: 0.3)
        button.addTarget(self, action: #selector(dismissBtnAction), for: .touchUpInside)
        return button
    }()

    lazy fileprivate var contentView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        return view
    }()
    
    lazy fileprivate var iconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "payment_coinLargeIcon")
        return imgView
    }()
    
    lazy fileprivate var valueLabel: PriceLabel = {
        let label = PriceLabel()
        label.font = UIFont(name: "PingFangSC-Semibold", size: 30)!
        label.textColor = UIConstants.Color.primaryOrange
        return label
    }()
    
    lazy fileprivate var footnoteLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.primaryOrange
        label.text = "本次分享金币奖励"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([dismissBtn, contentView])
        
        contentView.addSubviews([iconImgView, valueLabel, footnoteLabel])
        
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    fileprivate func initConstraints() {
        dismissBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 195, height: 160))
        }
        iconImgView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.top)
            make.centerX.equalToSuperview()
        }
        valueLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        footnoteLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-25)
        }
    }
    
    func present(string: String, mode: DRewardMode) {
        valueLabel.setPriceText(text: string, symbol: "+")
        
        if mode == .share {
            footnoteLabel.text = "本次分享金币奖励"
        } else if mode == .comment {
            footnoteLabel.text = "本次评论金币奖励"
        } else if mode == .study {
            footnoteLabel.text = "本次学习金币奖励"
        }
        
        contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        contentView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.contentView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    @objc func dismissBtnAction() {
        removeFromSuperview()
    }
}
