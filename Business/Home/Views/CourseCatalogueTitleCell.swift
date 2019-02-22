//
//  CourseCatalogueTitleCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/26.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class CourseCatalogueTitleCell: UITableViewCell {

    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h3
        label.textColor = UIConstants.Color.head
        label.text = "课程目录"
        return label
    }()
    
    lazy fileprivate var videoTagLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot3
        label.textColor = .white
        label.text = "视频"
        label.textAlignment = .center
        
        let sublayer = CAShapeLayer()
        let circlePath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: CGSize(width: 38, height: 15)), byRoundingCorners: [.topLeft, .topRight, .bottomRight] , cornerRadii: CGSize(width: 7.25, height: 7.25))
        sublayer.path = circlePath.cgPath
        sublayer.fillColor = UIConstants.Color.primaryGreen.cgColor
        label.layer.addSublayer(sublayer)
        
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubviews([titleLabel, videoTagLabel])
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(32)
            make.bottom.equalTo(-16)
        }
        videoTagLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(1)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(38)
            make.height.equalTo(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(isVideoCourse: Bool) {
        if isVideoCourse {
            videoTagLabel.text = "视频"
        } else {
            videoTagLabel.text = "音频"
        }
    }
}
