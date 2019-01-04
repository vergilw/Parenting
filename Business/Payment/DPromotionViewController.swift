//
//  DPromotionViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/4.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class DPromotionViewController: BaseViewController {

//    lazy fileprivate var viewHeight: CGFloat = {
//        var float: CGFloat = 0
//        if #available(iOS 11.0, *) {
//            float = UIScreenHeight - (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight) + ((navigationController?.navigationBar.bounds.size.height ?? 0) as CGFloat) - ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) as CGFloat)
//        } else {
//            float = UIScreenHeight - UIStatusBarHeight - (navigationController?.navigationBar.bounds.size.height ?? 0)
//        }
//        return float
//    }()
//
//    lazy fileprivate var heightRate: CGFloat = viewHeight/603
    
    lazy fileprivate var bgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "payment_promotionBg")
        return imgView
    }()
    
    lazy fileprivate var bgCapImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "payment_promotionCapBg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 9, left: 34.5, bottom: 242, right: 35.5), resizingMode: UIImage.ResizingMode.stretch)
        return imgView
    }()
    
    lazy fileprivate var titleImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "payment_promotionTitle")
        return imgView
    }()
    
    lazy fileprivate var avatarImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.borderColor = UIColor("#ceb981").cgColor
        imgView.layer.borderWidth = 1.5
        imgView.layer.cornerRadius = 30
        imgView.clipsToBounds = true
        if let URLString = AuthorizationService.sharedInstance.user?.avatar_url {
            imgView.kf.setImage(with: URL(string: URLString), placeholder: UIImage(named: "public_avatarPlaceholder"))
        }
        return imgView
    }()
    
    lazy fileprivate var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.head
        if let string = AuthorizationService.sharedInstance.user?.name {
            label.text = string
        }
        return label
    }()
    
    lazy fileprivate var bodyImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "payment_promotionBody")
        imgView.contentMode = .center
        return imgView
    }()
    
    lazy fileprivate var noteImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "payment_promotionNote")
        return imgView
    }()
    
    lazy fileprivate var qrImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = createQRForString(string: "https://www.baidu.com", size: CGSize(width: 100, height: 100))
        return imgView
    }()
    
    lazy fileprivate var actionStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 18
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "分享赢赏金"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubviews([bgImgView, bgCapImgView, titleImgView, avatarImgView, nameLabel, bodyImgView, noteImgView, qrImgView, actionStackView])
        
        initDashLine()
        initActionView()
    }
    
    fileprivate func initDashLine() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor("#ffc92b").cgColor
        shapeLayer.lineWidth = 3
        let remainder =  (UIScreenWidth - 80).truncatingRemainder(dividingBy: 10)
        shapeLayer.lineDashPattern = [0.01, 10]
        shapeLayer.lineCap = .round
        
        let path = CGMutablePath()
        var startHeight: CGFloat = 0
        let navigationHeight: CGFloat = navigationController?.navigationBar.bounds.size.height ?? 0
        if #available(iOS 11.0, *) {
            let topSafe: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
            startHeight = UIScreenHeight - topSafe - navigationHeight - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) - 226
        } else {
            startHeight = UIScreenHeight - UIStatusBarHeight - navigationHeight - 226
        }
        path.addLines(between: [CGPoint(x: 40+remainder/2, y: startHeight), CGPoint(x: UIScreenWidth-40-remainder/2+1, y: startHeight)])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
    fileprivate func initActionView() {
        let sessionBtn: UIButton = {
            let button = UIButton()
            button.setTitleColor(UIConstants.Color.head, for: .normal)
            button.titleLabel?.font = UIConstants.Font.body
            button.setTitle(" 分享至微信", for: .normal)
            button.setImage(UIImage(named: "payment_promotionSession"), for: .normal)
            button.layer.borderColor = UIConstants.Color.separator.cgColor
            button.layer.borderWidth = 0.5
            button.layer.cornerRadius = 23
            button.addTarget(self, action: #selector(sessionBtnAction), for: .touchUpInside)
            return button
        }()
        
        let timelineBtn: UIButton = {
            let button = UIButton()
            button.setTitleColor(UIConstants.Color.head, for: .normal)
            button.titleLabel?.font = UIConstants.Font.body
            button.setTitle(" 分享至朋友圈", for: .normal)
            button.setImage(UIImage(named: "payment_promotionTimeline"), for: .normal)
            button.layer.borderColor = UIConstants.Color.separator.cgColor
            button.layer.borderWidth = 0.5
            button.layer.cornerRadius = 23
            button.addTarget(self, action: #selector(timelineBtnAction), for: .touchUpInside)
            return button
        }()
        
        actionStackView.addArrangedSubview(sessionBtn)
        actionStackView.addArrangedSubview(timelineBtn)
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        bgImgView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
            } else {
                make.bottom.equalTo(0)
            }
        }
        bgCapImgView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(20)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
            } else {
                make.bottom.equalTo(0)
            }
        }
        titleImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(50)
            make.height.equalTo(83.5)
        }
        avatarImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleImgView.snp.bottom).offset(16)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImgView.snp.bottom).offset(8)
            make.height.equalTo(15)
        }
        bodyImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.bottom.equalTo(noteImgView.snp.top).offset(-50)
        }
        noteImgView.snp.makeConstraints { make in
            make.leading.equalTo(55)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(-105-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
            } else {
                make.bottom.equalTo(-105)
            }
        }
        qrImgView.snp.makeConstraints { make in
            make.trailing.equalTo(-46)
            make.centerY.equalTo(noteImgView)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        actionStackView.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(-16-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
            } else {
                make.bottom.equalTo(-16)
            }
            make.height.equalTo(46)
        }
        
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    func createQRForString(string: String, size: CGSize) -> UIImage? {
        guard let data = string.data(using: String.Encoding.isoLatin1) else { return nil }
        let filter = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage" : data, "inputCorrectionLevel": "H"])
        guard let img = filter?.outputImage else { return nil }
        
        let scaleX = size.width/img.extent.size.width
        let scaleY = size.height/img.extent.size.height
        let scaleImg = img.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        let image = UIImage(ciImage: scaleImg, scale: UIScreen.main.scale, orientation: UIImage.Orientation.up)
        return image
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============
    func generateImg(avatarImg: UIImage) -> UIImage? {
        let panelView: UIView = {
            let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 750, height: 1334)))
            return view
        }()
        
        let bgImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "payment_promotionShareBg")
            return imgView
        }()
        
        let avatarImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.contentMode = .scaleAspectFill
            imgView.layer.cornerRadius = 23.5
            imgView.clipsToBounds = true
            imgView.image = avatarImg
            return imgView
        }()
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.body
            label.textColor = UIConstants.Color.head
            if let string = AuthorizationService.sharedInstance.user?.name {
                label.text = string
            }
            return label
        }()
        
        let footnoteLabel: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.body
            label.textColor = UIConstants.Color.foot
            label.text = "邀请你成为赏金达人"
            return label
        }()
        
        let qrImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.image = createQRForString(string: "https://www.baidu.com", size: CGSize(width: 235, height: 235))
            return imgView
        }()

        let logoImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "AppIcon60x60")
            imgView.layer.borderColor = UIColor.white.cgColor
            imgView.layer.borderWidth = 3
            imgView.layer.cornerRadius = 8
            imgView.clipsToBounds = true
            return imgView
        }()
        
        panelView.addSubviews([bgImgView, avatarImgView, nameLabel, footnoteLabel, qrImgView, logoImgView])
        bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        avatarImgView.snp.makeConstraints { make in
            make.leading.equalTo(53)
            make.top.equalTo(244)
            make.size.equalTo(CGSize(width: 47, height: 47))
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImgView.snp.trailing).offset(13)
            make.top.equalTo(avatarImgView)
        }
        footnoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImgView.snp.trailing).offset(13)
            make.bottom.equalTo(avatarImgView)
        }
        qrImgView.snp.makeConstraints { make in
            make.leading.equalTo(70)
            make.top.equalTo(324)
            make.size.equalTo(CGSize(width: 235, height: 235))
        }
        logoImgView.snp.makeConstraints { make in
            make.center.equalTo(qrImgView)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        view.addSubview(panelView)
        panelView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 375, height: 667))
        }
        
        let img = panelView.snapshotImage(afterScreenUpdates: true)
        panelView.removeFromSuperview()
        return img
    }
    
    func shareToSession(img: UIImage) {
        let shareObj = UMShareImageObject()
        shareObj.shareImage = self.generateImg(avatarImg: img)
        
        let msgObj = UMSocialMessageObject(mediaObject: shareObj)
        UMSocialManager.default()?.share(to: UMSocialPlatformType.wechatSession, messageObject: msgObj, currentViewController: self, completion: { (result, error) in
            if let response = result as? UMSocialShareResponse {
                if let status = response.originalResponse as? Int, status == 0 {
                    HUDService.sharedInstance.show(string: "分享完成")
                    
                } else {
                    HUDService.sharedInstance.show(string: "分享失败")
                }
            } else {
                HUDService.sharedInstance.show(string: "分享失败")
            }
        })
    }
    
    func shareToTimeline(img: UIImage) {
        let shareObj = UMShareImageObject()
        shareObj.shareImage = self.generateImg(avatarImg: img)
        
        let msgObj = UMSocialMessageObject(mediaObject: shareObj)
        UMSocialManager.default()?.share(to: UMSocialPlatformType.wechatTimeLine, messageObject: msgObj, currentViewController: self, completion: { (result, error) in
            if let response = result as? UMSocialShareResponse {
                if let status = response.originalResponse as? Int, status == 0 {
                    HUDService.sharedInstance.show(string: "分享完成")
                    
                } else {
                    HUDService.sharedInstance.show(string: "分享失败")
                }
            } else {
                HUDService.sharedInstance.show(string: "分享失败")
            }
        })
    }
    
    @objc func sessionBtnAction() {
        if let URLString = AuthorizationService.sharedInstance.user?.avatar_url {
            KingfisherManager.shared.retrieveImage(with: URL(string: URLString)!, options: nil, progressBlock: nil, completionHandler: { (img, error, type, URL) in
                var resultImg: UIImage
                if let img = img {
                    resultImg = img
                } else {
                    resultImg = UIImage(named: "public_avatarPlaceholder")!
                }
                
                self.shareToSession(img: resultImg)
            })
        } else {
            shareToSession(img: UIImage(named: "public_avatarPlaceholder")!)
        }
    }
    
    @objc func timelineBtnAction() {
        if let URLString = AuthorizationService.sharedInstance.user?.avatar_url {
            KingfisherManager.shared.retrieveImage(with: URL(string: URLString)!, options: nil, progressBlock: nil, completionHandler: { (img, error, type, URL) in
                var resultImg: UIImage
                if let img = img {
                    resultImg = img
                } else {
                    resultImg = UIImage(named: "public_avatarPlaceholder")!
                }
                
                self.shareToTimeline(img: resultImg)
            })
        } else {
            shareToTimeline(img: UIImage(named: "public_avatarPlaceholder")!)
        }
    }
    
}
