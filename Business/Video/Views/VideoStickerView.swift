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
    
    fileprivate lazy var lastPoint: CGPoint = .zero
    
    fileprivate lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    
    fileprivate lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
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
        
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 4
//        let sublayer = CAShapeLayer()
//        let circlePath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 11, y: 11), size: CGSize(width: img.size.width, height: img.size.height)), cornerRadius: 4)
//        sublayer.path = circlePath.cgPath
//        sublayer.fillColor = UIColor.clear.cgColor
//        sublayer.lineWidth = 1
//        sublayer.strokeColor = UIColor.white.cgColor
//        layer.addSublayer(sublayer)
        
        addSubviews([contentView, imgView, removeBtn, transformBtn])
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11))
        }
        imgView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 11+10, left: 11+10, bottom: 11+10, right: 11+10))
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
        contentView.layer.borderWidth = 0
        removeBtn.isHidden = true
        transformBtn.isHidden = true
    }
    
    func showBorder() {
        contentView.layer.borderWidth = 1
        removeBtn.isHidden = false
        transformBtn.isHidden = false
    }
    
    @objc fileprivate func moveGestureAction(sender: UIPanGestureRecognizer) {
        guard let stickerView = sender.view else { return }
        
        let point = sender.location(in: stickerView.superview)
        
        if sender.state == .began {
            lastPoint = point
            return
        }
        
        if stickerView.translatesAutoresizingMaskIntoConstraints == false {
            stickerView.translatesAutoresizingMaskIntoConstraints = true
        }
        
        stickerView.center = CGPoint(x: stickerView.center.x - (lastPoint.x-point.x), y: stickerView.center.y - (lastPoint.y-point.y))
        lastPoint = point
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
        var scale = newestDistance / originDistance
        if scale < 0.3 {
            scale = 0.3
        }
        
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
