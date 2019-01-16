//
//  DVideoClipViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/16.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import AVFoundation

class DVideoClipViewController: BaseViewController {

    fileprivate let asset: AVAsset
    
    fileprivate lazy var keyframeImgs = [UIImage]()
    
    fileprivate lazy var keyframeCount: Int = 6
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 55, height: 55)
//        layout.sectionInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(VideoPreviewCell.self, forCellWithReuseIdentifier: VideoPreviewCell.className())
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy fileprivate var leftMaskImgView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    lazy fileprivate var rightMaskImgView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    lazy fileprivate var clipImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_clipVideoSlider")?.resizableImage(withCapInsets: UIEdgeInsets(top: 27.5, left: 17, bottom: 27.5, right: 17))
        return imgView
    }()
    
    fileprivate lazy var minClipSeconds: Double = 5
    
    fileprivate lazy var isMovingLeft: Bool = true
    
    init(asset: AVAsset, minClipSeconds: Double = 5) {
        self.asset = asset
        
        super.init(nibName: nil, bundle: nil)
        
        self.minClipSeconds = minClipSeconds
        
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
        initGestureRecognizer()
        addNotificationObservers()
        
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.backgroundColor = .black
        
        view.addSubviews([collectionView, leftMaskImgView, rightMaskImgView, clipImgView])
    }
    
    fileprivate func initGestureRecognizer() {
        let leftDragGesture: UIPanGestureRecognizer = {
            let view = UIPanGestureRecognizer(target: self, action: #selector(leftDragGesture(sender:)))
            return view
        }()
        view.addGestureRecognizer(leftDragGesture)
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(74)
            make.height.equalTo(55)
        }
        leftMaskImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(74)
            make.height.equalTo(55)
            make.trailing.equalTo(clipImgView.snp.leading).offset(12.5)
        }
        rightMaskImgView.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(74)
            make.height.equalTo(55)
            make.leading.equalTo(clipImgView.snp.trailing).offset(-12.5)
        }
        clipImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(74)
            make.height.equalTo(55)
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
    @objc func leftDragGesture(sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            let beginX = sender.location(in: view).x
            isMovingLeft = (beginX <= clipImgView.frame.midX)
            
        } else if sender.state == .changed {
            let offsetX = sender.velocity(in: view).x/150
            
            if clipImgView.translatesAutoresizingMaskIntoConstraints == false {
                clipImgView.translatesAutoresizingMaskIntoConstraints = true
            }
            leftMaskImgView.translatesAutoresizingMaskIntoConstraints = true
            rightMaskImgView.translatesAutoresizingMaskIntoConstraints = true
            
            if isMovingLeft {
                let minWidth: CGFloat = CGFloat(minClipSeconds / asset.duration.seconds) * collectionView.bounds.width
                let clipFrame = clipImgView.frame
                let maskFrame = rightMaskImgView.frame
                var clipViewWidth: CGFloat = clipFrame.width-offsetX
                var clipViewX: CGFloat = clipFrame.minX+offsetX
                
                if clipImgView.frame.width-offsetX < minWidth {
                    clipViewWidth = minWidth
                    clipViewX = clipFrame.maxX-minWidth
                } else if clipImgView.frame.minX+offsetX < collectionView.frame.minX {
                    clipViewWidth = clipFrame.maxX - UIConstants.Margin.leading
                    clipViewX = UIConstants.Margin.leading
                }
                
                clipImgView.frame = CGRect(origin: CGPoint(x: clipViewX, y: clipFrame.minY), size: CGSize(width: clipViewWidth, height: clipFrame.height))
                
                leftMaskImgView.frame = CGRect(origin: CGPoint(x: UIConstants.Margin.leading, y: maskFrame.minY), size: CGSize(width: clipImgView.frame.minX-UIConstants.Margin.leading, height: maskFrame.height))
            } else {
                let minWidth: CGFloat = CGFloat(minClipSeconds / asset.duration.seconds) * collectionView.bounds.width
                let clipFrame = clipImgView.frame
                let maskFrame = rightMaskImgView.frame
                var clipViewWidth: CGFloat = clipFrame.width+offsetX
                var maskViewWidth: CGFloat = maskFrame.width-offsetX
                if clipImgView.frame.width+offsetX < minWidth {
                    clipViewWidth = minWidth
                    maskViewWidth = collectionView.frame.width-(clipFrame.minX-clipViewWidth)+12.5
                } else if clipImgView.frame.maxX+offsetX > collectionView.frame.maxX {
                    clipViewWidth = collectionView.frame.width-(clipFrame.minX-UIConstants.Margin.leading)
                    maskViewWidth = 12.5
                }
                
                clipImgView.frame = CGRect(origin: CGPoint(x: clipFrame.minX, y: clipFrame.minY), size: CGSize(width: clipViewWidth, height: clipFrame.height))
                
                rightMaskImgView.frame = CGRect(origin: CGPoint(x: clipImgView.frame.maxX-12.5, y: maskFrame.minY), size: CGSize(width: maskViewWidth, height: maskFrame.height))
            }
            
        }
    }
}


// MARK: - ============= UICollectionViewDataSource, UICollectionViewDelegate =============
extension DVideoClipViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
