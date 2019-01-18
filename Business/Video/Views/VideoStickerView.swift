//
//  VideoStickerView.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/18.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class VideoStickerView: UIView {

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
        
        let sublayer = CAShapeLayer()
        let circlePath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 11, y: 11), size: CGSize(width: img.size.width, height: img.size.height)), cornerRadius: 4)
        sublayer.path = circlePath.cgPath
        sublayer.fillColor = UIColor.clear.cgColor
        sublayer.lineWidth = 1
        sublayer.strokeColor = UIColor.white.cgColor
        layer.addSublayer(sublayer)
        
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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    @objc func removeBtnAction() {
        removeFromSuperview()
    }
}
