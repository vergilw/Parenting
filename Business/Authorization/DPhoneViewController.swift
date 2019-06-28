//
//  DPhoneViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/12.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
//import IQKeyboardManagerSwift

class DPhoneViewController: BaseViewController {

    enum DPhoneMode {
        case signIn
        case binding
    }
    
    enum PasscodeMode {
        case passcode
        case password
    }
    
    lazy fileprivate var mode: DPhoneMode = .signIn
    
    fileprivate lazy var passcodeMode: PasscodeMode = .passcode
    
    lazy fileprivate var viewModel = DAuthorizationViewModel()
    
    fileprivate lazy var bgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "authorization_signInBg")
        return imgView
    }()
    
    lazy fileprivate var titleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = UIConstants.Color.head
        label.adjustsFontSizeToFitWidth = true
        label.setParagraphText("手机快速登录")
        if mode == .binding {
            label.setParagraphText("验证手机")
        }
        return label
    }()
    
    lazy fileprivate var subtitleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIFont(name: "PingFangSC-Regular", size: 18)!
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
    
    lazy fileprivate var accountTextField: UITextField = {
        let textField = UITextField()
        if #available(iOS 11, *) {
            textField.textContentType = .telephoneNumber
        }
        textField.delegate = self
        textField.returnKeyType = .next
        textField.keyboardType = .emailAddress
        textField.clearButtonMode = .whileEditing
        textField.font = UIConstants.Font.body
        textField.textColor = UIConstants.Color.head
        textField.attributedPlaceholder = NSAttributedString(string: "手机号/邮箱", attributes: [NSAttributedString.Key.foregroundColor : UIConstants.Color.foot])
        let placeholderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 36, height: 44)))
        textField.leftView = placeholderView
        textField.keyboardDistanceFromTextField = 35+32+26+52+12
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
//        let placeholderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 36, height: 44)))
//        textField.leftView = placeholderView
//        textField.leftViewMode = .always
        textField.keyboardDistanceFromTextField = 26+52+12
        return textField
    }()
    
    lazy fileprivate var pwdView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    lazy fileprivate var pwdTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .whileEditing
        textField.font = UIConstants.Font.body
        textField.textColor = UIConstants.Color.head
        textField.attributedPlaceholder = NSAttributedString(string: "密码", attributes: [NSAttributedString.Key.foregroundColor : UIConstants.Color.foot])
//        let placeholderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 36, height: 44)))
//        textField.leftView = placeholderView
//        textField.leftViewMode = .always
        textField.keyboardDistanceFromTextField = 26+52+12
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
    
    fileprivate lazy var passcodeModeBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.head, for: .normal)
        button.titleLabel?.font = UIConstants.Font.body
        button.setTitle("账号密码登录", for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(passcodeModeBtnAction), for: .touchUpInside)
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
            let text = "已阅读并同意氧育亲子用户协议"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIConstants.Color.foot], range: NSRange(location: 0, length: text.count))
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIConstants.Color.subhead, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: NSString(string: text).range(of: "氧育亲子用户协议"))
            button.setAttributedTitle(attributedString, for: .normal)
            button.addTarget(self, action: #selector(agreementBtnAction), for: .touchUpInside)
        }
        return button
    }()
    
    fileprivate var passcodeTimer: Timer?
    
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
        
        reloadPasscodeTimer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        if navigationController?.viewControllers.first != self {
            backBarBtn.tintColor = UIConstants.Color.head
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBarBtn)
        }
        
        view.addSubviews([bgImgView, backBarBtn, titleLabel, subtitleLabel, phoneView, codeView, pwdView, codeLineImgView, passcodeModeBtn, actionBtn, separatorLabel, wechatBtn, agreementBtn])
        
        if mode == .binding && (UMSocialManager.default()?.isInstall(.wechatSession) ?? true) {
            separatorLabel.isHidden = true
            wechatBtn.isHidden = true
            passcodeModeBtn.isHidden = true
        }
        if !(UMSocialManager.default()?.isInstall(.wechatSession) ?? false) {
            separatorLabel.isHidden = true
            wechatBtn.isHidden = true
        }
        
        phoneView.addSubviews([accountTextField, phoneLineImgView])
        codeView.addSubviews([codeTextField, fetchBtn])
        pwdView.addSubviews([pwdTextField])
        
        separatorLabel.drawSeparator(startPoint: CGPoint(x: 0, y: 6), endPoint: CGPoint(x: 16, y: 6))
        separatorLabel.drawSeparator(startPoint: CGPoint(x: 49, y: 6), endPoint: CGPoint(x: 65, y: 6))
        
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        bgImgView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(subtitleLabel.snp.bottom).offset(40)
        }
        backBarBtn.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(backBarBtn.bounds.size)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(40)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
//            make.top.equalTo(80).priority(.low)
            
//            if #available(iOS 11.0, *) {
                make.top.equalTo(16+(self.navigationController?.navigationBar.bounds.height ?? 0)+UIStatusBarHeight).priority(.required)
//            } else {
//                make.top.equalTo(16+(self.navigationController?.navigationBar.bounds.height ?? 0)).priority(.required)
//            }
        }
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.lessThanOrEqualTo(phoneView.snp.top).offset(-26).priority(.required)
        }
        
        phoneView.snp.makeConstraints { make in
            make.leading.equalTo(40)
            make.trailing.equalTo(-40)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(106).priority(.low)
            make.bottom.equalTo(codeView.snp.top).offset(-35)
            make.height.equalTo(32)
        }
        codeView.snp.makeConstraints { make in
            make.leading.equalTo(40)
            make.trailing.equalTo(-40)
//            make.top.equalTo(phoneView.snp.bottom).offset(35)
            make.bottom.equalTo(passcodeModeBtn.snp.top).offset(0)
            make.height.equalTo(32)
        }
        pwdView.snp.makeConstraints { make in
            make.leading.equalTo(40)
            make.trailing.equalTo(-40)
            make.bottom.equalTo(passcodeModeBtn.snp.top).offset(0)
            make.height.equalTo(32)
        }
        passcodeModeBtn.snp.makeConstraints { make in
            make.leading.equalTo(codeView)
            make.size.equalTo(CGSize(width: 84, height: 35))
            make.bottom.equalTo(actionBtn.snp.top).offset(-20)
        }
        actionBtn.snp.makeConstraints { make in
            make.leading.equalTo(48)
            make.trailing.equalTo(-48)
//            make.top.equalTo(codeView.snp.bottom).offset(27)
            make.bottom.lessThanOrEqualTo(separatorLabel.snp.top).offset(-80).priority(.required)
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
        
        accountTextField.snp.makeConstraints { make in
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
        pwdTextField.snp.makeConstraints { make in
            make.leading.bottom.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        codeLineImgView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(codeView)
            make.bottom.equalTo(codeView)
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
    
    func reloadPasscodeTimer() {
        if let timer = passcodeTimer {
            timer.invalidate()
            passcodeTimer = nil
        }
        
        if AppCacheService.sharedInstance.lastFetchingPasscodeDate != nil {
            fetchBtn.isEnabled = false
            passcodeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
                let interval = AppCacheService.sharedInstance.lastFetchingPasscodeDate?.timeIntervalSinceNow ?? 0
                if interval <= -60 {
                    self?.passcodeTimer?.invalidate()
                    self?.passcodeTimer = nil
                    if self?.accountTextField.text?.isPhone() ?? false {
                        self?.fetchBtn.isEnabled = true
                    }
                    self?.fetchBtn.setTitle("获取验证码", for: .normal)
                    AppCacheService.sharedInstance.lastFetchingPasscodeDate = nil
                } else {
                    self?.fetchBtn.setTitle(String(format: "重发%.0fs", interval+60), for: .normal)
                }
            })
            passcodeTimer?.fire()
        }
        
    }
    
    // MARK: - ============= Action =============
    
    @objc func fetchCodeBtnAction() {
        fetchBtn.startAnimating()
        viewModel.fetchCode(phone: Int(accountTextField.text!)!) { (bool) in
            self.fetchBtn.stopAnimating()
            self.codeTextField.becomeFirstResponder()
        
            AppCacheService.sharedInstance.lastFetchingPasscodeDate = Date()
            self.reloadPasscodeTimer()
        }
    }
    
    @objc func signInBtnAction() {
        view.endEditing(true)

        if mode == .signIn {
            if passcodeMode == .passcode {
                actionBtn.startAnimating()
                viewModel.signInWithPasscode(account: accountTextField.text!, passcode: codeTextField.text!) { (code) in
                    self.actionBtn.stopAnimating()
                    if code >= 0 {
                        HUDService.sharedInstance.show(string: "登录成功")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
            } else if passcodeMode == .password {
                actionBtn.startAnimating()
                viewModel.signInWithPassword(account: accountTextField.text!, password: pwdTextField.text!) { (code) in
                    self.actionBtn.stopAnimating()
                    if code >= 0 {
                        HUDService.sharedInstance.show(string: "登录成功")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            

        } else if mode == .binding {
            guard let openID = viewModel.wechatUID else { return }
            actionBtn.startAnimating()
            viewModel.signUp(oauthID: openID, phone: accountTextField.text!, passcode: codeTextField.text!) { (code) in
                self.actionBtn.stopAnimating()

                if code >= 0 {
                    HUDService.sharedInstance.show(string: "登录成功")
                    self.dismiss(animated: true, completion: nil)
                }
                
//                if code == 10004 {
//                    let alertController = UIAlertController(title: nil, message: "手机号\(self.accountTextField.text!)已注册，请直接登录", preferredStyle: UIAlertController.Style.alert)
//                    alertController.addAction(UIAlertAction(title: "去登录", style: UIAlertAction.Style.cancel, handler: { alertAction in
//                        self.navigationController?.pushViewController(DPhoneViewController(mode: .signIn), animated: true)
//                    }))
//                    self.present(alertController, animated: true, completion: nil)
//
//
//                }
            }
        }
        
    }
    
    @objc func wechatBtnAction() {
        UMSocialManager.default()?.auth(with: .wechatSession, currentViewController: self, completion: { [weak self] (response, error) in
            if let response = response as? UMSocialAuthResponse {
                HUDService.sharedInstance.show(string: "微信授权成功")
                self?.viewModel.signIn(openID: response.openid, accessToken: response.accessToken, refreshToken: response.refreshToken, expiresAt: response.expiration.string(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"), completion: { (code, oauthID) in
                    if code == -1, let oauthID = oauthID {
                        self?.navigationController?.pushViewController(DPhoneViewController(mode: .binding, wechatUID: oauthID), animated: true)
                    } else if code >= 0 {
                        HUDService.sharedInstance.show(string: "登录成功")
                        self?.dismiss(animated: true, completion: nil)
                    }
                })
            } else {
                HUDService.sharedInstance.show(string: "微信授权失败")
            }
        })
    }
    
    @objc func agreementBtnAction() {
        let viewController = WebViewController()
        viewController.navigationItem.title = "协议与隐私政策"
        #if DEBUG
        viewController.url = URL(string: "http://m.1314-edu.com/agreement.html")
        #else
        viewController.url = URL(string: "https://yy.1314-edu.com/agreement.html")
        #endif
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc fileprivate func passcodeModeBtnAction() {
        if passcodeMode == .passcode {
            passcodeMode = .password
            codeView.isHidden = true
            pwdView.isHidden = false
            passcodeModeBtn.setTitle("验证码登录", for: .normal)
            pwdTextField.becomeFirstResponder()
            
        } else if passcodeMode == .password {
            passcodeMode = .passcode
            codeView.isHidden = false
            pwdView.isHidden = true
            passcodeModeBtn.setTitle("账号密码登录", for: .normal)
            codeTextField.becomeFirstResponder()
        }
    }
    
    deinit {
        if let timer = passcodeTimer {
            timer.invalidate()
            passcodeTimer = nil
        }
    }
}

extension DPhoneViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == accountTextField {
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
        if textField == accountTextField && string.count > 1 {
            autoFillString = string.trimmingCharacters(in: .whitespaces)
            if autoFillString.hasPrefix("+86") {
                autoFillString.removeFirst(3)
            }
        }
        
        let resultText = NSString(string: text).replacingCharacters(in: range, with: autoFillString)
        
        if textField == accountTextField {
            if resultText.isPhone() || resultText.isEmail() {
                if AppCacheService.sharedInstance.lastFetchingPasscodeDate == nil {
                    fetchBtn.isEnabled = true
                }
            } else {
                fetchBtn.isEnabled = false
            }
            if (resultText.isPhone() || resultText.isEmail()) &&
                (passcodeMode == .passcode && codeTextField.text?.isCode() ?? false) &&
                (passcodeMode == .password && pwdTextField.text?.count ?? 0 >= 6) {
                actionBtn.isEnabled = true
                actionBtn.backgroundColor = UIConstants.Color.primaryGreen
            } else {
                actionBtn.isEnabled = false
                actionBtn.backgroundColor = UIConstants.Color.disable
            }
            
        } else if textField == codeTextField && passcodeMode == .passcode {
            if resultText.isCode() && (accountTextField.text?.isPhone() ?? false || accountTextField.text?.isEmail() ?? false) {
                actionBtn.isEnabled = true
                actionBtn.backgroundColor = UIConstants.Color.primaryGreen
            } else {
                actionBtn.isEnabled = false
                actionBtn.backgroundColor = UIConstants.Color.disable
            }
            
        } else if textField == pwdTextField && passcodeMode == .password {
            if resultText.count >= 6 && (accountTextField.text?.isPhone() ?? false || accountTextField.text?.isEmail() ?? false) {
                actionBtn.isEnabled = true
                actionBtn.backgroundColor = UIConstants.Color.primaryGreen
            } else {
                actionBtn.isEnabled = false
                actionBtn.backgroundColor = UIConstants.Color.disable
            }
        }
        
        if autoFillString == string {
            if textField == accountTextField && resultText.isPhone() {
                textField.text = resultText
                if passcodeMode == .passcode {
                    codeTextField.becomeFirstResponder()
                } else if passcodeMode == .password {
                    pwdTextField.becomeFirstResponder()
                }
                
            }
            return true
        }
        textField.text = autoFillString
        if textField == accountTextField && autoFillString.isPhone() {
            codeTextField.becomeFirstResponder()
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountTextField {
            if passcodeMode == .passcode {
                codeTextField.becomeFirstResponder()
            } else if passcodeMode == .password {
                pwdTextField.becomeFirstResponder()
            }
        } else if textField == pwdTextField {
            pwdTextField.resignFirstResponder()
        }
        return false
    }
}
