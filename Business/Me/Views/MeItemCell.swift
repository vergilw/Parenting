//
//  MeItemCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/14.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class MeItemCell: UITableViewCell {

    lazy fileprivate var iconImgView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2_regular
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var indicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_arrowIndicator")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imgView.tintColor = UIConstants.Color.foot
        return imgView
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
        
        contentView.addSubviews([iconImgView, titleLabel, indicatorImgView])
        
        iconImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading+32)
            make.centerY.equalToSuperview()
        }
        
        indicatorImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-UIConstants.Margin.trailing)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(img: UIImage? = nil, title: String, value: String? = nil) {
        if img != nil {
            iconImgView.image = img
            
            iconImgView.isHidden = false
            titleLabel.snp.remakeConstraints { make in
                make.leading.equalTo(UIConstants.Margin.leading+32)
                make.centerY.equalToSuperview()
            }
        } else {
            iconImgView.image = img
            
            iconImgView.isHidden = true
            titleLabel.snp.remakeConstraints { make in
                make.leading.equalTo(UIConstants.Margin.leading)
                make.centerY.equalToSuperview()
            }
        }
        
        titleLabel.text = title
    }
}
