//
//  VideoUserCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/10.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class VideoUserCell: UICollectionViewCell {
    
    lazy fileprivate var previewImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy fileprivate var viewsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        return label
    }()
    
    lazy fileprivate var viewsImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_viewsIcon")
        return imgView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor("#353535")
        contentView.addSubviews([previewImgView, viewsCountLabel, viewsImgView])
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func initConstraints() {
        previewImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        viewsImgView.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.bottom.equalTo(-10)
        }
        viewsCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(viewsImgView)
            make.leading.equalTo(viewsImgView.snp.trailing).offset(4)
        }
        
    }
    
    func setup(model: VideoModel) {
        
        if let URLString = model.cover_url {
            //            let width = (UIScreenWidth-1)/2.0
            //            let processor = RoundCornerImageProcessor(cornerRadius: 0, targetSize: CGSize(width: width*2, height: width/9.0*16*2))
            previewImgView.kf.setImage(with: URL(string: URLString))
        }
        
        
        viewsCountLabel.text = "\(model.view_count ?? "0")"
        
    }
}

