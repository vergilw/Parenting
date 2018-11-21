//
//  SearchHistoryCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/21.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class SearchHistoryCell: UICollectionViewCell {
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    lazy fileprivate var bgImgView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    fileprivate var bgLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews([bgImgView, titleLabel])
        bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(36)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        titleLabel.text = "儿童食谱"
        
        let size = titleLabel.systemLayoutSizeFitting(CGSize(width: UIScreenWidth, height: CGFloat.greatestFiniteMagnitude))
        
        
        if let layer = bgLayer {
            layer.removeFromSuperlayer()
        }

        let sublayer = CAShapeLayer()
        let circlePath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: CGSize(width: size.width+40, height: 36)), cornerRadius: 18)
        sublayer.path = circlePath.cgPath
        sublayer.fillColor = UIConstants.Color.background.cgColor
        bgImgView.layer.addSublayer(sublayer)
        bgLayer = sublayer
        
    }
}
