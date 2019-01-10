//
//  VideoUserHeaderView.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/10.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class VideoUserHeaderView: UICollectionReusableView {
    
    lazy fileprivate var avatarBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 34
        button.clipsToBounds = true
        //        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h1
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    lazy fileprivate var videosCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //profiles view
        let profilesStackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .leading
            view.axis = .vertical
            view.distribution = .fillProportionally
            view.spacing = 7
            return view
        }()
        profilesStackView.addArrangedSubview(nameLabel)
        profilesStackView.addArrangedSubview(descriptionLabel)
        
        addSubviews([avatarBtn, profilesStackView])
        avatarBtn.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(UIConstants.Margin.leading)
            make.size.equalTo(CGSize(width: 68, height: 68))
        }
        profilesStackView.snp.makeConstraints { make in
            make.leading.equalTo(avatarBtn.snp.trailing).offset(15)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalTo(avatarBtn)
        }
        
        
        //statistics view
        let statisticsStackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .fill
            view.axis = .horizontal
            view.distribution = .fillEqually
            return view
        }()
        statisticsStackView.addArrangedSubview(videosCountLabel)
        statisticsStackView.addArrangedSubview(likeCountLabel)
        statisticsStackView.addArrangedSubview(commentCountLabel)
        
        addSubview(statisticsStackView)
        statisticsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-15)
            make.height.equalTo(60)
        }
        
        drawSeparator(startPoint: CGPoint(x: 0, y: 164.5), endPoint: CGPoint(x: UIScreenWidth, y: 164.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        
    }
}
