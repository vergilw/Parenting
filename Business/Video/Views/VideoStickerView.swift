//
//  VideoStickerView.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/18.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

protocol VideoStickerViewDelegate: NSObjectProtocol {
    func stickerViewRemove(_ stickerView: VideoStickerView)
    
    func stickerViewTransform(_ stickerView: VideoStickerView)
    
}

class VideoStickerView: UIView {

    weak var delegate: VideoStickerViewDelegate?
    
    fileprivate lazy var originPoint: CGPoint = .zero
    fileprivate lazy var originTransform: CGAffineTransform = .identity
    
    fileprivate lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    
    fileprivate lazy var removeBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "video_stickerRemove"), for: .normal)
        button.addTarget(self, action: #selector(removeBtnAction), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var transformBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "video_stickerTransform"), for: .normal)
//        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    init(img: UIImage) {
        super.init(frame: .zero)
        
        imgView.image = img
        
        imgView.layer.borderColor = UIColor.white.cgColor
        imgView.layer.borderWidth = 1
        imgView.layer.cornerRadius = 4
//        let sublayer = CAShapeLayer()
//        let circlePath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 11, y: 11), size: CGSize(width: img.size.width, height: img.size.height)), cornerRadius: 4)
//        sublayer.path = circlePath.cgPath
//        sublayer.fillColor = UIColor.clear.cgColor
//        sublayer.lineWidth = 1
//        sublayer.strokeColor = UIColor.white.cgColor
//        layer.addSublayer(sublayer)
        
        addSubviews([imgView, removeBtn, transformBtn])
        
        imgView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11))
        }
        removeBtn.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        transformBtn.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
        }
        
        
        let moveGesture: UIPanGestureRecognizer = {
            let view = UIPanGestureRecognizer(target: self, action: #selector(moveGestureAction(sender:)))
            return view
        }()
        addGestureRecognizer(moveGesture)
        
        let transformGesture: UIPanGestureRecognizer = {
            let view = UIPanGestureRecognizer(target: self, action: #selector(transformGestureAction(sender:)))
            return view
        }()
        transformBtn.addGestureRecognizer(transformGesture)
        
        moveGesture.require(toFail: transformGesture)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    @objc func removeBtnAction() {
        removeFromSuperview()
        
        if let delegate = delegate {
            delegate.stickerViewRemove(self)
        }
    }
    
    func hideBorder() {
        imgView.layer.borderWidth = 0
        imgView.layer.cornerRadius = 0
    }
    
    @objc fileprivate func moveGestureAction(sender: UIPanGestureRecognizer) {
        guard let stickerView = sender.view else { return }
        
        if stickerView.translatesAutoresizingMaskIntoConstraints == false {
            stickerView.translatesAutoresizingMaskIntoConstraints = true
        }
        
        let point = sender.location(in: stickerView.superview)
        stickerView.center = point
    }
    
    @objc fileprivate func transformGestureAction(sender: UIPanGestureRecognizer) {
        guard let stickerView = sender.view?.superview else { return }
        
        if stickerView.translatesAutoresizingMaskIntoConstraints == false {
            stickerView.translatesAutoresizingMaskIntoConstraints = true
        }
        
        let point = sender.location(in: stickerView.superview)
        
        if sender.state == .began {
            originPoint = point
            originTransform = stickerView.transform
        }
        
        //distance
        let originDistance = distancePoint(pointA: originPoint, pointB: stickerView.center)
        let newestDistance = distancePoint(pointA: point, pointB: stickerView.center)
        let scale = newestDistance / originDistance
        
        //radius
        let originRadius = radiusPoint(pointA: stickerView.center, pointB: originPoint)
        let newestRadius = radiusPoint(pointA: stickerView.center, pointB: point)
        let radius = -(newestRadius - originRadius)
        
        stickerView.transform = originTransform.scaledBy(x: scale, y: scale).rotated(by: radius)
    }
    
    fileprivate func distancePoint(pointA: CGPoint, pointB: CGPoint) -> CGFloat {
        let x = pointA.x - pointB.x
        let y = pointA.y - pointB.y
        return sqrt(x*x + y*y)
    }
    
    fileprivate func radiusPoint(pointA: CGPoint, pointB: CGPoint) -> CGFloat {
        let x = pointA.x - pointB.x
        let y = pointA.y - pointB.y
        return atan2(x, y)
    }
}
