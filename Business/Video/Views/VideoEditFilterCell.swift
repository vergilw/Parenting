//
//  VideoEditFilterCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/18.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class VideoEditFilterCell: UICollectionViewCell {
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h1
        label.textColor = .white
        label.alpha = 0.0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.backgroundColor = .clear
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel.alpha = 1.0
                UIView.animate(withDuration: 1.5) {
                    self.titleLabel.alpha = 0.0
                }
            } else {
//                previewImgView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
            }
        }
    }
    
    func setup(string: String) {
        titleLabel.text = string
    }
}
