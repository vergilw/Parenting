//
//  VideoRewardView.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/30.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class VideoRewardView: UIView {

    lazy var countdownLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIColor("#ffd35b")
        return label
    }()
    
    fileprivate lazy var animatedView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate lazy var animatedImgView: YYAnimatedImageView = {
        let img = YYImage(named: "reward_videoAnimation")!
        return YYAnimatedImageView(image: img)
    }()
    
    var animator: UIViewPropertyAnimator?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([animatedView, countdownLabel])
        animatedView.addSubview(animatedImgView)
        
        animatedView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 55, height: 55))
        }
        countdownLabel.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
            make.top.equalTo(animatedView.snp.bottom).offset(3.5)
            make.height.equalTo(12)
        }
        
        animatedImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(animatedView.snp.bottom)
            make.size.equalTo(CGSize(width: 55, height: 55))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func startCountdown(startSeconds: Double, durationSeconds: Double) {
        if animator == nil {
            animator = UIViewPropertyAnimator(duration: durationSeconds-startSeconds, curve: UIView.AnimationCurve.linear) { [weak self] in
                guard let `self` = self else { return }
                self.animatedImgView.transform = CGAffineTransform(translationX: 0, y: -55)
            }
        } else {
            animator?.startAnimation()
        }
    }
    
    func invalidateCountdown() {
        
        if animator?.state == .active {
            animator?.pauseAnimation()
            print(#function)
        }
    }
    
    deinit {
        animator?.stopAnimation(true)
    }
}
