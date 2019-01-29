//
//  DVideoCoverViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/29.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import PLShortVideoKit

class DVideoCoverViewController: BaseViewController {

    fileprivate let asset: AVAsset
    
    fileprivate lazy var keyframeImgs = [UIImage]()
    
    fileprivate lazy var keyframeCount: Int = 6
    
    var completionHandler: ((Double)->Void)?
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 55, height: 55)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(VideoPreviewCell.self, forCellWithReuseIdentifier: VideoPreviewCell.className())
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.allowsSelection = false
        return view
    }()
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = .white
        label.text = "选择封面"
        return label
    }()
    
    fileprivate lazy var sliderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy fileprivate var lastOffsetX: CGFloat = 0
    
    init(asset: AVAsset) {
        self.asset = asset
        
        super.init(nibName: nil, bundle: nil)
        
        extractImages(asset: asset) { (image) in
            //TODO: sclae img
            DispatchQueue.main.async {
                self.keyframeImgs.append(image)
                self.collectionView.reloadData()
            }
        }
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
    fileprivate func initContentView() {
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(effectView)
        effectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubviews([collectionView, titleLabel, sliderView])
        
        view.drawSeparator(startPoint: CGPoint(x: 0, y: 56), endPoint: CGPoint(x: UIScreenWidth, y: 56))
        
        let panGesture: UIPanGestureRecognizer = {
            let view = UIPanGestureRecognizer(target: self, action: #selector(panGesture(sender:)))
            return view
        }()
        collectionView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(74)
            make.height.equalTo(55)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(56)
        }
        sliderView.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(collectionView)
            make.width.equalTo(sliderView.snp.height)
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    fileprivate func extractImages(asset: AVAsset, completionHandler:@escaping ((UIImage)->Void)) {
        let duration = asset.duration.seconds
        guard let frameRate = asset.tracks(withMediaType: AVMediaType.video).first?.nominalFrameRate else { return }
        
        var times = [NSValue]()
        var frame: Float64 = 0
        while frame < duration * Double(frameRate) {
            times.append(NSValue(time: CMTime(value: CMTimeValue(frame), timescale: CMTimeScale(frameRate))))
            
            frame += duration * Double(frameRate) / Double(keyframeCount)
        }
        
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.requestedTimeToleranceBefore = .zero
        imgGenerator.requestedTimeToleranceAfter = .zero
        imgGenerator.appliesPreferredTrackTransform = true
        imgGenerator.maximumSize = CGSize(width: 110, height: 110)
        imgGenerator.generateCGImagesAsynchronously(forTimes: times) { (requestedTime, image, actualTime, result, error) in
            
            guard let img = image, result == .succeeded else { return }
            completionHandler(UIImage(cgImage: img))
        }
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============
    @objc func panGesture(sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            lastOffsetX = sender.location(in: view).x
            
        } else if sender.state == .changed {
            let offsetX = sender.location(in: view).x
            
            if sliderView.translatesAutoresizingMaskIntoConstraints == false {
                sliderView.translatesAutoresizingMaskIntoConstraints = true
            }
            
            var minX: CGFloat = sliderView.frame.minX+offsetX-lastOffsetX
            if minX < UIConstants.Margin.leading {
                minX = UIConstants.Margin.leading
            } else if minX > UIScreenWidth-UIConstants.Margin.trailing-55 {
                minX = UIScreenWidth-UIConstants.Margin.trailing-55
            }
            sliderView.frame = CGRect(origin: CGPoint(x: minX, y: sliderView.frame.minY), size: sliderView.frame.size)
            
            lastOffsetX = offsetX
            
        } else if sender.state == .ended {
            
            if let closure = completionHandler {
                closure(asset.duration.seconds/Double(collectionView.bounds.size.width)*Double(sliderView.frame.minX))
            }
        }
    }
}


// MARK: - ============= UICollectionViewDataSource, UICollectionViewDelegate =============
extension DVideoCoverViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyframeImgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoPreviewCell.className(), for: indexPath) as! VideoPreviewCell
        if let img = keyframeImgs[exist: indexPath.row] {
            cell.setup(img: img)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
}
