//
//  DVideoForwardViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/10.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

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
                }
            }))
            
        } else {
            VideoProvider.request(.video_favorite_delete(videoID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
                
                if code >= 0 {
                    self.videoModel.starred = false
                    self.othersCollectionView.reloadData()
                }
            }))
        }
    }
    
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
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func reportRequest() {
        guard let string = videoModel.id, let videoID = Int(string) else { return }
        
        VideoProvider.request(.video_report(videoID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if code > 0 {
                HUDService.sharedInstance.show(string: "举报成功")
            }
            
        }))
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============

}


extension DVideoForwardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == forwardCollectionView {
            return 5
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
//            if indexPath.row == 0 {
//                cell.setup(imgNamed: "public_forwardItemWechatTimeline", bgColor: UIColor("#4ecf01"), text: "朋友圈")
//            } else if indexPath.row == 1 {
//                cell.setup(imgNamed: "public_forwardItemWechatSession", bgColor: UIColor("#00c80c"), text: "微信")
//            } else if indexPath.row == 2 {
//                cell.setup(imgNamed: "public_forwardItemQQZone", bgColor: UIColor("#ffbd01"), text: "QQ空间")
//            } else if indexPath.row == 3 {
//                cell.setup(imgNamed: "public_forwardItemQQ", bgColor: UIColor("#00bcff"), text: "QQ")
//            } else if indexPath.row == 4 {
//                cell.setup(imgNamed: "public_forwardItemWeibo", bgColor: UIColor("#ff8143"), text: "微博")
//            }
        } else if collectionView == othersCollectionView {
            if indexPath.row == 0 {
                reportBtnAction()
            } else if indexPath.row == 1 {
                favoriteRequest()
            }
//            } else if indexPath.row == 2 {
//                cell.setup(imgNamed: "public_actionItemClipboard", bgColor: UIColor("#f3f4f6"), text: "复制链接")
//            } else if indexPath.row == 3 {
//                cell.setup(imgNamed: "public_actionItemDownload", bgColor: UIColor("#f3f4f6"), text: "保存本地")
//            }
        }
    }
    
}
