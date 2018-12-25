//
//  RewardRankingCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/24.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class RewardRankingCell: UITableViewCell {

    lazy fileprivate var sequenceLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.disable
        return label
    }()
    
    lazy fileprivate var sequenceImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "payment_ranking0")
        imgView.isHidden = true
        return imgView
    }()
    
    lazy fileprivate var avatarImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_avatarPlaceholder")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy fileprivate var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var coinIconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "payment_coinIcon")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy fileprivate var valueLabel: PriceLabel = {
        let label = PriceLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.primaryOrange
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
        
        contentView.addSubviews([sequenceLabel, sequenceImgView, avatarImgView, nameLabel, coinIconImgView, valueLabel])
        
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func initConstraints() {
        sequenceLabel.snp.makeConstraints { make in
            make.center.equalTo(sequenceImgView)
        }
        sequenceImgView.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.centerY.equalToSuperview()
        }
        avatarImgView.snp.makeConstraints { make in
            make.leading.equalTo(70)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 45, height: 45))
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImgView.snp.trailing).offset(8.5)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(valueLabel.snp.leading).offset(-12)
        }
        coinIconImgView.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalToSuperview()
        }
        valueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(coinIconImgView.snp.leading).offset(-4)
        }
    }
    
    func setup(index: Int, model: RewardRankingModel) {
        if index < 3 {
            sequenceLabel.isHidden = true
            sequenceImgView.isHidden = false
            sequenceImgView.image = UIImage(named: "payment_ranking\(index)")
        } else {
            sequenceLabel.isHidden = false
            sequenceImgView.isHidden = true
            sequenceLabel.text = "\(index)"
        }
        
        if let URLString = model.user?.avatar_url {
            let processor = RoundCornerImageProcessor(cornerRadius: 22.5, targetSize: CGSize(width: 45, height: 45))
            avatarImgView.kf.setImage(with: URL(string: URLString), placeholder: UIImage(named: "public_avatarPlaceholder"), options: [.processor(processor)])
        }
        
        nameLabel.text = model.user?.name
        
        valueLabel.setStatisticText(string: model.income_amount ?? "")
    }
}
