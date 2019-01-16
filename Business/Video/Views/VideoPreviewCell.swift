//
//  VideoPreviewCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/16.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class VideoPreviewCell: UICollectionViewCell {
    
    lazy fileprivate var previewImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(previewImgView)
        previewImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(img: UIImage) {
        previewImgView.image = img
    }
}
