//
//  VideoFilterCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/17.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class VideoFilterCell: UICollectionViewCell {
    
    lazy fileprivate var previewImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        imgView.layer.borderWidth = 2
        imgView.layer.cornerRadius = 4
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.backgroundColor = .clear
        contentView.addSubviews([previewImgView, titleLabel])
        previewImgView.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 55, height: 55))
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(previewImgView.snp.bottom).offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                previewImgView.layer.borderColor = UIColor.white.cgColor
            } else {
                previewImgView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
            }
        }
    }
    
    func setup(img: UIImage, string: String) {
        previewImgView.image = img
        titleLabel.text = string
    }
    
}
