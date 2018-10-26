//
//  CourseCatalogueCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/24.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class CourseCatalogueCell: UITableViewCell {

    lazy fileprivate var sequenceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor("#999")
        return label
    }()
    
    lazy fileprivate var listeningIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
//        imgView.image = UIImage(named: <#T##String#>)
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor("#333")
        return label
    }()
    
    lazy fileprivate var timeImgView: UIImageView = {
        let imgView = UIImageView()
//        imgView.image = UIImage(named: <#T##String#>)
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy fileprivate var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor("#777")
        return label
    }()
    
    lazy fileprivate var auditionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
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
        
        contentView.addSubviews([sequenceLabel, listeningIndicatorImgView, titleLabel, timeImgView, timeLabel, auditionLabel])
        
        sequenceLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(16)
        }
        listeningIndicatorImgView.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(16)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(sequenceLabel.snp.trailing).offset(10)
            make.trailing.equalTo(-25)
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
    
    func setup(model: CourseSectionModel) {
        sequenceLabel.text = "01"
        titleLabel.text = model.title
        if let durationSeconds = model.duration_with_seconds {
            timeLabel.text = String(format: "%02d:%02d", durationSeconds/60, durationSeconds.truncatingRemainder(dividingBy: 60))
        }
        
    }
}
