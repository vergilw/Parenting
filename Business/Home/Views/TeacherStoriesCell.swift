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
        imgView.image = UIImage(named: "public_coursePlaceholder")
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy fileprivate var coverImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        return imgView
    }()
    
    lazy fileprivate var titleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreenWidth-35-35
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
        contentView.addSubviews([previewImgView, coverImgView, titleLabel, nameLabel, tagLabel])
        initConstraints()
    }
    
    fileprivate func initConstraints() {
        previewImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        coverImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualTo(35)
            make.trailing.lessThanOrEqualTo(-35)
        }
        tagLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
            make.leading.greaterThanOrEqualTo(35)
            make.trailing.lessThanOrEqualTo(-35)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(tagLabel.snp.top).offset(-8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func setup(model: StoryModel) {
        
        if var URLString = model.cover_image?.service_url {
            URLString += "?imageMogr2/thumbnail/\(UIScreenWidth)x\(UIScreenWidth/16.0*9)"
            previewImgView.kf.setImage(with: URL(string: URLString), placeholder: UIImage(named: "public_coursePlaceholder"))
        }
        
        titleLabel.setParagraphText(model.title ?? "")
        nameLabel.setParagraphText(model.story_teller?.name ?? "")
        
        if let tags = model.story_teller?.tags, tags.count > 0 {
            let tagString = tags.joined(separator: " | ")
            tagLabel.setParagraphText(tagString)
        }
        
    }
}
