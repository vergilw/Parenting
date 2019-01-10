//
//  PresentationActionCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/10.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class PresentationActionCell: UICollectionViewCell {
    
    lazy fileprivate var iconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .center
        imgView.layer.cornerRadius = 23.5
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy fileprivate var titleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews([iconImgView, titleLabel])
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func initConstraints() {
        iconImgView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 47, height: 47))
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
        }
    }
    
    func setup(imgNamed: String, bgColor: UIColor, text: String) {
        iconImgView.image = UIImage(named: imgNamed)
        iconImgView.backgroundColor = bgColor
        
        titleLabel.setParagraphText(text)
    }
}
