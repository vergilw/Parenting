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
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.text = "课程目录"
        return label
    }()
    
    lazy fileprivate var videoTagLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.primaryGreen
        label.backgroundColor = UIColor("#e5f6f6")
        label.text = "视频"
        label.layer.cornerRadius = 8.5
        label.clipsToBounds = true
        label.textAlignment = .center
        label.isHidden = true
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
            make.leading.equalTo(25)
            make.top.equalTo(32)
            make.bottom.equalTo(-16)
        }
        videoTagLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(42)
            make.height.equalTo(17)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(isVideoCourse: Bool) {
        if isVideoCourse {
            videoTagLabel.isHidden = false
        } else {
            videoTagLabel.isHidden = true
        }
    }
}
