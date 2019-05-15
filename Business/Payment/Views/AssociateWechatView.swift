//
//  AssociateWechatView.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/28.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class AssociateWechatView: UIView {

    lazy fileprivate var viewModel = DAuthorizationViewModel()
    
    lazy fileprivate var dismissBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0, alpha: 0.3)
        button.alpha = 0.0
        button.addTarget(self, action: #selector(dismissBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy fileprivate var iconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "payment_associateWechatIcon")
        return imgView
    }()
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.foot
        label.text = "微信未绑定"
        return label
    }()
    
    lazy fileprivate var wechatBtn: ActionButton = {
        let button = ActionButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 18)
        button.setTitle(" 微信绑定", for: .normal)
        button.backgroundColor = UIColor("#12bc00")
        button.layer.cornerRadius = 26
        button.setImage(UIImage(named: "authorization_wechatIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.shadowOffset = CGSize(width: 0, height: 8.0)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 11
        button.layer.shadowColor = UIColor("#12bc00").cgColor
        button.addTarget(self, action: #selector(wechatBtnAction), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([dismissBtn, contentView])
        contentView.addSubviews([iconImgView, titleLabel, wechatBtn])
        
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
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            if #available(iOS 11, *) {
                make.height.equalTo(264+(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
            } else {
                make.height.equalTo(264)
            }
        }
        iconImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(52)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImgView.snp.bottom).offset(12)
        }
        wechatBtn.snp.makeConstraints { make in
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.height.equalTo(50)
            if #available(iOS 11, *) {
                make.bottom.equalTo(-30-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
            } else {
                make.height.equalTo(-30)
            }
        }
    }
    
    func present() {
        layoutIfNeeded()
        
        contentView.transform = CGAffineTransform(translationX: 0, y: contentView.bounds.size.height)
        UIView.animate(withDuration: 0.25, animations: {
            self.dismissBtn.alpha = 1.0
            self.contentView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    @objc func dismissBtnAction() {
        removeFromSuperview()
    }

    @objc func wechatBtnAction() {
        guard let viewController = self.viewController else { return }
        
        wechatBtn.startAnimating()
        UMSocialManager.default()?.auth(with: .wechatSession, currentViewController: viewController, completion: { [weak self] (response, error) in
            if let response = response as? UMSocialAuthResponse {
                HUDService.sharedInstance.show(string: "微信授权成功")
                self?.viewModel.bindWechat(openID: response.openid, accessToken: response.accessToken, refreshToken: response.refreshToken, expiresAt: response.expiration.string(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"), completion: { (code) in
                    self?.wechatBtn.stopAnimating()
                    if code >= 0 {
                        HUDService.sharedInstance.show(string: "微信绑定成功")
                        
                        self?.dismissBtnAction()
                    } else {
                        HUDService.sharedInstance.show(string: "微信绑定失败")
                    }
                })
            } else {
                self?.wechatBtn.stopAnimating()
                HUDService.sharedInstance.show(string: "微信授权失败")
            }
        })
    }
}
