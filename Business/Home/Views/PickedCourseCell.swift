//
//  PickedCourseCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/24.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class PickedCourseCell: UICollectionViewCell {
    
    lazy fileprivate var previewImgView: UIImageView = {
        let imgView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: (UIScreenWidth-50-12)/2, height: (UIScreenWidth-50-12)/2)))
//        imgView.image = UIImage(named: <#T##String#>)
        imgView.backgroundColor = .gray
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "科学护肤指南"
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .leading
            view.axis = .vertical
            view.distribution = .equalSpacing
            return view
        }()
        stackView.addArrangedSubview(previewImgView)
        stackView.addArrangedSubview(titleLabel)
        
        addSubview(stackView)
        
        previewImgView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(previewImgView.snp.width)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo((UIScreenWidth-50-12)/2)
            make.height.equalTo(255)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
