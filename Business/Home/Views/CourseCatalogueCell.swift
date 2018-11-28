//
//  CourseCatalogueCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/24.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class CourseCatalogueCell: UITableViewCell {

    lazy fileprivate var sequenceLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.foot
        label.numberOfLines = 0
        return label
    }()
    
    lazy fileprivate var listeningIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "course_listeningIndicator")
        imgView.isHidden = true
        return imgView
    }()
    
    lazy fileprivate var titleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreenWidth-54-25
        return label
    }()
    
    lazy fileprivate var timeImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "course_timeDuration")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy fileprivate var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    lazy fileprivate var auditionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor("#f05053")
        label.text = "可试听"
        label.backgroundColor = UIColor(hex6: 0xf05053, alpha: 0.1)
        label.isHidden = true
        label.textAlignment = .center
        label.layer.cornerRadius = 8.5
        label.clipsToBounds = true
        return label
    }()
    
    static let timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter
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
        
        contentView.addSubviews([sequenceLabel, listeningIndicatorImgView, titleLabel, timeImgView, timeLabel, auditionLabel])
        
        sequenceLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
//            make.trailing.equalTo(titleLabel.snp.leading).offset(-10)
            make.firstBaseline.equalTo(titleLabel)
        }
        listeningIndicatorImgView.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(16)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(54)
            make.trailing.greaterThanOrEqualTo(-25)
            make.top.equalTo(16)
        }
        timeImgView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.bottom.equalTo(-16)
        }
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeImgView.snp.trailing).offset(5)
            make.centerY.equalTo(timeImgView)
        }
        auditionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeImgView)
            make.trailing.equalTo(-32)
            make.width.equalTo(42)
            make.height.equalTo(17)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(model: CourseSectionModel, isPlaying: Bool, isBought: Bool) {
        sequenceLabel.setParagraphText(String(format: "%02d", model.sort ?? 0))
        
        titleLabel.setParagraphText(model.title ?? "")
        
        
        if let durationSeconds = model.duration_with_seconds {
            let duration: TimeInterval = TimeInterval(durationSeconds)
            let durationDate = Date(timeIntervalSince1970: duration)
            timeLabel.text = CourseCatalogueCell.timeFormatter.string(from: durationDate)
        }
        
        if !isBought && model.audition == true {
            auditionLabel.isHidden = false
        } else {
            auditionLabel.isHidden = true
        }
        
        if isPlaying {
            sequenceLabel.isHidden = true
            listeningIndicatorImgView.isHidden = false
            titleLabel.textColor = UIConstants.Color.primaryGreen
        } else {
            sequenceLabel.isHidden = false
            listeningIndicatorImgView.isHidden = true
            titleLabel.textColor = UIConstants.Color.body
        }
    }
}
