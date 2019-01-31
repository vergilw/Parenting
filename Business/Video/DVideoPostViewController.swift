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
    
    fileprivate lazy var tagModels: [VideoTagModel]? = nil
    
    fileprivate lazy var textView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .done
        textView.keyboardType = .twitter
//        textView.backgroundColor = UIConstants.Color.background
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets.zero
        textView.font = UIConstants.Font.body
        textView.placeholder = "#点击下方标签或创造一个标签 找到更多同道中人"
        textView.delegate = self
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
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewLeftAlignedLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = UICollectionViewLeftAlignedLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 108, height: 35)
        layout.sectionInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(VideoTagCell.self, forCellWithReuseIdentifier: VideoTagCell.className())
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        return view
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
        button.setTitle("存入本地 ", for: .normal)
        button.setImage(UIImage(named: "public_arrowIndicator")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIConstants.Color.primaryGreen
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(draftsBtnAction), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var progressView: MBProgressHUD = {
        let HUD = MBProgressHUD(view: view)
        HUD.mode = .annularDeterminate
        return HUD
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
        
        fetchTagsData()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubviews([textView, previewBtn, previewImgView, collectionView, submitBtn, draftsBtn])
        
        view.drawSeparator(startPoint: CGPoint(x: 0, y: 20+160+20), endPoint: CGPoint(x: UIScreenWidth, y: 20+160+20))
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
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(previewBtn.snp.bottom).offset(60)
            make.height.equalTo((35+15)*3)
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
    fileprivate func fetchTagsData() {
        
        VideoProvider.request(.video_tags, completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if code >= 0 {
                if let data = JSON?["video_tags"] as? [[String: Any]] {
                    
                    if let models = [VideoTagModel].deserialize(from: data) as? [VideoTagModel] {
                        self.tagModels = models
                    }
                    self.collectionView.reloadData()
                }
                
            }
        }))
    }
    
    
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
        
        
        
        progressView.label.text = "正在上传..."
        view.addSubview(progressView)
        progressView.show(animated: true)
        
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
            self.progressView.label.text = "正在发布..."
            
            guard let videoSignedID = self.videoSignedID, let coverSignedID = self.coverSignedID else {
                self.progressView.hide(animated: true)
                HUDService.sharedInstance.show(string: "发布失败")
                return
            }
            
            VideoProvider.request(.video(self.textView.text, videoSignedID, coverSignedID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
                
                self.progressView.hide(animated: true)
                
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
        DispatchQueue.main.async {
            self.progressView.progress = uploadPercent
        }
        
    }
    
    func shortVideoUploader(_ uploader: PLShortVideoUploader, complete info: PLSUploaderResponseInfo, uploadKey: String, resp: [AnyHashable : Any]?) {
        
        guard info.error == nil else {
            dispatchGroup.leave()
            return
        }
        
        dispatchGroup.leave()
        
    }
}


// MARK: - ============= UITextView Delegate =============
extension DVideoPostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        let text = textView.attributedText.string
        
        guard let expression = try? NSRegularExpression(pattern: "#[^#]+#", options: [.caseInsensitive]) else { return }
        
        let results = expression.matches(in: text, options: NSRegularExpression.MatchingOptions(), range: NSString(string: text).rangeOfAll())
        
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        attributedText.addAttributes([NSAttributedString.Key.foregroundColor : UIConstants.Color.head], range: NSString(string: text).rangeOfAll())
        for result in results {
            attributedText.addAttributes([NSAttributedString.Key.foregroundColor : UIConstants.Color.primaryGreen], range: result.range)
        }
        
        textView.attributedText = attributedText
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.length == 0 && text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}


// MARK: - ============= UICollectionViewDataSource, UICollectionViewDelegate =============
extension DVideoPostViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoTagCell.className(), for: indexPath) as! VideoTagCell
        if let model = tagModels?[exist: indexPath.row] {
            cell.setup(model: model)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let model = tagModels?[exist: indexPath.row], let text = model.name {
            let text = " #\(text)#"
            
            guard let startPosition = textView.position(from: textView.beginningOfDocument, offset: textView.text.count) else { return }
            guard let endPosition = textView.position(from: startPosition, offset: 0) else { return }
            guard let range = textView.textRange(from: startPosition, to: endPosition) else { return }
            textView.replace(range, withText: text)
        }
    }
    
}
