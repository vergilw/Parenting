//
//  DPhoneViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/12.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DPhoneViewController: BaseViewController {

    enum DPhoneMode {
        case signIn
        case binding
    }
    
    lazy fileprivate var mode: DPhoneMode = .signIn
    
    lazy fileprivate var viewModel = DAuthorizationViewModel()
    
    lazy fileprivate var titleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = UIConstants.Color.head
        label.setParagraphText("登录氧育")
        if mode == .binding {
            label.setParagraphText("验证手机")
        }
        return label
    }()
    
    lazy fileprivate var subtitleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.body
        label.setParagraphText("知识赋能早教")
        if mode == .binding {
            label.setParagraphText("为了您账户安全请验证手机")
        }
        return label
    }()
    
    lazy fileprivate var phoneView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy fileprivate var phoneTextField: UITextField = {
        let textField = UITextField()
        if #available(iOS 11, *) {
            textField.textContentType = .telephoneNumber
        }
        textField.delegate = self
        textField.returnKeyType = .next
        textField.keyboardType = .phonePad
        textField.clearButtonMode = .whileEditing
        textField.font = UIConstants.Font.body
        textField.textColor = UIConstants.Color.head
        textField.attributedPlaceholder = NSAttributedString(string: "手机号", attributes: [NSAttributedString.Key.foregroundColor : UIConstants.Color.foot])
        let placeholderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 36, height: 44)))
        textField.leftView = placeholderView
        return textField
    }()
    
    lazy fileprivate var phoneLineImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIConstants.Color.separator
        return imgView
    }()
    
    lazy fileprivate var codeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy fileprivate var codeTextField: UITextField = {
        let textField = UITextField()
        if #available(iOS 12, *) {
            textField.textContentType = .oneTimeCode
        }
        textField.delegate = self
        textField.returnKeyType = .done
        textField.keyboardType = .numberPad
        textField.clearButtonMode = .whileEditing
        textField.font = UIConstants.Font.body
        textField.textColor = UIConstants.Color.head
        textField.attributedPlaceholder = NSAttributedString(string: "验证码", attributes: [NSAttributedString.Key.foregroundColor : UIConstants.Color.foot])
        let placeholderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 36, height: 44)))
        textField.leftView = placeholderView
        return textField
    }()
    
    lazy fileprivate var codeLineImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIConstants.Color.separator
        return imgView
    }()
    
    lazy fileprivate var fetchBtn: ActionButton = {
        let button = ActionButton()
        button.setTitleColor(UIConstants.Color.primaryGreen, for: .normal)
        button.setTitleColor(UIConstants.Color.disable, for: .disabled)
        button.titleLabel?.font = UIConstants.Font.body
        button.setTitle("获取验证码", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(fetchCodeBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var actionBtn: ActionButton = {
        let button = ActionButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 18)
        button.setTitle("登录", for: .normal)
        if mode == .binding {
            button.setTitle("验证", for: .normal)
        }
        button.backgroundColor = UIConstants.Color.disable
        button.layer.cornerRadius = 26
        button.addTarget(self, action: #selector(signInBtnAction), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy fileprivate var separatorLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        label.textAlignment = .center
        label.text = "or"
        return label
    }()
    
    lazy fileprivate var wechatBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "authorization_wechatBtn")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(wechatBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var agreementBtn: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIConstants.Font.foot
        if mode == .binding {
            button.setTitleColor(UIConstants.Color.foot, for: .normal)
            button.setTitle("因中华人民共和国网络安全法规定，请您完成手机验证", for: .normal)
        } else {
            let text = "已阅读并同意氧育用户协议"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIConstants.Color.foot], range: NSRange(location: 0, length: text.count))
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIConstants.Color.subhead, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: NSString(string: text).range(of: "氧育用户协议"))
            button.setAttributedTitle(attributedString, for: .normal)
            button.addTarget(self, action: #selector(agreementBtnAction), for: .touchUpInside)
        }
        return button
    }()
    
    // MARK: - ============= ViewController Cycle =============
    
    init(mode: DPhoneMode, wechatUID: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.mode = mode
        viewModel.wechatUID = wechatUID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
        
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        view.addSubviews([titleLabel, subtitleLabel, phoneView, codeView, actionBtn, separatorLabel, wechatBtn, agreementBtn])
        
        if mode == .binding && (UMSocialManager.default()?.isInstall(.wechatSession) ?? true) {
            separatorLabel.isHidden = true
            wechatBtn.isHidden = true
        }
        
        phoneView.addSubviews([phoneTextField, phoneLineImgView])
        codeView.addSubviews([codeTextField, fetchBtn, codeLineImgView])
        
        separatorLabel.drawSeparator(startPoint: CGPoint(x: 0, y: 6), endPoint: CGPoint(x: 16, y: 6))
        separatorLabel.drawSeparator(startPoint: CGPoint(x: 49, y: 6), endPoint: CGPoint(x: 65, y: 6))
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(40)
            make.top.equalTo(80)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        phoneView.snp.makeConstraints { make in
            make.leading.equalTo(40)
            make.trailing.equalTo(-40)
//            make.top.equalTo(subtitleLabel.snp.bottom).offset(130)
            make.bottom.equalTo(codeView.snp.top).offset(-35)
            make.height.equalTo(32)
        }
        codeView.snp.makeConstraints { make in
            make.leading.equalTo(40)
            make.trailing.equalTo(-40)
//            make.top.equalTo(phoneView.snp.bottom).offset(35)
            make.bottom.equalTo(actionBtn.snp.top).offset(-26)
            make.height.equalTo(32)
        }
        actionBtn.snp.makeConstraints { make in
            make.leading.equalTo(48)
            make.trailing.equalTo(-48)
//            make.top.equalTo(codeView.snp.bottom).offset(27)
            make.bottom.equalTo(separatorLabel.snp.top).offset(-80)
            make.height.equalTo(52)
        }
        wechatBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(agreementBtn.snp.top).offset(-36)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        separatorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(wechatBtn.snp.top).offset(-8)
            make.width.equalTo(65)
            make.height.equalTo(12)
        }
        agreementBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                make.bottom.equalTo(view.snp.bottom).offset(-10)
            }
//            make.width.equalTo(180)
            make.height.equalTo(12+20)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        phoneLineImgView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        codeTextField.snp.makeConstraints { make in
            make.leading.bottom.top.equalToSuperview()
            make.trailing.equalTo(fetchBtn.snp.leading)
        }
        codeLineImgView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        fetchBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(78)
        }
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============
    
    @objc func fetchCodeBtnAction() {
        fetchBtn.startAnimating()
        viewModel.fetchCode(phone: Int(phoneTextField.text!)!) { (bool) in
            self.fetchBtn.stopAnimating()
            self.codeTextField.becomeFirstResponder()
        }
    }
    
    @objc func signInBtnAction() {
        view.endEditing(true)
        
        if mode == .signIn {
            actionBtn.startAnimating()
            viewModel.signIn(phone: phoneTextField.text!, code: codeTextField.text!) { (code) in
                self.actionBtn.stopAnimating()
                if code != -1 {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        } else {
            guard let openID = viewModel.wechatUID else { return }
            actionBtn.startAnimating()
            viewModel.signUp(openID: openID, phone: phoneTextField.text!, code: codeTextField.text!) { (code) in
                self.actionBtn.stopAnimating()
                if code != -1 {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @objc func wechatBtnAction() {
        UMSocialManager.default()?.auth(with: .wechatSession, currentViewController: self, completion: { (response, error) in
            if let response = response as? UMSocialAuthResponse {
                HUDService.sharedInstance.show(string: "微信授权成功")
                self.viewModel.signIn(openID: response.openid, accessToken: response.accessToken, completion: { (code) in
                    if code == 10002 {
                        self.navigationController?.pushViewController(DPhoneViewController(mode: .binding, wechatUID: response.uid), animated: true)
                    } else if code == 10001 {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            } else {
                HUDService.sharedInstance.show(string: "微信授权失败")
            }
        })
    }
    
    @objc func agreementBtnAction() {
        navigationController?.pushViewController(DAgreementViewController(), animated: true)
    }
}

extension DPhoneViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == phoneTextField {
            phoneLineImgView.backgroundColor = UIConstants.Color.primaryGreen
            codeLineImgView.backgroundColor = UIConstants.Color.separator
        } else if textField == codeTextField {
            phoneLineImgView.backgroundColor = UIConstants.Color.separator
            codeLineImgView.backgroundColor = UIConstants.Color.primaryGreen
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        guard textField == phoneTextField else { return true }
        guard let text = textField.text else { return true }
        
        //auto fill phone
        var autoFillString = string
        if textField == phoneTextField && string.count > 1 {
            autoFillString = string.trimmingCharacters(in: .whitespaces)
            if autoFillString.hasPrefix("+86") {
                autoFillString.removeFirst(3)
            }
        }
        
        let resultText = NSString(string: text).replacingCharacters(in: range, with: autoFillString)
        
        if textField == phoneTextField {
            if resultText.isPhone() {
                fetchBtn.isEnabled = true
            } else {
                fetchBtn.isEnabled = false
            }
            if resultText.isPhone() && codeTextField.text?.isCode() ?? false {
                actionBtn.isEnabled = true
                actionBtn.backgroundColor = UIConstants.Color.primaryGreen
            } else {
                actionBtn.isEnabled = false
                actionBtn.backgroundColor = UIConstants.Color.disable
            }
        } else if textField == codeTextField {
            if resultText.isCode() && phoneTextField.text?.isPhone() ?? false {
                actionBtn.isEnabled = true
                actionBtn.backgroundColor = UIConstants.Color.primaryGreen
            } else {
                actionBtn.isEnabled = false
                actionBtn.backgroundColor = UIConstants.Color.disable
            }
        }
        
        if autoFillString == string {
            if textField == phoneTextField && resultText.isPhone() {
                textField.text = resultText
                codeTextField.becomeFirstResponder()
            }
            return true
        }
        textField.text = autoFillString
        if textField == phoneTextField && autoFillString.isPhone() {
            codeTextField.becomeFirstResponder()
        }
        return false
    }
}
