//
//  ShareView.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/5.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class ShareView: UIView {
    
    var shareClosure: ((UMSocialPlatformType) -> ())?
    
    lazy fileprivate var dismissBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0, alpha: 0.3)
        button.alpha = 0.0
        button.addTarget(self, action: #selector(dismissBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var panelView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy fileprivate var cancelBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(UIConstants.Color.head, for: .normal)
        button.titleLabel?.font = UIConstants.Font.body
        button.setTitle("取消", for: .normal)
        button.layer.cornerRadius = 4
                button.addTarget(self, action: #selector(dismissBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var timelineBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(timelineBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var timelineImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_wechatTimeline")
        return imgView
    }()
    
    lazy fileprivate var timelineLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.body
        label.setParagraphText("朋友圈")
        return label
    }()
    lazy fileprivate var sessionBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(sessionBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var sessionImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_wechatSession")
        return imgView
    }()
    
    lazy fileprivate var sessionLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.body
        label.setParagraphText("微信")
        return label
    }()
    
    lazy fileprivate var clipboardBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clipboardBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var clipboardImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_clipboard")
        return imgView
    }()
    
    lazy fileprivate var clipboardLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.body
        label.setParagraphText("复制链接")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        panelView.drawRoundBg(roundedRect: CGRect(origin: CGPoint(x: UIConstants.Margin.leading, y: 0), size: CGSize(width: UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing, height: 140)), cornerRadius: 4)
        
        addSubviews([dismissBtn, panelView])
        panelView.addSubviews([cancelBtn, timelineBtn, sessionBtn, clipboardBtn])
        timelineBtn.addSubviews([timelineImgView, timelineLabel])
        sessionBtn.addSubviews([sessionImgView, sessionLabel])
        clipboardBtn.addSubviews([clipboardImgView, clipboardLabel])
        
        
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    fileprivate func initConstraints() {
        dismissBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        panelView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.snp.bottom)
            make.height.equalTo(218)
        }
        cancelBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.height.equalTo(40)
            make.bottom.equalTo(-25)
        }
        sessionBtn.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.bottom.equalTo(cancelBtn.snp.top).offset(-50)
            make.width.equalTo(50)
            make.centerX.equalToSuperview()
        }
        timelineBtn.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.bottom.equalTo(cancelBtn.snp.top).offset(-50)
            make.width.equalTo(50)
            make.centerX.equalToSuperview().multipliedBy(1.0/2)
        }
        clipboardBtn.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.bottom.equalTo(cancelBtn.snp.top).offset(-50)
            make.width.equalTo(50)
            make.centerX.equalToSuperview().multipliedBy(3.0/2)
        }
        
        timelineImgView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }
        timelineLabel.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
        }
        
        sessionImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(3)
        }
        sessionLabel.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
        }
        
        clipboardImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(8)
        }
        clipboardLabel.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
        }
    }
    
    func present() {
        self.panelView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(218)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.dismissBtn.alpha = 1.0
            self.layoutIfNeeded()
        }
    }
    
    @objc func dismissBtnAction() {
        removeFromSuperview()
    }
    
    @objc func timelineBtnAction() {
        if let closure = shareClosure {
            closure(UMSocialPlatformType.wechatTimeLine)
        }
    }
    
    @objc func sessionBtnAction() {
        if let closure = shareClosure {
            closure(UMSocialPlatformType.wechatSession)
        }
    }
    
    @objc func clipboardBtnAction() {
        if let closure = shareClosure {
            closure(UMSocialPlatformType(rawValue: 1001)!)
        }
    }
}
