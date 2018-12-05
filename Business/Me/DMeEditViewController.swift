//
//  DMeEditViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/15.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import QuickLook
import Photos
import MobileCoreServices

class DMeEditViewController: BaseViewController {

    lazy fileprivate var viewModel = DAuthorizationViewModel()

    lazy fileprivate var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    lazy fileprivate var avatarBtn: ActionButton = {
        let button = ActionButton()
        button.setIndicatorColor(UIConstants.Color.primaryGreen)
        button.layer.cornerRadius = 66
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.backgroundColor = UIConstants.Color.background
        button.setImage(UIImage(named: "me_editCamera")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(avatarBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var saveBtn: ActionButton = {
        let button = ActionButton()
        button.setIndicatorColor(UIConstants.Color.primaryRed)
        button.setTitleColor(UIConstants.Color.primaryRed, for: .normal)
        button.titleLabel?.font = UIConstants.Font.h3
        button.setTitle("保存", for: .normal)
        button.addTarget(self, action: #selector(nameSaveBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var nameTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.text = "名字"
        return label
    }()
    
    lazy fileprivate var nameTextField: UITextField = {
        let textField = UITextField()
        if #available(iOS 10, *) {
            textField.textContentType = .name
        }
        textField.delegate = self
        textField.returnKeyType = .done
        textField.keyboardType = .namePhonePad
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont(name: "PingFangSC-Regular", size: 17)
        textField.textColor = UIConstants.Color.head
        textField.attributedPlaceholder = NSAttributedString(string: "请输入你的名字", attributes: [NSAttributedString.Key.foregroundColor : UIConstants.Color.foot])
        let placeholderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 36, height: 44)))
        textField.leftView = placeholderView
        textField.drawSeparator(startPoint: CGPoint(x: 0, y: 57), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing, y: 57))
        return textField
    }()
    
    lazy fileprivate var wechatTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.text = "微信"
        return label
    }()
    
    lazy fileprivate var wechatBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.primaryGreen, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 17)
        button.setTitle("未绑定微信，点击绑定", for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(bindWechatBtnAction), for: .touchUpInside)
        button.drawSeparator(startPoint: CGPoint(x: 0, y: 57), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing, y: 57))
        return button
    }()
    
    lazy fileprivate var phoneTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.text = "手机"
        return label
    }()
    
    lazy fileprivate var phoneTextField: UITextField = {
        let textField = UITextField()
        if #available(iOS 10, *) {
            textField.textContentType = .name
        }
        textField.returnKeyType = .next
        textField.keyboardType = .phonePad
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont(name: "PingFangSC-Regular", size: 17)
        textField.textColor = UIConstants.Color.foot
        textField.attributedPlaceholder = NSAttributedString(string: "手机号", attributes: [NSAttributedString.Key.foregroundColor : UIConstants.Color.foot])
        let placeholderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 36, height: 44)))
        textField.leftView = placeholderView
        textField.drawSeparator(startPoint: CGPoint(x: 0, y: 57), endPoint: CGPoint(x: UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing, y: 57))
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "资料修改"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        reload()
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        view.addSubview(scrollView)
        scrollView.addSubviews([avatarBtn, nameTitleLabel, nameTextField, wechatTitleLabel, wechatBtn, phoneTitleLabel, phoneTextField])
    }
    
    func initNavigationItem() {
//        let barBtnItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(nameSaveBtnAction))
//        barBtnItem.tintColor = UIConstants.Color.primaryGreen
        
        let barBtnItem = UIBarButtonItem(customView: saveBtn)
        barBtnItem.width = 50
        navigationItem.rightBarButtonItem = barBtnItem
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        avatarBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(60)
            make.size.equalTo(CGSize(width: 132, height: 132))
        }
        nameTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(avatarBtn.snp.bottom).offset(60)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(12)
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.height.equalTo(57)
        }
        wechatTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(nameTextField.snp.bottom).offset(60)
        }
        wechatBtn.snp.makeConstraints { make in
            make.top.equalTo(wechatTitleLabel.snp.bottom).offset(12)
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.height.equalTo(57)
        }
        phoneTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(wechatBtn.snp.bottom).offset(60)
        }
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneTitleLabel.snp.bottom).offset(12)
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.height.equalTo(57)
            make.width.equalTo(UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)
            make.bottom.equalTo(-UIConstants.Margin.bottom)
        }
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        if let model = AuthorizationService.sharedInstance.user {
            nameTextField.text = model.name
            if let avatarURL = model.avatar_url {
                avatarBtn.kf.setImage(with: URL(string: avatarURL), for: .normal)
            }
            if let mobile = model.mobile {
                phoneTextField.text = String(mobile)
            }
            if let wechat = model.wechat_name {
                wechatBtn.setTitle(wechat, for: .normal)
            } else {
                wechatBtn.setTitle("未绑定微信，点击绑定", for: .normal)
            }
        }
    }
    
    
    
    // MARK: - ============= Action =============
    
    @objc override func backBarItemAction() {
        view.endEditing(true)
        
        if nameTextField.text != AuthorizationService.sharedInstance.user?.name {
            let alertController = UIAlertController(title: nil, message: "您有未保存的资料，确定不保存吗？", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func nameSaveBtnAction() {
        view.endEditing(true)
        
        let text = nameTextField.text?.replacingOccurrences(of: "\\s", with: "", options: String.CompareOptions.regularExpression)
        
        guard text?.count ?? 0 != 0 else {
            HUDService.sharedInstance.show(string: "名字不能为空")
            return
        }
        
        saveBtn.startAnimating()
        
        UserProvider.request(.user(text, nil), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            self.saveBtn.stopAnimating()

            if code >= 0 {
                if let JSON = JSON, let name = JSON["name"] as? String {
                    self.nameTextField.text = name
                    
                    if let model = AuthorizationService.sharedInstance.user {
                        model.name = name
                        AuthorizationService.sharedInstance.user = model
                        NotificationCenter.default.post(name: Notification.User.userInfoDidChange, object: nil)
                    }
                    HUDService.sharedInstance.show(string: "名字修改成功")
                }
            }
        }))
    }

    @objc func avatarBtnAction() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "照片", style: .default, handler: { alertAction in
            let imgPicker = UIImagePickerController()
            imgPicker.sourceType = .photoLibrary
            imgPicker.allowsEditing = true
            imgPicker.delegate = self
            self.present(imgPicker, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "拍摄", style: .default, handler: { alertAction in
            let imgPicker = UIImagePickerController()
            imgPicker.sourceType = .camera
            imgPicker.allowsEditing = true
            imgPicker.delegate = self
            self.present(imgPicker, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "文件", style: .default, handler: { alertAction in
            //            let types: NSArray = NSArray(object: kUTTypePDF as NSString)
            let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeImage] as [String], in: UIDocumentPickerMode.import)
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func bindWechatBtnAction() {
        UMSocialManager.default()?.auth(with: .wechatSession, currentViewController: self, completion: { [weak self] (response, error) in
            if let response = response as? UMSocialAuthResponse {
                HUDService.sharedInstance.show(string: "微信授权成功")
                self?.viewModel.bindWechat(openID: response.openid, accessToken: response.accessToken, completion: { (code) in
                    if code != -1 {
                        HUDService.sharedInstance.show(string: "微信绑定成功")
                        
                        self?.reload()
                        
                    } else {
                        HUDService.sharedInstance.show(string: "微信绑定失败")
                    }
                })
            } else {
                HUDService.sharedInstance.show(string: "微信授权失败")
            }
        })
    }
}


extension DMeEditViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        initNavigationItem()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let _ = textField.text else { return true }
        
        //auto fill name
        var autoFillString = string
        if textField == nameTextField && string.count > 1 {
            autoFillString = string.replacingOccurrences(of: "\\s", with: "", options: String.CompareOptions.regularExpression)
            textField.text = autoFillString
            return false
        } else {
            return true
        }
    }
}


extension DMeEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
//        avatarBtn.setImage(info[UIImagePickerController.InfoKey.editedImage] as? UIImage, for: .normal)
        
        avatarBtn.startAnimating()
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage, let imgData = image.jpegData(compressionQuality: 0.75) {
            UploadService.sharedInstance.upload(data: imgData, complete: { [weak self] avatarKey in
                if let avatarKey = avatarKey {
                    
                    UserProvider.request(.user(nil, avatarKey), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
                        self?.avatarBtn.stopAnimating()
                        
                        if code >= 0 {
                            if let JSON = JSON, let avatarURL = JSON["avatar_url"] as? String {
                                self?.avatarBtn.kf.setImage(with: URL(string: avatarURL), for: .normal)
                                
                                if let model = AuthorizationService.sharedInstance.user {
                                    model.avatar_url = avatarURL
                                    AuthorizationService.sharedInstance.user = model
                                    NotificationCenter.default.post(name: Notification.User.userInfoDidChange, object: nil)
                                }
                                HUDService.sharedInstance.show(string: "头像修改成功")
                            }
                        }
                    }))
                } else {
                    self?.avatarBtn.stopAnimating()
                }
            })
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


extension DMeEditViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        guard let data = try? Data(contentsOf: url) else { return }
        avatarBtn.setImage(UIImage(data: data, scale: UIScreen.main.scale), for: .normal)
        
    }
}
