//
//  DVideoStickersViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/29.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class DVideoStickersViewController: BaseViewController {

    var stickerHandler: ((UIImage)->Void)?
    
    fileprivate lazy var stickersImgNames: [String] = [
        "stickers_duck",
        "stickers_strawberry",
        "stickers_swimRing",
        "stickers_gloves",
        "stickers_horn",
        "stickers_airplane",
        "stickers_couplet",
        "stickers_gift",
        "stickers_candy",
        "stickers_ingotPig",
        "stickers_nipple",
        "stickers_trumpet",
        "stickers_sachet",
        "stickers_heartEnvelope",
        "stickers_goldBell",
        "stickers_loveBear",
        "stickers_strawberryPie",
        "stickers_bathtub",
        "stickers_stockings",
        "stickers_briefs",
        "stickers_topHat",
        "stickers_lantern",
        "stickers_teapot",
        "stickers_birthdayCake",
        "stickers_feeder",
        "stickers_lollipop",
        "stickers_heartGift"
    ]
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Semibold", size: 15)!
        label.textColor = .white
        label.text = "添加贴纸"
        return label
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 48, height: 48)
        layout.sectionInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 18
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(VideoStickerCell.self, forCellWithReuseIdentifier: VideoStickerCell.className())
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(effectView)
        effectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubviews([titleLabel, collectionView])
        
        view.drawSeparator(startPoint: CGPoint(x: 0, y: 56), endPoint: CGPoint(x: UIScreenWidth, y: 56))
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.height.equalTo(56)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(74)
            make.height.equalTo(48+18+48)
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

}



// MARK: - ============= UICollectionViewDataSource, UICollectionViewDelegate =============
extension DVideoStickersViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickersImgNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoStickerCell.className(), for: indexPath) as! VideoStickerCell
        if let imgName = stickersImgNames[exist: indexPath.row], let img = UIImage(named: imgName) {
            cell.setup(img: img)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let closure = stickerHandler, let imgName = stickersImgNames[exist: indexPath.row], let img = UIImage(named: imgName) {
            closure(img)
        }
    }
    
}
