//
//  DVideoPostViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/21.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import PLShortVideoKit
import Photos

class DVideoPostViewController: BaseViewController {

    fileprivate lazy var fileURL: URL? = nil
    
    fileprivate lazy var coverImg: UIImage? = nil
    
    fileprivate lazy var videoUploader: PLShortVideoUploader? = nil
    
    fileprivate lazy var videoSignedID: String? = nil
    
    fileprivate lazy var coverSignedID: String? = nil
    
    fileprivate let dispatchGroup = DispatchGroup()
    
    fileprivate lazy var textView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .done
//        textView.backgroundColor = UIConstants.Color.background
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets.zero
        textView.font = UIConstants.Font.body
        textView.placeholder = "写标题并使用合适的话题～"
        return textView
    }()
    
    fileprivate lazy var previewBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(previewBtnAction), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var previewImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_playerPlay")
        return imgView
    }()
    
    fileprivate lazy var submitBtn: ActionButton = {
        let button = ActionButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIConstants.Font.h2_regular
        button.setTitle(" 发布", for: .normal)
        button.setImage(UIImage(named: "video_postVideo"), for: .normal)
        button.backgroundColor = UIConstants.Color.primaryGreen
        button.layer.cornerRadius = 23
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(submitBtnAction), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var draftsBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.primaryGreen, for: .normal)
        button.titleLabel?.font = UIConstants.Font.h2_regular
        button.setTitle("存入草稿箱 ", for: .normal)
        button.setImage(UIImage(named: "public_arrowIndicator")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIConstants.Color.primaryGreen
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(draftsBtnAction), for: .touchUpInside)
        return button
    }()
    
    init(fileURL: URL, coverImg: UIImage) {
        super.init(nibName: nil, bundle: nil)
        
        self.fileURL = fileURL
        self.coverImg = coverImg
        previewBtn.setImage(coverImg, for: UIControl.State.normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "发布"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubviews([textView, previewBtn, previewImgView, submitBtn, draftsBtn])
        
        view.drawSeparator(startPoint: CGPoint(x: 0, y: 210), endPoint: CGPoint(x: UIScreenWidth, y: 210))
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        previewBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.top.equalTo(20)
            make.size.equalTo(CGSize(width: 90, height: 160))
        }
        previewImgView.snp.makeConstraints { make in
            make.center.equalTo(previewBtn)
        }
        textView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(previewBtn.snp.leading).offset(-10)
            make.top.equalTo(20)
            make.bottom.equalTo(previewBtn.snp.bottom)
        }
        draftsBtn.snp.makeConstraints { make in
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.height.equalTo(30)
            if #available(iOS 11, *) {
                make.bottom.equalTo(-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)-40)
            } else {
                make.bottom.equalTo(-40)
            }
        }
        submitBtn.snp.makeConstraints { make in
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.height.equalTo(46)
            make.bottom.equalTo(draftsBtn.snp.top).offset(-24)
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============
    @objc func previewBtnAction() {
        guard let fileURL = fileURL else { return }
        let viewController = DVideoPreviewViewController(fileURL: fileURL)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func submitBtnAction() {
        guard let fileURL = fileURL else { return }
        guard let fileData = try? Data(contentsOf: fileURL) else { return }
        guard let coverImg = coverImg else { return }
        
        submitBtn.startAnimating()
        
        dispatchGroup.enter()
        //TODO: video mimetype detect
        CommonProvider.request(.uploadToken(fileData.count, "video/mpeg"), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            
            guard code >= 0, let key = JSON?["key"] as? String, let directUpload = JSON?["direct_upload"] as? [String: Any], let headers = directUpload["headers"] as? [String: Any], let token = headers["Up-Token"] as? String, let signedID = JSON?["signed_id"] as? String else {
                self.dispatchGroup.leave()
                return
            }
            
            self.videoSignedID = signedID
            
            guard let config = PLSUploaderConfiguration(token: token, videoKey: key, https: true, recorder: nil) else {
                self.dispatchGroup.leave()
                return
            }
            self.videoUploader = PLShortVideoUploader(configuration: config)
            self.videoUploader?.delegate = self
            self.videoUploader?.uploadVideoFile(fileURL.path)
            
        }))
        
        
        if let data = coverImg.pngData() {
            dispatchGroup.enter()
            UploadService.sharedInstance.upload(data: data) { (signedID) in
                self.coverSignedID = signedID
                self.dispatchGroup.leave()
            }
        }
        
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            
            guard let videoSignedID = self.videoSignedID, let coverSignedID = self.coverSignedID else {
                self.submitBtn.stopAnimating()
                return
            }
            
            VideoProvider.request(.video(self.textView.text, videoSignedID, coverSignedID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
                
                self.submitBtn.stopAnimating()
                
                guard code >= 0 else {
                    return
                }
                
                HUDService.sharedInstance.show(string: "发布成功")
                self.dismiss(animated: true, completion: nil)
            }))
        }
    }
    
    @objc func draftsBtnAction() {
        guard let fileURL = fileURL else { return }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
        }) { (saved, error) in
            if saved {
                HUDService.sharedInstance.show(string: "保存成功")
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
}


// MARK: - ============= PLShortVideoUploaderDelegate =============
extension DVideoPostViewController: PLShortVideoUploaderDelegate {
    func shortVideoUploader(_ uploader: PLShortVideoUploader, uploadKey: String?, uploadPercent: Float) {
        
    }
    
    func shortVideoUploader(_ uploader: PLShortVideoUploader, complete info: PLSUploaderResponseInfo, uploadKey: String, resp: [AnyHashable : Any]?) {
        
        guard info.error == nil else {
            dispatchGroup.leave()
            return
        }
        
        dispatchGroup.leave()
        
    }
}
