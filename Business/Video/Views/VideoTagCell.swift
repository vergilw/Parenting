//
//  VideoTagCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/30.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class VideoTagCell: UICollectionViewCell {
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.backgroundColor = UIConstants.Color.background
        contentView.layer.cornerRadius = 17.5
        contentView.clipsToBounds = true
        
        contentView.addSubviews([titleLabel])
        titleLabel.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
            make.height.equalTo(35)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(model: VideoTagModel) {
        titleLabel.text = "#\(model.name ?? "")#"
    }
}
