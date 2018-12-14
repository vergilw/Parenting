//
//  VideoCollectionCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/14.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class VideoCollectionCell: UICollectionViewCell {
    
    lazy fileprivate var previewImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(previewImgView)
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func initConstraints() {
        previewImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setup(model: VideoModel) {
        
        if let URLString = model.cover_url {
            let width = (UIScreenWidth-30)/2.0
            let processor = RoundCornerImageProcessor(cornerRadius: 8, targetSize: CGSize(width: width*2, height: width/9.0*16*2))
            previewImgView.kf.setImage(with: URL(string: URLString), options: [.processor(processor)])
        }
    }
}
