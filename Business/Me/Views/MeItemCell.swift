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
        label.font = UIConstants.Font.caption2
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var indicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_arrowIndicator")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imgView.tintColor = UIConstants.Color.foot
        return imgView
    }()
    
    lazy fileprivate var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    fileprivate lazy var valueBgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIConstants.Color.primaryRed
        imgView.layer.cornerRadius = 6
        imgView.clipsToBounds = true
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
        
        contentView.addSubviews([iconImgView, titleLabel, indicatorImgView, valueBgImgView, valueLabel])
        
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
        
        valueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(indicatorImgView.snp.leading).offset(-10)
        }
        valueBgImgView.snp.makeConstraints { make in
            make.center.equalTo(valueLabel)
            make.height.equalTo(12)
            make.width.greaterThanOrEqualTo(12)
            make.leading.lessThanOrEqualTo(valueLabel).offset(-3)
            make.trailing.greaterThanOrEqualTo(valueLabel).offset(3)
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
        
        if value != nil {
            valueLabel.text = value
            valueLabel.isHidden = false
            valueLabel.textColor = UIConstants.Color.foot
            valueLabel.font = UIConstants.Font.body
            
            valueLabel.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalTo(indicatorImgView.snp.leading).offset(-10)
            }
        } else {
            valueLabel.isHidden = true
        }
        
        valueBgImgView.isHidden = true
        
        titleLabel.text = title
    }
    
    func setupMessages(img: UIImage, title: String, unreadCount: Int) {
        iconImgView.image = img
        
        iconImgView.isHidden = false
        titleLabel.snp.remakeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading+32)
            make.centerY.equalToSuperview()
        }
        
        if unreadCount == 0 {
            valueLabel.isHidden = true
            valueBgImgView.isHidden = true
        } else if unreadCount < 100 {
            valueLabel.text = "\(unreadCount)"
            valueLabel.isHidden = false
            valueBgImgView.isHidden = false
        } else {
            valueLabel.text = "99+"
            valueLabel.isHidden = false
            valueBgImgView.isHidden = false
        }
        
        valueLabel.font = UIConstants.Font.foot3
        valueLabel.textColor = .white
        
        valueLabel.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(indicatorImgView.snp.leading).offset(-10-3)
            make.height.equalTo(12)
        }
        
        titleLabel.text = title
    }
}
