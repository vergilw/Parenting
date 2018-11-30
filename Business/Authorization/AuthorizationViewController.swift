//
//  AuthorizationViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/12.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class AuthorizationViewController: BaseViewController {

    lazy fileprivate var viewModel = DAuthorizationViewModel()
    
    lazy fileprivate var bgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "authorization_homeBg")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Regular", size: 40)
        label.textColor = UIColor("#cb9370")
//        label.text = "知识赋能早教"
        label.numberOfLines = 0
        let attributedString = NSMutableAttributedString(string: "知识赋能早教")
        let paragraph = NSMutableParagraphStyle()
        paragraph.maximumLineHeight = 45
        paragraph.minimumLineHeight = 45
        attributedString.addAttributes([
            NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.baselineOffset: (45-label.font.lineHeight)/4+1.25, NSAttributedString.Key.font: label.font], range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        return label
    }()
    
    lazy fileprivate var agreementBtn: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIConstants.Font.foot
        let text = "已阅读并同意氧育用户协议"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIConstants.Color.foot], range: NSRange(location: 0, length: text.count))
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIConstants.Color.subhead, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: NSString(string: text).range(of: "氧育用户协议"))
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(agreementBtnAction), for: .touchUpInside)
        return button
    }()

    lazy fileprivate var phoneBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.head, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 18)
        button.setTitle(" 手机登录", for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor("#eee").cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 26
        button.setImage(UIImage(named: "authorization_phoneIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        button.imageEdgeInsets = UIEdgeInsets(top: 11, left: 7.5, bottom: 11, right: 7.5)
        button.layer.shadowOffset = CGSize(width: 0, height: 8.0)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 11
        button.layer.shadowColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(phoneBtnAction), for: .touchUpInside)
        return button
    }()

    lazy fileprivate var wechatBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 18)
        button.setTitle(" 微信登录", for: .normal)
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
    
    lazy fileprivate var shadowOffsetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "高度 3.0"
        return label
    }()
    
    lazy fileprivate var shadowOffsetHeightAddBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("+", for: .normal)
        button.addTarget(self, action: #selector(shadowOffsetHeightAddAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var shadowOffsetHeightRemoveBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("-", for: .normal)
        button.addTarget(self, action: #selector(shadowOffsetHeightRemoveAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var shadowOpacityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "不透明度 0.6"
        return label
    }()
    
    lazy fileprivate var shadowOpacityAddBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("+", for: .normal)
        button.addTarget(self, action: #selector(shadowOpacityAddAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var shadowOpacityRemoveBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("-", for: .normal)
        button.addTarget(self, action: #selector(shadowOpacityRemoveAction), for: .touchUpInside)
        return button
    }()
    
    
    lazy fileprivate var shadowRadiusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "半径 26"
        return label
    }()
    
    lazy fileprivate var shadowRadiusAddBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("+", for: .normal)
        button.addTarget(self, action: #selector(shadowRadiusAddAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var shadowRadiusRemoveBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("-", for: .normal)
        button.addTarget(self, action: #selector(shadowRadiusRemoveAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "登录"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        shadowOffsetLabel.text = String(format: "高度 %.1f", phoneBtn.layer.shadowOffset.height)
        shadowOpacityLabel.text = String(format: "不透明度 %.1f", phoneBtn.layer.shadowOpacity)
        shadowRadiusLabel.text = String(format: "半径 %.1f", phoneBtn.layer.shadowRadius)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        
        
        view.addSubviews([bgImgView, titleLabel, agreementBtn, phoneBtn, wechatBtn])
        
//        view.addSubviews([shadowOffsetHeightAddBtn, shadowOffsetHeightRemoveBtn, shadowOffsetLabel,
//                          shadowOpacityLabel, shadowOpacityAddBtn, shadowOpacityRemoveBtn,
//                          shadowRadiusLabel, shadowRadiusAddBtn, shadowRadiusRemoveBtn])
        
        if presentingViewController != nil {
            let backBtn: UIButton = {
                let img = UIImage(named: "public_dismissBorderBtn")!.withRenderingMode(.alwaysOriginal)
                let button = UIButton()
                button.setImage(img, for: .normal)
                button.addTarget(self, action: #selector(dismissBtnAction), for: .touchUpInside)
                return button
            }()
            view.addSubview(backBtn)
            backBtn.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                if #available(iOS 11, *) {
                    make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                } else {
                    make.top.equalToSuperview()
                }
                make.width.equalTo(UIConstants.Margin.leading*2+backBtn.imageView!.image!.size.width)
                make.height.equalTo(50)
            }
        }
        
        
        if !(UMSocialManager.default()?.isInstall(.wechatSession) ?? false) {
            wechatBtn.isHidden = true
        }
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        bgImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(wechatBtn)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(46)
            } else {
                make.top.equalTo(46)
            }
            make.width.equalTo(40)
        }
        agreementBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                make.bottom.equalTo(view.snp.bottom).offset(-10)
            }
            make.width.equalTo(180)
            make.height.equalTo(12+20)
        }
        
        phoneBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(agreementBtn.snp.top).offset(-30)
            make.width.equalTo(217)
            make.height.equalTo(52)
        }
        
        wechatBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(phoneBtn.snp.top).offset(-25)
            make.width.equalTo(217)
            make.height.equalTo(52)
        }
        
        
        /*
        shadowOffsetHeightAddBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(50)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }

        shadowOffsetHeightRemoveBtn.snp.makeConstraints { make in
            make.leading.equalTo(shadowOffsetHeightAddBtn.snp.trailing).offset(10)
            make.top.equalTo(50)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        shadowOffsetLabel.snp.makeConstraints { make in
            make.trailing.equalTo(shadowOffsetHeightAddBtn.snp.leading).offset(-10)
            make.centerY.equalTo(shadowOffsetHeightAddBtn)
        }
        
        shadowOpacityAddBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(shadowOffsetHeightAddBtn.snp.bottom).offset(20)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        shadowOpacityRemoveBtn.snp.makeConstraints { make in
            make.leading.equalTo(shadowOffsetHeightAddBtn.snp.trailing).offset(10)
            make.centerY.equalTo(shadowOpacityAddBtn)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        shadowOpacityLabel.snp.makeConstraints { make in
            make.trailing.equalTo(shadowOffsetHeightAddBtn.snp.leading).offset(-10)
            make.centerY.equalTo(shadowOpacityAddBtn)
        }
        
        
        shadowRadiusAddBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(shadowOpacityAddBtn.snp.bottom).offset(20)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        shadowRadiusRemoveBtn.snp.makeConstraints { make in
            make.leading.equalTo(shadowRadiusAddBtn.snp.trailing).offset(10)
            make.centerY.equalTo(shadowRadiusAddBtn)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        shadowRadiusLabel.snp.makeConstraints { make in
            make.trailing.equalTo(shadowRadiusAddBtn.snp.leading).offset(-10)
            make.centerY.equalTo(shadowRadiusAddBtn)
        }
 */
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============
    
    @objc func dismissBtnAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func wechatBtnAction() {
        UMSocialManager.default()?.auth(with: .wechatSession, currentViewController: self, completion: { (response, error) in
            if let response = response as? UMSocialAuthResponse {
                HUDService.sharedInstance.show(string: "微信授权成功")
                self.viewModel.signIn(openID: response.openid, accessToken: response.accessToken, completion: { (code) in
                    if code == 10002 {
                        self.navigationController?.pushViewController(DPhoneViewController(mode: .binding, wechatUID: response.openid), animated: true)
                    } else if code == 10001 {
                        HUDService.sharedInstance.show(string: "登录成功")
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            } else {
                HUDService.sharedInstance.show(string: "微信授权失败")
            }
        })

    }
    
    @objc func phoneBtnAction() {
        navigationController?.pushViewController(DPhoneViewController(mode: .signIn), animated: true)
    }
    
    @objc func agreementBtnAction() {
        navigationController?.pushViewController(DAgreementViewController(), animated: true)
    }
    
    @objc func shadowOffsetHeightAddAction() {
        wechatBtn.layer.shadowOffset.height = wechatBtn.layer.shadowOffset.height + 0.1
        shadowOffsetLabel.text = String(format: "高度 %.1f", wechatBtn.layer.shadowOffset.height)
    }

    @objc func shadowOffsetHeightRemoveAction() {
        wechatBtn.layer.shadowOffset.height = wechatBtn.layer.shadowOffset.height - 0.1
        shadowOffsetLabel.text = String(format: "高度 %.1f", wechatBtn.layer.shadowOffset.height)
    }
    
    @objc func shadowOpacityAddAction() {
        wechatBtn.layer.shadowOpacity = wechatBtn.layer.shadowOpacity + 0.1
        if wechatBtn.layer.shadowOpacity > 1.0 {
            wechatBtn.layer.shadowOpacity = 1.0
        }
        shadowOpacityLabel.text = String(format: "不透明度 %.1f", wechatBtn.layer.shadowOpacity)
    }
    
    @objc func shadowOpacityRemoveAction() {
        wechatBtn.layer.shadowOpacity = wechatBtn.layer.shadowOpacity - 0.1
        if wechatBtn.layer.shadowOpacity < 0.0 {
            wechatBtn.layer.shadowOpacity = 0.0
        }
        shadowOpacityLabel.text = String(format: "不透明度 %.1f", wechatBtn.layer.shadowOpacity)
    }
    
    @objc func shadowRadiusAddAction() {
        wechatBtn.layer.shadowRadius = wechatBtn.layer.shadowRadius + 0.5
        shadowRadiusLabel.text = String(format: "半径 %.1f", wechatBtn.layer.shadowRadius)
    }
    
    @objc func shadowRadiusRemoveAction() {
        wechatBtn.layer.shadowRadius = wechatBtn.layer.shadowRadius - 0.5
        shadowRadiusLabel.text = String(format: "半径 %.1f", wechatBtn.layer.shadowRadius)
    }
}
