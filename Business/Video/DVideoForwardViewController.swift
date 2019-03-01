//
//  DVideoForwardViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/10.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import Alamofire
import Photos

class DVideoForwardViewController: BaseViewController {

    fileprivate let videoModel: VideoModel
    
    fileprivate lazy var forwardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 47, height: 72)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        
        let remainderWidth = UIScreenWidth-layout.sectionInset.left-layout.sectionInset.right-layout.itemSize.width*5
        if remainderWidth > 40 {
            layout.minimumInteritemSpacing = remainderWidth/4
            layout.minimumLineSpacing = remainderWidth/4
        } else {
            layout.minimumInteritemSpacing = 22
            layout.minimumLineSpacing = 22
        }
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(PresentationActionCell.self, forCellWithReuseIdentifier: PresentationActionCell.className())
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        view.alwaysBounceHorizontal = true
        return view
    }()
    
    fileprivate lazy var othersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 47, height: 72)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        layout.minimumLineSpacing = 0
        let remainderWidth = UIScreenWidth-layout.sectionInset.left-layout.sectionInset.right-layout.itemSize.width*5
        if remainderWidth > 40 {
            layout.minimumInteritemSpacing = remainderWidth/4
            layout.minimumLineSpacing = remainderWidth/4
        } else {
            layout.minimumInteritemSpacing = 22
            layout.minimumLineSpacing = 22
        }
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(PresentationActionCell.self, forCellWithReuseIdentifier: PresentationActionCell.className())
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        view.alwaysBounceHorizontal = true
        return view
    }()
    
    lazy fileprivate var dismissBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.body, for: .normal)
        button.titleLabel?.font = UIConstants.Font.body
        button.setTitle("取消", for: .normal)
        button.addTarget(self, action: #selector(dimissBarItemAction), for: .touchUpInside)
        return button
    }()
    
    init(model: VideoModel) {
        videoModel = model
        
        super.init(nibName: nil, bundle: nil)
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
    
    override func viewWillLayoutSubviews() {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 4, height: 4))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubviews([forwardCollectionView, othersCollectionView, dismissBtn])
        
        view.drawSeparator(startPoint: CGPoint(x: 0, y: 115.5), endPoint: CGPoint(x: UIScreenWidth, y: 115.5))
        view.drawSeparator(startPoint: CGPoint(x: 0, y: 221.5), endPoint: CGPoint(x: UIScreenWidth, y: 221.5))
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        forwardCollectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(116)
        }
        othersCollectionView.snp.makeConstraints { make in
            make.top.equalTo(forwardCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(106)
        }
        dismissBtn.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(othersCollectionView.snp.bottom)
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    fileprivate func favoriteRequest() {
        guard let videoIDString = videoModel.id, let videoID = Int(videoIDString) else { return }
        
        if videoModel.starred == false {
            VideoProvider.request(.video_favorite(videoID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
                
                if code >= 0 {
                    self.videoModel.starred = true
                    self.othersCollectionView.reloadData()
                    
                    NotificationCenter.default.post(name: Notification.Video.videoFavoritesDidChange, object: nil)
                }
            }))
            
        } else {
            VideoProvider.request(.video_favorite_delete(videoID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
                
                if code >= 0 {
                    self.videoModel.starred = false
                    self.othersCollectionView.reloadData()
                    
                    NotificationCenter.default.post(name: Notification.Video.videoFavoritesDidChange, object: nil)
                }
            }))
        }
    }
    
    fileprivate func reportRequest() {
        guard let string = videoModel.id, let videoID = Int(string) else { return }
        
        VideoProvider.request(.video_report(videoID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if code > 0 {
                HUDService.sharedInstance.show(string: "举报成功")
            }
            
        }))
    }
    
    fileprivate func rewardShareRequest() {
        guard AuthorizationService.sharedInstance.isSignIn() else {
            return
        }
        
        guard let string = videoModel.id, let videoID = Int(string) else { return }
        
        RewardCoinProvider.request(.reward_fetch("Video", videoID, "share_video"), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if code >= 0, let reward = JSON?["reward"] as? [String: Any], let status = reward["code"] as? String, status == "success", let amount = reward["amount"] as? String {
                let view = RewardView()
                UIApplication.shared.keyWindow?.addSubview(view)
                view.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                view.present(string: amount, mode: RewardView.DRewardMode.share)
                
                if let rewardCodes = reward["rewardable_codes"] as? [String] {
                    NotificationCenter.default.post(name: Notification.Video.rewardStatusDidChange, object: nil, userInfo: ["id": String(videoID), "rewardable_codes": rewardCodes])
                }
                
            }
            
        }))
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============
    fileprivate func reportBtnAction() {
        
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "色情低俗", style: UIAlertAction.Style.default, handler: { (action) in
            self.reportRequest()
        }))
        alertController.addAction(UIAlertAction(title: "政治敏感", style: UIAlertAction.Style.default, handler: { (action) in
            self.reportRequest()
        }))
        alertController.addAction(UIAlertAction(title: "违法犯罪", style: UIAlertAction.Style.default, handler: { (action) in
            self.reportRequest()
        }))
        alertController.addAction(UIAlertAction(title: "垃圾广告、售卖假货", style: UIAlertAction.Style.default, handler: { (action) in
            self.reportRequest()
        }))
        alertController.addAction(UIAlertAction(title: "造谣传谣、涉嫌欺诈", style: UIAlertAction.Style.default, handler: { (action) in
            self.reportRequest()
        }))
        alertController.addAction(UIAlertAction(title: "侮辱谩骂", style: UIAlertAction.Style.default, handler: { (action) in
            self.reportRequest()
        }))
        alertController.addAction(UIAlertAction(title: "盗用TA人作品", style: UIAlertAction.Style.default, handler: { (action) in
            self.reportRequest()
        }))
        alertController.addAction(UIAlertAction(title: "未成年人不当行为", style: UIAlertAction.Style.default, handler: { (action) in
            self.reportRequest()
        }))
        alertController.addAction(UIAlertAction(title: "内容不适合未成年观看", style: UIAlertAction.Style.default, handler: { (action) in
            self.reportRequest()
        }))
        alertController.addAction(UIAlertAction(title: "引人不适", style: UIAlertAction.Style.default, handler: { (action) in
            self.reportRequest()
        }))
        alertController.addAction(UIAlertAction(title: "疑似自我伤害", style: UIAlertAction.Style.default, handler: { (action) in
            self.reportRequest()
        }))
        alertController.addAction(UIAlertAction(title: "诱导点赞、分享", style: UIAlertAction.Style.default, handler: { (action) in
            self.reportRequest()
        }))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    fileprivate func shareBtnAction(isAlertHidden: Bool, shareType: UMSocialPlatformType) {
        
        //登录检测
        if isAlertHidden == false && videoModel.rewardable == true && !AuthorizationService.sharedInstance.isSignIn() {
            let alertController = UIAlertController(title: nil, message: "登录后进行分享才可获取赏金哟", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "继续分享", style: UIAlertAction.Style.default, handler: { (action) in
                self.shareBtnAction(isAlertHidden: true, shareType: shareType)
            }))
            alertController.addAction(UIAlertAction(title: "去登录", style: UIAlertAction.Style.default, handler: { (action) in
                let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
                self.present(authorizationNavigationController, animated: true, completion: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        
        //开始分享
        guard let shareURL = videoModel.share_url else {
            HUDService.sharedInstance.show(string: "分享信息缺失")
            return
        }
        
        let title: String = videoModel.title ?? ""
        let descr: String = videoModel.author?.name ?? ""
        let imgURL: String = videoModel.cover_url ?? ""

        
        if shareType == .wechatSession {
            
            let shareObj = UMShareWebpageObject.shareObject(withTitle: title, descr: descr, thumImage: imgURL)
            shareObj?.webpageUrl = shareURL
            let msgObj = UMSocialMessageObject(mediaObject: shareObj)
            UMSocialManager.default()?.share(to: UMSocialPlatformType.wechatSession, messageObject: msgObj, currentViewController: self, completion: { [weak self] (result, error) in
                if let response = result as? UMSocialShareResponse {
                    if let status = response.originalResponse as? Int, status == 0 {
                        HUDService.sharedInstance.show(string: "分享完成")
                        
                        self?.rewardShareRequest()
                    } else {
                        HUDService.sharedInstance.show(string: "分享失败")
                    }
                } else {
                    HUDService.sharedInstance.show(string: "分享失败")
                }
                self?.dismiss(animated: true, completion: nil)
            })
            
        } else if shareType == .wechatTimeLine {
            
            let shareObj = UMShareWebpageObject.shareObject(withTitle: title, descr: descr, thumImage: imgURL)
            shareObj?.webpageUrl = shareURL
            let msgObj = UMSocialMessageObject(mediaObject: shareObj)
            UMSocialManager.default()?.share(to: UMSocialPlatformType.wechatTimeLine, messageObject: msgObj, currentViewController: self, completion: { [weak self] (result, error) in
                if let response = result as? UMSocialShareResponse {
                    if let status = response.originalResponse as? Int, status == 0 {
                        HUDService.sharedInstance.show(string: "分享完成")
                        
                        self?.rewardShareRequest()
                    } else {
                        HUDService.sharedInstance.show(string: "分享失败")
                    }
                } else {
                    HUDService.sharedInstance.show(string: "分享失败")
                }
                self?.dismiss(animated: true, completion: nil)
            })
            
        }
    }
    
    fileprivate func pasteboardBtnAction() {
        guard let shareURL = videoModel.share_url else {
            HUDService.sharedInstance.show(string: "分享信息缺失")
            return
        }
        
        UIPasteboard.general.string = shareURL
        HUDService.sharedInstance.show(string: "已将链接复制至剪贴板")
        
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func downloadBtnAction() {
        //TODO: 视频水印
        guard let URLString = videoModel.media?.wm_url, let URL = URL(string: URLString) else {
            HUDService.sharedInstance.show(string: "视频地址缺失")
            return
        }
        
        let progressView = MBProgressHUD(view: view)
        progressView.mode = .annularDeterminate
        progressView.label.text = "正在下载..."
        view.addSubview(progressView)
        progressView.show(animated: true)
        
        Alamofire.download(URL) { (URL, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
            let documentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
            return (documentsURL.appendingPathComponent("\(Date().timeIntervalSince1970).mp4"), DownloadRequest.DownloadOptions())
            }.downloadProgress(closure: { (progress) in
                progressView.progress = Float(progress.fractionCompleted)
            }).response { (response) in
                progressView.hide(animated: true)
                if let URL = response.destinationURL {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL)
                    }) { (saved, error) in
                        if saved {
                            DispatchQueue.main.async {
                                HUDService.sharedInstance.show(string: "保存成功")
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
        }
        
    }
}


// MARK: - ============= UICollectionViewDataSource, UICollectionViewDelegate =============
extension DVideoForwardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == forwardCollectionView {
            return 2
        } else if collectionView == othersCollectionView {
            return 4
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PresentationActionCell.className(), for: indexPath) as! PresentationActionCell
        if collectionView == forwardCollectionView {
            if indexPath.row == 0 {
                cell.setup(imgNamed: "public_forwardItemWechatTimeline", bgColor: UIColor("#4ecf01"), text: "朋友圈")
            } else if indexPath.row == 1 {
                cell.setup(imgNamed: "public_forwardItemWechatSession", bgColor: UIColor("#00c80c"), text: "微信")
            } else if indexPath.row == 2 {
                cell.setup(imgNamed: "public_forwardItemQQZone", bgColor: UIColor("#ffbd01"), text: "QQ空间")
            } else if indexPath.row == 3 {
                cell.setup(imgNamed: "public_forwardItemQQ", bgColor: UIColor("#00bcff"), text: "QQ")
            } else if indexPath.row == 4 {
                cell.setup(imgNamed: "public_forwardItemWeibo", bgColor: UIColor("#ff8143"), text: "微博")
            }
        } else if collectionView == othersCollectionView {
            if indexPath.row == 0 {
                cell.setup(imgNamed: "public_actionItemReport", bgColor: UIColor("#f3f4f6"), text: "举报")
            } else if indexPath.row == 1 {
                if videoModel.starred == true {
                    cell.setup(imgNamed: "public_actionItemFavoriteHighlight", bgColor: UIColor("#f3f4f6"), text: "已收藏")
                } else {
                    cell.setup(imgNamed: "public_actionItemFavorite", bgColor: UIColor("#f3f4f6"), text: "收藏")
                }
            } else if indexPath.row == 2 {
                cell.setup(imgNamed: "public_actionItemClipboard", bgColor: UIColor("#f3f4f6"), text: "复制链接")
            } else if indexPath.row == 3 {
                cell.setup(imgNamed: "public_actionItemDownload", bgColor: UIColor("#f3f4f6"), text: "保存本地")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if collectionView == forwardCollectionView {
            if indexPath.row == 0 {
                shareBtnAction(isAlertHidden: false, shareType: UMSocialPlatformType.wechatTimeLine)
            } else if indexPath.row == 1 {
                shareBtnAction(isAlertHidden: false, shareType: UMSocialPlatformType.wechatSession)
            }
//            } else if indexPath.row == 2 {
//                cell.setup(imgNamed: "public_forwardItemQQZone", bgColor: UIColor("#ffbd01"), text: "QQ空间")
//            } else if indexPath.row == 3 {
//                cell.setup(imgNamed: "public_forwardItemQQ", bgColor: UIColor("#00bcff"), text: "QQ")
//            } else if indexPath.row == 4 {
//                cell.setup(imgNamed: "public_forwardItemWeibo", bgColor: UIColor("#ff8143"), text: "微博")
//            }
        } else if collectionView == othersCollectionView {
            if indexPath.row == 0 {
                guard AuthorizationService.sharedInstance.isSignIn() else {
                    let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
                    present(authorizationNavigationController, animated: true, completion: nil)
                    return
                }
                
                reportBtnAction()
            } else if indexPath.row == 1 {
                guard AuthorizationService.sharedInstance.isSignIn() else {
                    let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
                    present(authorizationNavigationController, animated: true, completion: nil)
                    return
                }
                
                favoriteRequest()
            } else if indexPath.row == 2 {
                pasteboardBtnAction()
            } else if indexPath.row == 3 {
                downloadBtnAction()
            }
        }
    }
    
}
