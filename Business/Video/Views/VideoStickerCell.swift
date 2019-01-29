//
//  VideoStickerCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/29.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class VideoStickerCell: UICollectionViewCell {
    
    lazy fileprivate var previewImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.drawRoundBg(roundedRect: CGRect(origin: .zero, size: CGSize(width: 48, height: 48)), cornerRadius: 24, color: UIColor(white: 1.0, alpha: 0.2))
        
        contentView.backgroundColor = .clear
        contentView.addSubviews([previewImgView])
        previewImgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(img: UIImage) {
        previewImgView.image = img
        
//        if img.size.width > img.size.height {
//            if img.size.width > 35 {
//                previewImgView.snp.remakeConstraints { make in
//                    make.center.equalToSuperview()
//                    make.size.equalTo(CGSize(width: 35, height: 35/img.size.width*img.size.height))
//                }
//            }
//        } else {
//            if img.size.height > 35 {
//                previewImgView.snp.remakeConstraints { make in
//                    make.center.equalToSuperview()
//                    make.size.equalTo(CGSize(width: 35/img.size.height*img.size.width, height: 35))
//                }
//            }
//        }
        
        
    }
}
