//
//  TeacherStoriesCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/20.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class TeacherStoriesCell: UITableViewCell {

    lazy fileprivate var previewImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy fileprivate var titleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing
        return label
    }()
    
    lazy fileprivate var nameLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h3
        label.textColor = .white
        return label
    }()
    
    lazy fileprivate var tagLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
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
        contentView.backgroundColor = .gray
        contentView.addSubviews([previewImgView, titleLabel, nameLabel, tagLabel])
        initConstraints()
    }
    
    fileprivate func initConstraints() {
        previewImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualTo(UIConstants.Margin.leading)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
        }
        tagLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(tagLabel.snp.top).offset(-8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func setup() {
        titleLabel.setParagraphText("一个育儿专家，是怎么把教父母如何哄宝宝睡觉变成…")
        nameLabel.setParagraphText("Ndesw")
        tagLabel.setParagraphText("全职妈妈丨心理咨询")
    }
}
