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
        label.font = UIConstants.Font.h4
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
        label.font = UIConstants.Font.h4
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
        label.font = UIConstants.Font.foot2
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    lazy fileprivate var auditionLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot3
        label.textColor = .white
        label.text = "可试听"
        label.backgroundColor = UIConstants.Color.primaryOrange
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
    
    lazy fileprivate var progressView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 5
        view.isHidden = true
        
        return view
    }()
    
    var progressImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "course_progressFinished")
        return imgView
    }()
    
    var progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot2
        label.textColor = UIConstants.Color.primaryGreen
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
        
        contentView.addSubviews([sequenceLabel, listeningIndicatorImgView, titleLabel, timeImgView, timeLabel, auditionLabel, progressView])
        progressView.addArrangedSubview(progressImgView)
        progressView.addArrangedSubview(progressLabel)
        
        sequenceLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
//            make.trailing.equalTo(titleLabel.snp.leading).offset(-10)
            make.firstBaseline.equalTo(titleLabel)
        }
        listeningIndicatorImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(16+(UIConstants.ParagraphLineHeight.body-sequenceLabel.font.lineHeight)/4+1.25)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading+28)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
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
        progressView.snp.makeConstraints { make in
            make.centerY.equalTo(timeImgView)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(model: CourseSectionModel, isPlaying: Bool, isBought: Bool, isProgressHidden: Bool = false) {
        sequenceLabel.setParagraphText(String(format: "%02d", model.sort ?? 0))
        
        titleLabel.setParagraphText(model.title ?? "")
        
        
        if let durationSeconds = model.duration_with_seconds {
            let duration: TimeInterval = TimeInterval(durationSeconds)
            let durationDate = Date(timeIntervalSince1970: duration)
            timeLabel.text = CourseCatalogueCell.timeFormatter.string(from: durationDate)
        }
        
        var recordSeconds: Double?
        
        if let courseID = model.course?.id, let sectionID = model.id, isProgressHidden == false {
            if let record = PlaybackRecordService.sharedInstance.fetchRecords(courseID: courseID, sectionID: sectionID) as? Double {
                recordSeconds = record
            }
        }
        if isProgressHidden == false && (recordSeconds != nil || (model.learned != nil && model.learned != 0)) && isBought == true {
            auditionLabel.isHidden = true
            progressView.isHidden = false
            
            if recordSeconds == nil {
                if let learned = model.learned {
                    recordSeconds = learned
                }
            }
            if let recordSeconds = recordSeconds {
                if let durationSeconds = model.duration_with_seconds {
                    let percent = recordSeconds/durationSeconds*100
                    
                    if percent < 100 && durationSeconds-recordSeconds > 1 {
                        progressLabel.text = String(format: "%.0f%%", floor(percent))
                        progressImgView.image = UIImage(named: "course_progressUnfinished")
                    } else {
                        progressLabel.text = "100%"
                        progressImgView.image = UIImage(named: "course_progressFinished")
                    }
                }
            }
            
        } else if !isBought && model.audition == true {
            auditionLabel.isHidden = false
            progressView.isHidden = true
        } else {
            auditionLabel.isHidden = true
            progressView.isHidden = true
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
