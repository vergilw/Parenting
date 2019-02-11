//
//  IAPSignInView.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/2/11.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class IAPSignInView: UIView {

    lazy fileprivate var dismissBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0, alpha: 0.3)
        button.alpha = 0.0
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
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.text = "您尚未登录"
        return label
    }()
    
    fileprivate lazy var bodyLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.body
        label.setParagraphText("未登录状态下购买会有以下限制：\n1. 充值的氧育币仅能转移到新注册的氧育亲子账号；\n2. 氧育币购买后仅存在于本机，不能跨设备使用；\n3. APP卸载后充值的虚拟货币有丢失的风险；")
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var signInBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIConstants.Font.body
        button.setTitle("先去登录", for: .normal)
        button.backgroundColor = UIConstants.Color.primaryRed
        button.layer.cornerRadius = 17.5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(signInBtnAction), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var skipBtn: ActionButton = {
        let button = ActionButton()
        button.setIndicatorStyle(style: UIActivityIndicatorView.Style.gray)
        button.setTitleColor(UIConstants.Color.disable, for: .normal)
        button.titleLabel?.font = UIConstants.Font.foot
        button.setTitle("仅在本设备购买", for: .normal)
        button.addTarget(self, action: #selector(skipBtnAction), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([dismissBtn, contentView])
        
        contentView.addSubviews([titleLabel, bodyLabel, signInBtn, skipBtn])
        contentView.drawSeparator(startPoint: CGPoint(x: 0, y: 66), endPoint: CGPoint(x: UIScreenWidth-110, y: 66))
        
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
            make.leading.equalTo(55)
            make.trailing.equalTo(-55)
//            make.size.equalTo(CGSize(width: 195, height: 160))
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(66)
        }
        bodyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        signInBtn.snp.makeConstraints { make in
            make.top.equalTo(bodyLabel.snp.bottom).offset(20)
            make.leading.equalTo(32)
            make.trailing.equalTo(-32)
            make.height.equalTo(35)
        }
        skipBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(signInBtn.snp.bottom).offset(10)
            make.bottom.equalTo(-20)
        }
    }
    
    func present() {
        
        contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        contentView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.dismissBtn.alpha = 1.0
            self.contentView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    @objc func dismissBtnAction() {
        removeFromSuperview()
    }
    
    @objc func signInBtnAction() {
        dismissBtnAction()
        
        let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
        UIApplication.shared.keyWindow?.rootViewController?.present(authorizationNavigationController, animated: true, completion: nil)
    }
    
    @objc func skipBtnAction() {
        skipBtn.startAnimating()
        
        AuthorizationProvider.request(.signUpWithDeviceID, completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            self.skipBtn.stopAnimating()
            
            if code >= 0 {
                if let userJSON = JSON?["user"] as? [String: Any], let model = UserModel.deserialize(from: userJSON) {
                    model.isDeviceSignIn = true
                    AuthorizationService.sharedInstance.cacheSignInInfo(model: model)
                    NotificationCenter.default.post(name: Notification.Authorization.signInDidSuccess, object: nil)
                    AuthorizationService.sharedInstance.updateUserInfo()
                    
                    self.dismissBtnAction()
                }
            }
        }))
    }
}
